"""Build scrunchy-holder-theme-catalog.pdf from print/catalog previews."""
from __future__ import annotations

import os
import sys

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.lib.utils import ImageReader
from reportlab.platypus import (
    Image,
    KeepTogether,
    PageBreak,
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
CAT = os.path.join(ROOT, "print", "catalog")
OUT = os.path.join(ROOT, "scrunchy-holder-theme-catalog.pdf")

sys.path.insert(0, os.path.dirname(__file__))
from export_catalog import DESIGNS  # noqa: E402

NAVY = colors.HexColor("#003B6F")
INK = colors.HexColor("#0b0f19")
MUTED = colors.HexColor("#4b5563")
PAPER = colors.HexColor("#ffffff")
RULE = colors.HexColor("#cbd5e1")
CARD = colors.HexColor("#f8fafc")


def styles():
    base = getSampleStyleSheet()
    return {
        "cover_kicker": ParagraphStyle(
            "cover_kicker", parent=base["Normal"],
            fontName="Helvetica", fontSize=10, textColor=colors.white,
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
        "theme": ParagraphStyle(
            "theme", parent=base["Heading1"],
            fontName="Helvetica-Bold", fontSize=16, leading=20,
            textColor=NAVY, spaceBefore=4, spaceAfter=4,
        ),
        "title": ParagraphStyle(
            "title", parent=base["Heading2"],
            fontName="Helvetica-Bold", fontSize=12, leading=15,
            textColor=INK, spaceBefore=0, spaceAfter=2,
        ),
        "body": ParagraphStyle(
            "body", parent=base["BodyText"],
            fontName="Helvetica", fontSize=9.5, leading=12.5,
            textColor=INK, alignment=TA_LEFT, spaceAfter=2,
        ),
        "meta": ParagraphStyle(
            "meta", parent=base["Normal"],
            fontName="Courier", fontSize=7.5, leading=10,
            textColor=MUTED, spaceAfter=4,
        ),
        "caption": ParagraphStyle(
            "caption", parent=base["Normal"],
            fontName="Helvetica-Oblique", fontSize=8, leading=11,
            textColor=MUTED, alignment=TA_CENTER, spaceBefore=2, spaceAfter=4,
        ),
        "index": ParagraphStyle(
            "index", parent=base["Normal"],
            fontName="Helvetica", fontSize=10, leading=14,
            textColor=INK, spaceAfter=2,
        ),
    }


def header_footer(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(PAPER)
    canvas.rect(0, 0, letter[0], letter[1], fill=1, stroke=0)
    canvas.setFillColor(NAVY)
    canvas.rect(0, letter[1] - 18, letter[0], 18, fill=1, stroke=0)
    canvas.setFillColor(colors.white)
    canvas.setFont("Helvetica", 8)
    canvas.drawString(0.75 * inch, letter[1] - 13,
                      "Scrunchy holder theme catalog  ·  30 freeform designs")
    canvas.setFillColor(NAVY)
    canvas.rect(0, 0, letter[0], 28, fill=1, stroke=0)
    canvas.setFillColor(colors.white)
    canvas.setFont("Helvetica", 8)
    canvas.drawCentredString(letter[0] / 2, 12, f"Page {doc.page}")
    canvas.restoreState()


def cover_hf(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(PAPER)
    canvas.rect(0, 0, letter[0], letter[1], fill=1, stroke=0)
    canvas.setFillColor(NAVY)
    canvas.rect(0, letter[1] - 72, letter[0], 72, fill=1, stroke=0)
    canvas.setFillColor(colors.white)
    canvas.setFont("Helvetica", 9)
    canvas.drawCentredString(letter[0] / 2, letter[1] - 42,
                             "SCRUNCHY HOLDERS  ·  THEME CATALOG")
    canvas.setFillColor(NAVY)
    canvas.rect(0, 0, letter[0], 36, fill=1, stroke=0)
    canvas.setFillColor(colors.white)
    canvas.setFont("Helvetica", 8)
    canvas.drawCentredString(
        letter[0] / 2, 14,
        "OpenSCAD  ·  hollow center  ·  keyhole slides on both sides",
    )
    canvas.restoreState()


def fig(path, max_w, max_h):
    if not os.path.isfile(path):
        return Paragraph(f"[missing {os.path.basename(path)}]",
                         ParagraphStyle("miss", fontName="Helvetica-Oblique",
                                        fontSize=9, textColor=MUTED,
                                        alignment=TA_CENTER))
    ir = ImageReader(path)
    iw, ih = ir.getSize()
    scale = min(max_w / iw, max_h / ih)
    return Image(path, width=iw * scale, height=ih * scale, hAlign="CENTER")


def card(design, st):
    slug, scad, variant, theme, title, blurb = design
    png = os.path.join(CAT, f"{slug}.png")
    img = fig(png, 3.05 * inch, 2.85 * inch)
    cap_w = 3.15 * inch
    body = Table(
        [[Paragraph(theme, st["meta"])],
         [Paragraph(title, st["title"])],
         [Paragraph(blurb, st["body"])],
         [Paragraph(f"cad/{scad}  VARIANT={variant}", st["meta"])],
         [Paragraph(f"print/catalog/{slug}.stl", st["meta"])]],
        colWidths=[cap_w],
    )
    body.setStyle(TableStyle([
        ("LEFTPADDING", (0, 0), (-1, -1), 0),
        ("RIGHTPADDING", (0, 0), (-1, -1), 0),
        ("TOPPADDING", (0, 0), (-1, -1), 1),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 1),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("BACKGROUND", (0, 0), (-1, -1), CARD),
    ]))
    inner = Table([[img], [body]], colWidths=[3.3 * inch])
    inner.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), CARD),
        ("BOX", (0, 0), (-1, -1), 0.6, RULE),
        ("LEFTPADDING", (0, 0), (-1, -1), 8),
        ("RIGHTPADDING", (0, 0), (-1, -1), 8),
        ("TOPPADDING", (0, 0), (0, 0), 8),
        ("BOTTOMPADDING", (0, -1), (-1, -1), 8),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("ALIGN", (0, 0), (0, 0), "CENTER"),
    ]))
    return inner


