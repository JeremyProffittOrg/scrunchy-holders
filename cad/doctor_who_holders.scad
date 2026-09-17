// Doctor Who themed scrunchy holders. VARIANT 1..5.

include <holder_core.scad>

VARIANT = 1;
$fa = 6;
$fs = 0.45;

C_CREAM = "#D9D2C5";
C_GOLD  = "#C4A35A";
C_BLK   = "#1A1A1A";
C_EYE   = "#D4E8F2";
C_STONE = "#8A8F86";
C_WING  = "#C5C8BE";
C_SONIC = "#2E2E2E";
C_EMIT  = "#6EC4D8";
C_ROTOR = "#6FE0C8";
C_BRASS = "#8A6A32";
C_SILV  = "#B0B6BC";
C_RED   = "#C8102E";
C_DK    = "#4A4A4A";

module dalek_bumps(d, z0, z1, rows = 4) {
    for (row = [0:rows - 1]) {
        z = z0 + row * ((z1 - z0) / rows);
        n = 10;
        for (i = [0:n - 1]) {
            a = i * 360 / n + (row % 2) * (180 / n);
            if (abs(cos(a)) < 0.78)
                rotate([0, 0, a])
                    translate([0, d / 2 + 1.4, z])
                        sphere(d = 11, $fn = 16);
        }
    }
}

module dw_dalek() {
    w = 92; d = 92; h = 112;
    painted(C_CREAM, w, d, h, "cyl") {
        frustum_cyl(110, 92, 54, 44);
        translate([0, 0, 54])
            cylinder(h = h - 54, d = 92, $fn = 44);
    }
    painted(C_GOLD, w, d, h, "cyl") {
        translate([0, 0, 50]) ring(95, 78, 6, 44);
        translate([0, 0, 78]) ring(95, 78, 6, 44);
        translate([0, 0, 100]) ring(94, 76, 5, 40);
    }
    color(C_GOLD)
        dalek_bumps(104, 12, 48, 4);
    color(C_CREAM) {
        translate([0, 0, h])
            frustum_cyl(92, 62, 16, 36);
        translate([0, 0, h + 16])
            hemisphere(32, 36);
        for (z = [h + 2, h + 8])
            translate([0, 0, z])
                ring(70, 54, 3.2, 32);
    }
    color(C_BLK)
        translate([0, 0, h + 16])
            rotate([-50, 0, 0])
                translate([0, 0, 31]) {
                    cylinder(h = 8, d = 10, $fn = 16);
                    cylinder(h = 28, d = 6.2, $fn = 14);
                    translate([0, 0, 10]) ring(12, 6.4, 2.2, 16);
                    translate([0, 0, 18]) ring(11, 6.4, 2.2, 16);
                }
    color(C_EYE)
        translate([0, 0, h + 16])
            rotate([-50, 0, 0])
                translate([0, 0, 60])
                    sphere(d = 11, $fn = 16);
    color(C_GOLD) {
        translate([-14, d / 2 + 2, 90])
            rotate([-90, 0, 0]) {
                cylinder(h = 8, d = 12, $fn = 16);
                cylinder(h = 30, d = 5.5, $fn = 12);
                translate([0, 0, 30])
                    cylinder(h = 6, d = 10, $fn = 12);
            }
        translate([14, d / 2 + 2, 90])
            rotate([-90, 0, 0]) {
                cylinder(h = 8, d = 14, $fn = 16);
                cylinder(h = 26, d = 7, $fn = 12);
                translate([0, 0, 26])
                    sphere(d = 12, $fn = 14);
            }
    }
    color(C_GOLD)
        wrap_band(d / 2 + 1.0, 64, -40, 20, 14)
            cube([8, 2.0, 10], center = true);
}

module dw_k9() {
    w = 90; d = 90; h = 118;
    painted(C_SILV, w, d, h, "box")
        rounded_xy_cube(w, d, h, 5);
    painted(C_DK, w, d, h, "box")
        translate([0, 0, 9])
            cube([w + 1.2, d + 1.2, 6], center = true);
    color(C_SILV) {
        translate([0, d / 2 + 10, 86])
            rotate([24, 0, 0])
                cube([62, 34, 42], center = true);
        translate([0, d / 2 + 24, 78])
            rotate([24, 0, 0])
                cube([40, 16, 18], center = true);
    }
    color(C_BLK) {
        translate([0, d / 2 + 28, 92])
            rotate([24, 0, 0])
                cube([36, 5, 14], center = true);
        wrap_y(d / 2 + 1.4, 48, -35)
            cube([16, 2.4, 36], center = true);
        wrap_y(d / 2 + 1.4, 48, 20)
            cube([16, 2.4, 36], center = true);
    }
    color(C_GOLD) {
        translate([22, d / 2 + 6, 108])
            rotate([0, 0, 20])
                cylinder(h = 18, d = 10, $fn = 16);
        translate([0, 0, h])
            cylinder(h = 20, d = 6, $fn = 12);
        front_inlay(d, 1.8)
            translate([0, 24])
                mirror([1, 0, 0])
                    text("K9", size = 10, font = "Arial:style=Bold",
                         halign = "center", valign = "center");
    }
    color(C_RED)
        translate([0, 0, h + 20])
            sphere(d = 9, $fn = 14);
    color(C_BLK)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 7), 10]) {
                cube([w - 14, 12, 18], center = true);
                for (x = [-28, -14, 0, 14, 28])
                    translate([x, s * 4, -2])
                        rotate([0, 90, 0])
                            cylinder(h = 8, d = 14, $fn = 14, center = true);
            }
}

