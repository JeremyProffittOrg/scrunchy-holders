// R2-D2 themed scrunchy holders. VARIANT 1..5.
// Front-right quadrant carries the character so a 3/4 view still reads.

include <holder_core.scad>

VARIANT = 1;
$fa = 6;
$fs = 0.45;

C_WHITE = "#F4F1E8";
C_BLUE  = "#2F5DA8";
C_SILV  = "#9AA3AE";
C_DK    = "#2A2E33";
C_RED   = "#C41E3A";
C_BLK   = "#141414";

module r2_skirt(d, h = 14) {
    cylinder(h = h, d = d + 10, $fn = 44);
    for (a = [-50, -25, 0, 25])
        wrap_y(d / 2 + 5.2, h / 2, a)
            cube([10, 2.2, 7], center = true);
}

module r2_blue_doors(d, z_list, w = 20, h = 18) {
    for (z = z_list)
        for (a = [-48, -24, 0, 18])
            wrap_y(d / 2 + 0.9, z, a)
                cube([w - abs(a) * 0.08, 2.4, h], center = true);
}

module r2_lamps(d, z) {
    wrap_y(d / 2 + 1.4, z, -18)
        sphere(d = 7.5, $fn = 16);
    wrap_y(d / 2 + 1.4, z + 14, 12)
        sphere(d = 6, $fn = 14);
}

module r2_radar(dome_r, body_h) {
    translate([0, 0, body_h])
        rotate([-42, 8, 0])
            translate([0, 0, dome_r - 1]) {
                color(C_BLK)
                    cylinder(h = 3.2, d = 22, $fn = 28);
                color(C_SILV)
                    translate([0, 0, 3])
                        cylinder(h = 5, d1 = 14, d2 = 9, $fn = 24);
                color(C_BLK)
                    translate([0, 0, 9])
                        sphere(d = 8.5, $fn = 20);
            }
}

module r2_dome_greebles(dome_r, body_h) {
    translate([0, 0, body_h]) {
        color(C_SILV)
            for (a = [-40, -10, 20])
                rotate([0, 0, a])
                    rotate([-18, 0, 0])
                        translate([0, 0, dome_r - 0.6])
                            cylinder(h = 2.2, d = 10, $fn = 6);
        color(C_BLUE)
            rotate([0, 0, 28])
                rotate([-55, 0, 0])
                    translate([0, 0, dome_r - 0.4])
                        cube([12, 9, 2.4], center = true);
        color(C_DK)
            rotate([8, 0, -30])
                translate([0, 0, dome_r + 2])
                    cylinder(h = 8, d = 4.2, $fn = 12);
    }
}

module r2_utility(d, z) {
    wrap_y(d / 2 + 1.6, z, -8) {
        cube([26, 3.2, 22], center = true);
        translate([0, 1.2, 0])
            cube([18, 2, 14], center = true);
    }
}

// 1. Classic astromech.
module r2_classic() {
    w = 86; d = 86; h = 138;
    painted(C_WHITE, w, d, h, "cyl") {
        cylinder(h = h, d = w, $fn = 44);
        translate([0, 0, h])
            hemisphere(w / 2, 44);
        r2_skirt(w, 12);
    }
    painted(C_BLUE, w, d, h, "cyl") {
        translate([0, 0, 16]) ring(w + 1.4, w - 8, 5, 44);
        translate([0, 0, 72]) ring(w + 1.2, w - 8, 4.5, 44);
        translate([0, 0, 118]) ring(w + 1.2, w - 8, 4.5, 44);
    }
    color(C_BLUE)
        r2_blue_doors(w, [36, 56, 92], 18, 16);
    painted(C_SILV, w, d, h, "cyl")
        translate([0, 0, h - 5])
            cylinder(h = 6, d = w + 2, $fn = 44);
    color(C_DK)
        r2_utility(d, 54);
    color(C_RED)
        r2_lamps(d, 44);
    color(C_SILV)
        wrap_band(d / 2 + 1.1, 14, -50, 20, 18)
            cube([8, 2, 3.5], center = true);
    r2_radar(w / 2, h);
    r2_dome_greebles(w / 2, h);
}

