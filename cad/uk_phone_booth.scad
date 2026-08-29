// UK K6 red telephone-box scrunchy holder.
// Front reads as a Giles Gilbert Scott K6 with TARDIS-style two-bay
// windows (2 x 3 panes, black muntins, white glass). The left window
// holds a Union Flag. The box is a hollow shell. Left and right sides
// each have a scrunchy slide: a 40% wide centered channel with 90% x
// 25mm loading slots, 5mm from the top and bottom, rounded corners.
//
// Export parts for Bambu AMS (same origin, complementary volumes):
//   openscad -D PART=\"red\"   -o print/uk_phone_booth_red.stl   cad/uk_phone_booth.scad
//   openscad -D PART=\"white\" -o print/uk_phone_booth_white.stl cad/uk_phone_booth.scad
//   openscad -D PART=\"blue\"  -o print/uk_phone_booth_blue.stl  cad/uk_phone_booth.scad
//   openscad -D PART=\"black\" -o print/uk_phone_booth_black.stl cad/uk_phone_booth.scad
//   openscad -D PART=\"gold\"  -o print/uk_phone_booth_gold.stl  cad/uk_phone_booth.scad

PART = "all"; // all | red | white | blue | black | gold

$fa = 8;
$fs = 0.45;

body_w = 90;
body_d = 90;
plinth_h = 10;
plinth_extra = 3.2;
post_w = 7.0;
post_h = 176;
sign_h = 13;
cornice_h = 4.2;
pediment_h = 20;
dome_h = 6;

wall_front = 6;
wall_back = 4.2;
wall_left = 3.6;
wall_right = 3.6;
floor_t = 3;
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
muntin_d = 1.5;

sign_inset = 2.2;
sign_d = 2.2;
sign_recess = 0.5;
sign_font = "Times New Roman:style=Bold";
sign_size = 6.6;

crown_d = 1.6;

lamp_ball_r = 3.4;

function body_h() = plinth_h + post_h + sign_h + cornice_h;
function row_h() = post_h / 4;
function inner_w() = body_w - 2 * post_w;
function door_w() = (inner_w() - door_gap) / 2;
function left_door_cx() = -(door_gap / 2 + door_w() / 2);
function right_door_cx() = (door_gap / 2 + door_w() / 2);
function window_w() = door_w() - 2 * window_margin;
function window_h() = row_h() - 2 * window_margin;
function window_z() = plinth_h + 3 * row_h() + row_h() / 2;
function flag_w() = window_w() - 2 * muntin;
function flag_h() = window_h() - 2 * muntin;
function sign_z() = plinth_h + post_h + sign_h / 2;
function roof_z0() = body_h();
function crown_z() = roof_z0() + pediment_h * 0.36;
function dome_peak_z() = roof_z0() + pediment_h + 3.2;
function handle_z() = plinth_h + post_h * 0.44;
function handle_x() = -(body_w / 2 - post_w - 7.5);
function pediment_face() = body_d / 2 + 0.8;

module rounded_rect(w, h, r) {
    r2 = min(r, w / 2 - 0.05, h / 2 - 0.05);
    offset(r = r2)
        offset(delta = -r2)
            square([w, h], center = true);
}

