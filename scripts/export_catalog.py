"""Render preview PNGs (and optional STLs) for every themed scrunchy holder."""
from __future__ import annotations

import argparse
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
CAD = os.path.join(ROOT, "cad")
OUT = os.path.join(ROOT, "print", "catalog")
OPENSCAD = r"C:\Program Files\OpenSCAD\openscad.exe"

# slug, scad, variant, title, blurb
DESIGNS = [
    ("r2d2-01-classic", "r2d2_holders.scad", 1, "R2-D2", "Classic Astromech",
     "Barrel, dome, skirt, and radar eye. Scrunchy keyhole on both sides."),
    ("r2d2-02-field-unit", "r2d2_holders.scad", 2, "R2-D2", "Field Unit with Legs",
     "Shorter barrel with two side legs and a front caster."),
    ("r2d2-03-dome-heavy", "r2d2_holders.scad", 3, "R2-D2", "Dome-Heavy Unit",
     "Fat short barrel with an oversized dome head."),
    ("r2d2-04-panel-tank", "r2d2_holders.scad", 4, "R2-D2", "Panel Tank",
     "Boxy astromech body with a dome and front instrument panels."),
    ("r2d2-05-slim", "r2d2_holders.scad", 5, "R2-D2", "Slim Astromech",
     "Tall thin barrel stacked with blue rings and a small dome."),
    ("hogwarts-01-keep", "hogwarts_holders.scad", 1, "Hogwarts", "Castle Keep",
     "Square keep, four side turrets, and a center spire."),
    ("hogwarts-02-great-hall", "hogwarts_holders.scad", 2, "Hogwarts", "Great Hall",
     "Long front with a rose window and a steep pitched roof."),
    ("hogwarts-03-astronomy", "hogwarts_holders.scad", 3, "Hogwarts", "Astronomy Tower",
     "Tall stone cylinder, gallery, conical roof."),
    ("hogwarts-04-four-houses", "hogwarts_holders.scad", 4, "Hogwarts", "Four Houses",
     "Shared keep with Gryffindor, Slytherin, Ravenclaw, and Hufflepuff towers."),
    ("hogwarts-05-clock", "hogwarts_holders.scad", 5, "Hogwarts", "Clock Tower",
     "Square shaft, clock face, battlements, and a spire."),
    ("harry-potter-01-sorting-hat", "harry_potter_holders.scad", 1, "Harry Potter", "Sorting Hat",
     "Wide brim and wrinkled cone, face on the front."),
    ("harry-potter-02-snitch", "harry_potter_holders.scad", 2, "Harry Potter", "Golden Snitch",
     "Gold sphere with wings on the front and back."),
    ("harry-potter-03-glasses", "harry_potter_holders.scad", 3, "Harry Potter", "Glasses and Scar",
     "Round totem head with round glasses and a lightning bolt."),
    ("harry-potter-04-platform", "harry_potter_holders.scad", 4, "Harry Potter", "Platform 9 3/4",
     "Brick wall with an arch and a 9 3/4 sign."),
    ("harry-potter-05-cauldron", "harry_potter_holders.scad", 5, "Harry Potter", "Potion Cauldron",
     "Pot-belly cauldron with a rim and three feet."),
    ("doctor-who-01-dalek", "doctor_who_holders.scad", 1, "Doctor Who", "Dalek",
     "Flared skirt, bands, dome, eyestalk and gun on the front."),
    ("doctor-who-02-k9", "doctor_who_holders.scad", 2, "Doctor Who", "K-9",
     "Boxy dog body, sloped head, antenna, tread rails."),
    ("doctor-who-03-angel", "doctor_who_holders.scad", 3, "Doctor Who", "Weeping Angel",
     "Draped stone column with wing silhouettes and a head."),
    ("doctor-who-04-sonic", "doctor_who_holders.scad", 4, "Doctor Who", "Sonic Screwdriver",
     "Grip rings, clip, and a glowing emitter cage."),
    ("doctor-who-05-rotor", "doctor_who_holders.scad", 5, "Doctor Who", "Time Rotor",
     "Brass drum, circular face, glass column on top."),
    ("star-wars-01-death-star", "star_wars_holders.scad", 1, "Star Wars", "Death Star",
     "Sphere with an equatorial trench and a superlaser dish."),
    ("star-wars-02-bb8", "star_wars_holders.scad", 2, "Star Wars", "BB-8",
     "White sphere, orange hex panels, and a small dome."),
    ("star-wars-03-lightsaber", "star_wars_holders.scad", 3, "Star Wars", "Lightsaber Hilt",
     "Tall grip with rings, activation box, and emitter."),
    ("star-wars-04-tie", "star_wars_holders.scad", 4, "Star Wars", "TIE Cockpit",
     "Hexagonal cockpit with a viewport and wing stubs."),
    ("star-wars-05-holocron", "star_wars_holders.scad", 5, "Star Wars", "Jedi Holocron",
     "Gold cube, triangle inlays, pyramid cap."),
    ("star-trek-01-enterprise", "star_trek_holders.scad", 1, "Star Trek", "Constitution Totem",
     "Engineering hull as the holder, saucer on top, nacelles on front and back."),
    ("star-trek-02-communicator", "star_trek_holders.scad", 2, "Star Trek", "Communicator",
     "Standing slab with grill, hero button, and lid cap."),
    ("star-trek-03-borg", "star_trek_holders.scad", 3, "Star Trek", "Borg Cube",
     "Greebled cube. Keyhole cuts two faces into the hollow."),
    ("star-trek-04-delta", "star_trek_holders.scad", 4, "Star Trek", "Starfleet Delta",
     "Navy body with a large extruded chevron on the front."),
    ("star-trek-05-warp-core", "star_trek_holders.scad", 5, "Star Trek", "Warp Core",
     "Glowing column with torus rings and a cap."),
]