// 2. Field unit: classic body plus articulated legs on ±Y and a caster.
module r2_legged() {
    w = 80; d = 80; h = 124;
    painted(C_WHITE, w, d, h, "cyl") {
        cylinder(h = h, d = w, $fn = 44);
        translate([0, 0, h])
            hemisphere(w / 2, 44);
        r2_skirt(w, 13);
    }
    painted(C_BLUE, w, d, h, "cyl") {
        translate([0, 0, 20]) ring(w + 1.3, w - 7, 6, 44);
        translate([0, 0, 84]) ring(w + 1.3, w - 7, 6, 44);
    }
    color(C_BLUE)
        r2_blue_doors(w, [40, 62], 17, 15);
    color(C_WHITE)
        for (s = [-1, 1]) {
            translate([0, s * (d / 2 + 7), 10]) {
                cube([26, 16, 12], center = true);
                translate([0, s * 2, 28])
                    cube([18, 12, 44], center = true);
                translate([0, s * 8, 52])
                    rotate([s * 22, 0, 0])
                        cube([16, 11, 48], center = true);
                translate([0, s * 18, 8])
                    cube([22, 14, 8], center = true);
            }
        }
    color(C_SILV) {
        translate([0, d / 2 + 10, 6])
            rotate([90, 0, 0])
                cylinder(h = 8, d = 16, $fn = 20);
        translate([0, d / 2 + 14, 6])
            sphere(d = 14, $fn = 18);
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 22), 6])
                cube([20, 6, 5], center = true);
    }
    color(C_RED)
        r2_lamps(d, 38);
    r2_radar(w / 2 * 0.98, h);
    r2_dome_greebles(w / 2 * 0.98, h);
}

// 3. Dome-heavy: fat barrel, oversized instrument dome.
module r2_dome_heavy() {
    w = 100; d = 100; h = 102;
    painted(C_WHITE, w, d, h, "cyl") {
        cylinder(h = h, d = w, $fn = 46);
        translate([0, 0, h])
            hemisphere(w / 2 + 3, 46);
        r2_skirt(w, 14);
    }
    painted(C_BLUE, w, d, h, "cyl") {
        translate([0, 0, 18]) ring(w + 1.6, w - 10, 7, 46);
        translate([0, 0, 52]) ring(w + 1.6, w - 10, 7, 46);
    }
    color(C_BLUE)
        r2_blue_doors(w, [34, 70], 22, 18);
    color(C_DK)
        r2_utility(d, 48);
    color(C_RED)
        r2_lamps(d, 36);
    color(C_SILV)
        for (a = [-35, 0, 30])
            wrap_y(d / 2 + 1.2, 88, a)
                cylinder(h = 3, d = 12, $fn = 6);
    r2_radar(w / 2 + 3, h);
    r2_dome_greebles(w / 2 + 3, h);
    color(C_BLUE)
        translate([0, 0, h])
            rotate([-35, 0, 25])
                translate([0, 0, w / 2 + 2])
                    cube([16, 12, 2.6], center = true);
}

// 4. Panel tank: boxy astromech (the "square R2") with dense door plates.
module r2_panel_tank() {
    w = 90; d = 90; h = 136;
    painted(C_WHITE, w, d, h, "box") {
        rounded_xy_cube(w, d, h, 5);
        translate([0, 0, h])
            hemisphere(38, 40);
        rounded_xy_cube(w + 8, d + 8, 10, 4);
    }
    color(C_BLUE) {
        front_inlay(d, 2.4)
            for (row = [0:3])
                for (col = [-1, 0, 1])
                    translate([col * 24, 28 + row * 26])
                        square([20, 22], center = true);
        wrap_y(d / 2 + 1.1, 48, -40)
            cube([18, 2.4, 28], center = true);
        wrap_y(d / 2 + 1.1, 88, -40)
            cube([16, 2.4, 22], center = true);
    }
    color(C_DK)
        front_inlay(d, 3.0)
            translate([0, 58])
                square([28, 24], center = true);
    color(C_SILV) {
        front_inlay(d, 1.8)
            pane_muntins_2d(28, 24, 3, 2, 1.6);
        translate([0, 0, 9])
            cube([w + 1, d + 1, 3], center = true);
    }
    color(C_RED)
        translate([18, d / 2 + 1.6, 58])
            sphere(d = 8, $fn = 14);
    r2_radar(38, h);
    r2_dome_greebles(38, h);
}

// 5. Slim astromech: tall stack of instrument belts.
module r2_slim() {
    w = 74; d = 74; h = 168;
    painted(C_WHITE, w, d, h, "cyl") {
        cylinder(h = h, d = w, $fn = 44);
        translate([0, 0, h])
            hemisphere(w / 2 - 1, 40);
        r2_skirt(w, 11);
    }
    painted(C_BLUE, w, d, h, "cyl")
        for (z = [22, 46, 70, 94, 118, 142])
            translate([0, 0, z])
                ring(w + 1.4, w - 6, 5.2, 44);
    color(C_DK) {
        r2_utility(d, 88);
        wrap_y(d / 2 + 1.3, 120, -30)
            cube([14, 2.4, 20], center = true);
    }
    color(C_RED)
        r2_lamps(d, 64);
    color(C_SILV)
        wrap_band(d / 2 + 1.0, 160, -45, 20, 16)
            cube([6, 1.8, 4], center = true);
    r2_radar(w / 2 - 1, h);
    r2_dome_greebles(w / 2 - 1, h);
}

module assembly() {
    if (VARIANT == 1) r2_classic();
    else if (VARIANT == 2) r2_legged();
    else if (VARIANT == 3) r2_dome_heavy();
    else if (VARIANT == 4) r2_panel_tank();
    else r2_slim();
}

assembly();
