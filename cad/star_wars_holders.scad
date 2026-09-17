// Star Wars themed scrunchy holders (not R2-D2). VARIANT 1..5.
// Slots on ±X, character on ±Y.

include <holder_core.scad>

VARIANT = 1;
$fa = 8;
$fs = 0.55;

C_GREY  = "#8B9088";
C_DARK  = "#2A2C2E";
C_WHITE = "#E8E6E1";
C_ORNG  = "#D4652F";
C_SABER = "#4A4A4A";
C_EMIT  = "#C8CCD0";
C_TIE   = "#1E1E1E";
C_VIEW  = "#6EC8FF";
C_HOLO  = "#C9A227";
C_HOLO2 = "#5A3E12";

// 1. Death Star: sphere, equatorial trench, superlaser dish on +Y.
module sw_death_star() {
    w = 100; d = 100; h = 100;
    r = w / 2;
    painted(C_GREY, w, d, h, "sphere")
        difference() {
            flat_sphere(r, 5, 44);
            translate([0, 0, r])
                rotate_extrude($fn = 48)
                    translate([r, 0, 0])
                        square([3.2, 5.5], center = true);
            translate([0, r - 8, r + 16])
                sphere(d = 28, $fn = 28);
        }
    color(C_DARK)
        translate([0, r - 6, r + 16])
            cylinder(h = 2, d = 20, $fn = 24);
}

// 2. BB-8: sphere + dome, orange panels on +Y.
module sw_bb8() {
    w = 94; d = 94; h = 94;
    painted(C_WHITE, w, d, h, "sphere")
        flat_sphere(w / 2, 5, 44);
    color(C_ORNG) {
        translate([0, d / 2 + 0.6, 48])
            rotate([90, 0, 0])
                cylinder(h = 3.2, d = 28, $fn = 6);
        translate([-18, d / 2 + 0.6, 28])
            rotate([90, 0, 0])
                cylinder(h = 3.2, d = 16, $fn = 6);
        translate([20, d / 2 + 0.6, 68])
            rotate([90, 0, 0])
                cylinder(h = 3.2, d = 14, $fn = 6);
    }
    color(C_WHITE)
        translate([0, 0, h - 4])
            hemisphere(28, 32);
    color(C_ORNG)
        translate([0, 0, h + 10])
            ring(40, 24, 6, 28);
    color(C_DARK)
        translate([0, 18, h + 18])
            sphere(d = 12, $fn = 16);
}

// 3. Lightsaber hilt: grip rings, emitter, activation box on +Y.
module sw_lightsaber() {
    w = 74; d = 74; h = 160;
    painted(C_SABER, w, d, h, "cyl") {
        cylinder(h = 14, d = 82, $fn = 36);
        cylinder(h = h, d = w, $fn = 36);
    }
    painted("#2E2E2E", w, d, h, "cyl")
        for (z = [20:16:140])
            translate([0, 0, z])
                ring(w + 2.5, w - 6, 5, 36);
    color("#B8B8B8")
        translate([0, d / 2 + 1.4, 96])
            cube([22, 4, 28], center = true);
    color("#C8102E")
        translate([0, d / 2 + 3.4, 102])
            sphere(d = 8, $fn = 14);
    color(C_EMIT) {
        translate([0, 0, h])
            cylinder(h = 18, d1 = w - 4, d2 = 40, $fn = 36);
        translate([0, 0, h + 18])
            ring(48, 32, 6, 24);
    }
}

// 4. TIE cockpit: hexagonal prism, viewport on +Y, wing stubs on ±Y.
module sw_tie() {
    w = 90; d = 90; h = 150;
    painted(C_TIE, w, d, h, "cyl")
        cylinder(h = h, d = w, $fn = 36);
    color(C_VIEW)
        translate([0, d / 2 + 0.6, 88])
            rotate([90, 0, 0])
                cylinder(h = 4, d = 40, $fn = 6);
    color("#4A4A4A")
        translate([0, d / 2 + 1.2, 88])
            rotate([90, 0, 0])
                difference() {
                    cylinder(h = 3.2, d = 50, $fn = 6);
                    translate([0, 0, -0.4])
                        cylinder(h = 4, d = 36, $fn = 6);
                }
    color(C_DARK)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 1), h / 2])
                rotate([s * 90, 0, 0])
                    cylinder(h = 5, d = 118, $fn = 6);
}

// 5. Jedi holocron: cube with pyramid cap and triangle inlays.
module sw_holocron() {
    w = 90; d = 90; h = 110;
    painted(C_HOLO, w, d, h, "box")
        body_cube(w, d, h);
    color(C_HOLO2) {
        translate([0, d / 2 + 0.4, 36])
            rotate([90, 0, 0])
                linear_extrude(height = 2.2)
                    polygon([[-22, 0], [22, 0], [0, 28]]);
        translate([0, d / 2 + 0.4, 74])
            rotate([90, 0, 0])
                linear_extrude(height = 2.2)
                    polygon([[-22, 0], [22, 0], [0, 28]]);
    }
    color(C_HOLO)
        translate([0, 0, h])
            cylinder(h = 28, d1 = 70, d2 = 4, $fn = 4);
    color(C_HOLO2)
        translate([0, 0, h + 28])
            sphere(d = 8, $fn = 12);
}

module assembly() {
    if (VARIANT == 1) sw_death_star();
    else if (VARIANT == 2) sw_bb8();
    else if (VARIANT == 3) sw_lightsaber();
    else if (VARIANT == 4) sw_tie();
    else sw_holocron();
}

assembly();