def build():
    st = styles()
    story = []
    story.append(Spacer(1, 0.9 * inch))
    story.append(Paragraph("30 DESIGNS  ·  6 THEMES", st["cover_sub"]))
    story.append(Paragraph("Scrunchy holder<br/>theme catalog", st["cover_title"]))
    story.append(Paragraph(
        "Each holder keeps the same mechanics as the TARDIS and the red phone booth: "
        "a hollow center, and a rounded keyhole slide on both sides "
        "(40 percent channel, 90 percent by 25 mm loading slots, 5 mm from top and bottom). "
        "The shells are freeform. They are not phone booths.",
        st["cover_sub"],
    ))
    story.append(Paragraph(
        "17 September 2026  ·  repo scrunchy-holders  ·  cad/*_holders.scad",
        st["cover_sub"],
    ))
    story.append(Spacer(1, 0.2 * inch))

    themes = []
    seen = []
    for d in DESIGNS:
        if d[3] not in seen:
            seen.append(d[3])
            names = [x[4] for x in DESIGNS if x[3] == d[3]]
            themes.append(f"<b>{d[3]}</b> — " + "; ".join(names))
    for line in themes:
        story.append(Paragraph(line, st["index"]))

    story.append(Spacer(1, 0.25 * inch))
    story.append(Paragraph(
        "Open a design in Bambu Studio from print/catalog/&lt;slug&gt;.stl. "
        "Rebuild previews with python scripts/export_catalog.py --stl. "
        "Rebuild this PDF with python scripts/make_theme_catalog.py.",
        st["cover_sub"],
    ))

    by_theme = []
    cur = None
    bucket = []
    for d in DESIGNS:
        if d[3] != cur:
            if bucket:
                by_theme.append((cur, bucket))
            cur = d[3]
            bucket = [d]
        else:
            bucket.append(d)
    if bucket:
        by_theme.append((cur, bucket))

    for theme, items in by_theme:
        story.append(PageBreak())
        story.append(Paragraph(theme, st["theme"]))
        story.append(Paragraph(
            "Hollow center. Keyhole slides on the left and right faces. "
            "Character detail on the front, back, and roof.",
            st["body"],
        ))
        story.append(Spacer(1, 0.08 * inch))
        # 2 cards per row, leftover centered.
        rows = []
        i = 0
        while i < len(items):
            if i + 1 < len(items):
                rows.append([card(items[i], st), card(items[i + 1], st)])
                i += 2
            else:
                rows.append([card(items[i], st), Spacer(3.3 * inch, 1)])
                i += 1
        grid = Table(rows, colWidths=[3.45 * inch, 3.45 * inch])
        grid.setStyle(TableStyle([
            ("VALIGN", (0, 0), (-1, -1), "TOP"),
            ("LEFTPADDING", (0, 0), (-1, -1), 4),
            ("RIGHTPADDING", (0, 0), (-1, -1), 4),
            ("TOPPADDING", (0, 0), (-1, -1), 4),
            ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
            ("BACKGROUND", (0, 0), (-1, -1), PAPER),
        ]))
        story.append(grid)

    doc = SimpleDocTemplate(
        OUT,
        pagesize=letter,
        leftMargin=0.6 * inch,
        rightMargin=0.6 * inch,
        topMargin=0.45 * inch,
        bottomMargin=0.45 * inch,
        title="Scrunchy holder theme catalog",
        author="scrunchy-holders",
        subject="30 freeform themed scrunchy holders",
    )
    doc.build(story, onFirstPage=cover_hf, onLaterPages=header_footer)
    print("wrote", OUT, os.path.getsize(OUT))
    return OUT


if __name__ == "__main__":
    build()
