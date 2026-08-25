// TARDIS-style scrunchy holder.
// Front reads as a police box. The box is a hollow shell. Right side
// has a scrunchy slide that opens into that hollow: a 40% wide centered
// channel with 90% x 25mm loading slots, 5mm from the top and bottom,
// all corners rounded.
//
// Export parts for Bambu AMS (same origin, complementary volumes):
//   openscad -D PART=\"blue\"  -o print/tardis_blue.stl  cad/tardis_scrunchy_holder.scad
//   openscad -D PART=\"white\" -o print/tardis_white.stl cad/tardis_scrunchy_holder.scad
//   openscad -D PART=\"black\" -o print/tardis_black.stl cad/tardis_scrunchy_holder.scad
//   openscad -D PART=\"gold\"  -o print/tardis_gold.stl  cad/tardis_scrunchy_holder.scad

PART = "all"; // all | blue | white | black | gold

$fa = 8;
$fs = 0.45;

body_w = 90;
body_d = 90;
plinth_h = 8;
plinth_extra = 2.8;
post_w = 7.2;
post_h = 150;
sign_h = 14;
cornice_h = 5;
roof_step_h = 4.2;
roof_step_inset = 3.2;
roof_pyramid_h = 9;
roof_pyramid_top = 22;

wall_front = 6;
wall_back = 3.6;
wall_left = 3.6;
wall_right = 3.6;
floor_t = 3;
// Punch the side slide through the right wall into the hollow.
slot_depth = wall_right + 10;

slot_margin = 5;
slot_end_h = 25;
slot_slide_frac = 0.40;
slot_end_frac = 0.90;
slot_corner_r = 5;

panel_inset = 2.4;
panel_gap = 2.2;
panel_recess = 1.7;
door_gap = 1.5;
window_margin = 2.2;
window_cols = 2;
window_rows = 3;
muntin = 1.35;
window_pocket_d = 3.6;
glass_recess = 0.7;
muntin_d = 1.5;

sign_inset = 2.0;
sign_d = 2.4;
sign_recess = 0.5;
sign_font = "Arial:style=Bold";

lamp_base = 13;
lamp_base_h = 3.2;
lamp_glass_r = 5.1;
lamp_glass_h = 10.5;
lamp_cap_r = 5.6;

function body_h() = plinth_h + post_h + sign_h + cornice_h;
function row_h() = post_h / 4;
function inner_w() = body_w - 2 * post_w;
function door_w() = (inner_w() - door_gap) / 2;
function left_door_cx() = -(door_gap / 2 + door_w() / 2);
function right_door_cx() = (door_gap / 2 + door_w() / 2);
function window_w() = door_w() - 2 * window_margin;
function window_h() = row_h() - 2 * window_margin;
function window_z() = plinth_h + 3 * row_h() + row_h() / 2;
function sign_z() = plinth_h + post_h + sign_h / 2;
function roof_z0() = body_h();
function lamp_z0() = roof_z0() + 2 * roof_step_h + roof_pyramid_h;

module rounded_rect(w, h, r) {
    r2 = min(r, w / 2 - 0.05, h / 2 - 0.05);
    offset(r = r2)
        offset(delta = -r2)
            square([w, h], center = true);
}

// 2D slot in (Z, Y): x = world Z, y = world Y.
module slot_profile_2d() {
    slide_w = body_d * slot_slide_frac;
    end_w = body_d * slot_end_frac;
    h = body_h();
    // Round convex and concave corners, keep the slot size.
    offset(r = slot_corner_r)
        offset(r = -slot_corner_r)
            offset(r = -slot_corner_r)
                offset(r = slot_corner_r)
                    union() {
                        translate([slot_margin, -slide_w / 2])
                            square([h - 2 * slot_margin, slide_w]);
                        translate([slot_margin, -end_w / 2])
                            square([slot_end_h, end_w]);
                        translate([h - slot_margin - slot_end_h, -end_w / 2])
                            square([slot_end_h, end_w]);
                    }
}

module scrunchy_slot_cut() {
    // Extrude the YZ profile in -X from the right face.
    translate([body_w / 2 + 0.4, 0, 0])
        rotate([0, -90, 0])
            linear_extrude(height = slot_depth + 0.8, convexity = 8)
                slot_profile_2d();
}

