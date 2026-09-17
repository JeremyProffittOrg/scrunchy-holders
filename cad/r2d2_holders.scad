// R2-D2 themed scrunchy holders. VARIANT 1..5.
// Slots on ±X, character on ±Y, hollow center.

include <holder_core.scad>

VARIANT = 1;
$fa = 8;
$fs = 0.55;

C_WHITE = "#F4F1E8";
C_BLUE  = "#3B6FBF";
C_SILV  = "#8A93A0";
C_BLACK = "#1A1A1A";
C_RED   = "#C8102E";

module r2_radar(body_d, z, s = 1) {
    translate([0, body_d / 2 + 0.2, z])
        rotate([-90, 0, 0]) {
            color(C_BLACK)
                cylinder(h = 1.6 * s, d = 22 * s, $fn = 28);
            color(C_SILV)
                translate([0, 0, 1.5 * s])
                    cylinder(h = 2.4 * s, d = 12 * s, $fn = 24);
            color(C_BLACK)
                translate([0, 0, 3.8 * s])
                    sphere(d = 8 * s, $fn = 20);
        }
}

module r2_blue_panels(diam, z0, z1, count = 4) {
    r = diam / 2 + 0.4;
    for (i = [0:count - 1]) {
        a = -48 + i * (96 / max(1, count - 1));
        z = z0 + (z1 - z0) * (i / max(1, count));
        rotate([0, 0, a])
            translate([0, r, z])
                cube([18, 2.2, 16], center = true);
    }
}

module r2_front_vents(body_d, z, w = 28, h = 18) {
    translate([0, body_d / 2 + 0.3, z])
        cube([w, 2.0, h], center = true);
}

// 1. Classic astromech: barrel + dome + skirt.
module r2_classic() {
    w = 86; d = 86; h = 148;
    painted(C_WHITE, w, d, h, "cyl") {
        cylinder(h = h, d = w, $fn = 40);
        translate([0, 0, h])
            hemisphere(w / 2, 40);
        cylinder(h = 8, d = w + 6, $fn = 40);
    }
    painted(C_BLUE, w, d, h, "cyl") {
        translate([0, 0, 18])
            cylinder(h = 6, d = w + 0.8, $fn = 40);
        translate([0, 0, 70])
            cylinder(h = 5, d = w + 0.8, $fn = 40);
        translate([0, 0, 118])
            cylinder(h = 5, d = w + 0.8, $fn = 40);
        r2_blue_panels(w, 28, 108, 3);
    }
    painted(C_SILV, w, d, h, "cyl")
        translate([0, 0, h - 4])
            cylinder(h = 6, d = w + 1.2, $fn = 40);
    r2_radar(d, 108);
    color(C_RED)
        translate([16, d / 2 + 0.6, 52])
            sphere(d = 7, $fn = 16);
}

// 2. Field unit: classic proportions plus two legs on ±Y and a caster.
module r2_legged() {
    w = 80; d = 80; h = 132;
    painted(C_WHITE, w, d, h, "cyl") {
        cylinder(h = h, d = w, $fn = 40);
        translate([0, 0, h])
            hemisphere(w / 2 * 0.98, 40);
        cylinder(h = 10, d = w + 8, $fn = 40);
    }
    painted(C_BLUE, w, d, h, "cyl") {
        translate([0, 0, 22]) ring(w + 1, w - 8, 7);
        translate([0, 0, 88]) ring(w + 1, w - 8, 7);
        r2_blue_panels(w, 36, 80, 3);
    }
    color(C_WHITE)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 8), 0]) {
                translate([-11, s > 0 ? 0 : -14, 0])
                    cube([22, 14, 8]);
                translate([0, s * 7, 40])
                    cube([16, 10, 70], center = true);
                translate([0, s * 10, 52])
                    rotate([s * 18, 0, 0])
                        cube([14, 8, 52], center = true);
            }
    color(C_SILV)
        translate([0, d / 2 + 6, 4])
            sphere(d = 14, $fn = 20);
    r2_radar(d, 96, 0.9);
}

// 3. Dome-heavy: short fat barrel, oversized head.
module r2_dome_heavy() {
    w = 100; d = 100; h = 108;
    painted(C_WHITE, w, d, h, "cyl") {
        cylinder(h = h, d = w, $fn = 42);
        translate([0, 0, h])
            hemisphere(w / 2 + 2, 42);
        cylinder(h = 9, d = w + 7, $fn = 42);
    }
    painted(C_BLUE, w, d, h, "cyl") {
        translate([0, 0, 16]) ring(w + 1.2, w - 10, 8);
        translate([0, 0, 52]) ring(w + 1.2, w - 10, 8);
        r2_blue_panels(w, 26, 90, 4);
    }
    painted(C_SILV, w, d, h, "cyl")
        translate([0, 0, h - 3])
            cylinder(h = 5, d = w + 2, $fn = 42);
    r2_radar(d, 78, 1.15);
    color(C_BLACK)
        translate([-18, d / 2 + 0.4, 44])
            cube([10, 2.2, 14], center = true);
}

// 4. Panel tank: boxy R2 body with a dome (the "square astromech").
module r2_panel_tank() {
    w = 90; d = 90; h = 140;
    painted(C_WHITE, w, d, h, "box") {
        rounded_xy_cube(w, d, h, 6);
        translate([0, 0, h])
            hemisphere(40, 36);
        rounded_xy_cube(w + 6, d + 6, 8, 5);
    }
    painted(C_BLUE, w, d, h, "box") {
        translate([0, d / 2 + 0.4, 40])
            cube([54, 2.0, 28], center = true);
        translate([0, d / 2 + 0.4, 84])
            cube([40, 2.0, 22], center = true);
        translate([0, d / 2 + 0.4, 116])
            cube([36, 2.0, 14], center = true);
    }
    painted(C_SILV, w, d, h, "box")
        translate([0, 0, 8])
            cube([w + 0.6, d + 0.6, 4], center = true);
    r2_radar(d, 100, 0.95);
    color(C_RED)
        translate([20, d / 2 + 0.8, 40])
            cylinder(h = 2.2, d = 8, $fn = 16);
}

// 5. Slim astromech: tall thin barrel, stacked rings, small dome.
module r2_slim() {
    w = 74; d = 74; h = 176;
    painted(C_WHITE, w, d, h, "cyl") {
        cylinder(h = h, d = w, $fn = 40);
        translate([0, 0, h])
            hemisphere(w / 2 - 1, 36);
        cylinder(h = 7, d = w + 8, $fn = 40);
    }
    painted(C_BLUE, w, d, h, "cyl")
        for (z = [20, 48, 76, 104, 132, 158])
            translate([0, 0, z])
                ring(w + 1.0, w - 6, 5);
    painted(C_SILV, w, d, h, "cyl")
        translate([0, 0, h - 6])
            cylinder(h = 6, d = w + 1.4, $fn = 40);
    r2_radar(d, 150, 0.75);
    color(C_BLACK)
        translate([0, d / 2 + 0.5, 90])
            cube([22, 2.0, 36], center = true);
}

module assembly() {
    if (VARIANT == 1) r2_classic();
    else if (VARIANT == 2) r2_legged();
    else if (VARIANT == 3) r2_dome_heavy();
    else if (VARIANT == 4) r2_panel_tank();
    else r2_slim();
}

assembly();
