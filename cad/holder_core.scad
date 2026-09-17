// Shared mechanical core for themed scrunchy holders.
// Same contract as the TARDIS and K6 booth:
//   * Hollow center with ~3.6 mm walls and a 3 mm floor.
//   * Left and right faces (±X) get a keyhole slide into that hollow.
//   * Slide is 40% of body depth, centered on Y.
//   * Loading slots are 90% of depth × 25 mm, 5 mm from the top and
//     bottom of the FUNCTIONAL body (decorative roofs sit above body_h).
//   * Convex and concave corners rounded 5 mm.
// Character lives on the front (+Y) and wraps toward +X (negative
// wrap angles) so a 3/4 camera still reads the theme.

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
                 d = max(8, diam - 2 * wall_x), $fn = 40);
}

module sphere_cavity(diam, wall_x = wall, floor = floor_t) {
    r = diam / 2;
    inner = max(8, r - wall_x);
    difference() {
        translate([0, 0, r])
            sphere(r = inner, $fn = 48);
        translate([0, 0, -r])
            cube([diam * 2, diam * 2, floor * 2 + r], center = true);
    }
}

module flat_sphere(r, foot = 4, fn = 48) {
    difference() {
        translate([0, 0, r])
            sphere(r = r, $fn = fn);
        translate([0, 0, -r])
            cube([r * 4, r * 4, (r - foot) * 2], center = true);
    }
}

module frustum_cyl(d1, d2, h, fn = 40) {
    cylinder(h = h, d1 = d1, d2 = d2, $fn = fn);
}

module torus(r, tube, fn = 40) {
    rotate_extrude($fn = fn)
        translate([r, 0, 0])
            circle(r = tube, $fn = 20);
}

module hex_prism(across, h) {
    cylinder(h = h, d = across, $fn = 6);
}

module cone(d1, d2, h, fn = 40) {
    cylinder(h = h, d1 = d1, d2 = d2, $fn = fn);
}

module hemisphere(r, fn = 44) {
    intersection() {
        sphere(r = r, $fn = fn);
        translate([0, 0, r])
            cube([r * 2.2, r * 2.2, r * 2], center = true);
    }
}

module ring(d_outer, d_inner, h, fn = 40) {
    difference() {
        cylinder(h = h, d = d_outer, $fn = fn);
        translate([0, 0, -0.2])
            cylinder(h = h + 0.4, d = d_inner, $fn = fn);
    }
}

module body_cube(w, d, h) {
    translate([0, 0, h / 2])
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
        linear_extrude(height = d, convexity = 16)
            children();
}

module back_inlay(body_d, d) {
    multmatrix([
        [-1, 0, 0, 0],
        [0, 0, 1, -body_d / 2],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = d, convexity = 16)
            children();
}

// a = 0 is +Y (front). Negative a wraps toward +X (the slot).
module wrap_y(r, z, a) {
    rotate([0, 0, a])
        translate([0, r, z])
            children();
}

module wrap_band(r, z, a0, a1, step = 18) {
    for (a = [a0:step:a1])
        wrap_y(r, z, a)
            children();
}

module pane_muntins_2d(w, h, cols, rows, t = 1.4) {
    difference() {
        square([w, h], center = true);
        pw = (w - (cols + 1) * t) / cols;
        ph = (h - (rows + 1) * t) / rows;
        for (c = [0:cols - 1], rr = [0:rows - 1])
            translate([
                -w / 2 + t + c * (pw + t) + pw / 2,
                -h / 2 + t + rr * (ph + t) + ph / 2
            ])
                square([pw, ph], center = true);
    }
}

module lancet_2d(w, h) {
    union() {
        translate([0, -(w / 4)])
            square([w, max(0.5, h - w / 2)], center = true);
        translate([0, h / 2 - w / 2])
            circle(d = w, $fn = 24);
    }
}

module brick_bond_2d(w, h, bw = 13, bh = 5.6, gap = 1.35) {
    cols = floor((w + gap) / (bw + gap));
    rows = floor((h + gap) / (bh + gap));
    translate([-w / 2, -h / 2])
        for (rr = [0:max(0, rows - 1)]) {
            off = (rr % 2) * ((bw + gap) / 2);
            for (c = [0:cols]) {
                x = gap + c * (bw + gap) + off;
                y = gap + rr * (bh + gap);
                if (x >= 0 && x + bw <= w && y + bh <= h)
                    translate([x, y])
                        square([bw, bh]);
            }
        }
}

module rivet(d = 2.4, h = 1.4) {
    cylinder(h = h, d = d, $fn = 12);
}

module rivet_grid(nx, nz, sx, sz, d = 2.2, h = 1.3) {
    for (i = [0:nx - 1], j = [0:nz - 1])
        translate([
            -(nx - 1) * sx / 2 + i * sx,
            0,
            -(nz - 1) * sz / 2 + j * sz
        ])
            rotate([90, 0, 0])
                rivet(d, h);
}

module crenels(w, d, z, t = 6, h = 10, n = 5) {
    for (i = [0:n - 1]) {
        x = -w / 2 + (i + 0.5) * (w / n);
        translate([x, d / 2 - t / 2, z + h / 2])
            cube([w / n * 0.52, t, h], center = true);
        translate([x, -d / 2 + t / 2, z + h / 2])
            cube([w / n * 0.52, t, h], center = true);
    }
}

module quoins(w, d, h, s = 7, t = 2.2) {
    for (sx = [-1, 1], sy = [-1, 1])
        for (z = [s:s * 2:h - s])
            translate([sx * (w / 2 - t / 2), sy * (d / 2 - 8), z])
                cube([t + 0.2, 16, s * 0.7], center = true);
}

module feather_2d(len, wid) {
    hull() {
        circle(d = wid * 0.35, $fn = 10);
        translate([len * 0.55, 0])
            circle(d = wid, $fn = 12);
        translate([len, 0])
            circle(d = wid * 0.12, $fn = 8);
    }
}

module starfleet_delta_2d(s = 1) {
    scale(s)
        polygon([
            [0, 24],
            [18, -16],
            [6, -16],
            [0, -5],
            [-6, -16],
            [-18, -16]
        ]);
}

module lightning_2d() {
    polygon([
        [2, 22], [8, 8], [3, 8], [10, -8],
        [4, -2], [6, -22], [-1, -4], [-6, -4],
        [-2, 6], [-8, 6]
    ]);
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

module painted(c, body_w, body_d, body_h, kind = "box", roof = 4) {
    color(c)
        difference() {
            children();
            holder_cuts(body_w, body_d, body_h, kind, roof);
        }
}