module pane_muntins_2d(w, h) {
    difference() {
        square([w, h], center = true);
        pw = (w - (window_cols + 1) * muntin) / window_cols;
        ph = (h - (window_rows + 1) * muntin) / window_rows;
        for (c = [0:window_cols - 1], r = [0:window_rows - 1])
            translate([
                -w / 2 + muntin + c * (pw + muntin) + pw / 2,
                -h / 2 + muntin + r * (ph + muntin) + ph / 2
            ])
                square([pw, ph], center = true);
    }
}

module pane_glass_2d(w, h) {
    pw = (w - (window_cols + 1) * muntin) / window_cols;
    ph = (h - (window_rows + 1) * muntin) / window_rows;
    for (c = [0:window_cols - 1], r = [0:window_rows - 1])
        translate([
            -w / 2 + muntin + c * (pw + muntin) + pw / 2,
            -h / 2 + muntin + r * (ph + muntin) + ph / 2
        ])
            square([pw, ph], center = true);
}

module sign_letters_2d() {
    translate([0, 2.35])
        text("POLICE", size = 5.8, font = sign_font,
             halign = "center", valign = "center", spacing = 1.04);
    translate([0, -3.15])
        text("BOX", size = 5.8, font = sign_font,
             halign = "center", valign = "center", spacing = 1.08);
}

// 2D (x,y) -> front face (X, Z), extruded toward -Y.
module front_inlay(d) {
    multmatrix([
        [1, 0, 0, 0],
        [0, 0, -1, body_d / 2],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 12)
            children();
}

// 2D (x,y) -> left face (Y, Z), extruded toward +X.
module left_inlay(d) {
    multmatrix([
        [0, 0, 1, -body_w / 2],
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 12)
            children();
}

// 2D (x,y) -> back face (X, Z), extruded toward +Y.
module back_inlay(d) {
    multmatrix([
        [-1, 0, 0, 0],
        [0, 0, 1, -body_d / 2],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 12)
            children();
}

module two_bay_windows_2d() {
    translate([left_door_cx(), window_z()])
        square([window_w(), window_h()], center = true);
    translate([right_door_cx(), window_z()])
        square([window_w(), window_h()], center = true);
}

module two_bay_muntins_2d() {
    translate([left_door_cx(), window_z()])
        pane_muntins_2d(window_w(), window_h());
    translate([right_door_cx(), window_z()])
        pane_muntins_2d(window_w(), window_h());
}

module two_bay_glass_2d() {
    translate([left_door_cx(), window_z()])
        pane_glass_2d(window_w(), window_h());
    translate([right_door_cx(), window_z()])
        pane_glass_2d(window_w(), window_h());
}

module panel_squares_2d() {
    pw = door_w() - 2 * panel_inset;
    ph = row_h() - panel_gap;
    for (bay = [left_door_cx(), right_door_cx()])
        for (row = [0:2])
            translate([bay, plinth_h + row * row_h() + row_h() / 2])
                square([pw, ph], center = true);
}

module frustum(s1, s2, h) {
    hull() {
        translate([0, 0, 0.05])
            cube([s1, s1, 0.1], center = true);
        translate([0, 0, h - 0.05])
            cube([s2, s2, 0.1], center = true);
    }
}

module blue_solid() {
    bw = body_w;
    bd = body_d;
    bh = body_h();

    // Plinth
    translate([0, 0, plinth_h / 2])
        cube([bw + 2 * plinth_extra, bd + 2 * plinth_extra, plinth_h], center = true);

    // Main box (plinth to cornice)
    translate([0, 0, plinth_h + (bh - plinth_h) / 2])
        cube([bw, bd, bh - plinth_h], center = true);