module dw_angel() {
    w = 88; d = 88; h = 136;
    painted(C_STONE, w, d, h, "cyl") {
        cylinder(h = h, d1 = 98, d2 = 80, $fn = 40);
        for (a = [-40, -15, 15, 40])
            wrap_y(d / 2 + 2, 60, a)
                rotate([8, 0, 0])
                    cube([16, 8, 90], center = true);
    }
    color(C_STONE) {
        translate([0, 0, h])
            cylinder(h = 14, d = 46, $fn = 28);
        translate([0, 0, h + 20]) {
            sphere(d = 34, $fn = 28);
            translate([-7, 11, 6]) sphere(d = 5.5, $fn = 12);
            translate([7, 11, 6]) sphere(d = 5.5, $fn = 12);
            translate([0, 13, 1]) cube([8, 6, 6], center = true);
        }
        translate([0, d / 2 + 2, h - 8]) {
            cube([28, 10, 18], center = true);
            translate([-10, 4, 8]) cube([8, 8, 16], center = true);
            translate([10, 4, 8]) cube([8, 8, 16], center = true);
        }
    }
    color(C_WING)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 2), 78])
                rotate([s * 12, 0, 0])
                    for (i = [0:7])
                        translate([0, s * (4 + i * 2.2), 8 - i * 2])
                            rotate([s * 8, 0, 0])
                                linear_extrude(height = 2)
                                    rotate(s > 0 ? 90 : -90)
                                        feather_2d(34 - i * 1.4, 8);
}

module dw_sonic() {
    w = 76; d = 76; h = 158;
    painted(C_SONIC, w, d, h, "cyl") {
        cylinder(h = 14, d = 84, $fn = 40);
        cylinder(h = h, d = w, $fn = 40);
    }
    painted(C_DK, w, d, h, "cyl")
        for (z = [20:12:140])
            translate([0, 0, z])
                ring(w + 3.2, w - 7, 5, 40);
    color(C_BRASS)
        translate([0, 0, h])
            cylinder(h = 10, d = w - 2, $fn = 40);
    color(C_EMIT) {
        translate([0, 0, h + 10])
            cylinder(h = 14, d1 = 34, d2 = 16, $fn = 24);
        translate([0, 0, h + 24])
            cylinder(h = 12, d = 8, $fn = 14);
        for (a = [0:45:315])
            rotate([0, 0, a])
                translate([12, 0, h + 12])
                    cube([1.6, 4, 16], center = true);
    }
    color(C_GOLD)
        wrap_y(d / 2 + 1.6, 72, -10)
            cube([16, 3.6, 44], center = true);
    color(C_RED)
        wrap_y(d / 2 + 3.4, 92, -10)
            sphere(d = 8, $fn = 14);
    color(C_SILV)
        wrap_y(d / 2 + 1.4, 40, 18)
            cube([12, 2.4, 18], center = true);
}

module dw_rotor() {
    w = 90; d = 90; h = 138;
    painted(C_BRASS, w, d, h, "cyl")
        cylinder(h = h, d = w, $fn = 44);
    painted(C_GOLD, w, d, h, "cyl")
        for (z = [16, 48, 80, 112])
            translate([0, 0, z])
                ring(w + 2.4, w - 10, 7, 44);
    color(C_BLK)
        translate([0, d / 2 + 2.6, 78])
            rotate([90, 0, 0])
                cylinder(h = 2.6, d = 62, $fn = 40);
    color(C_GOLD)
        translate([0, d / 2 + 3.0, 78])
            rotate([90, 0, 0]) {
                ring(56, 48, 2.2, 32);
                ring(40, 32, 2.2, 28);
                ring(22, 8, 2.2, 24);
                for (a = [0:20:340])
                    rotate([0, 0, a])
                        translate([24, 0, 1])
                            cube([8, 2.0, 2.0], center = true);
                for (a = [10:40:350])
                    rotate([0, 0, a])
                        translate([14, 0, 1])
                            cylinder(h = 2.2, d = 3.2, $fn = 10);
            }
    color(C_ROTOR) {
        translate([0, 0, h])
            cylinder(h = 38, d = 30, $fn = 24);
        translate([0, 0, h + 8])
            cylinder(h = 22, d = 18, $fn = 16);
        translate([0, 0, h + 38])
            sphere(d = 24, $fn = 22);
    }
    color(C_BRASS)
        translate([0, 0, h])
            ring(42, 31, 8, 24);
}

module assembly() {
    if (VARIANT == 1) dw_dalek();
    else if (VARIANT == 2) dw_k9();
    else if (VARIANT == 3) dw_angel();
    else if (VARIANT == 4) dw_sonic();
    else dw_rotor();
}

assembly();
