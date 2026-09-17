// Star Wars themed scrunchy holders (not R2-D2). VARIANT 1..5.

include <holder_core.scad>

VARIANT = 1;
$fa = 6;
$fs = 0.45;

C_GREY  = "#8B9088";
C_DARK  = "#2A2C2E";
C_WHITE = "#E8E6E1";
C_ORNG  = "#D4652F";
C_SABER = "#3A3A3A";
C_EMIT  = "#C8CCD0";
C_TIE   = "#1A1A1A";
C_VIEW  = "#6EC8FF";
C_HOLO  = "#C9A227";
C_HOLO2 = "#5A3E12";
C_RED   = "#C8102E";

module sw_death_star() {
    w = 102; d = 102; h = 102;
    r = w / 2;
    painted(C_GREY, w, d, h, "sphere")
        difference() {
            flat_sphere(r, 5, 48);
            translate([0, 0, r])
                rotate_extrude($fn = 56)
                    translate([r, 0, 0])
                        square([3.6, 6.5], center = true);
            translate([0, r - 10, r + 18])
                sphere(d = 32, $fn = 32);
            for (lat = [-50:20:50], lon = [0:24:336])
                if (abs(lat) > 8)
                    rotate([0, 0, lon])
                        rotate([0, lat, 0])
                            translate([0, 0, r + 0.2])
                                cube([9, 7, 1.4], center = true);
        }
    color(C_DARK) {
        translate([0, r - 8, r + 18])
            rotate([90, 0, 0]) {
                cylinder(h = 2.4, d = 24, $fn = 28);
                ring(20, 14, 2.6, 24);
                ring(12, 6, 2.6, 20);
                for (a = [0:30:150])
                    rotate([0, 0, a])
                        cube([22, 1.4, 2.2], center = true);
            }
        translate([0, 0, r])
            rotate_extrude($fn = 48)
                translate([r - 2, 0, 0])
                    square([1.6, 3.2], center = true);
    }
}

module sw_bb8() {
    w = 94; d = 94; h = 94;
    painted(C_WHITE, w, d, h, "sphere")
        flat_sphere(w / 2, 5, 48);
    color(C_ORNG) {
        wrap_y(d / 2 + 0.8, 48, -8)
            rotate([90, 0, 0])
                cylinder(h = 3.4, d = 30, $fn = 28);
        wrap_y(d / 2 + 0.8, 28, -32)
            rotate([90, 0, 0])
                cylinder(h = 3.2, d = 18, $fn = 24);
        wrap_y(d / 2 + 0.8, 70, 18)
            rotate([90, 0, 0])
                cylinder(h = 3.2, d = 16, $fn = 24);
        wrap_y(d / 2 + 0.8, 62, -40)
            rotate([90, 0, 0])
                cylinder(h = 3.2, d = 14, $fn = 22);
        translate([0, 0, h + 10])
            ring(38, 24, 5, 28);
    }
    color(C_WHITE)
        translate([0, 0, h - 2])
            hemisphere(27, 32);
    color(C_DARK) {
        translate([0, 16, h + 18])
            sphere(d = 12, $fn = 16);
        translate([8, 10, h + 22])
            cylinder(h = 8, d = 3.4, $fn = 10);
        wrap_y(d / 2 + 1.6, 48, -8)
            rotate([90, 0, 0])
                ring(34, 26, 2.2, 24);
    }
    color("#C8C8C8")
        wrap_y(d / 2 + 1.2, 48, -8)
            rotate([90, 0, 0])
                cylinder(h = 2, d = 8, $fn = 16);
}

