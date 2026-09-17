// Star Trek themed scrunchy holders. VARIANT 1..5.

include <holder_core.scad>

VARIANT = 1;
$fa = 6;
$fs = 0.45;

C_HULL  = "#C8CCD0";
C_NAC   = "#D8DCE0";
C_RED   = "#B71C1C";
C_NAVY  = "#1C3A5A";
C_GOLD  = "#C6A15B";
C_BLK   = "#1A1A1A";
C_BORG  = "#4A5348";
C_GREEB = "#2E332C";
C_CORE  = "#5BE0E8";
C_CORE2 = "#1A6A78";
C_COMM  = "#8A1E1E";
C_SILV  = "#B0B6BC";
C_GLOW  = "#6A8A4A";

module st_enterprise() {
    w = 82; d = 82; h = 148;
    painted(C_HULL, w, d, h, "cyl") {
        frustum_cyl(68, 82, 18, 40);
        translate([0, 0, 18])
            cylinder(h = h - 18, d = w, $fn = 40);
    }
    color(C_NAVY)
        translate([0, d / 2 + 0.6, 72])
            rotate([90, 0, 0])
                linear_extrude(height = 2.6)
                    starfleet_delta_2d(1.2);
    color("#6EC8FF")
        translate([0, d / 2 + 1.0, 26])
            rotate([90, 0, 0])
                cylinder(h = 2.4, d = 22, $fn = 24);
    color(C_BLK)
        wrap_band(d / 2 + 0.8, 50, -45, 20, 12)
            cube([4, 1.8, 3], center = true);
    color(C_HULL) {
        translate([0, 0, h])
            cylinder(h = 14, d = 118, $fn = 48);
        translate([0, 0, h + 14])
            cylinder(h = 4, d = 42, $fn = 28);
    }
    color(C_NAVY)
        translate([0, 0, h + 14])
            cylinder(h = 4.2, d = 38, $fn = 28);
    color(C_BLK)
        for (a = [0:15:345])
            rotate([0, 0, a])
                translate([52, 0, h + 7])
                    cube([4, 2.2, 2.2], center = true);
    color(C_NAC)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 16), 36]) {
                cylinder(h = 92, d = 18, $fn = 24);
                translate([0, s * 2, 46])
                    cube([8, 10, 40], center = true);
            }
    color(C_RED)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 16), 128])
                sphere(d = 18, $fn = 18);
    color("#4A6A8A")
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 16), 40])
                cylinder(h = 8, d = 16, $fn = 20);
}

module st_communicator() {
    w = 90; d = 88; h = 148;
    painted(C_COMM, w, d, h, "box")
        rounded_xy_cube(w, d, h, 8);
    color(C_SILV) {
        front_inlay(d, 2.8)
            translate([0, 108])
                square([70, 52], center = true);
        for (i = [0:5])
            translate([0, d / 2 + 3.2, 108])
                rotate([90, 0, 0])
                    ring(28 - i * 4, 24 - i * 4, 1.6, 28);
        translate([0, 0, h])
            rounded_xy_cube(w - 6, d - 6, 8, 6);
    }
    color(C_GOLD) {
        translate([0, d / 2 + 4.2, 118])
            rotate([90, 0, 0])
                cylinder(h = 3.2, d = 16, $fn = 24);
        translate([0, d / 2 - 2, h + 8])
            cube([36, 8, 4], center = true);
        front_inlay(d, 2.4)
            translate([0, 118])
                starfleet_delta_2d(0.55);
    }
    color(C_BLK)
        for (row = [0:6])
            translate([0, d / 2 + 2.2, 52 + row * 5.5])
                cube([52, 2.0, 2.6], center = true);
    color(C_GOLD)
        wrap_y(d / 2 + 1.4, 24, -30)
            cube([18, 2.4, 8], center = true);
}

module st_borg() {
    w = 100; d = 100; h = 100;
    painted(C_BORG, w, d, h, "box")
        body_cube(w, d, h);
    color(C_GREEB) {
        translate([20, 18, h + 6]) cube([30, 26, 14], center = true);
        translate([-22, -14, h + 8]) cube([22, 34, 18], center = true);
        translate([6, -26, h + 4]) cube([18, 16, 10], center = true);
        translate([-12, 30, h / 2]) cube([20, 10, 26], center = true);
        translate([28, -8, 40]) cube([12, 40, 10], center = true);
        for (i = [0:8]) {
            x = -32 + (i % 3) * 24;
            z = 18 + floor(i / 3) * 26;
            translate([x, d / 2 + 1.6, z])
                cube([18 + (i % 2) * 6, 4.2, 12 + (i % 3) * 5], center = true);
        }
        wrap_y(d / 2 + 2.0, 70, -40)
            cube([16, 5, 28], center = true);
        wrap_y(d / 2 + 2.0, 36, -40)
            cube([22, 5, 16], center = true);
    }
    color(C_GLOW) {
        translate([18, d / 2 + 2.2, 58])
            cube([20, 3.4, 20], center = true);
        translate([-8, 12, h + 12])
            cube([14, 14, 4], center = true);
        wrap_y(d / 2 + 2.4, 70, -40)
            cube([8, 2.2, 10], center = true);
    }
}

module st_delta() {
    w = 90; d = 88; h = 158;
    painted(C_NAVY, w, d, h, "box")
        rounded_xy_cube(w, d, h, 10);
    color(C_GOLD) {
        translate([0, d / 2 + 0.4, 92])
            rotate([90, 0, 0])
                linear_extrude(height = 8)
                    starfleet_delta_2d(2.55);
        translate([0, 0, h])
            cylinder(h = 8, d = 40, $fn = 6);
        wrap_y(d / 2 + 1.4, 28, -28)
            cube([22, 2.6, 8], center = true);
    }
    color(C_HULL)
        front_inlay(d, 1.8)
            translate([0, 28])
                square([54, 8], center = true);
    color("#D8E4F0")
        for (i = [0:18])
            translate([
                -30 + (i % 7) * 10,
                d / 2 + 1.2,
                48 + floor(i / 7) * 14
            ])
                sphere(d = 2.4, $fn = 8);
}

module st_warp_core() {
    w = 86; d = 86; h = 172;
    painted(C_CORE2, w, d, h, "cyl")
        cylinder(h = h, d = w, $fn = 40);
    painted(C_CORE, w, d, h, "cyl")
        translate([0, 0, h / 2])
            cylinder(h = 40, d = w - 10, $fn = 40, center = true);
    painted("#C8D0D4", w, d, h, "cyl")
        for (z = [16, 44, 108, 136, 160])
            translate([0, 0, z])
                torus(w / 2 + 2, 5.2, 28);
    color("#C8D0D4")
        for (z = [16, 44, 108, 136, 160])
            for (a = [0:45:315])
                if (abs(cos(a)) < 0.85)
                    rotate([0, 0, a])
                        translate([w / 2 + 1, 0, z])
                            cube([8, 2.2, 10], center = true);
    color(C_GOLD) {
        cylinder(h = 10, d = w + 12, $fn = 40);
        translate([0, 0, h])
            cylinder(h = 10, d = w + 8, $fn = 40);
    }
    color(C_CORE)
        translate([0, 0, h + 10])
            sphere(d = 22, $fn = 20);
    color(C_RED)
        wrap_band(d / 2 + 0.9, 86, -40, 20, 18)
            cube([10, 2.0, 4], center = true);
}

module assembly() {
    if (VARIANT == 1) st_enterprise();
    else if (VARIANT == 2) st_communicator();
    else if (VARIANT == 3) st_borg();
    else if (VARIANT == 4) st_delta();
    else st_warp_core();
}

assembly();
