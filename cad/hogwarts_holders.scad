// Hogwarts-themed scrunchy holders. VARIANT 1..5.

include <holder_core.scad>

VARIANT = 1;
$fa = 6;
$fs = 0.45;

C_STONE = "#8A7D70";
C_STONE2 = "#6F6458";
C_ROOF  = "#3A2422";
C_GOLD  = "#C6A15B";
C_GLASS = "#7BA8BC";
C_DARK  = "#2B241C";
C_GRY   = "#7A1F2B";
C_SLY   = "#1F5C3A";
C_RAV   = "#2A4A7A";
C_HUF   = "#C4A035";
C_WOOD  = "#5A3A22";

module stone_windows(body_d, zs, xs, ww = 10, hh = 18) {
    color(C_GLASS)
        front_inlay(body_d, 4.2)
            for (z = zs, x = xs)
                translate([x, z])
                    lancet_2d(ww, hh);
    color(C_DARK)
        front_inlay(body_d, 4.8)
            for (z = zs, x = xs)
                translate([x, z])
                    difference() {
                        offset(delta = 1.6) lancet_2d(ww, hh);
                        lancet_2d(ww, hh);
                    }
}

module door_arch(body_d, z = 28) {
    color(C_WOOD)
        front_inlay(body_d, 3.2)
            translate([0, z])
                lancet_2d(22, 36);
    color(C_GOLD)
        translate([6, body_d / 2 + 3.4, z])
            sphere(d = 4.2, $fn = 12);
}

module ribbed_cone(d, h) {
    cone(d, 3.2, h, 32);
    translate([0, 0, h * 0.35])
        cylinder(h = 2.2, d = d * 0.72, $fn = 28);
}

module turret(x, y, z0, h, d, roof_h, col = C_STONE) {
    color(col)
        translate([x, y, z0]) {
            cylinder(h = h, d = d, $fn = 28);
            for (z = [18, 40, 62, 84])
                if (z < h - 10)
                    translate([0, d / 2 + 0.6, z])
                        cube([7, 2.0, 12], center = true);
        }
    color(C_GLASS)
        translate([x, y + d / 2 + 0.7, z0 + h * 0.45])
            cube([6, 2.0, 11], center = true);
    color(C_ROOF)
        translate([x, y, z0 + h])
            ribbed_cone(d + 6, roof_h);
    color(C_GOLD)
        translate([x, y, z0 + h + roof_h])
            sphere(d = 5.5, $fn = 12);
}

module hog_keep() {
    w = 90; d = 90; h = 124;
    painted(C_STONE, w, d, h, "box") {
        rounded_xy_cube(w, d, h, 2.5);
        crenels(w, d, h, 6, 12, 5);
        quoins(w, d, h, 8, 2.4);
        translate([0, 0, 8])
            cube([w + 1.2, d + 1.2, 4], center = true);
        translate([0, 0, 64])
            cube([w + 1.0, d + 1.0, 3.2], center = true);
    }
    stone_windows(d, [40, 72, 100], [-22, 0, 22], 9, 16);
    door_arch(d, 28);
    turret(-22, d / 2 + 11, 0, 148, 24, 30);
    turret(22, d / 2 + 11, 0, 138, 24, 28);
    turret(-22, -d / 2 - 11, 0, 142, 24, 28);
    turret(22, -d / 2 - 11, 0, 132, 24, 26);
    turret(0, 0, h + 12, 40, 30, 34);
}

module hog_great_hall() {
    w = 94; d = 88; h = 108;
    painted(C_STONE, w, d, h, "box") {
        rounded_xy_cube(w, d, h, 2);
        for (sx = [-1, 1])
            translate([sx * (w / 2 - 6), d / 2 - 4, h / 2])
                cube([10, 14, h], center = true);
        translate([0, 0, 8])
            cube([w + 2, d + 2, 5], center = true);
    }
    color(C_GLASS) {
        front_inlay(d, 4.4)
            for (x = [-32, -16, 0, 16, 32])
                translate([x, 42])
                    lancet_2d(10, 44);
        front_inlay(d, 4.4)
            translate([0, 86])
                circle(d = 30, $fn = 28);
    }
    color(C_GOLD)
        front_inlay(d, 2.8)
            translate([0, 86])
                difference() {
                    circle(d = 36, $fn = 28);
                    circle(d = 24, $fn = 28);
                    for (a = [0:30:150])
                        rotate(a)
                            square([36, 1.6], center = true);
                }
    color(C_DARK)
        front_inlay(d, 2.8)
            for (x = [-32, -16, 0, 16, 32])
                translate([x, 42])
                    pane_muntins_2d(10, 36, 1, 3, 1.2);
    color(C_ROOF) {
        translate([0, 0, h])
            rotate([90, 0, 90])
                linear_extrude(height = w + 6, center = true)
                    polygon([[-d / 2 - 6, 0], [d / 2 + 6, 0], [0, 52]]);
        for (y = [-28, -14, 0, 14, 28])
            translate([0, y, h + 18])
                cube([w + 4, 2.2, 4], center = true);
    }
    color(C_GOLD) {
        translate([0, 0, h + 54])
            sphere(d = 8, $fn = 12);
        translate([0, 0, h + 60])
            cube([2, 18, 2], center = true);
    }
}