    // Corner posts, proud on front / left / back. Right face stays flat for the slide.
    post_proud = 0.9;
    post_d_front = bd + post_proud;
    for (sx = [-1, 1]) {
        // Front-left and front-right posts (front proud)
        translate([sx * (bw / 2 - post_w / 2), post_proud / 2, plinth_h + post_h / 2])
            cube([post_w, post_d_front, post_h], center = true);
        // Back posts (back proud)
        translate([sx * (bw / 2 - post_w / 2), -post_proud / 2, plinth_h + post_h / 2])
            cube([post_w, bd + post_proud, post_h], center = true);
    }
    // Left-face post wrap already covered by X positions. Extra left proud:
    translate([-(bw / 2 + post_proud / 2), 0, plinth_h + post_h / 2])
        cube([post_proud, bd - 2, post_h], center = true);

    // Cornice / lintel wrap
    translate([0, 0, plinth_h + post_h + sign_h + cornice_h / 2])
        cube([bw + 3.2, bd + 3.2, cornice_h], center = true);

    // Roof steps + pyramid
    rz = roof_z0();
    translate([0, 0, rz + roof_step_h / 2])
        cube([bw - 2, bd - 2, roof_step_h], center = true);
    translate([0, 0, rz + roof_step_h + roof_step_h / 2])
        cube([bw - 2 - 2 * roof_step_inset, bd - 2 - 2 * roof_step_inset, roof_step_h], center = true);
    translate([0, 0, rz + 2 * roof_step_h])
        frustum(bw - 2 - 4 * roof_step_inset, roof_pyramid_top, roof_pyramid_h);

}

module interior_cavity() {
    // Empty shell: thin walls, floor, and a solid roof/sign cap.
    x0 = -body_w / 2 + wall_left;
    x1 = body_w / 2 - wall_right;
    y0 = -body_d / 2 + wall_back;
    y1 = body_d / 2 - wall_front;
    z0 = floor_t;
    z1 = body_h() - 3;
    translate([x0, y0, z0])
        cube([x1 - x0, y1 - y0, z1 - z0]);
}

module door_gap_cut() {
    translate([-door_gap / 2, body_d / 2 - 2.2, plinth_h + 1])
        cube([door_gap, 2.4, post_h - 2]);
}

module phone_pocket_2d() {
    // Left door, row under the window.
    pw = door_w() * 0.62;
    ph = row_h() * 0.55;
    translate([left_door_cx(), plinth_h + 2 * row_h() + row_h() / 2])
        square([pw, ph], center = true);
}

module handle_cut() {
    translate([right_door_cx() + door_w() * 0.22, body_d / 2 - 0.6,
               plinth_h + 1.45 * row_h()])
        rotate([-90, 0, 0]) {
            cylinder(h = 4.2, r = 2.2);
            translate([0, 0, 3.7])
                rotate([0, 90, 0])
                    cylinder(h = 9.6, r = 1.85, center = true);
        }
}

module badge_cut() {
    translate([right_door_cx(), body_d / 2 - 0.2,
               plinth_h + 0.55 * row_h()])
        rotate([-90, 0, 0])
            cylinder(h = 2.4, r = 5.1);
}

module blue_part() {
    difference() {
        blue_solid();
        interior_cavity();
        scrunchy_slot_cut();
        door_gap_cut();
        handle_cut();
        badge_cut();
        front_inlay(window_pocket_d + 0.05) two_bay_windows_2d();
        front_inlay(panel_recess) panel_squares_2d();
        front_inlay(sign_d + sign_recess + 0.05)
            translate([0, sign_z()])
                square([inner_w() - 2 * sign_inset, sign_h - 1.6], center = true);
        front_inlay(window_pocket_d)
            phone_pocket_2d();
        left_inlay(window_pocket_d + 0.05) two_bay_windows_2d();
        left_inlay(panel_recess) panel_squares_2d();
        back_inlay(window_pocket_d + 0.05) two_bay_windows_2d();
        back_inlay(panel_recess) panel_squares_2d();
    }
}

module white_part() {
    // Window muntins, flush with the outer faces.
    front_inlay(muntin_d) two_bay_muntins_2d();
    left_inlay(muntin_d) two_bay_muntins_2d();
    back_inlay(muntin_d) two_bay_muntins_2d();

    // Phone hatch frame
    front_inlay(muntin_d)
        difference() {
            phone_pocket_2d();
            offset(delta = -1.25) phone_pocket_2d();
        }

