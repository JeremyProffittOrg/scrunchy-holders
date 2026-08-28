"""Build tardis-holder-learning-guide.pdf from the session prompts and OpenSCAD views."""
from __future__ import annotations

import os

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_JUSTIFY, TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.lib.utils import ImageReader
from reportlab.platypus import (
    Image,
    KeepTogether,
    ListFlowable,
    ListItem,
    PageBreak,
    Paragraph,
    Preformatted,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
PRINT = os.path.join(ROOT, "print")
OUT = os.path.join(ROOT, "tardis-holder-learning-guide.pdf")

NAVY = colors.HexColor("#003B6F")
INK = colors.HexColor("#0b0f19")
MUTED = colors.HexColor("#4b5563")
PAPER = colors.HexColor("#ffffff")
QUOTE_BG = colors.HexColor("#f1f5f9")
QUOTE_FG = colors.HexColor("#e2e8f0")
QUOTE_DK = colors.HexColor("#0f172a")
RULE = colors.HexColor("#cbd5e1")


def styles():
    base = getSampleStyleSheet()
    s = {
        "cover_kicker": ParagraphStyle(
            "cover_kicker", parent=base["Normal"],
            fontName="Helvetica", fontSize=10, textColor=NAVY,
            alignment=TA_CENTER, spaceAfter=8,
        ),
        "cover_title": ParagraphStyle(
            "cover_title", parent=base["Title"],
            fontName="Helvetica-Bold", fontSize=26, leading=30,
            textColor=INK, alignment=TA_CENTER, spaceAfter=10,
        ),
        "cover_sub": ParagraphStyle(
            "cover_sub", parent=base["Normal"],
            fontName="Helvetica", fontSize=12, leading=16,
            textColor=MUTED, alignment=TA_CENTER, spaceAfter=6,
        ),
        "h1": ParagraphStyle(
            "h1", parent=base["Heading1"],
            fontName="Helvetica-Bold", fontSize=16, leading=20,
            textColor=NAVY, spaceBefore=14, spaceAfter=8,
        ),
        "h2": ParagraphStyle(
            "h2", parent=base["Heading2"],
            fontName="Helvetica-Bold", fontSize=12.5, leading=16,
            textColor=INK, spaceBefore=10, spaceAfter=6,
        ),
        "body": ParagraphStyle(
            "body", parent=base["BodyText"],
            fontName="Helvetica", fontSize=10.5, leading=14.5,
            textColor=INK, alignment=TA_JUSTIFY, spaceAfter=8,
        ),
        "caption": ParagraphStyle(
            "caption", parent=base["Normal"],
            fontName="Helvetica-Oblique", fontSize=9, leading=12,
            textColor=MUTED, alignment=TA_CENTER, spaceBefore=4, spaceAfter=12,
        ),
        "bullet": ParagraphStyle(
            "bullet", parent=base["BodyText"],
            fontName="Helvetica", fontSize=10.5, leading=14.5,
            textColor=INK, leftIndent=8, spaceAfter=3,
        ),
        "footer": ParagraphStyle(
            "footer", parent=base["Normal"],
            fontName="Helvetica", fontSize=8, textColor=MUTED, alignment=TA_CENTER,
        ),
        "prompt": ParagraphStyle(
            "prompt", parent=base["Code"],
            fontName="Courier", fontSize=8.5, leading=11.5,
            textColor=QUOTE_FG, backColor=QUOTE_DK,
            leftIndent=6, rightIndent=6, spaceBefore=4, spaceAfter=4,
        ),
        "code": ParagraphStyle(
            "code", parent=base["Code"],
            fontName="Courier", fontSize=8.5, leading=11.5,
            textColor=INK, backColor=QUOTE_BG,
            leftIndent=6, rightIndent=6, spaceBefore=4, spaceAfter=8,
        ),
        "step": ParagraphStyle(
            "step", parent=base["Heading1"],
            fontName="Helvetica-Bold", fontSize=14, leading=18,
            textColor=NAVY, spaceBefore=4, spaceAfter=8,
        ),
    }
    return s


def fig(path, max_w, max_h, caption, st):
    if not os.path.isfile(path):
        return [Paragraph(f"[missing image: {os.path.basename(path)}]", st["caption"])]
    ir = ImageReader(path)
    iw, ih = ir.getSize()
    scale = min(max_w / iw, max_h / ih)
    img = Image(path, width=iw * scale, height=ih * scale, hAlign="CENTER")
    cap = Paragraph(caption, st["caption"])
    return [KeepTogether([img, cap])]


def prompt_block(text):
    # Dark quote block so the prompt stays readable if a mail/PDF viewer inverts colors.
    inner = Preformatted(text.strip(), ParagraphStyle(
        "prompt_pre",
        fontName="Courier",
        fontSize=8.3,
        leading=11.2,
        textColor=QUOTE_FG,
        backColor=QUOTE_DK,
    ))
    tbl = Table([[inner]], colWidths=[6.5 * inch])
    tbl.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), QUOTE_DK),
        ("TEXTCOLOR", (0, 0), (-1, -1), QUOTE_FG),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
        ("BOX", (0, 0), (-1, -1), 0.5, NAVY),
    ]))
    return tbl


