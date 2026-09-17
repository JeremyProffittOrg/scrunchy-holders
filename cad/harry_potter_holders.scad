// Harry Potter themed scrunchy holders. VARIANT 1..5.

include <holder_core.scad>

VARIANT = 1;
$fa = 6;
$fs = 0.45;

C_HAT   = "#5C3A1C";
C_HAT2  = "#3E2612";
C_GOLD  = "#D4A017";
C_WING  = "#F4E6C0";
C_SKIN  = "#E2C7A8";
C_HAIR  = "#2B1A12";
C_SCAR  = "#A33A2A";
C_BRICK = "#8B3A2A";
C_MORT  = "#C4B7A6";
C_IRON  = "#3A3A3A";
C_POT   = "#2A4636";
C_SIGN  = "#1A1A1A";
C_IVORY = "#F4F1E8";

module hp_sorting_hat() {
    w = 90; d = 90; h = 138;
    painted(C_HAT, w, d, h, "cyl") {
        cylinder(h = 9, d = 128, $fn = 44);
        for (a = [0:30:330])
            rotate([0, 0, a])
                translate([52, 0, 5])
                    scale([1.2, 0.7, 1])
                        sphere(d = 16, $fn = 16);
        cylinder(h = h, d = 92, $fn = 40);
        translate([10, 14, 70])
            rotate([14, 10, 18])
                cube([22, 14, 60], center = true);
        translate([-12, 10, 95])
            rotate([-10, -12, -16])
                cube([18, 12, 48], center = true);
        translate([0, 16, 50])
            rotate([8, 0, 0])
                cube([36, 10, 20], center = true);
    }
    color(C_HAT2) {
        translate([0, 0, h])
            cone(92, 8, 44, 36);
        translate([8, 4, h + 28])
            rotate([0, 18, 20])
                cube([14, 10, 28], center = true);
        wrap_y(d / 2 - 2, 58, 0)
            cube([34, 8, 8], center = true);
        wrap_y(d / 2 - 1, 78, -12)
            cube([10, 7, 18], center = true);
        wrap_y(d / 2 - 1, 78, 12)
            cube([10, 7, 18], center = true);
    }
    color(C_GOLD) {
        wrap_y(d / 2 + 1.4, 42, -8)
            cube([40, 3.2, 7], center = true);
        wrap_y(d / 2 + 2.2, 42, -8)
            cube([12, 3.6, 10], center = true);
        translate([0, 0, h + 46])
            sphere(d = 9, $fn = 14);
    }
    color(C_HAT)
        wrap_y(d / 2 + 0.8, 64, 0)
            for (i = [-3:3])
                translate([i * 4, 0, -6])
                    cube([1.6, 2.4, 8], center = true);
}

module hp_snitch() {
    w = 94; d = 94; h = 94;
    painted(C_GOLD, w, d, h, "sphere")
        difference() {
            flat_sphere(w / 2, 5, 48);
            for (a = [0:30:150])
                translate([0, 0, w / 2])
                    rotate([90, 0, a])
                        torus(w / 2 + 0.2, 0.7, 40);
            translate([0, 0, w / 2])
                for (z = [-24, 0, 24])
                    translate([0, 0, z])
                        torus(sqrt(max(4, (w / 2) * (w / 2) - z * z)), 0.65, 36);
        }
    color(C_WING)
        for (s = [-1, 1])
            translate([0, s * (d / 2 - 2), h * 0.62])
                rotate([s * 18, 0, s * 8])
                    for (i = [0:8])
                        rotate([0, -40 + i * 10, 0])
                            linear_extrude(height = 1.8)
                                feather_2d(42 - i * 1.2, 7 - i * 0.25);
    color("#B8860B")
        translate([0, d / 2 - 1, h * 0.62])
            sphere(d = 9, $fn = 16);
}