module sw_lightsaber() {
    w = 74; d = 74; h = 158;
    painted(C_SABER, w, d, h, "cyl") {
        cylinder(h = 14, d = 84, $fn = 40);
        cylinder(h = h, d = w, $fn = 40);
    }
    painted("#2A2A2A", w, d, h, "cyl")
        for (z = [18:10:132])
            translate([0, 0, z])
                ring(w + 2.8, w - 6, 4.6, 40);
    color(C_EMIT) {
        translate([0, 0, h])
            cylinder(h = 16, d1 = w - 2, d2 = 42, $fn = 36);
        translate([0, 0, h + 16])
            ring(48, 30, 7, 24);
        for (a = [0:45:315])
            rotate([0, 0, a])
                translate([20, 0, h + 8])
                    cube([2, 6, 12], center = true);
    }
    color("#B8B8B8")
        wrap_y(d / 2 + 1.8, 96, -8)
            cube([24, 4.2, 32], center = true);
    color(C_RED)
        wrap_y(d / 2 + 4.2, 104, -8)
            sphere(d = 8, $fn = 14);
    color(C_DARK)
        wrap_y(d / 2 + 3.6, 90, -8)
            cube([8, 3, 8], center = true);
    color(C_EMIT) {
        translate([0, 0, 4])
            torus(18, 2.4, 24);
        wrap_y(d / 2 + 1.2, 28, 20)
            cube([10, 2.4, 14], center = true);
    }
}

module sw_tie() {
    w = 88; d = 88; h = 148;
    painted(C_TIE, w, d, h, "cyl")
        cylinder(h = h, d = w, $fn = 40);
    color(C_VIEW)
        translate([0, d / 2 + 0.8, 86])
            rotate([90, 0, 0])
                cylinder(h = 4.2, d = 42, $fn = 6);
    color("#4A4A4A")
        translate([0, d / 2 + 1.6, 86])
            rotate([90, 0, 0])
                difference() {
                    cylinder(h = 3.4, d = 54, $fn = 6);
                    translate([0, 0, -0.4])
                        cylinder(h = 4.4, d = 38, $fn = 6);
                    for (a = [0:60:300])
                        rotate([0, 0, a])
                            cube([40, 1.6, 4], center = true);
                }
    color(C_DARK)
        for (s = [-1, 1]) {
            translate([0, s * (d / 2 + 2), h / 2])
                rotate([s * 90, 0, 0]) {
                    cylinder(h = 6, d = 124, $fn = 6);
                    for (row = [-3:3], col = [-2:2])
                        translate([col * 14, row * 12, 5.5])
                            cube([12, 10, 1.6], center = true);
                }
            translate([0, s * (d / 2 + 1), 86])
                cube([16, 8, 18], center = true);
        }
}

module sw_holocron() {
    w = 90; d = 90; h = 108;
    painted(C_HOLO, w, d, h, "box")
        body_cube(w, d, h);
    color(C_HOLO2) {
        front_inlay(d, 2.6)
            for (z = [28, 62])
                translate([0, z])
                    polygon([[-26, 0], [26, 0], [0, 30]]);
        front_inlay(d, 2.2)
            translate([0, h / 2])
                difference() {
                    square([w - 12, h - 14], center = true);
                    square([w - 24, h - 26], center = true);
                }
        for (sx = [-1, 1], sz = [12, h - 12])
            translate([sx * (w / 2 - 4), d / 2 - 4, sz])
                cube([8, 8, 8], center = true);
    }
    color(C_HOLO)
        translate([0, 0, h])
            cylinder(h = 30, d1 = 72, d2 = 4, $fn = 4);
    color(C_HOLO2) {
        translate([0, 0, h + 8])
            cylinder(h = 2.2, d = 48, $fn = 4);
        translate([0, 0, h + 30])
            sphere(d = 8, $fn = 12);
        wrap_y(d / 2 + 1.2, 88, -35)
            cube([18, 2.4, 18], center = true);
    }
}

module assembly() {
    if (VARIANT == 1) sw_death_star();
    else if (VARIANT == 2) sw_bb8();
    else if (VARIANT == 3) sw_lightsaber();
    else if (VARIANT == 4) sw_tie();
    else sw_holocron();
}

assembly();