def run_openscad(scad: str, dest: str, variant: int, extra: list[str]) -> None:
    cmd = [
        OPENSCAD,
        "-D", f"VARIANT={variant}",
        "-o", dest,
        *extra,
        os.path.join(CAD, scad),
    ]
    print("RUN", dest, flush=True)
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        err = (r.stderr or r.stdout or "").strip()[-2000:]
        raise RuntimeError(f"OpenSCAD failed {dest}\n{err}")


def preview_extra() -> list[str]:
    return [
        "--preview",
        "--imgsize=1000,1200",
        "--autocenter",
        "--viewall",
        "--camera", "0,0,0,62,0,38,420",
        "--projection=perspective",
        "--colorscheme=Tomorrow",
    ]


def render_one(design: tuple, do_stl: bool, skip_png: bool = False) -> str:
    slug, scad, variant, _theme, _title, _blurb = design
    os.makedirs(OUT, exist_ok=True)
    if not skip_png:
        png = os.path.join(OUT, f"{slug}.png")
        run_openscad(scad, png, variant, preview_extra())
    if do_stl:
        stl = os.path.join(OUT, f"{slug}.stl")
        run_openscad(scad, stl, variant, [])
    return slug


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--stl", action="store_true", help="also export STLs")
    ap.add_argument("--stl-only", action="store_true", help="export STLs, skip PNG")
    ap.add_argument("--jobs", type=int, default=4)
    ap.add_argument("--only", default="", help="comma-separated slug prefixes")
    args = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    designs = DESIGNS
    if args.only:
        prefs = [p.strip() for p in args.only.split(",") if p.strip()]
        designs = [d for d in DESIGNS if any(d[0].startswith(p) for p in prefs)]
        if not designs:
            print("no designs matched", args.only)
            return 2
    failed = []
    ok = []
    with ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
        do_stl = args.stl or args.stl_only
        skip_png = args.stl_only
        futs = {pool.submit(render_one, d, do_stl, skip_png): d[0] for d in designs}
        for fut in as_completed(futs):
            slug = futs[fut]
            try:
                ok.append(fut.result())
                print("OK", slug, flush=True)
            except Exception as e:
                failed.append((slug, str(e)))
                print("FAIL", slug, e, flush=True)
    print(f"done ok={len(ok)} fail={len(failed)} of {len(designs)}")
    for slug, err in failed:
        print("---", slug, "---")
        print(err[-1500:])
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
