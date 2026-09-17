// Doctor Who themed scrunchy holders. VARIANT 1..5.
// Not a police box (that already exists). Slots on ±X.

include <holder_core.scad>

VARIANT = 1;
$fa = 8;
$fs = 0.55;

C_CREAM = "#D9D2C5";
C_GOLD  = "#C4A35A";
C_BLACK = "#1A1A1A";
C_BLUE  = "#3A6EA5";
C_EYE   = "#D4E8F2";
C_STONE = "#8A8F86";
C_WING  = "#C5C8BE";
C_SONIC = "#3A3A3A";
C_EMIT  = "#6EC4D8";
C_ROTOR = "#6FE0C8";
C_BRASS = "#8A6A32";
C_SILVER = "#B0B6BC";
C_RED   = "#C8102E";

module dalek_bumps(d, z0, z1, rows = 4) {
    for (row = [0:rows - 1]) {
        z = z0 + row * ((z1 - z0) / rows);
        n = 8;
        for (i = [0:n - 1]) {
            a = i * 360 / n + (row % 2) * (180 / n);
            // Keep bumps off the exact ±X slot faces.
            if (abs(cos(a)) < 0.82)
                rotate([0, 0, a])
                    translate([0, d / 2 + 1.2, z])
                        sphere(d = 10, $fn = 14);
        }
    }
}

// 1. Dalek: flared skirt, bands, dome, eyestalk and gun on +Y.
module dw_dalek() {
    w = 92; d = 92; h = 112;
    painted(C_CREAM, w, d, h, "cyl") {
        frustum_cyl(108, 92, 56, 40);
        translate([0, 0, 56])
            cylinder(h = h - 56, d = 92, $fn = 40);
    }
    painted(C_GOLD, w, d, h, "cyl") {
        translate([0, 0, 52]) ring(94, 80, 6, 40);
        translate([0, 0, 84]) ring(94, 80, 6, 40);
    }
    color(C_CREAM) {
        translate([0, 0, h])
            frustum_cyl(92, 64, 16, 36);
        translate([0, 0, h + 16])
            hemisphere(32, 32);
    }
    color(C_GOLD)
        dalek_bumps(100, 14, 50, 3);
    color(C_BLACK)
        translate([0, 0, h + 16])
            rotate([-52, 0, 0])
                translate([0, 0, 31])
                    cylinder(h = 26, d = 7, $fn = 14);
    color(C_EYE)
        translate([0, 0, h + 16])
            rotate([-52, 0, 0])
                translate([0, 0, 57])
                    sphere(d = 10, $fn = 16);
    color(C_GOLD) {
        translate([-12, d / 2 + 2, 92])
            rotate([-90, 0, 0])
                cylinder(h = 26, d = 6, $fn = 12);
        translate([12, d / 2 + 2, 92])
            rotate([-90, 0, 0])
                cylinder(h = 22, d = 8, $fn = 12);
    }
}

// 2. K-9: boxy dog, sloped head on +Y, antenna, treads as bottom rails.
module dw_k9() {
    w = 90; d = 90; h = 120;
    painted(C_SILVER, w, d, h, "box")
        rounded_xy_cube(w, d, h, 5);
    painted("#6A727A", w, d, h, "box")
        translate([0, 0, 8])
            cube([w + 1, d + 1, 6], center = true);
    color("#B0B6BC")
        translate([0, d / 2 + 8, 82])
            rotate([22, 0, 0])
                cube([58, 32, 40], center = true);
    color(C_BLACK)
        translate([0, d / 2 + 22, 88])
            cube([28, 6, 12], center = true);
    color(C_GOLD)
        translate([0, 0, h])
            cylinder(h = 22, d = 6, $fn = 12);
    color(C_RED)
        translate([0, 0, h + 22])
            sphere(d = 8, $fn = 12);
    color(C_BLACK)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 6), 8])
                cube([w - 16, 10, 16], center = true);
}

// 3. Weeping Angel: draped column, wing silhouettes on ±Y, head.
module dw_angel() {
    w = 88; d = 88; h = 140;
    painted(C_STONE, w, d, h, "cyl")
        cylinder(h = h, d1 = 96, d2 = 82, $fn = 36);
    color(C_STONE) {
        translate([0, 0, h])
            cylinder(h = 16, d = 48, $fn = 28);
        translate([0, 0, h + 22]) {
            sphere(d = 36, $fn = 28);
            translate([-7, 11, 8])
                sphere(d = 6, $fn = 12);
            translate([7, 11, 8])
                sphere(d = 6, $fn = 12);
        }
    }
    color(C_WING)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 4), 78])
                rotate([s * 8, 0, 0])
                    hull() {
                        cube([8, 6, 70], center = true);
                        translate([0, s * 18, 24])
                            cube([4, 6, 36], center = true);
                        translate([0, s * 8, -20])
                            cube([20, 5, 20], center = true);
                    }
}

// 4. Sonic screwdriver: stacked grip rings, clip on +Y, emitter cage.
module dw_sonic() {
    w = 76; d = 76; h = 160;
    painted(C_SONIC, w, d, h, "cyl") {
        cylinder(h = 16, d = 82, $fn = 36);
        cylinder(h = h, d = w, $fn = 36);
    }
    painted("#5A5A5A", w, d, h, "cyl")
        for (z = [22, 44, 66, 88, 110, 132])
            translate([0, 0, z])
                ring(w + 3, w - 8, 6, 36);
    color(C_BRASS)
        translate([0, 0, h])
            cylinder(h = 10, d = w - 2, $fn = 36);
    color(C_EMIT) {
        translate([0, 0, h + 10])
            cylinder(h = 16, d1 = 36, d2 = 18, $fn = 24);
        translate([0, 0, h + 26])
            cylinder(h = 14, d = 10, $fn = 16);
    }
    color(C_GOLD)
        translate([0, d / 2 + 1.2, 70])
            cube([14, 3.2, 40], center = true);
}

// 5. Time rotor: Gallifreyan disc face, glass column on top of a drum.
module dw_rotor() {
    w = 90; d = 90; h = 140;
    painted(C_BRASS, w, d, h, "cyl")
        cylinder(h = h, d = w, $fn = 40);
    painted(C_GOLD, w, d, h, "cyl")
        for (z = [18, 50, 82, 114])
            translate([0, 0, z])
                ring(w + 2, w - 10, 6, 40);
    color(C_BLACK)
        translate([0, d / 2 + 2.4, 80])
            rotate([90, 0, 0])
                cylinder(h = 2.4, d = 64, $fn = 40);
    color(C_GOLD)
        translate([0, d / 2 + 2.6, 80])
            rotate([90, 0, 0]) {
                ring(58, 50, 2.2, 32);
                ring(42, 34, 2.2, 28);
                ring(24, 10, 2.2, 24);
                for (a = [0:30:330])
                    rotate([0, 0, a])
                        translate([20, 0, 1])
                            cube([10, 2.2, 2.0], center = true);
            }
    color(C_ROTOR) {
        translate([0, 0, h])
            cylinder(h = 36, d = 28, $fn = 24);
        translate([0, 0, h + 36])
            sphere(d = 22, $fn = 20);
    }
    color(C_BRASS)
        translate([0, 0, h])
            ring(40, 30, 8, 24);
}

module assembly() {
    if (VARIANT == 1) dw_dalek();
    else if (VARIANT == 2) dw_k9();
    else if (VARIANT == 3) dw_angel();
    else if (VARIANT == 4) dw_sonic();
    else dw_rotor();
}

assembly();
