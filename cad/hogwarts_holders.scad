// Hogwarts-themed scrunchy holders. VARIANT 1..5.
// Towers sit on ±Y and on the roof so ±X stays free for the keyhole.

include <holder_core.scad>

VARIANT = 1;
$fa = 8;
$fs = 0.55;

C_STONE = "#8B8178";
C_ROOF  = "#3A2A28";
C_GOLD  = "#C6A15B";
C_GLASS = "#7BA3B5";
C_DARK  = "#2B241C";
C_GRY   = "#7A1F2B";
C_SLY   = "#1F5C3A";
C_RAV   = "#2A4A7A";
C_HUF   = "#C4A035";

module merlons(w, d, z, t = 6, h = 10, n = 5) {
    for (i = [0:n - 1]) {
        x = -w / 2 + (i + 0.5) * (w / n);
        translate([x, d / 2 - t / 2, z + h / 2])
            cube([w / n * 0.55, t, h], center = true);
        translate([x, -d / 2 + t / 2, z + h / 2])
            cube([w / n * 0.55, t, h], center = true);
    }
}

module cone_roof(d, h) {
    color(C_ROOF)
        cone(d, 2.4, h, 28);
    color(C_GOLD)
        translate([0, 0, h])
            sphere(d = 5.5, $fn = 12);
}

module window_row(body_d, z, n, w = 8, h = 14) {
    color(C_GLASS)
        for (i = [0:n - 1]) {
            x = -((n - 1) / 2) * 16 + i * 16;
            translate([x, body_d / 2 + 0.4, z])
                cube([w, 2.0, h], center = true);
        }
}

module round_tower(x, y, z0, h, d, roof_h) {
    color(C_STONE)
        translate([x, y, z0])
            cylinder(h = h, d = d, $fn = 28);
    translate([x, y, z0 + h])
        cone_roof(d + 4, roof_h);
}

// 1. Castle keep with four Y-side turrets and a taller center spire.
module hog_keep() {
    w = 90; d = 90; h = 128;
    painted(C_STONE, w, d, h, "box") {
        rounded_xy_cube(w, d, h, 3);
        merlons(w, d, h, 6, 11, 5);
    }
    window_row(d, 40, 3);
    window_row(d, 70, 3);
    window_row(d, 100, 3);
    for (sx = [-1, 1], sy = [-1, 1])
        round_tower(sx * 22, sy * (d / 2 + 10), 0, 150, 22, 28);
    round_tower(0, 0, h, 46, 28, 36);
}

// 2. Great Hall: long front, steep pitched roof, rose window.
module hog_great_hall() {
    w = 92; d = 88; h = 110;
    painted(C_STONE, w, d, h, "box")
        rounded_xy_cube(w, d, h, 3);
    color(C_GLASS) {
        translate([0, d / 2 + 0.4, 78])
            cylinder(h = 2.2, d = 28, $fn = 24);
        for (i = [-2, -1, 0, 1, 2])
            translate([i * 14, d / 2 + 0.4, 36])
                cube([8, 2.0, 28], center = true);
    }
    color(C_GOLD)
        translate([0, d / 2 + 0.6, 78])
            difference() {
                cylinder(h = 2.4, d = 32, $fn = 24);
                translate([0, 0, -0.2])
                    cylinder(h = 3, d = 24, $fn = 24);
            }
    color(C_ROOF) {
        translate([0, 0, h])
            rotate([90, 0, 90])
                linear_extrude(height = w, center = true)
                    polygon([[-d / 2 - 4, 0], [d / 2 + 4, 0], [0, 48]]);
    }
    color(C_GOLD)
        translate([0, 0, h + 50])
            sphere(d = 7, $fn = 12);
}

// 3. Astronomy tower: tall cylinder, gallery, cone, sphere finial.
module hog_astronomy() {
    w = 84; d = 84; h = 168;
    painted(C_STONE, w, d, h, "cyl") {
        cylinder(h = h, d = w, $fn = 36);
        translate([0, 0, h - 18])
            cylinder(h = 10, d = w + 14, $fn = 36);
    }
    color(C_GLASS)
        for (a = [-40, -20, 0, 20, 40])
            for (z = [36, 72, 108, 140])
                rotate([0, 0, a])
                    translate([0, d / 2 + 0.4, z])
                        cube([7, 2.0, 14], center = true);
    color(C_STONE)
        for (a = [0:45:315])
            rotate([0, 0, a])
                translate([0, w / 2 + 4, h - 14])
                    cube([6, 8, 16], center = true);
    translate([0, 0, h])
        cone_roof(w + 8, 52);
}

// 4. Four houses: shared keep, four color-coded Y-side towers.
module hog_four_houses() {
    w = 90; d = 88; h = 120;
    painted(C_STONE, w, d, h, "box")
        rounded_xy_cube(w, d, h, 3);
    window_row(d, 36, 3, 9, 16);
    window_row(d, 72, 3, 9, 16);
    window_row(d, 100, 3, 9, 12);
    // Front pair: Gryffindor, Slytherin. Back pair: Ravenclaw, Hufflepuff.
    color(C_GRY)
        translate([-22, d / 2 + 11, 0])
            cylinder(h = 148, d = 22, $fn = 24);
    color(C_SLY)
        translate([22, d / 2 + 11, 0])
            cylinder(h = 136, d = 22, $fn = 24);
    color(C_RAV)
        translate([-22, -d / 2 - 11, 0])
            cylinder(h = 142, d = 22, $fn = 24);
    color(C_HUF)
        translate([22, -d / 2 - 11, 0])
            cylinder(h = 128, d = 22, $fn = 24);
    translate([-22, d / 2 + 11, 148]) cone_roof(26, 24);
    translate([22, d / 2 + 11, 136]) cone_roof(26, 22);
    translate([-22, -d / 2 - 11, 142]) cone_roof(26, 24);
    translate([22, -d / 2 - 11, 128]) cone_roof(26, 20);
}

// 5. Clock tower: square shaft, clock faces on ±Y, spire.
module hog_clock() {
    w = 88; d = 88; h = 160;
    painted(C_STONE, w, d, h, "box") {
        rounded_xy_cube(w, d, h, 2.5);
        merlons(w, d, h, 6, 12, 4);
    }
    color("#F4F1E8")
        translate([0, d / 2 + 0.3, 110])
            cylinder(h = 2.2, d = 44, $fn = 32);
    color(C_DARK) {
        translate([0, d / 2 + 1.4, 110])
            cylinder(h = 2.0, d = 6, $fn = 16);
        translate([8, d / 2 + 1.5, 114])
            rotate([0, 55, 0])
                cube([18, 1.6, 3], center = true);
        translate([-2, d / 2 + 1.5, 120])
            rotate([0, -10, 0])
                cube([3, 1.6, 16], center = true);
    }
    color(C_GLASS)
        for (z = [28, 52, 76])
            for (x = [-18, 0, 18])
                translate([x, d / 2 + 0.4, z])
                    cube([9, 2.0, 16], center = true);
    translate([0, 0, h + 12])
        cone_roof(w - 10, 48);
}

module assembly() {
    if (VARIANT == 1) hog_keep();
    else if (VARIANT == 2) hog_great_hall();
    else if (VARIANT == 3) hog_astronomy();
    else if (VARIANT == 4) hog_four_houses();
    else hog_clock();
}

assembly();
