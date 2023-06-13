ESCAPE_HOLES = true;
BATTERY_THICKNESS = 4;
WALL_THICKNESS_FRONT_BACK = 0.8;
WALL_THICKNESS_LEFT_RIGHT = 0.8;
WALL_THICKNESS_TOP = 0.5;
WALL_THICKNESS_BOTTOM = 0.8;
BOARD_WIDTH = 88;
BOARD_HEIGHT = 30;
BOARD_DEPTH = 4.5 + BATTERY_THICKNESS;
CASE_HEIGHT_BOTTOM = 6.7;
CASE_HEIGHT_TOP = 0.8 + BATTERY_THICKNESS - 3;
BOARD_OVERSIZE = 0.4;
BUTTON_BASE_THICKNESS = 0.8;
BUTTON_ACTUATOR_LENGTH = 0.8;
BUTTON_ACTUATION = 0.6;
SCREW_HEAD_SIZE = 2; // non-oversized: 2
SCREW_HOLE_SIZE = 1.1; // non-oversized: 1.1
SCREW_THREAD_SIZE = 0.9; // non-oversized: 0.9
/* Anycubic Kossel settings
SCREW_HEAD_SIZE = 2.5; // non-oversized: 2
SCREW_HOLE_SIZE = 1.5; // non-oversized: 1.1
SCREW_THREAD_SIZE = 1; // non-oversized: 0.9
*/

REVERSE_MOUNT = true;

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
        if (REVERSE_MOUNT) {
            translate([0, 2.2, -2]) translate([4.61, 4.62 - 1, 0]) cube([78.78, 21.18, 2]);
        } else {
            translate([0, 2.2, -2]) translate([4.61, 4.62 - 0, 0]) cube([78.78, 21.18, 2]);
        }
        translate([0, 0, 2 + 0.15 + 1]) {
            // Antenna
            translate([39, 26, 0]) cube([3, 3, 4]);
            // USB-C port
            translate([45.5 - 0.25, 30, 0]) cube([9.5, 2, 3.6]);
            // Audio port
            // translate([41, 30 + 3, 2]) rotate([90, 0, 0]) cylinder(3, 0.75, 0.75, $fn=100);
            if (!REVERSE_MOUNT) {
                // Light sensor
                translate([33.5, 30, 0.25]) cube([3, 2, 1.5 + 0.5]);
            } else {
                // Light sensor 2
                translate([75.28, -2, 0.25]) cube([3, 2, 1.5 + 0.5]);
            }
            
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
    cylinder(5, SCREW_THREAD_SIZE/2, SCREW_THREAD_SIZE/2, $fn=100);
    if (ESCAPE_HOLES) {
        translate([0, 0, 0.75 -0.1]) rotate([0, 90, 0]) cylinder(3, 0.75, 0.75, $fn=100);
    }
}

module screw_hole() {
    cylinder(100, SCREW_HOLE_SIZE/2, SCREW_HOLE_SIZE/2, $fn=100);
    translate([0, 0, 2]) cylinder(100, SCREW_HEAD_SIZE/2, SCREW_HEAD_SIZE/2, $fn=100);
}

