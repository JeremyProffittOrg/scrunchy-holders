// Shared mechanical core for themed scrunchy holders.
// Same contract as the TARDIS and K6 booth:
//   * Hollow center with ~3.6 mm walls and a 3 mm floor.
//   * Left and right faces (±X) get a keyhole slide into that hollow.
//   * Slide is 40% of body depth, centered on Y.
//   * Loading slots are 90% of depth × 25 mm, 5 mm from the top and
//     bottom of the FUNCTIONAL body (decorative roofs sit above body_h).
//   * Convex and concave corners rounded 5 mm.
// Character lives on ±Y and on anything above body_h. Keep ±X as slot faces.

slot_margin = 5;
slot_end_h = 25;
slot_slide_frac = 0.40;
slot_end_frac = 0.90;
slot_corner_r = 5;

wall = 3.6;
floor_t = 3;
roof_plug = 4;

module rounded_rect(w, h, r) {
    r2 = min(r, w / 2 - 0.05, h / 2 - 0.05);
    offset(r = r2)
        offset(delta = -r2)
            square([w, h], center = true);
}

module rounded_xy(w, d, r) {
    r2 = min(r, w / 2 - 0.05, d / 2 - 0.05);
    offset(r = r2)
        offset(delta = -r2)
            square([w, d], center = true);
}

module rounded_xy_cube(w, d, h, r = 4) {
    linear_extrude(height = h, convexity = 4)
        rounded_xy(w, d, r);
}

module slot_profile_2d(body_d, body_h) {
    slide_w = body_d * slot_slide_frac;
    end_w = body_d * slot_end_frac;
    h = body_h;
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

module scrunchy_slot_one_side(body_w, body_d, body_h, wall_x = wall) {
    depth = wall_x + 10;
    translate([body_w / 2 + 0.4, 0, 0])
        rotate([0, -90, 0])
            linear_extrude(height = depth + 0.8, convexity = 8)
                slot_profile_2d(body_d, body_h);
}

module scrunchy_slots(body_w, body_d, body_h, wall_x = wall) {
    scrunchy_slot_one_side(body_w, body_d, body_h, wall_x);
    mirror([1, 0, 0])
        scrunchy_slot_one_side(body_w, body_d, body_h, wall_x);
}

module box_cavity(body_w, body_d, body_h,
                  wall_x = wall, wall_y = wall,
                  floor = floor_t, roof = roof_plug) {
    x0 = -body_w / 2 + wall_x;
    x1 = body_w / 2 - wall_x;
    y0 = -body_d / 2 + wall_y;
    y1 = body_d / 2 - wall_y;
    z0 = floor;
    z1 = body_h - roof;
    translate([x0, y0, z0])
        cube([x1 - x0, y1 - y0, max(0.5, z1 - z0)]);
}

module cyl_cavity(diam, body_h,
                  wall_x = wall,
                  floor = floor_t, roof = roof_plug) {
    translate([0, 0, floor])
        cylinder(h = max(0.5, body_h - floor - roof),
                 d = max(8, diam - 2 * wall_x), $fn = 36);
}

module sphere_cavity(diam, wall_x = wall, floor = floor_t) {
    r = diam / 2;
    inner = max(8, r - wall_x);
    difference() {
        translate([0, 0, r])
            sphere(r = inner, $fn = 40);
        translate([0, 0, -r])
            cube([diam * 2, diam * 2, floor * 2 + r], center = true);
    }
}

// Outer sphere sitting on z = 0 with a small flat print foot.
module flat_sphere(r, foot = 4, fn = 44) {
    difference() {
        translate([0, 0, r])
            sphere(r = r, $fn = fn);
        translate([0, 0, -r])
            cube([r * 4, r * 4, (r - foot) * 2], center = true);
    }
}

module frustum_cyl(d1, d2, h, fn = 36) {
    cylinder(h = h, d1 = d1, d2 = d2, $fn = fn);
}

module torus(r, tube, fn = 36) {
    rotate_extrude($fn = fn)
        translate([r, 0, 0])
            circle(r = tube, $fn = 20);
}

module hex_prism(across, h) {
    cylinder(h = h, d = across, $fn = 6);
}

module cone(d1, d2, h, fn = 36) {
    cylinder(h = h, d1 = d1, d2 = d2, $fn = fn);
}

module hemisphere(r, fn = 40) {
    intersection() {
        sphere(r = r, $fn = fn);
        translate([0, 0, r])
            cube([r * 2.2, r * 2.2, r * 2], center = true);
    }
}

module ring(d_outer, d_inner, h, fn = 36) {
    difference() {
        cylinder(h = h, d = d_outer, $fn = fn);
        translate([0, 0, -0.2])
            cylinder(h = h + 0.4, d = d_inner, $fn = fn);
    }
}

module panel_box(w, d, h) {
    cube([w, d, h], center = true);
}

// 2D (x,y) -> front face (X, Z), extruded toward -Y.
module front_inlay(body_d, d) {
    multmatrix([
        [1, 0, 0, 0],
        [0, 0, -1, body_d / 2],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 12)
            children();
}

module back_inlay(body_d, d) {
    multmatrix([
        [-1, 0, 0, 0],
        [0, 0, 1, -body_d / 2],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 12)
            children();
}

module holder_cuts(body_w, body_d, body_h, kind = "box", roof = 4) {
    if (kind == "box")
        box_cavity(body_w, body_d, body_h, roof = roof);
    else if (kind == "cyl")
        cyl_cavity(min(body_w, body_d), body_h, roof = roof);
    else if (kind == "sphere")
        sphere_cavity(min(body_w, body_d, body_h));
    scrunchy_slots(body_w, body_d, body_h);
}

module cut_holder(body_w, body_d, body_h, kind = "box", roof = 4) {
    difference() {
        children();
        holder_cuts(body_w, body_d, body_h, kind, roof);
    }
}

// Color survives CSG: each paint group is differenced on its own.
module painted(c, body_w, body_d, body_h, kind = "box", roof = 4) {
    color(c)
        difference() {
            children();
            holder_cuts(body_w, body_d, body_h, kind, roof);
        }
}

module body_cube(w, d, h) {
    translate([0, 0, h / 2])
        cube([w, d, h], center = true);
}
