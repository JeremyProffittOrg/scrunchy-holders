// Star Trek themed scrunchy holders. VARIANT 1..5.
// Slots on ±X, character on ±Y.

include <holder_core.scad>

VARIANT = 1;
$fa = 8;
$fs = 0.55;

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

module delta_2d(s = 1) {
    scale(s)
        polygon([
            [0, 22],
            [16, -14],
            [5, -14],
            [0, -4],
            [-5, -14],
            [-16, -14]
        ]);
}

// 1. Constitution totem: engineering hull as the holder, saucer on top,
//    nacelles on ±Y so the slots stay clear.
module st_enterprise() {
    w = 82; d = 82; h = 150;
    painted(C_HULL, w, d, h, "cyl") {
        frustum_cyl(70, 82, 20, 36);
        translate([0, 0, 20])
            cylinder(h = h - 20, d = w, $fn = 36);
    }
    color(C_NAVY)
        translate([0, d / 2 + 0.4, 70])
            rotate([90, 0, 0])
                linear_extrude(height = 2.2)
                    delta_2d(1.15);
    color("#6EC8FF")
        translate([0, d / 2 + 0.6, 28])
            rotate([90, 0, 0])
                cylinder(h = 2, d = 24, $fn = 24);
    color(C_HULL)
        translate([0, 0, h])
            cylinder(h = 16, d = 118, $fn = 44);
    color(C_NAVY)
        translate([0, 0, h + 16])
            cylinder(h = 4, d = 40, $fn = 28);
    color(C_NAC)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 16), 40])
                cylinder(h = 90, d = 18, $fn = 24);
    color(C_RED)
        for (s = [-1, 1])
            translate([0, s * (d / 2 + 16), 130])
                sphere(d = 18, $fn = 16);
}

// 2. Communicator: thick standing slab, grill and hero button on +Y.
module st_communicator() {
    w = 90; d = 88; h = 150;
    painted(C_COMM, w, d, h, "box")
        rounded_xy_cube(w, d, h, 8);
    color(C_SILV)
        translate([0, d / 2 + 0.4, 96])
            cube([64, 2.2, 70], center = true);
    color(C_GOLD)
        translate([0, d / 2 + 1.6, 118])
            cylinder(h = 3, d = 18, $fn = 24);
    color(C_BLK)
        for (row = [0:5])
            translate([0, d / 2 + 1.4, 58 + row * 6])
                cube([48, 1.8, 2.4], center = true);
    color(C_SILV)
        translate([0, 0, h])
            rounded_xy_cube(w - 6, d - 6, 8, 6);
    color(C_GOLD)
        translate([0, d / 2 - 2, h + 8])
            cube([40, 8, 4], center = true);
}

// 3. Borg cube: greebled cube, green-grey, slots punch two faces.
module st_borg() {
    w = 100; d = 100; h = 100;
    painted(C_BORG, w, d, h, "box")
        body_cube(w, d, h);
    color(C_GREEB) {
        translate([18, 16, h + 5])
            cube([28, 24, 12], center = true);
        translate([-22, -12, h + 7])
            cube([20, 32, 16], center = true);
        translate([8, -24, h + 4])
            cube([16, 16, 10], center = true);
        translate([-8, 28, h / 2])
            cube([18, 8, 22], center = true);
        for (i = [0:5]) {
            x = -28 + (i % 3) * 22;
            z = 22 + floor(i / 3) * 32;
            translate([x, d / 2 + 1.2, z])
                cube([16 + (i % 2) * 6, 4, 12 + (i % 2) * 8], center = true);
        }
    }
    color("#6A8A4A")
        translate([16, d / 2 + 1.4, 58])
            cube([22, 3.2, 22], center = true);
}

// 4. Starfleet delta: rounded body with a large extruded chevron on +Y.
module st_delta() {
    w = 90; d = 88; h = 160;
    painted(C_NAVY, w, d, h, "box")
        rounded_xy_cube(w, d, h, 10);
    color(C_GOLD)
        translate([0, d / 2 + 0.2, 88])
            rotate([90, 0, 0])
                linear_extrude(height = 6)
                    delta_2d(2.4);
    color(C_HULL)
        translate([0, d / 2 + 0.4, 28])
            cube([50, 2.2, 8], center = true);
    color(C_GOLD)
        translate([0, 0, h])
            cylinder(h = 8, d = 36, $fn = 6);
}

// 5. Warp core: stacked torus rings around a glowing column.
module st_warp_core() {
    w = 86; d = 86; h = 176;
    painted(C_CORE2, w, d, h, "cyl")
        cylinder(h = h, d = w, $fn = 36);
    painted(C_CORE, w, d, h, "cyl")
        translate([0, 0, h / 2])
            cylinder(h = 36, d = w - 8, $fn = 36, center = true);
    painted("#C8D0D4", w, d, h, "cyl")
        for (z = [18, 46, 110, 138, 162])
            translate([0, 0, z])
                torus(w / 2 + 2, 5.5, 28);
    color(C_GOLD) {
        translate([0, 0, 0])
            cylinder(h = 10, d = w + 10, $fn = 36);
        translate([0, 0, h])
            cylinder(h = 10, d = w + 6, $fn = 36);
    }
    color(C_CORE)
        translate([0, 0, h + 10])
            sphere(d = 22, $fn = 20);
}

module assembly() {
    if (VARIANT == 1) st_enterprise();
    else if (VARIANT == 2) st_communicator();
    else if (VARIANT == 3) st_borg();
    else if (VARIANT == 4) st_delta();
    else st_warp_core();
}

assembly();