module slot_profile_2d() {
    slide_w = body_d * slot_slide_frac;
    end_w = body_d * slot_end_frac;
    h = body_h();
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

module scrunchy_slot_one_side() {
    translate([body_w / 2 + 0.4, 0, 0])
        rotate([0, -90, 0])
            linear_extrude(height = slot_depth + 0.8, convexity = 8)
                slot_profile_2d();
}

module scrunchy_slot_cut() {
    scrunchy_slot_one_side();
    mirror([1, 0, 0])
        scrunchy_slot_one_side();
}

// 2D (x,y) -> front face (X, Z), extruded toward -Y.
module front_inlay(d) {
    multmatrix([
        [1, 0, 0, 0],
        [0, 0, -1, body_d / 2],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 16)
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
        linear_extrude(height = d, convexity = 16)
            children();
}

// 2D (x,y) -> back face (X, Z), extruded toward +Y. +x stays +X so
// the Union Flag hoist (left) is correct when looking at the back.
module back_inlay(d) {
    multmatrix([
        [1, 0, 0, 0],
        [0, 0, 1, -body_d / 2],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 16)
            children();
}

// 2D (x,y) -> right face (-Y, Z), extruded toward -X.
module right_inlay(d) {
    multmatrix([
        [0, 0, -1, body_w / 2],
        [-1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 16)
            children();
}

module pane_muntins_2d(w, h, cols, rows) {
    difference() {
        square([w, h], center = true);
        pw = (w - (cols + 1) * muntin) / cols;
        ph = (h - (rows + 1) * muntin) / rows;
        for (c = [0:cols - 1], r = [0:rows - 1])
            translate([
                -w / 2 + muntin + c * (pw + muntin) + pw / 2,
                -h / 2 + muntin + r * (ph + muntin) + ph / 2
            ])
                square([pw, ph], center = true);
    }
}

module pane_glass_2d(w, h, cols, rows) {
    pw = (w - (cols + 1) * muntin) / cols;
    ph = (h - (rows + 1) * muntin) / rows;
    for (c = [0:cols - 1], r = [0:rows - 1])
        translate([
            -w / 2 + muntin + c * (pw + muntin) + pw / 2,
            -h / 2 + muntin + r * (ph + muntin) + ph / 2
        ])
            square([pw, ph], center = true);
}

module two_bay_windows_2d() {
    translate([left_door_cx(), window_z()])
        square([window_w(), window_h()], center = true);
    translate([right_door_cx(), window_z()])
        square([window_w(), window_h()], center = true);
}

module right_window_muntins_2d() {
    translate([right_door_cx(), window_z()])
        pane_muntins_2d(window_w(), window_h(), window_cols, window_rows);
}

module right_window_glass_2d() {
    translate([right_door_cx(), window_z()])
        pane_glass_2d(window_w(), window_h(), window_cols, window_rows);
}

module left_window_frame_2d() {
    translate([left_door_cx(), window_z()])
        difference() {
            square([window_w(), window_h()], center = true);
            square([flag_w(), flag_h()], center = true);
        }
}

module panel_squares_2d() {
    for (bay = [left_door_cx(), right_door_cx()])
        for (row = [0:2])
            translate([bay, plinth_h + row * row_h() + row_h() / 2])
                square([window_w(), window_h()], center = true);
}

module panel_muntins_2d() {
    for (bay = [left_door_cx(), right_door_cx()])
        for (row = [0:2])
            translate([bay, plinth_h + row * row_h() + row_h() / 2])
                pane_muntins_2d(window_w(), window_h(), window_cols, 1);
}

module panel_glass_2d() {
    for (bay = [left_door_cx(), right_door_cx()])
        for (row = [0:2])
            translate([bay, plinth_h + row * row_h() + row_h() / 2])
                pane_glass_2d(window_w(), window_h(), window_cols, 1);
}

module sign_plate_2d() {
    translate([0, sign_z()])
        square([inner_w() - 2 * sign_inset, sign_h - 1.8], center = true);
}

module sign_letters_2d() {
    translate([0, sign_z()])
        mirror([1, 0])
            text("TELEPHONE", size = sign_size, font = sign_font,
                 halign = "center", valign = "center", spacing = 1.08);
}

module back_sign_letters_2d() {
    translate([0, sign_z()])
        text("TELEPHONE", size = sign_size, font = sign_font,
             halign = "center", valign = "center", spacing = 1.08);
}

module vent_slots_2d() {
    y = plinth_h + post_h + 1.15;
    for (x = [-20, 0, 20])
        translate([x, y])
            rounded_rect(11, 1.5, 0.6);
}

// --- Union Flag (3:5), hoist on -X, +Y up ---------------------------------
// Thicknesses follow the Flag Institute: St George red H/5, white
// fimbriation H/15; St Andrew white H/5; St Patrick red H/15, offset
// H/30 anti-clockwise (hoist side below the diagonals, fly side above).

module uk_diag_bar(w, h, t, ang, poff) {
    d = sqrt(w * w + h * h) * 1.45;
    rotate(ang)
        translate([0, poff])
            square([d, t], center = true);
}

module uk_st_andrew(w, h) {
    t = h / 5;
    a = atan2(h, w);
    intersection() {
        square([w, h], center = true);
        union() {
            uk_diag_bar(w, h, t, a, 0);
            uk_diag_bar(w, h, t, -a, 0);
        }
    }
}

module uk_st_george_white(w, h) {
    tw = h / 5 + 2 * (h / 15);
    square([tw, h], center = true);
    square([w, tw], center = true);
}

module uk_st_george_red(w, h) {
    tw = h / 5;
    square([tw, h], center = true);
    square([w, tw], center = true);
}

module uk_st_patrick(w, h) {
    t = h / 15;
    off = h / 30;
    a = atan2(h, w);
    intersection() {
        square([w, h], center = true);
        union() {
            intersection() {
                translate([-w / 4, 0])
                    square([w / 2 + 0.02, h + 0.02], center = true);
                union() {
                    uk_diag_bar(w, h, t, a, -off);
                    uk_diag_bar(w, h, t, -a, -off);
                }
            }
            intersection() {
                translate([w / 4, 0])
                    square([w / 2 + 0.02, h + 0.02], center = true);
                union() {
                    uk_diag_bar(w, h, t, a, off);
                    uk_diag_bar(w, h, t, -a, off);
                }
            }
        }
    }
}

module uk_flag_red_2d(w, h) {
    union() {
        uk_st_george_red(w, h);
        uk_st_patrick(w, h);
    }
}

module uk_flag_white_2d(w, h) {
    difference() {
        union() {
            uk_st_andrew(w, h);
            uk_st_george_white(w, h);
        }
        uk_flag_red_2d(w, h);
    }
}

module uk_flag_blue_2d(w, h) {
    difference() {
        square([w, h], center = true);
        uk_st_andrew(w, h);
        uk_st_george_white(w, h);
        uk_flag_red_2d(w, h);
    }
}

module uk_flag_frame_2d(w, h, t) {
    difference() {
        square([w + 2 * t, h + 2 * t], center = true);
        square([w, h], center = true);
    }
}

module flag_at_2d() {
    translate([left_door_cx(), window_z()])
        mirror([1, 0])
            children();
}

// Bold Tudor-crown silhouette so it still reads at ~15 mm.
module tudor_crown_2d() {
    scale([1.12, 1.12]) {
        translate([0, -0.3])
            square([13.2, 1.5], center = true);
        translate([0, 1.25])
            square([15.2, 3.0], center = true);
        for (x = [-5.6, 0, 5.6])
            translate([x, 1.25])
                circle(d = 2.2, $fn = 14);
        for (x = [-5.9, 5.9])
            translate([x, 4.55]) {
                square([1.8, 4.6], center = true);
                translate([0, 1.75])
                    square([4.0, 1.7], center = true);
            }
        translate([0, 5.35]) {
            square([1.9, 6.2], center = true);
            translate([0, 2.45])
                square([4.4, 1.7], center = true);
            translate([0, 3.55])
                circle(d = 1.9, $fn = 12);
        }
        for (x = [-3.0, 3.0])
            translate([x, 3.85]) {
                circle(d = 2.6, $fn = 14);
                translate([0, 1.7])
                    circle(d = 1.9, $fn = 12);
            }
    }
}

module crown_2d() {
    translate([0, crown_z()])
        tudor_crown_2d();
}

// Segmental pediment: circular arch of height h on a chord of width w.
module pediment_2d() {
    w = body_w + 3.0;
    h = pediment_h;
    r = (w * w / 4 + h * h) / (2 * h);
    intersection() {
        translate([-w / 2, 0])
            square([w, h + 4]);
        translate([0, h - r])
            circle(r = r, $fn = 64);
    }
}

// Four arched gables extruded to the centre, forming the K6 saucer roof.
module arch_roof() {
    translate([0, 0, roof_z0() + 1.1])
        cube([body_w + 2.4, body_d + 2.4, 2.2], center = true);
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([0, body_d / 2 + 0.8, roof_z0() - 0.15])
                rotate([90, 0, 0])
                    linear_extrude(height = body_d / 2 + 1.6, convexity = 8)
                        pediment_2d();
    translate([0, 0, roof_z0() + pediment_h - 1.6])
        scale([1, 1, 0.30])
            sphere(r = 15, $fn = 36);
}

module crown_front(d) {
    multmatrix([
        [1, 0, 0, 0],
        [0, 0, -1, pediment_face()],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 8)
            children();
}

module crown_back(d) {
    multmatrix([
        [1, 0, 0, 0],
        [0, 0, 1, -pediment_face()],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 8)
            children();
}

module crown_left(d) {
    multmatrix([
        [0, 0, 1, -pediment_face()],
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 8)
            children();
}

module crown_right(d) {
    multmatrix([
        [0, 0, -1, pediment_face()],
        [-1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 8)
            children();
}

module four_crowns(d) {
    crown_front(d) crown_2d();
    crown_back(d) crown_2d();
    crown_left(d) crown_2d();
    crown_right(d) crown_2d();
}

module red_solid() {
    bw = body_w;
    bd = body_d;
    bh = body_h();

    translate([0, 0, plinth_h / 2])
        cube([bw + 2 * plinth_extra, bd + 2 * plinth_extra, plinth_h],
             center = true);

    translate([0, 0, plinth_h + (bh - plinth_h) / 2])
        cube([bw, bd, bh - plinth_h], center = true);

    post_proud = 1.0;
    for (sx = [-1, 1]) {
        translate([sx * (bw / 2 - post_w / 2), post_proud / 2,
                   plinth_h + post_h / 2])
            cube([post_w, bd + post_proud, post_h], center = true);
        translate([sx * (bw / 2 - post_w / 2), -post_proud / 2,
                   plinth_h + post_h / 2])
            cube([post_w, bd + post_proud, post_h], center = true);
    }

    translate([0, 0, plinth_h + post_h + sign_h + cornice_h / 2])
        cube([bw + 3.4, bd + 3.4, cornice_h], center = true);

    arch_roof();
}

module interior_cavity() {
    x0 = -body_w / 2 + wall_left;
    x1 = body_w / 2 - wall_right;
    y0 = -body_d / 2 + wall_back;
    y1 = body_d / 2 - wall_front;
    z0 = floor_t;
    z1 = body_h() - 3;
    translate([x0, y0, z0])
        cube([x1 - x0, y1 - y0, z1 - z0]);
}

module door_reveal_cut() {
    translate([-door_gap / 2, body_d / 2 - 2.2, plinth_h + 1])
        cube([door_gap, 2.4, post_h - 2]);
}

module handle_cut() {
    translate([handle_x(), body_d / 2 - 1.6, handle_z()])
        cube([7.2, 3.2, 18], center = true);
}

function glass_back_d() = window_pocket_d - muntin_d - 0.1;
function glass_shift() = muntin_d + 0.1;

module flag_inlay(d) {
    translate([0, -glass_shift(), 0])
        front_inlay(d)
            flag_at_2d()
                children();
}

module red_part() {
    union() {
        difference() {
            red_solid();
            interior_cavity();
            scrunchy_slot_cut();
            door_reveal_cut();
            front_inlay(window_pocket_d + 0.05) two_bay_windows_2d();
            front_inlay(window_pocket_d + 0.05) panel_squares_2d();
            front_inlay(sign_d + sign_recess + 0.05) sign_plate_2d();
            front_inlay(1.1) vent_slots_2d();
            four_crowns(crown_d + 0.12);
            handle_cut();
            back_inlay(sign_d + sign_recess + 0.05) sign_plate_2d();
        }
        flag_inlay(glass_back_d())
            uk_flag_red_2d(flag_w(), flag_h());
    }
}

module white_part() {
    translate([0, -glass_shift(), 0])
        front_inlay(glass_back_d()) right_window_glass_2d();
    translate([0, -glass_shift(), 0])
        front_inlay(glass_back_d()) panel_glass_2d();

    translate([0, -sign_recess, 0])
        front_inlay(sign_d)
            difference() {
                sign_plate_2d();
                sign_letters_2d();
            }

    translate([0, sign_recess, 0])
        back_inlay(sign_d)
            difference() {
                sign_plate_2d();
                back_sign_letters_2d();
            }

    flag_inlay(glass_back_d())
        uk_flag_white_2d(flag_w(), flag_h());
}

module blue_part() {
    flag_inlay(glass_back_d())
        uk_flag_blue_2d(flag_w(), flag_h());
}

module black_part() {
    front_inlay(muntin_d) right_window_muntins_2d();
    front_inlay(muntin_d) left_window_frame_2d();
    front_inlay(muntin_d) panel_muntins_2d();

    translate([0, -sign_recess, 0])
        front_inlay(sign_d)
            sign_letters_2d();

    translate([0, sign_recess, 0])
        back_inlay(sign_d)
            back_sign_letters_2d();
}

module gold_handle() {
    hx = handle_x();
    hy = body_d / 2 + 0.2;
    hz = handle_z();
    translate([hx, hy, hz]) {
        hull() {
            translate([0, 0, 7.2])
                rotate([90, 0, 0])
                    cylinder(h = 4.2, r = 1.55, $fn = 20);
            translate([0, 0, -7.2])
                rotate([90, 0, 0])
                    cylinder(h = 4.2, r = 1.55, $fn = 20);
        }
        translate([0, -2.7, 7.2])
            sphere(r = 1.7, $fn = 16);
        translate([0, -2.7, -7.2])
            sphere(r = 1.7, $fn = 16);
    }
}

module gold_part() {
    four_crowns(crown_d);
    gold_handle();
    translate([0, 0, dome_peak_z() + lamp_ball_r * 0.55])
        sphere(r = lamp_ball_r, $fn = 24);
}

module assembly() {
    if (PART == "all" || PART == "red")
        color("#C8102E") red_part();
    if (PART == "all" || PART == "white")
        color("#F4F1E8") white_part();
    if (PART == "all" || PART == "blue")
        color("#012169") blue_part();
    if (PART == "all" || PART == "black")
        color("#1A1A1A") black_part();
    if (PART == "all" || PART == "gold")
        color("#D4A017") gold_part();
}

assembly();

echo(str("body ", body_w, "x", body_d, "x", body_h(),
         "  slide ", body_d * slot_slide_frac,
         "  end-slot ", body_d * slot_end_frac, "x", slot_end_h,
         "  total-h ", dome_peak_z() + lamp_ball_r * 1.4));