def bullets(items, st):
    flow = []
    for item in items:
        flow.append(ListItem(Paragraph(item, st["bullet"]), leftIndent=12))
    return ListFlowable(flow, bulletType="bullet", leftIndent=18, spaceAfter=8)


def header_footer(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(PAPER)
    canvas.rect(0, 0, letter[0], letter[1], fill=1, stroke=0)
    canvas.setFillColor(NAVY)
    canvas.rect(0, letter[1] - 18, letter[0], 18, fill=1, stroke=0)
    canvas.setFillColor(colors.white)
    canvas.setFont("Helvetica", 8)
    canvas.drawString(0.75 * inch, letter[1] - 13, "TARDIS scrunchy holder  ·  learning guide")
    canvas.setFillColor(NAVY)
    canvas.rect(0, 0, letter[0], 28, fill=1, stroke=0)
    canvas.setFillColor(colors.white)
    canvas.setFont("Helvetica", 8)
    canvas.drawCentredString(letter[0] / 2, 12, f"Page {doc.page}")
    canvas.restoreState()


def cover_header_footer(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(PAPER)
    canvas.rect(0, 0, letter[0], letter[1], fill=1, stroke=0)
    canvas.setFillColor(NAVY)
    canvas.rect(0, letter[1] - 72, letter[0], 72, fill=1, stroke=0)
    canvas.setFillColor(colors.white)
    canvas.setFont("Helvetica", 9)
    canvas.drawCentredString(letter[0] / 2, letter[1] - 42, "SCRUNCHY HOLDERS  ·  FROM PROMPT TO PRINT")
    canvas.setFillColor(NAVY)
    canvas.rect(0, 0, letter[0], 36, fill=1, stroke=0)
    canvas.setFillColor(colors.white)
    canvas.setFont("Helvetica", 8)
    canvas.drawCentredString(letter[0] / 2, 14, "OpenSCAD  ·  multi-color STL parts  ·  Bambu Studio 3MF")
    canvas.restoreState()


def build():
    st = styles()
    p = lambda name: os.path.join(PRINT, name)
    story = []

    story.append(Spacer(1, 0.85 * inch))
    story.append(Paragraph("A LEARNING GUIDE", st["cover_kicker"]))
    story.append(Paragraph("Building a TARDIS<br/>scrunchy holder", st["cover_title"]))
    story.append(Paragraph(
        "How a short operator prompt became an OpenSCAD police-box model, "
        "four complementary color parts, and a Bambu Studio multi-part 3MF.",
        st["cover_sub"],
    ))
    story.append(Paragraph(
        "28 August 2026  ·  repo scrunchy-holders  ·  cad/tardis_scrunchy_holder.scad",
        st["cover_sub"],
    ))
    story.append(Spacer(1, 0.12 * inch))
    story.extend(fig(p("tardis_preview.png"), 4.8 * inch, 4.7 * inch,
                     "Figure 1. Finished holder, three-quarter view. Front is a police box. "
                     "The right face is the scrunchy slide into a hollow center.", st))

    story.append(PageBreak())
    story.append(Paragraph("What this guide teaches", st["h1"]))
    story.append(Paragraph(
        "This is a record of one build, not a generic CAD tutorial. The same pattern "
        "works for any multi-color FDM object: one OpenSCAD file, one PART switch, "
        "non-overlapping solids, then a 3MF that Bambu Studio treats as one object "
        "with several AMS parts.",
        st["body"],
    ))
    story.append(bullets([
        "Turn a visual + mechanical prompt into parameters (width, slot fractions, wall thickness).",
        "Split a model into complementary color volumes that occupy the same origin.",
        "Cut a keyhole slide that prints as a hole in a hollow shell.",
        "Iterate from later prompts without throwing the model away.",
        "Pack STLs into a Bambu Lab 3MF and open it in Bambu Studio.",
    ], st))
    story.append(Paragraph("The prompts, in order", st["h2"]))
    story.append(Paragraph(
        "Full wording lives in prompts.md. These seven turns drove the object:",
        st["body"],
    ))
    numbered = []
    for item in [
        "TARDIS-shaped holder in SCAD, multi-color, police-box front, right-side slide 40% wide with 90% x 25 mm slots 5 mm from top and bottom, rounded corners, open in Bambu as multi-part multi-color.",
        "Make the center hollow.",
        "POLICE BOX on one line, not two.",
        "Cutouts on both sides, not one.",
        "POLICE BOX is reversed left to right -- flip it.",
        "Remove the gold ornaments on the front door.",
        "Write prompts.md and a PDF learning guide with images.",
    ]:
        numbered.append(ListItem(Paragraph(item, st["bullet"]), leftIndent=12))
    story.append(ListFlowable(numbered, bulletType="1", leftIndent=18, spaceAfter=8,
                              start="1"))

    story.append(PageBreak())
    story.append(Paragraph("Step 1  ·  Read the request before modeling", st["step"]))
    story.append(Paragraph(
        "The first prompt mixed three jobs: look (a TARDIS from the front), "
        "function (a scrunchy slide on the side), and delivery (OpenSCAD plus a "
        "Bambu multi-part multi-color print). Do not start cutting cubes until "
        "those three are named.",
        st["body"],
    ))
    story.append(prompt_block(
        "create for me a scrunchy holder which is shapped like a tardis,\n"
        "using scad and multi-color 3d print sections, it should look like\n"
        "a tardis from the front, but on the right side, have a slide 40%\n"
        "of the side wide, centered, with a larger full 90 percent wide\n"
        "and 25mm tall slots near the top and bottom (5mm from top and\n"
        "bottom), make sure the slots on the side have rounded corners.\n"
        "create and open in bambulabs as a multi-part, multi-color 3d print"
    ))
    story.append(Spacer(1, 8))
    story.append(Paragraph("What that locked in", st["h2"]))
    story.append(bullets([
        "CAD tool: OpenSCAD, not a GUI modeler.",
        "Front: police-box face (posts, doors, 2 x 3 windows, POLICE BOX sign, lamp).",
        "Right face: keyhole. Narrow run = 40% of side depth, centered. Fat ends = 90% wide x 25 mm tall, 5 mm from top and bottom.",
        "Slot outline: rounded corners (convex and concave).",
        "Print: one assembled object, several color parts, opened in Bambu Studio.",
    ], st))
    story.append(Paragraph(
        "A square 90 mm body matches a police box in plan. Height follows the "
        "classic post/sign/roof stack: plinth 8 mm, posts 150 mm, sign 14 mm, "
        "cornice 5 mm, then stepped roof and lamp. Total height is about 214 mm, "
        "which fits a Bambu H2D or X1C.",
        st["body"],
    ))

    story.append(PageBreak())
    story.append(Paragraph("Step 2  ·  One OpenSCAD file, four color parts", st["step"]))
    story.append(Paragraph(
        "Bambu AMS colors a print by part, not by face paint, unless you paint in "
        "the slicer. The reliable CAD method is complementary volumes: each color "
        "is a solid. Together they make the TARDIS. They share one origin. They "
        "must not occupy the same space.",
        st["body"],
    ))
    story.append(Paragraph(
        "The file cad/tardis_scrunchy_holder.scad has a PART switch. Preview uses "
        "PART=\"all\" with color(). STL export sets PART to blue, white, black, or gold.",
        st["body"],
    ))
    story.append(Preformatted(
        'PART = "all"; // all | blue | white | black | gold\n'
        "\n"
        "module assembly() {\n"
        '    if (PART == "all" || PART == "blue")  color("#003B6F") blue_part();\n'
        '    if (PART == "all" || PART == "white") color("#F4F1E8") white_part();\n'
        '    if (PART == "all" || PART == "black") color("#1A1A1A") black_part();\n'
        '    if (PART == "all" || PART == "gold")  color("#D4A017") gold_part();\n'
        "}\n"
        "assembly();",
        st["code"],
    ))
    story.append(Paragraph(
        "Coordinates: X is left/right as you face the doors, Y is back/front "
        "(+Y is the front), Z is up. The scrunchy slides are cut in the +X and -X faces.",
        st["body"],
    ))
    story.append(Paragraph("Who owns which volume", st["h2"]))
    story.append(bullets([
        "Blue: shell, plinth, posts, roof, door panels. Subtracts the interior, the slides, window pockets, and the sign pocket.",
        "White: window muntins, phone-hatch frame, POLICE BOX letters, lamp glass.",
        "Black: window glass plates behind the muntins, sign plate minus the letters, phone-hatch glass.",
        "Gold: lamp base, cage rings, and cap. Door handle and badge were removed later.",
    ], st))
    story.extend(fig(p("tardis_white.png"), 5.4 * inch, 3.5 * inch,
                     "Figure 2. White part only. Window bars, one-line POLICE BOX, lamp glass. "
                     "These solids sit in pockets cut from the blue body.", st))

    story.append(PageBreak())
    story.append(Paragraph("Step 3  ·  Make the front read as a TARDIS", st["step"]))
    story.append(Paragraph(
        "The front is two bays between corner posts. The top row of each bay is a "
        "six-pane window (2 columns x 3 rows). The three rows below are recessed "
        "panels. A center groove splits the doors. The lintel holds a recessed "
        "black sign. A stepped roof and a lamp sit on top.",
        st["body"],
    ))
    story.extend(fig(p("tardis_front.png"), 4.0 * inch, 4.4 * inch,
                     "Figure 3. Front view. Windows and lamp carry the TARDIS reading. "
                     "The sign is a shallow inlay, so OpenCSG preview can hide it; "
                     "the white and black STLs still hold the letters.", st))
    story.append(Paragraph(
        "Inlay rule for a vertical wall: cut a pocket from blue, then fill it. "
        "White muntins are 1.5 mm deep at the outer face. Black glass sits behind "
        "them so the panes read dark. The sign works the same way: black plate "
        "minus letter shapes, white letters in the holes, both inset 0.5 mm so "
        "the band is a recess.",
        st["body"],
    ))
    story.extend(fig(p("tardis_black.png"), 5.2 * inch, 3.4 * inch,
                     "Figure 4. Black part only. Window plates and the sign plate with "
                     "POLICE BOX cut out. Pair this with Figure 2; the holes and the "
                     "letters are the same 2D paths.", st))

    story.append(PageBreak())
    story.append(Paragraph("Step 4  ·  Draw the scrunchy slide as a 2D keyhole", st["step"]))
    story.append(Paragraph(
        "Do not model the slot as a pile of 3D cubes. Draw it once in 2D, round "
        "the corners, then extrude it through the side wall. The 2D plane is "
        "world Z along x and world Y along y.",
        st["body"],
    ))
    story.append(Preformatted(
        "slide_w = body_d * 0.40;   // 36 mm on a 90 mm side\n"
        "end_w   = body_d * 0.90;   // 81 mm\n"
        "end_h   = 25;\n"
        "margin  = 5;\n"
        "\n"
        "// union: tall 40% strip + 90% x 25 mm at top and bottom\n"
        "// then offset(r) offset(-r) offset(-r) offset(r) to round\n"
        "// convex and concave corners without changing size",
        st["code"],
    ))
    story.append(Paragraph(
        "Extrude that profile from the +X face in -X (and mirror it for -X). "
        "slot_depth is the wall thickness plus a bit extra so the hole breaks "
        "into the hollow. Rounded corners use OpenSCAD offset, not Minkowski, "
        "so compile stays fast.",
        st["body"],
    ))
    story.extend(fig(p("tardis_34.png"), 5.2 * inch, 4.3 * inch,
                     "Figure 5. Right face: 40% centered slide, 90% loading slots near "
                     "top and bottom, rounded inside and outside corners, open to the hollow.", st))

    story.append(PageBreak())
    story.append(Paragraph("Step 5  ·  Hollow the center, then both sides", st["step"]))
    story.append(Paragraph(
        "The first shell kept a thick right wall so the slot was only a pocket. "
        "The next prompt was: the center needs to be hollow. The fix was thinner "
        "walls (about 3.6 mm, 6 mm on the front for window depth) and a cavity "
        "from the floor up to just under the roof. The slot cut is longer than "
        "the wall, so it meets the cavity. Scrunchies go in the 25 mm ends and "
        "sit inside.",
        st["body"],
    ))
    story.append(prompt_block("oh, the center needs to be hollow"))
    story.append(Spacer(1, 8))
    story.append(Paragraph(
        "A later prompt asked for the same cutouts on both sides. Mirror the "
        "right-side cut across X. Drop the left-face windows so they do not "
        "fight the 90% slots. Keep windows on the front and back.",
        st["body"],
    ))
    story.append(prompt_block("make the cutouts on both sides not just one"))
    story.append(Spacer(1, 8))
    story.extend(fig(p("tardis_left.png"), 5.0 * inch, 4.0 * inch,
                     "Figure 6. Left face after the both-sides prompt. Same keyhole as "
                     "the right. Front still reads as a police box.", st))

    story.append(PageBreak())
    story.append(Paragraph("Step 6  ·  Small prompts, small diffs", st["step"]))
    story.append(Paragraph(
        "Once the shell and slides were right, the remaining prompts were local. "
        "Change the 2D sign path or delete a gold module. Re-export. Do not "
        "rebuild the box.",
        st["body"],
    ))
    story.append(Paragraph("Sign on one line", st["h2"]))
    story.append(prompt_block("and police box should be on line line, not two"))
    story.append(Spacer(1, 6))
    story.append(Paragraph(
        "Two text() calls became one: text(\"POLICE BOX\", size=7.4) in the 14 mm "
        "lintel. The black plate subtracts the same path, so the inlay still mates.",
        st["body"],
    ))
    story.append(Paragraph("Flip left to right", st["h2"]))
    story.append(prompt_block("police box is reversed left to right, flip"))
    story.append(Spacer(1, 6))
    story.append(Paragraph(
        "The front_inlay matrix maps 2D x to world X. Depending on which way you "
        "look in the slicer, letters can read backwards. wrap the 2D text in "
        "mirror([1, 0]). White letters and black holes stay in sync because they "
        "share sign_letters_2d().",
        st["body"],
    ))
    story.append(Paragraph("Remove gold door ornaments", st["h2"]))
    story.append(prompt_block("remove the gold ornimants ont eh front door"))
    story.append(Spacer(1, 6))
    story.append(Paragraph(
        "Delete the handle and badge solids from gold_part, and delete the matching "
        "holes from blue_part. Keep the gold lamp. Gold is then only the roof light.",
        st["body"],
    ))
    story.extend(fig(p("tardis_gold.png"), 4.0 * inch, 3.3 * inch,
                     "Figure 7. Gold part after the door ornaments came off: lamp base, "
                     "glass cage rings, and cap. Nothing on the doors.", st))

    story.append(PageBreak())
    story.append(Paragraph("Step 7  ·  Export STLs and pack a Bambu 3MF", st["step"]))
    story.append(Paragraph(
        "OpenSCAD 2021.01 writes one color per STL. scripts/export_tardis.py runs "
        "four openscad -D PART=... jobs, loads the meshes with trimesh, and writes "
        "a Bambu-flavored 3MF: one parent object, four components, each part tagged "
        "with an extruder in Metadata/model_settings.config.",
        st["body"],
    ))
    story.append(Preformatted(
        'openscad -D PART="blue"  -o print/tardis_blue.stl  cad/tardis_scrunchy_holder.scad\n'
        'openscad -D PART="white" -o print/tardis_white.stl cad/tardis_scrunchy_holder.scad\n'
        'openscad -D PART="black" -o print/tardis_black.stl cad/tardis_scrunchy_holder.scad\n'
        'openscad -D PART="gold"  -o print/tardis_gold.stl  cad/tardis_scrunchy_holder.scad\n'
        "python scripts/export_tardis.py",
        st["code"],
    ))
    story.append(Paragraph(
        "Filament map used here (Bambu PLA Basic on an H2D 0.4 nozzle): "
        "1 TARDIS blue #003B6F, 2 ivory #F4F1E8, 3 near-black #1A1A1A, "
        "4 gold #D4A017. Tree supports are on because the slot roofs are long "
        "bridges on a hollow shell.",
        st["body"],
    ))
    story.append(Paragraph(
        "Open print/tardis-holder-multicolor.3mf in Bambu Studio. You should see "
        "one object named TARDIS Scrunchy Holder with four parts. If a second "
        "Studio window is already open, use File Open on that 3MF so you do not "
        "land in an empty Untitled plate.",
        st["body"],
    ))

    story.append(Paragraph("Step 8  ·  What to copy next time", st["step"]))
    story.append(bullets([
        "Lock look, function, and delivery in the first prompt (or extract them before you model).",
        "Put every color in one SCAD file with a PART switch and shared helpers (the 2D sign, the 2D slot).",
        "Cut pockets from the body; fill them with other colors. Do not overlap.",
        "Model holes as rounded 2D profiles extruded through a wall, then union them with a real interior cavity if the object must be hollow.",
        "Treat later prompts as diffs: one-line sign, mirror, delete gold, copy the cut to the other side.",
        "Keep a rebuild script. A 3MF that Bambu wrote back to disk can overwrite your pack; write a second filename if needed.",
    ], st))
    story.append(Paragraph(
        "Source of truth: cad/tardis_scrunchy_holder.scad. Print file: "
        "print/tardis-holder-multicolor.3mf. Prompts: prompts.md. Rebuild: "
        "python scripts/export_tardis.py. This PDF: python scripts/make_learning_guide.py.",
        st["body"],
    ))

    doc = SimpleDocTemplate(
        OUT,
        pagesize=letter,
        leftMargin=0.75 * inch,
        rightMargin=0.75 * inch,
        topMargin=0.55 * inch,
        bottomMargin=0.5 * inch,
        title="Building a TARDIS scrunchy holder",
        author="scrunchy-holders",
        subject="Learning guide: OpenSCAD multi-color TARDIS holder to Bambu Studio",
    )
    doc.build(story, onFirstPage=cover_header_footer, onLaterPages=header_footer)
    print("wrote", OUT, os.path.getsize(OUT))
    return OUT


if __name__ == "__main__":
    build()
