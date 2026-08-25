"""Export TARDIS holder STLs from OpenSCAD and pack a Bambu Studio 3MF.

The 3MF is one object with four AMS parts (blue / white / black / gold)
sharing a single origin so they print as a multi-color assembly.
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
import uuid
import zipfile
from xml.sax.saxutils import escape

import numpy as np
import trimesh

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SCAD = os.path.join(ROOT, "cad", "tardis_scrunchy_holder.scad")
OUT = os.path.join(ROOT, "print")
OPENSCAD = r"C:\Program Files\OpenSCAD\openscad.exe"
TEMPLATE_3MF = (
    r"C:\dev\automatica-jetson-orion-nano"
    r"\cases\jetson-orin-nano\build\jetson-orin-nano-base.3mf"
)

PARTS = [
    ("blue",  "body_blue",   1),
    ("white", "windows_white", 2),
    ("black", "glass_black", 3),
    ("gold",  "trim_gold",   4),
]

# TARDIS blue, ivory, near-black, lamp gold — mapped onto H2D PLA slots.
FILAMENT_COLOURS = ["#003B6F", "#F4F1E8", "#1A1A1A", "#D4A017"]


def _u() -> str:
    return str(uuid.uuid4())


def run_openscad(part: str, dest: str, extra: list[str] | None = None) -> None:
    cmd = [
        OPENSCAD,
        "-D", f'PART="{part}"',
        "-o", dest,
        *(extra or []),
        SCAD,
    ]
    print("RUN", " ".join(cmd), flush=True)
    subprocess.run(cmd, check=True)


def export_stls() -> list[str]:
    os.makedirs(OUT, exist_ok=True)
    paths = []
    for part, _name, _ex in PARTS:
        path = os.path.join(OUT, f"tardis_{part}.stl")
        run_openscad(part, path)
        paths.append(path)
    return paths


def export_preview() -> str:
    png = os.path.join(OUT, "tardis_preview.png")
    # Front-right view so the TARDIS face and the scrunchy slide are both visible.
    run_openscad(
        "all",
        png,
        extra=[
            "--preview",
            "--imgsize=1100,1300",
            "--autocenter",
            "--viewall",
            "--camera", "0,0,0,65,0,40,400",
            "--projection=perspective",
            "--colorscheme=Tomorrow",
        ],
    )
    return png


def load_mesh(path: str) -> trimesh.Trimesh:
    mesh = trimesh.load(path, force="mesh")
    if isinstance(mesh, trimesh.Scene):
        mesh = trimesh.util.concatenate(tuple(mesh.geometry.values()))
    mesh = mesh.copy()
    mesh.merge_vertices()
    mesh.update_faces(mesh.unique_faces())
    mesh.remove_unreferenced_vertices()
    if mesh.faces.shape[0] == 0:
        raise RuntimeError(f"empty mesh: {path}")
    return mesh


def mesh_xml(mesh: trimesh.Trimesh) -> str:
    v = np.asarray(mesh.vertices, dtype=float)
    f = np.asarray(mesh.faces, dtype=np.int64)
    vx = np.char.mod('      <vertex x="%.6f"', v[:, 0])
    vy = np.char.mod(' y="%.6f"', v[:, 1])
    vz = np.char.mod(' z="%.6f"/>', v[:, 2])
    verts = "\n".join(np.char.add(np.char.add(vx, vy), vz))
    t1 = np.char.mod('      <triangle v1="%d"', f[:, 0])
    t2 = np.char.mod(' v2="%d"', f[:, 1])
    t3 = np.char.mod(' v3="%d"/>', f[:, 2])
    tris = "\n".join(np.char.add(np.char.add(t1, t2), t3))
    return (
        "    <mesh>\n"
        "     <vertices>\n"
        f"{verts}\n"
        "     </vertices>\n"
        "     <triangles>\n"
        f"{tris}\n"
        "     </triangles>\n"
        "    </mesh>"
    )


def object_model(oid: int, mesh: trimesh.Trimesh) -> str:
    uid = f"{oid:08d}-81cb-4c03-9d28-80fed5dfa1dc"
    return (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<model unit="millimeter" xml:lang="en-US" '
        'xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02" '
        'xmlns:BambuStudio="http://schemas.bambulab.com/package/2021" '
        'xmlns:p="http://schemas.microsoft.com/3dmanufacturing/production/2015/06" '
        'requiredextensions="p">\n'
        ' <metadata name="BambuStudio:3mfVersion">1</metadata>\n'
        " <resources>\n"
        f'  <object id="{oid}" p:UUID="{uid}" type="model">\n'
        f"{mesh_xml(mesh)}\n"
        "  </object>\n"
        " </resources>\n"
        " <build/>\n"
        "</model>\n"
    )


def write_3mf(stl_paths: list[str], preview_png: str | None) -> str:
    meshes = [load_mesh(p) for p in stl_paths]
    combined = trimesh.util.concatenate(meshes)
    minb, maxb = combined.bounds
    center_xy = (minb[:2] + maxb[:2]) / 2.0
    shift = np.array([-center_xy[0], -center_xy[1], -minb[2]])
    for m in meshes:
        m.apply_translation(shift)

    # H2D bed centre (350 x 320)
    bed_x, bed_y = 175.0, 160.0
    item_transform = f"1 0 0 0 1 0 0 0 1 {bed_x:.6f} {bed_y:.6f} 0"

    components = []
    rels = []
    objects = []
    parts_xml = []
    for i, ((part, name, extruder), mesh) in enumerate(zip(PARTS, meshes), start=1):
        oid = i  # 1..4 inside each nested file, also used as part id
        objects.append((f"3D/Objects/object_{i}.model", object_model(oid, mesh)))
        uid = f"{i:04d}0000-b206-40ff-9872-83e8017abed1"
        components.append(
            f'    <component p:path="/3D/Objects/object_{i}.model" '
            f'objectid="{oid}" p:UUID="{uid}" '
            f'transform="1 0 0 0 1 0 0 0 1 0 0 0"/>'
        )
        rels.append(
            f' <Relationship Target="/3D/Objects/object_{i}.model" '
            f'Id="rel-{i}" '
            f'Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>'
        )
        face_count = int(mesh.faces.shape[0])
        parts_xml.append(
            f'    <part id="{oid}" subtype="normal_part">\n'
            f'      <metadata key="name" value="{escape(name)}"/>\n'
            f'      <metadata key="matrix" value="1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1"/>\n'
            f'      <metadata key="extruder" value="{extruder}"/>\n'
            f'      <mesh_stat face_count="{face_count}" edges_fixed="0" '
            f'degenerate_facets="0" facets_removed="0" facets_reversed="0" '
            f'backwards_edges="0"/>\n'
            f"    </part>"
        )

    parent_uuid = "00000002-61cb-4c03-9d28-80fed5dfa1dc"
    model = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<model unit="millimeter" xml:lang="en-US" '
        'xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02" '
        'xmlns:BambuStudio="http://schemas.bambulab.com/package/2021" '
        'xmlns:p="http://schemas.microsoft.com/3dmanufacturing/production/2015/06" '
        'requiredextensions="p">\n'
        ' <metadata name="Application">BambuStudio-02.08.02.61</metadata>\n'
        ' <metadata name="BambuStudio:3mfVersion">1</metadata>\n'
        ' <metadata name="Title">TARDIS Scrunchy Holder</metadata>\n'
        " <resources>\n"
        f'  <object id="2" p:UUID="{parent_uuid}" type="model">\n'
        "   <components>\n"
        + "\n".join(components)
        + "\n   </components>\n"
        "  </object>\n"
        " </resources>\n"
        f' <build p:UUID="{_u()}">\n'
        f'  <item objectid="2" p:UUID="00000002-b1ec-4553-aec9-835e5b724bb4" '
        f'transform="{item_transform}" printable="1"/>\n'
        " </build>\n"
        "</model>\n"
    )

    model_settings = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        "<config>\n"
        '  <object id="2">\n'
        '    <metadata key="name" value="TARDIS Scrunchy Holder"/>\n'
        '    <metadata key="extruder" value="1"/>\n'
        '    <metadata key="flush_into_infill" value="1"/>\n'
        '    <metadata key="flush_into_objects" value="0"/>\n'
        '    <metadata key="flush_into_support" value="1"/>\n'
        + "\n".join(parts_xml)
        + "\n  </object>\n"
        "  <plate>\n"
        '    <metadata key="plater_id" value="1"/>\n'
        '    <metadata key="plater_name" value="TARDIS Holder"/>\n'
        '    <metadata key="locked" value="false"/>\n'
        '    <metadata key="filament_map_mode" value="Auto For Flush"/>\n'
        '    <metadata key="filament_maps" value="1 1 1 1 2 1"/>\n'
        '    <metadata key="thumbnail_file" value="Metadata/plate_1.png"/>\n'
        "    <model_instance>\n"
        '      <metadata key="object_id" value="2"/>\n'
        '      <metadata key="instance_id" value="0"/>\n'
        '      <metadata key="identify_id" value="1"/>\n'
        "    </model_instance>\n"
        "  </plate>\n"
        "  <assemble>\n"
        '   <assemble_item object_id="2" instance_id="0" '
        'transform="1 0 0 0 1 0 0 0 1 0 0 0" offset="0 0 0" />\n'
        "  </assemble>\n"
        "</config>\n"
    )

    with zipfile.ZipFile(TEMPLATE_3MF) as z:
        proj = json.loads(z.read("Metadata/project_settings.config").decode("utf-8"))

    colours = list(proj.get("filament_colour") or ["#FFFFFF"] * 6)
    while len(colours) < 6:
        colours.append("#888888")
    for i, c in enumerate(FILAMENT_COLOURS):
        colours[i] = c
    colours[4] = "#888888"
    colours[5] = "#888888"
    proj["filament_colour"] = colours
    # Force every AMS slot to PLA so H2D does not mix ABS + PLA.
    nslot = len(proj.get("filament_type") or colours)
    pla_keys = {
        "filament_type": "PLA",
        "filament_settings_id": "Bambu PLA Basic @BBL H2D",
        "filament_ids": "GFA00",
        "filament_density": "1.26",
    }
    for k, val in pla_keys.items():
        if k in proj and isinstance(proj[k], list) and proj[k]:
            proj[k] = [val] * len(proj[k])
    skip = {"filament_colour", "filament_multi_colour", "filament_self_index"}
    for k, v in list(proj.items()):
        if k in skip or not isinstance(v, list) or not v:
            continue
        if len(v) == nslot:
            proj[k] = [v[0]] * nslot
        elif len(v) == nslot * 2:
            proj[k] = [v[0], v[1]] * nslot
    proj["from"] = "project"
    if "enable_support" in proj:
        proj["enable_support"] = "0"

    content_types = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">\n'
        ' <Default Extension="rels" '
        'ContentType="application/vnd.openxmlformats-package.relationships+xml"/>\n'
        ' <Default Extension="model" '
        'ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>\n'
        ' <Default Extension="png" ContentType="image/png"/>\n'
        "</Types>\n"
    )
    root_rels = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\n'
        ' <Relationship Target="/3D/3dmodel.model" Id="rel-1" '
        'Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>\n'
        ' <Relationship Target="/Metadata/plate_1.png" Id="rel-2" '
        'Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/thumbnail"/>\n'
        "</Relationships>\n"
    )
    model_rels = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\n'
        + "\n".join(rels)
        + "\n</Relationships>\n"
    )
    slice_info = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        "<config>\n  <header>\n"
        '    <header_item key="X-BBL-Client-Type" value="slicer"/>\n'
        '    <header_item key="X-BBL-Client-Version" value="02.08.02.61"/>\n'
        "  </header>\n</config>\n"
    )

    dest = os.path.join(OUT, "tardis_scrunchy_holder.3mf")
    with zipfile.ZipFile(dest, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("[Content_Types].xml", content_types)
        z.writestr("_rels/.rels", root_rels)
        z.writestr("3D/3dmodel.model", model)
        z.writestr("3D/_rels/3dmodel.model.rels", model_rels)
        for path, xml in objects:
            z.writestr(path, xml)
        z.writestr("Metadata/project_settings.config", json.dumps(proj, indent=4))
        z.writestr("Metadata/model_settings.config", model_settings)
        z.writestr("Metadata/slice_info.config", slice_info)
        if preview_png and os.path.isfile(preview_png):
            z.write(preview_png, "Metadata/plate_1.png")
            z.write(preview_png, "Metadata/plate_1_small.png")
    print("3MF", dest, "size", os.path.getsize(dest), flush=True)
    print(
        "bbox mm",
        (maxb - minb).round(2).tolist(),
        "shifted",
        shift.round(3).tolist(),
        flush=True,
    )
    return dest


def main() -> int:
    os.makedirs(OUT, exist_ok=True)
    preview = export_preview()
    stls = export_stls()
    write_3mf(stls, preview)
    return 0


if __name__ == "__main__":
    sys.exit(main())
