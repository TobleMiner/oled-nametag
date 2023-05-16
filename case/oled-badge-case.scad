module switch() {
    translate([-3, 0 - 0.6, 0.6 - 1.5 - 0.1]) cube([6, 4.8 + 1.2, 3 + 0.2]);
}

module button() {
    color("brown") {
        translate([0, 0, -1.5]) cube([2, 5.8, 3]);
        translate([2, 0 - 1.1 - 0.5, -2.5 - 0.5]) cube([1, 9, 6]);
    }
}

module button_mirrored() {
    color("brown") {
        translate([-2, 0, -1.5]) cube([2, 5.8, 3]);
        translate([-3, 0 - 1.1 - 0.5, -2.5 - 0.5]) cube([1, 9, 6]);
    }
}

module switch_and_button() {
    switch();
    translate([0, 0 - 0.6 + 0.1, 0.6]) button();
}

module switch_and_button_mirrored() {
    switch();
    translate([0, 0 - 0.6 + 0.1, 0.6]) button_mirrored();
}

module board() {
    // Main body
    translate([-0.25/2, -0.25/2, 0]) cube([88.25, 30.25, 8.5]);
    // Display cutout
    translate([0, 2.2, -2]) translate([4.61, 4.62, 0]) cube([78.78, 21.18, 2]);
    translate([0, 0, 2 + 0.15 + 1]) {
        // USB-C port
        translate([45, 30, 0]) cube([9.5, 2, 3.6]);
        // Audio port
        translate([41, 30 + 3, 2]) rotate([90, 0, 0]) cylinder(3, 1, 1, $fn=100);
        // Light sensor
        translate([33.7, 30, 0.5]) cube([3, 2, 1.5 + 0.5]);
        translate([0, 0, 0.5]) {
            // Buttons
            translate([-4, 4.6, 0]) switch_and_button();
            translate([-4, 20.6, 0]) switch_and_button();
            translate([88 + 4, 4.6, 0]) switch_and_button_mirrored();
            translate([88 + 4, 20.6, 0]) switch_and_button_mirrored();
            // Buttons pressed
            translate([1 - 4, 4.6, 0]) switch_and_button();
            translate([1 - 4, 20.6, 0]) switch_and_button();
            translate([88 + 4 - 1, 4.6, 0]) switch_and_button_mirrored();
            translate([88 + 4 - 1 , 20.6, 0]) switch_and_button_mirrored();
        }
    }
}

module screw_thread() {
    cylinder(5, 0.45, 0.45, $fn=100);
}

module screw_hole() {
    cylinder(100, 0.6, 0.6, $fn=100);
    translate([0, 0, 2]) cylinder(100, 1, 1, $fn=100);
}

module top_cover() {
        width = 92 + 0.8 * 2;
        mic_pos = [width / 2 - 1.5, 32 - (8 + 1 - 4)    , 1.8];
        translate([0, 0, 1 + 6.7]) {
            difference() {
                cube([92 + 0.8 * 2, 32, 1.8 + 2]);
                union() {
                    translate(mic_pos) mic_hole();
                    translate([(92 + 0.8 * 2) / 2 - 41/2, 32 / 2 - 13/2, 1.8]) cube([41, 13, 1.2]);
                    translate([1.3, 1.7, 0]) screw_hole();
                    translate([1.3, 32 / 2, 0]) screw_hole();
                    translate([1.3, 32 - 1.7, 0]) screw_hole();
                    translate([(92 + 0.8 * 2) - 1.3, 1.7, 0]) screw_hole();
                    translate([(92 + 0.8 * 2) - 1.3, 32 / 2, 0]) screw_hole();
                    translate([(92 + 0.8 * 2) - 1.3, 32 - 1.7, 0]) screw_hole();
                };
            }
            translate(mic_pos) grid();
        }
}

module bottom_shell() {
    difference() {
        width = 92 + 0.8 * 2;
        height = 32;
        cube([width, height, 1 + 6.7]);
        translate([0, 0, 1 + 6.7 - 5]) {
            translate([1.3, 1.7, 0]) screw_thread();
            translate([1.3, height / 2, 0]) screw_thread();
            translate([1.3, height - 1.7, 0]) screw_thread();
            translate([width - 1.3, 1.7, 0]) screw_thread();
            translate([width - 1.3, height / 2, 0]) screw_thread();
            translate([width - 1.3, height - 1.7, 0]) screw_thread();
        }
    }
}

module grid_bar() {
    translate([-4, -0.5, 0]) cube([8, 1, 2]);
}

module grid() {
    translate([-1, 1, 0]) rotate([0, 0, 45]) grid_bar();
    translate([1, -1, 0]) rotate([0, 0, 45]) grid_bar();
    translate([-1,-1, 0]) rotate([0, 0, -45]) grid_bar();
    translate([1, 1, 0]) rotate([0, 0, -45]) grid_bar();
}

module mic_hole() {
    cylinder(2, 4, 4, $fn=100);
}

difference() {
    union() {
        top_cover();
        bottom_shell();
    }
    union() {
        translate([0, 1, 1]) {
            //translate([1, 0, 1.5]) cube([90 + 0.8 * 2, 30, 3]);
            translate([2 + 0.8, 0, 0]) board();
        }
    }
}

module button_real() {
    color("brown") {
        translate([-0.5, 0, -1.5]) cube([2.5, 5.8, 3]);
        translate([2, 0 - 1.1, -2.5]) cube([1, 8, 5]);
    }
}

//scale([0.93, 0.95, 1]) rotate([0, 90, 0]) button_real();