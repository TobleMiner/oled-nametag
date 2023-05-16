WALL_THICKNESS_FRONT_BACK = 0.8;
WALL_THICKNESS_LEFT_RIGHT = 0.8;
WALL_THICKNESS_TOP = 0.8;
WALL_THICKNESS_BOTTOM = 0.8;
BOARD_WIDTH = 88;
BOARD_HEIGHT = 30;
BOARD_DEPTH = 8.5;
BOARD_OVERSIZE = 0.4;
BUTTON_BASE_THICKNESS = 0.8;
BUTTON_ACTUATOR_LENGTH = 0.8;
BUTTON_ACTUATION = 0.6;

module button() {
    color("brown") {
        translate([0 - 4, 0, -1.5]) cube([4, 5.8, 3]);
        translate([0, 0 - 1.1 - 0.5, -2.5 - 0.5]) cube([BUTTON_BASE_THICKNESS + 0.01, 9, 6]);
    }
}

module button_mirrored() {
    color("brown") {
        translate([BUTTON_BASE_THICKNESS, 0, -1.5]) cube([4, 5.8, 3]);
        translate([-0.01, 0 - 1.1 - 0.5, -2.5 - 0.5]) cube([BUTTON_BASE_THICKNESS + 0.01, 9, 6]);
    }
}

module switch_and_button() {
    translate([0, 0 - 0.6 + 0.1, 0.6]) button();
}

module switch_and_button_mirrored() {
    translate([0, 0 - 0.6 + 0.1, 0.6]) button_mirrored();
}

module board() {
    body_width = BOARD_WIDTH + BOARD_OVERSIZE;
    body_height = BOARD_HEIGHT + BOARD_OVERSIZE;
    translate([0, 0, 2 + 0.15 + 1]) translate([0, 0, 0.5]) {
        // Buttons left
        translate([0, 4.6, 0]) switch_and_button();
        translate([0, 20.6, 0]) switch_and_button();
        translate([BUTTON_BASE_THICKNESS, 4.6, 0]) switch_and_button();
        translate([BUTTON_BASE_THICKNESS, 20.6, 0]) switch_and_button();
    }

    translate([BUTTON_BASE_THICKNESS + BUTTON_ACTUATOR_LENGTH, 0, 0]) {
        // Main body
        cube([body_width, body_height, BOARD_DEPTH]);
        // Display cutout
        translate([0, 2.2, -2]) translate([4.61, 4.62, 0]) cube([78.78, 21.18, 2]);
        translate([0, 0, 2 + 0.15 + 1]) {
            // Antenna
            translate([39, 26, 0]) cube([3, 3, 4]);
            // USB-C port
            translate([45.5 - 0.25, 30, 0]) cube([9.5, 2, 3.6]);
            // Audio port
            translate([41, 30 + 3, 2]) rotate([90, 0, 0]) cylinder(3, 0.75, 0.75, $fn=100);
            // Light sensor
            translate([33.5, 30, 0.5]) cube([3, 2, 1.5 + 0.5]);
            translate([0, 0, 0.5]) {
                // Buttons right
                translate([body_width, 4.6, 0]) switch_and_button_mirrored();
                translate([body_width, 20.6, 0]) switch_and_button_mirrored();
                translate([body_width + BUTTON_BASE_THICKNESS, 4.6, 0]) switch_and_button_mirrored();
                translate([body_width + BUTTON_BASE_THICKNESS , 20.6, 0]) switch_and_button_mirrored();
            }
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
        width = BOARD_WIDTH + BOARD_OVERSIZE + WALL_THICKNESS_LEFT_RIGHT * 2 + BUTTON_ACTUATOR_LENGTH * 2 + BUTTON_BASE_THICKNESS * 2;
        height = BOARD_HEIGHT + BOARD_OVERSIZE + WALL_THICKNESS_FRONT_BACK * 2;
        depth = 1.8 /* board */ + 1 /* magnet */ + WALL_THICKNESS_TOP;
        mic_pos = [width / 2 - 1.5, height - (8 + 1 - 4), 1.8];
        difference() {
            cube([width, height, depth]);
            union() {
                // microphone grid hole
                translate(mic_pos) mic_hole();
                // magnet detent
                translate([width / 2 - 41/2, height / 2 - 13/2, 1.8]) cube([41, 13, 1.2]);
                // screw holes
                translate([1.25, 1.7, 0]) screw_hole();
                translate([1.25, height / 2, 0]) screw_hole();
                translate([1.25, height - 1.7, 0]) screw_hole();
                translate([width - 1.25, 1.7, 0]) screw_hole();
                translate([width - 1.25, height / 2, 0]) screw_hole();
                translate([width - 1.25, height - 1.7, 0]) screw_hole();
            };
        }
        // microphone grid
        translate(mic_pos) grid(WALL_THICKNESS_TOP + 1);
}

module bottom_shell() {
    width = BOARD_WIDTH + BOARD_OVERSIZE + WALL_THICKNESS_LEFT_RIGHT * 2 + BUTTON_ACTUATOR_LENGTH * 2 + BUTTON_BASE_THICKNESS * 2;
    height = BOARD_HEIGHT + BOARD_OVERSIZE + WALL_THICKNESS_FRONT_BACK * 2;
    difference() {
        // bottom shell
        cube([width, height, WALL_THICKNESS_BOTTOM + 6.7]);
        translate([0, 0, WALL_THICKNESS_BOTTOM + 6.7 - 4]) {
            // screw holes (4mm deep)
            translate([1.25, 1.7, 0]) screw_thread();
            translate([1.25, height / 2, 0]) screw_thread();
            translate([1.25, height - 1.7, 0]) screw_thread();
            translate([width - 1.25, 1.7, 0]) screw_thread();
            translate([width - 1.25, height / 2, 0]) screw_thread();
            translate([width - 1.25, height - 1.7, 0]) screw_thread();
        }
    }
}

module grid_bar(height) {
    translate([-4, -0.5, 0]) cube([8, 1, height]);
}

module grid(height) {
    translate([-1, 1, 0]) rotate([0, 0, 45]) grid_bar(height);
    translate([1, -1, 0]) rotate([0, 0, 45]) grid_bar(height);
    translate([-1,-1, 0]) rotate([0, 0, -45]) grid_bar(height);
    translate([1, 1, 0]) rotate([0, 0, -45]) grid_bar(height);
}

module mic_hole() {
    cylinder(2, 4, 4, $fn=100);
}

module case(top ,bottom) {
    difference() {
        bottom_shell_height = WALL_THICKNESS_BOTTOM + 6.7;
        union() {
            if (bottom) { color("green") bottom_shell(); }
            if (top) { translate([0, 0, bottom_shell_height]) color("red") top_cover(); }
        }
        translate([WALL_THICKNESS_LEFT_RIGHT, WALL_THICKNESS_FRONT_BACK, WALL_THICKNESS_BOTTOM]) !board();
    }
}
/*
    translate([WALL_THICKNESS_LEFT_RIGHT, WALL_THICKNESS_FRONT_BACK, WALL_THICKNESS_TOP]) color("white") board();
*/

module button_real() {
    color("brown") {
        translate([0, -2.7, -1.3]) cube([2.5, 5.8 - 0.4, 3 - 0.4]);
        translate([2.5, -4, -2.5]) cube([BUTTON_BASE_THICKNESS, 8, 5]);
    }
}

//scale([0.93, 0.95, 1]) rotate([0, 90, 0]) button_real();

case(false, true);
//button_real();