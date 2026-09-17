// Harry Potter themed scrunchy holders. VARIANT 1..5.
// Not castle-shaped (that is the Hogwarts set). Slots on ±X.

include <holder_core.scad>

VARIANT = 1;
$fa = 8;
$fs = 0.55;

C_HAT   = "#5A3A1C";
C_GOLD  = "#D4A017";
C_WING  = "#F3E6C4";
C_SKIN  = "#E2C7A8";
C_HAIR  = "#2B1A12";
C_SCAR  = "#A33A2A";
C_BRICK = "#8B3A2A";
C_MORT  = "#C4B7A6";
C_IRON  = "#3A3A3A";
C_POT   = "#2F4A38";
C_SIGN  = "#1A1A1A";

// 1. Sorting Hat: brim + fat body (slots need width) + pointy cap above.
module hp_sorting_hat() {
    w = 90; d = 90; h = 140;
    painted(C_HAT, w, d, h, "cyl") {
        cylinder(h = 10, d = 124, $fn = 40);
        cylinder(h = h, d1 = 96, d2 = 82, $fn = 36);
        translate([0, 10, 78])
            rotate([12, 0, 0])
                cube([22, 12, 56], center = true);
    }
    color(C_HAT) {
        translate([0, 0, h])
            cone(82, 10, 42, 32);
        translate([0, d / 2 - 4, 58])
            rotate([8, 0, 0])
                cube([30, 8, 7], center = true);
        translate([-11, d / 2 - 2, 76])
            rotate([10, 0, -8])
                cube([9, 7, 16], center = true);
        translate([11, d / 2 - 2, 76])
            rotate([10, 0, 8])
                cube([9, 7, 16], center = true);
    }
    color(C_GOLD)
        translate([0, 0, h + 44])
            sphere(d = 8, $fn = 14);
}

// 2. Golden Snitch: sphere body, wings on ±Y.
module hp_snitch() {
    w = 92; d = 92; h = 92;
    painted(C_GOLD, w, d, h, "sphere")
        flat_sphere(w / 2, 5, 44);
    color(C_WING)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 2), h * 0.58]) {
                rotate([s * 12, 0, 0])
                    hull() {
                        translate([0, s * 4, 0])
                            sphere(d = 8, $fn = 14);
                        translate([-28, s * 22, 18])
                            sphere(d = 4, $fn = 12);
                        translate([28, s * 22, 18])
                            sphere(d = 4, $fn = 12);
                        translate([0, s * 36, 28])
                            sphere(d = 3.5, $fn = 12);
                    }
            }
    color("#B8860B")
        translate([0, d / 2 - 2, h * 0.62])
            sphere(d = 10, $fn = 16);
}

// 3. Glasses and scar totem: round head, round glasses, lightning bolt.
module hp_glasses() {
    w = 90; d = 90; h = 150;
    painted(C_SKIN, w, d, h, "cyl")
        cylinder(h = h, d = w, $fn = 40);
    painted(C_HAIR, w, d, h, "cyl")
        translate([0, 0, h - 28])
            cylinder(h = 28, d = w + 4, $fn = 40);
    color(C_HAIR)
        translate([0, 0, h])
            hemisphere(w / 2 + 2, 36);
    color(C_SIGN) {
        translate([-16, d / 2 + 3.2, 88])
            rotate([90, 0, 0])
                ring(28, 20, 3.4, 28);
        translate([16, d / 2 + 3.2, 88])
            rotate([90, 0, 0])
                ring(28, 20, 3.4, 28);
        translate([0, d / 2 + 2.4, 88])
            cube([8, 3.2, 3.4], center = true);
    }
    color(C_SCAR)
        translate([10, d / 2 + 0.8, 124])
            rotate([0, 0, -18])
                linear_extrude(height = 2.4)
                    polygon([
                        [0, 16], [4, 8], [1.5, 8], [5, -2],
                        [1, 2], [-1, -10], [0.5, 4], [-4, 4]
                    ]);
}

// 4. Platform 9 3/4: brick wall with arch and sign.
module hp_platform() {
    w = 94; d = 88; h = 160;
    painted(C_BRICK, w, d, h, "box")
        rounded_xy_cube(w, d, h, 2);
    color(C_MORT)
        for (row = [0:8]) {
            off = (row % 2) * 7;
            for (col = [-2:2])
                translate([col * 14 + off, d / 2 + 0.7, 16 + row * 14])
                    cube([12, 1.6, 5.5], center = true);
        }
    color(C_DARK)
        translate([0, d / 2 + 0.6, 70])
            difference() {
                cube([54, 2.4, 72], center = true);
                translate([0, 0, -8])
                    cube([40, 3.2, 48], center = true);
                translate([0, 0, 16])
                    rotate([90, 0, 0])
                        cylinder(h = 4, d = 40, $fn = 28);
            }
    color(C_SIGN)
        translate([0, d / 2 + 1.2, 138])
            cube([70, 3, 18], center = true);
    color("#F4F1E8")
        translate([0, d / 2 + 2.6, 138])
            rotate([90, 0, 0])
                linear_extrude(height = 1.4)
                    mirror([1, 0, 0])
                        text("9 3/4", size = 9, font = "Arial:style=Bold",
                             halign = "center", valign = "center");
    color(C_SIGN)
        translate([0, 0, h + 3])
            cube([78, 26, 6], center = true);
    color("#F4F1E8")
        translate([0, 0, h + 6.2])
            linear_extrude(height = 1.6)
                text("9 3/4", size = 10, font = "Arial:style=Bold",
                     halign = "center", valign = "center");
}

// 5. Potion cauldron: pot belly, rim, three feet on the bed.
module hp_cauldron() {
    w = 96; d = 96; h = 130;
    painted(C_POT, w, d, h, "cyl") {
        cylinder(h = 16, d1 = 78, d2 = 96, $fn = 40);
        translate([0, 0, 16])
            cylinder(h = h - 16, d = 96, $fn = 40);
    }
    color(C_POT)
        translate([0, 0, h])
            ring(108, 72, 10, 40);
    color(C_IRON)
        for (a = [-40, 40, 180])
            rotate([0, 0, a])
                translate([0, d / 2 - 8, 0]) {
                    cube([14, 16, 10], center = true);
                    translate([0, 6, 4])
                        sphere(d = 12, $fn = 16);
                }
    color(C_GOLD)
        translate([0, d / 2 + 0.6, 70])
            cube([18, 2.2, 28], center = true);
}

module assembly() {
    if (VARIANT == 1) hp_sorting_hat();
    else if (VARIANT == 2) hp_snitch();
    else if (VARIANT == 3) hp_glasses();
    else if (VARIANT == 4) hp_platform();
    else hp_cauldron();
}

assembly();