module top_cover() {
    width = BOARD_WIDTH + BOARD_OVERSIZE + WALL_THICKNESS_LEFT_RIGHT * 2 + BUTTON_ACTUATOR_LENGTH * 2 + BUTTON_BASE_THICKNESS * 2;
    height = BOARD_HEIGHT + BOARD_OVERSIZE + WALL_THICKNESS_FRONT_BACK * 2;
    depth = CASE_HEIGHT_TOP /* board */ + 1 /* magnet */ + WALL_THICKNESS_TOP;
    mic_pos = [width / 2 - 1.5, height - (8 + 1 - 4), CASE_HEIGHT_TOP];
    difference() {
        cube([width, height, depth]);
        union() {
            // microphone grid hole
            translate(mic_pos) mic_hole();
            if (REVERSE_MOUNT) {
                // magnet detent
                translate([width / 2 - 41/2, 1, CASE_HEIGHT_TOP]) cube([41, 13, 1.2]);
                // weight reduction
                translate([7, 3, CASE_HEIGHT_TOP]) {
                    difference() {
                        cube([width - 14, height - 6, 1.2]);
                        translate([(width - 14 - 50) / 2, 0, 0]) cube([50, 15, 1.2]);
                    }
                }
            } else {
                // magnet detent
                translate([width / 2 - 41/2, height / 2 - 13/2, CASE_HEIGHT_TOP]) cube([41, 13, 1.2]);
                // weight reduction
                translate([7, 3, CASE_HEIGHT_TOP]) {
                    difference() {
                        cube([width - 14, height - 6, 1.2]);
                        translate([(width - 14 - 50) / 2, (height - 6 - 20) / 2, 0]) cube([50, 20, 1.2]);
                    }
                }
            }
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
    difference() {
        translate(mic_pos) grid(WALL_THICKNESS_TOP + 1);
        // weight reduction
        translate([7, 3, CASE_HEIGHT_TOP]) {
            difference() {
                cube([width - 14, height - 6, 1.2]);
                translate([(width - 14 - 50) / 2, (height - 6 - 20) / 2, 0]) cube([50, 20, 1.2]);
            }
        }
    }
}

module bottom_shell() {
    width = BOARD_WIDTH + BOARD_OVERSIZE + WALL_THICKNESS_LEFT_RIGHT * 2 + BUTTON_ACTUATOR_LENGTH * 2 + BUTTON_BASE_THICKNESS * 2;
    height = BOARD_HEIGHT + BOARD_OVERSIZE + WALL_THICKNESS_FRONT_BACK * 2;
    difference() {
        // bottom shell
        cube([width, height, WALL_THICKNESS_BOTTOM + CASE_HEIGHT_BOTTOM]);
        translate([0, 0, WALL_THICKNESS_BOTTOM + CASE_HEIGHT_BOTTOM - 4]) {
            // screw holes (4mm deep)
            translate([1.25, 1.7, 0]) screw_thread();
            translate([1.25, height / 2, 0]) screw_thread();
            translate([1.25, height - 1.7, 0]) screw_thread();
            translate([width - 1.25, 1.7, 0]) rotate([0, 0, 180]) screw_thread();
            translate([width - 1.25, height / 2, 0]) rotate([0, 0, 180]) screw_thread();
            translate([width - 1.25, height - 1.7, 0]) rotate([0, 0, 180]) screw_thread();
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

module taper_bar() {
    cube([100, 100, 1], center=true);
}

module taper_shell() {
    width = BOARD_WIDTH + BOARD_OVERSIZE + WALL_THICKNESS_LEFT_RIGHT * 2 + BUTTON_ACTUATOR_LENGTH * 2 + BUTTON_BASE_THICKNESS * 2;
    height = BOARD_HEIGHT + BOARD_OVERSIZE + WALL_THICKNESS_FRONT_BACK * 2;
    depth = CASE_HEIGHT_TOP + 1 + WALL_THICKNESS_TOP + CASE_HEIGHT_BOTTOM + WALL_THICKNESS_BOTTOM;
    
    translate([width/2, 0, 0]) rotate([-45, 0, 0]) taper_bar();
    translate([width/2, height, 0]) rotate([45, 0, 0]) taper_bar();
    translate([0, height/2, 0]) rotate([0, 45, 0]) taper_bar();
    translate([width, height/2, 0]) rotate([0, -45, 0]) taper_bar();

    translate([0, 0, depth]) {
        translate([width/2, 0, 0]) rotate([45, 0, 0]) taper_bar();
        translate([width/2, height, 0]) rotate([-45, 0, 0]) taper_bar();
        translate([0, height/2, 0]) rotate([0, -45, 0]) taper_bar();
        translate([width, height/2, 0]) rotate([0, 45, 0]) taper_bar();

        translate([0, 0, 0]) translate([0.25, 0.25, -0.25]) rotate([45, 0, -45]) taper_bar();
        translate([0, height, 0]) translate([0.25, -0.25, -0.25]) rotate([-45, 0, 45]) taper_bar();
        translate([width, 0, 0]) translate([-0.25, 0.25, -0.25]) rotate([45, 0, 45]) taper_bar();
        translate([width, height, 0]) translate([-0.25, -0.25, -0.25]) rotate([-45, 0, -45]) taper_bar();
    }

    translate([0, 0, depth/2]) rotate([90, 0, -45]) taper_bar();
    translate([0, height, depth/2]) rotate([90, 0, 45]) taper_bar();
    translate([width, height, depth/2]) rotate([90, 0, -45]) taper_bar();
    translate([width, 0, depth/2]) rotate([90, 0, 45]) taper_bar();

    translate([0, 0, 0]) translate([0.25, 0.25, 0.25]) rotate([-45, 0, -45]) taper_bar();
    translate([0, height, 0]) translate([0.25, -0.25, 0.25]) rotate([45, 0, 45]) taper_bar();
    translate([width, 0, 0]) translate([-0.25, 0.25, 0.25]) rotate([-45, 0, 45]) taper_bar();
    translate([width, height, 0]) translate([-0.25, -0.25, 0.25]) rotate([45, 0, -45]) taper_bar();
}

module case(top ,bottom) {
    difference() {
        bottom_shell_height = WALL_THICKNESS_BOTTOM + CASE_HEIGHT_BOTTOM;
        union() {
            if (bottom) { color("green") bottom_shell(); }
            if (top) { translate([0, 0, bottom_shell_height]) color("red") top_cover(); }
        }
        translate([WALL_THICKNESS_LEFT_RIGHT, WALL_THICKNESS_FRONT_BACK, WALL_THICKNESS_BOTTOM]) board();
    }
}
/*
    translate([WALL_THICKNESS_LEFT_RIGHT, WALL_THICKNESS_FRONT_BACK, WALL_THICKNESS_TOP]) color("white") board();
*/

module button_real() {
    color("brown") {
        translate([4, 2.5, 0]) {
            translate([-4, -2.5, 0]) cube([8, 5, BUTTON_BASE_THICKNESS]);
            translate([-2.8, -1.3, BUTTON_BASE_THICKNESS]) cube([5.8 - 0.2, 3 - 0.4, WALL_THICKNESS_LEFT_RIGHT + BUTTON_ACTUATOR_LENGTH /*+ BOARD_OVERSIZE/2*/]);
        }
/*
        translate([0, -2.8, -1.3]) cube([2, 5.8 - 0.2, 3 - 0.4]);
        translate([2, -4, -2.5]) cube([BUTTON_BASE_THICKNESS, 8, 5]);
        */
    }
}
 
//scale([0.93, 0.95, 1]) rotate([0, 90, 0]) button_real();

translate([0, 0, -(CASE_HEIGHT_BOTTOM + WALL_THICKNESS_BOTTOM)]) difference() {
    case(true, true);
    taper_shell();
}

module button_row() {
    for (i = [0 : 4]) {
        translate([i * 10, 0, 0]) button_real();
        if (i < 4) {
            translate([i * 10 + 8, 2.5 - 0.36, 0]) cube([2, 0.7, 0.7]);
        }
    }
}

module buttons() {
    for (i = [0 : 4]) {
        translate([0, i * 7, 0]) button_row();

        if (i < 4) {
            for (j = [0 : 4]) {
                translate([j * 10 + 4 - 0.35, i * 7 + 5, 0]) cube([0.7, 2, 0.7]);
            }
        }
    }
}

//buttons();