module hog_astronomy() {
    w = 84; d = 84; h = 160;
    painted(C_STONE, w, d, h, "cyl") {
        cylinder(h = h, d = w, $fn = 40);
        translate([0, 0, h - 16])
            cylinder(h = 12, d = w + 16, $fn = 40);
        translate([0, 0, 10])
            cylinder(h = 5, d = w + 8, $fn = 40);
    }
    color(C_GLASS)
        for (z = [28, 56, 84, 112, 138])
            wrap_band(d / 2 + 0.8, z, -48, 24, 18)
                cube([8, 2.2, 16], center = true);
    color(C_DARK)
        for (z = [28, 56, 84, 112, 138])
            wrap_band(d / 2 + 1.5, z, -48, 24, 18)
                difference() {
                    cube([10, 1.6, 18], center = true);
                    cube([6, 2.2, 12], center = true);
                }
    color(C_STONE)
        for (a = [0:30:330])
            rotate([0, 0, a])
                translate([0, w / 2 + 5, h - 10])
                    cube([7, 10, 18], center = true);
    color(C_ROOF)
        translate([0, 0, h])
            ribbed_cone(w + 10, 50);
    color(C_GOLD)
        translate([0, 0, h + 50])
            sphere(d = 7, $fn = 12);
    color(C_DARK)
        translate([18, d / 2 + 6, h - 8])
            rotate([0, 55, 0])
                cylinder(h = 28, d = 6, $fn = 14);
}

module hog_four_houses() {
    w = 90; d = 88; h = 118;
    painted(C_STONE, w, d, h, "box") {
        rounded_xy_cube(w, d, h, 2.5);
        crenels(w, d, h, 6, 10, 5);
        translate([0, 0, 8])
            cube([w + 1.4, d + 1.4, 4], center = true);
    }
    stone_windows(d, [36, 68, 96], [-18, 18], 10, 18);
    door_arch(d, 26);
    turret(-24, d / 2 + 12, 0, 150, 26, 26, C_GRY);
    turret(24, d / 2 + 12, 0, 138, 26, 24, C_SLY);
    turret(-24, -d / 2 - 12, 0, 144, 26, 26, C_RAV);
    turret(24, -d / 2 - 12, 0, 130, 26, 22, C_HUF);
    color(C_GOLD) {
        translate([-24, d / 2 + 24, 90]) cube([1.6, 10, 28], center = true);
        translate([24, d / 2 + 24, 82]) cube([1.6, 10, 24], center = true);
    }
}

module hog_clock() {
    w = 88; d = 88; h = 154;
    painted(C_STONE, w, d, h, "box") {
        rounded_xy_cube(w, d, h, 2);
        crenels(w, d, h, 6, 12, 4);
        quoins(w, d, h, 9, 2.2);
        translate([0, 0, 8])
            cube([w + 1.6, d + 1.6, 4], center = true);
    }
    stone_windows(d, [32, 58, 84], [-18, 18], 10, 18);
    door_arch(d, 24);
    color("#F4EFE2")
        translate([0, d / 2 + 2.2, 118])
            rotate([90, 0, 0])
                cylinder(h = 5.5, d = 52, $fn = 36);
    color(C_DARK) {
        translate([0, d / 2 + 6.0, 118])
            rotate([90, 0, 0])
                for (a = [0:30:330])
                    rotate([0, 0, a])
                        translate([20, 0, 0])
                            cube([3.2, 1.6, 2.2], center = true);
        translate([0, d / 2 + 4.0, 118])
            rotate([90, 0, 0]) {
                cylinder(h = 2.4, d = 6, $fn = 14);
                rotate([0, 0, -18])
                    translate([10, 0, 1])
                        cube([20, 3.2, 2], center = true);
                rotate([0, 0, 70])
                    translate([7, 0, 1])
                        cube([14, 2.4, 2], center = true);
            }
    }
    color(C_ROOF)
        translate([0, 0, h + 12])
            ribbed_cone(w - 8, 46);
    color(C_GOLD)
        translate([0, 0, h + 58])
            sphere(d = 7, $fn = 12);
}

module assembly() {
    if (VARIANT == 1) hog_keep();
    else if (VARIANT == 2) hog_great_hall();
    else if (VARIANT == 3) hog_astronomy();
    else if (VARIANT == 4) hog_four_houses();
    else hog_clock();
}

assembly();