module hp_glasses() {
    w = 90; d = 90; h = 148;
    painted(C_SKIN, w, d, h, "cyl")
        cylinder(h = h, d = w, $fn = 44);
    painted(C_HAIR, w, d, h, "cyl")
        translate([0, 0, h - 36])
            cylinder(h = 36, d = w + 5, $fn = 44);
    color(C_HAIR) {
        translate([0, 0, h])
            hemisphere(w / 2 + 3, 40);
        for (a = [-50, -25, 0, 25, 45])
            wrap_y(d / 2 + 3, h - 8, a)
                scale([1, 1.4, 1.8])
                    sphere(d = 16, $fn = 16);
        wrap_y(d / 2 + 6, h + 8, -20)
            sphere(d = 18, $fn = 16);
    }
    color(C_SIGN) {
        translate([-17, d / 2 + 3.4, 86])
            rotate([90, 0, 0])
                ring(30, 22, 3.6, 28);
        translate([17, d / 2 + 3.4, 86])
            rotate([90, 0, 0])
                ring(30, 22, 3.6, 28);
        translate([0, d / 2 + 3.8, 86])
            cube([8, 4, 3.6], center = true);
        translate([-32, d / 2 + 1.6, 86])
            rotate([0, 0, 18])
                cube([10, 3, 3.2], center = true);
        translate([32, d / 2 + 1.6, 86])
            rotate([0, 0, -18])
                cube([10, 3, 3.2], center = true);
    }
    color(C_SCAR)
        front_inlay(d, 2.8)
            translate([12, 122])
                lightning_2d();
}

module hp_platform() {
    w = 94; d = 88; h = 156;
    painted(C_BRICK, w, d, h, "box")
        rounded_xy_cube(w, d, h, 1.5);
    color(C_MORT)
        front_inlay(d, 1.8)
            translate([0, h / 2])
                brick_bond_2d(w - 8, h - 16, 14, 6, 1.4);
    color(C_DARK)
        front_inlay(d, 3.4)
            translate([0, 64])
                difference() {
                    square([58, 88], center = true);
                    translate([0, -8])
                        lancet_2d(36, 64);
                }
    color(C_MORT)
        front_inlay(d, 3.8)
            translate([0, 88])
                for (a = [-50, -25, 0, 25, 50])
                    rotate(a)
                        translate([0, 22])
                            square([10, 16], center = true);
    color(C_SIGN) {
        translate([0, d / 2 + 8, 142])
            cube([8, 14, 8], center = true);
        translate([0, d / 2 + 16, 138])
            cube([64, 5, 22], center = true);
        translate([0, 0, h + 3])
            cube([78, 26, 6], center = true);
    }
    color(C_IVORY) {
        translate([0, d / 2 + 19, 138])
            rotate([90, 0, 0])
                linear_extrude(height = 1.6)
                    mirror([1, 0, 0])
                        text("9 3/4", size = 9, font = "Arial:style=Bold",
                             halign = "center", valign = "center");
        translate([0, 0, h + 6.2])
            linear_extrude(height = 1.6)
                text("9 3/4", size = 10, font = "Arial:style=Bold",
                     halign = "center", valign = "center");
    }
}

module hp_cauldron() {
    w = 96; d = 96; h = 128;
    painted(C_POT, w, d, h, "cyl") {
        cylinder(h = 16, d1 = 78, d2 = 96, $fn = 44);
        translate([0, 0, 16])
            cylinder(h = h - 16, d = 96, $fn = 44);
    }
    color(C_POT)
        translate([0, 0, h])
            ring(110, 70, 11, 44);
    color(C_IRON) {
        for (a = [-48, 8, 180])
            rotate([0, 0, a])
                translate([0, d / 2 - 6, 4]) {
                    cube([16, 18, 10], center = true);
                    translate([0, 8, 2])
                        sphere(d = 14, $fn = 16);
                    translate([0, 10, -2])
                        cube([18, 8, 5], center = true);
                }
        wrap_band(d / 2 + 1.2, 40, -50, 20, 14)
            rivet(2.6, 1.6);
        wrap_band(d / 2 + 1.2, 70, -50, 20, 14)
            rivet(2.6, 1.6);
        wrap_band(d / 2 + 1.2, 100, -50, 20, 14)
            rivet(2.6, 1.6);
        translate([0, 0, h + 16])
            rotate([90, 0, 0])
                intersection() {
                    rotate_extrude($fn = 28)
                        translate([26, 0, 0])
                            circle(d = 5, $fn = 12);
                    translate([0, 20, 0])
                        cube([80, 44, 16], center = true);
                }
    }
    color(C_GOLD)
        wrap_y(d / 2 + 1.4, 78, -12)
            cube([16, 2.6, 26], center = true);
}

module assembly() {
    if (VARIANT == 1) hp_sorting_hat();
    else if (VARIANT == 2) hp_snitch();
    else if (VARIANT == 3) hp_glasses();
    else if (VARIANT == 4) hp_platform();
    else hp_cauldron();
}

assembly();