    // POLICE BOX letters, inset with the sign plate
    translate([0, -sign_recess, 0])
        front_inlay(sign_d)
            translate([0, sign_z()])
                sign_letters_2d();

    // Lamp glass
    translate([0, 0, lamp_z0() + lamp_base_h])
        cylinder(h = lamp_glass_h, r = lamp_glass_r);
}

module black_part() {
    // Full window plates sit behind the white muntins so the panes read black.
    back_d = window_pocket_d - muntin_d - 0.1;
    shift = muntin_d + 0.1;
    translate([0, -shift, 0])
        front_inlay(back_d) two_bay_windows_2d();
    translate([shift, 0, 0])
        left_inlay(back_d) two_bay_windows_2d();
    translate([0, shift, 0])
        back_inlay(back_d) two_bay_windows_2d();

    // Sign plate minus letters, inset so the band reads from the front
    translate([0, -sign_recess, 0])
        front_inlay(sign_d)
            translate([0, sign_z()])
                difference() {
                    square([inner_w() - 2 * sign_inset, sign_h - 1.6], center = true);
                    sign_letters_2d();
                }

    // Phone hatch glass, behind the white frame
    translate([0, -shift, 0])
        front_inlay(back_d)
            offset(delta = -1.25) phone_pocket_2d();
}

module gold_handle() {
    translate([right_door_cx() + door_w() * 0.22, body_d / 2 - 0.4,
               plinth_h + 1.45 * row_h()])
        rotate([-90, 0, 0]) {
            cylinder(h = 3.2, r = 2.0);
            translate([0, 0, 3.1])
                rotate([0, 90, 0])
                    cylinder(h = 9.0, r = 1.6, center = true);
        }
}

module gold_badge() {
    translate([right_door_cx(), body_d / 2 - 0.6,
               plinth_h + 0.55 * row_h()])
        rotate([-90, 0, 0]) {
            cylinder(h = 1.4, r = 4.9);
            // St John-style cross, proud of the disc
            translate([0, 0, 1.5])
                cube([1.8, 7.0, 1.4], center = true);
            translate([0, 0, 1.5])
                cube([7.0, 1.8, 1.4], center = true);
        }
}

module gold_lamp() {
    translate([0, 0, lamp_z0()]) {
        translate([0, 0, lamp_base_h / 2])
            cube([lamp_base, lamp_base, lamp_base_h], center = true);
        // Hemisphere cap sitting on the white glass, no overlap
        translate([0, 0, lamp_base_h + lamp_glass_h])
            intersection() {
                sphere(r = lamp_cap_r);
                translate([0, 0, lamp_cap_r])
                    cube([lamp_cap_r * 2.2, lamp_cap_r * 2.2, lamp_cap_r * 2], center = true);
            }
        // Cage rings outside the white glass
        translate([0, 0, lamp_base_h + 0.55])
            difference() {
                cylinder(h = 1.15, r = lamp_glass_r + 0.9);
                translate([0, 0, -0.2])
                    cylinder(h = 1.55, r = lamp_glass_r + 0.08);
            }
        translate([0, 0, lamp_base_h + lamp_glass_h - 1.7])
            difference() {
                cylinder(h = 1.15, r = lamp_glass_r + 0.9);
                translate([0, 0, -0.2])
                    cylinder(h = 1.55, r = lamp_glass_r + 0.08);
            }
    }
}

module gold_part() {
    gold_handle();
    gold_badge();
    gold_lamp();
}

module assembly() {
    if (PART == "all" || PART == "blue")
        color("#003B6F") blue_part();
    if (PART == "all" || PART == "white")
        color("#F4F1E8") white_part();
    if (PART == "all" || PART == "black")
        color("#1A1A1A") black_part();
    if (PART == "all" || PART == "gold")
        color("#D4A017") gold_part();
}

assembly();

echo(str("body ", body_w, "x", body_d, "x", body_h(),
         "  slide ", body_d * slot_slide_frac,
         "  end-slot ", body_d * slot_end_frac, "x", slot_end_h,
         "  total-h ", lamp_z0() + lamp_base_h + lamp_glass_h + lamp_cap_r));
