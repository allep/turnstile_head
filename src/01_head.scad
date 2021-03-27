//------------------------------------------------
// 1 - Turnstile Antenna head - actual head part
//
// author: Alessandro Paganelli 
// e-mail: alessandro.paganelli@gmail.com
// github: https://github.com/allep
// license: GPL-3.0-or-later
// 
// Description
// This is the lower part of the antenna head.
//
// All sizes are expressed in mm.
//------------------------------------------------

// Set face number to a sufficiently high number.
$fn = 50;

//------------------------------------------------
// Debug mode
// Set DEBUG_MODE to 1 to simulate the actual 
// screw positions, to validate the design.
DEBUG_MODE = 0;

//------------------------------------------------
// Variables
ANENNA_ELEMENT_EXTERNAL_RADIUS = 4.05;

ANTENNA_ELEMENT_HOLDER_LENGTH = 30.0;
ANTENNA_ELEMENT_HOLDER_THICKNESS = 15.0;

CYLINDER_RADIUS_INNER = 30.0;
CYLINDER_SIDE_THICKNESS = 15.0;
CYLINDER_INNER_HEIGHT = 25.0;
CYLINDER_BASE_THICKNESS = 5.0;

//------------------------------------------------
// Modules

module cylinder_body(inner_radius, side_thickness, inner_height, base_thickness) {
    outer_radius = inner_radius + side_thickness;
    outer_height = inner_height + base_thickness;
    difference() {
        cylinder(h = outer_height, r = outer_radius);
        translate([0, 0, base_thickness])
        cylinder(h = inner_height, r = inner_radius);
    }
}

module single_antenna_holder_body(length, thickness, height) {
    translate([0, 0, height/2])
    cube(size = [length, thickness, height], center = true);
}

module antenna_holders_bodies(length, thickness, height, inner_radius, side_thickness) {
    translate([inner_radius + side_thickness/2, 0, 0])
    single_antenna_holder_body(length, thickness, height);
    
    rotate([0, 0, 90])
    translate([inner_radius + side_thickness/2, 0, 0])
    single_antenna_holder_body(length, thickness, height);
    
    rotate([0, 0, 180])
    translate([inner_radius + side_thickness/2, 0, 0])
    single_antenna_holder_body(length, thickness, height);
    
    rotate([0, 0, 270])
    translate([inner_radius + side_thickness/2, 0, 0])
    single_antenna_holder_body(length, thickness, height);
}

// To be subtracted from the assembly
module antenna_elements_holes(hole_length, hole_radius, height, inner_radius, side_thickness) {
    translate([inner_radius + side_thickness/2, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length, r = hole_radius, center = true);
    
    rotate([0, 0, 90])
    translate([inner_radius + side_thickness/2, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length, r = hole_radius, center = true);
    
    rotate([0, 0, 180])
    translate([inner_radius + side_thickness/2, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length, r = hole_radius, center = true);

    rotate([0, 0, 270])
    translate([inner_radius + side_thickness/2, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length, r = hole_radius, center = true);    
}

module cable_holes() {
    // TODO
}

module screw_holes() {
    // TODO
}

module boom_connector() {
    // TODO
}

//------------------------------------------------
// Actual script

difference() {
    union() {
        cylinder_body(CYLINDER_RADIUS_INNER, CYLINDER_SIDE_THICKNESS, CYLINDER_INNER_HEIGHT, CYLINDER_BASE_THICKNESS);
        antenna_holders_bodies(ANTENNA_ELEMENT_HOLDER_LENGTH, ANTENNA_ELEMENT_HOLDER_THICKNESS, CYLINDER_INNER_HEIGHT + CYLINDER_BASE_THICKNESS, CYLINDER_RADIUS_INNER, CYLINDER_SIDE_THICKNESS);
    }
    antenna_elements_holes(ANTENNA_ELEMENT_HOLDER_LENGTH, ANENNA_ELEMENT_EXTERNAL_RADIUS, (CYLINDER_INNER_HEIGHT + CYLINDER_BASE_THICKNESS)/2, CYLINDER_RADIUS_INNER, CYLINDER_SIDE_THICKNESS);
}

//-------------------------------------------------
// Commented out stuff


////------------------------------------------------
//// Pockets
//// Let's increase a little bit pocket sizs in order 
//// to allow for easier simulation.
//POCKET_TOLERANCE = 0.1;

////------------------------------------------------
//// Box
//
//// Inner sizes: outer size will be increased by
//// the wall thickness.
//Z_LEN = 21;
//
//WALL_THICKNESS = 1.2;
//BASE_THICKNESS = 1.2;
//
//CYLINDER_THICKNESS = 0.8;
//
//// For M3 screws it must be 1.5 mm + 5% tolerance
//CYLINDER_RADIUS = 1.575;
//
//// tolerances
//CYLINDER_GAP = 1.0;
//
////------------------------------------------------
//// Board size
//BOARD_THICKNESS = 2.0;
//BOARD_HEIGHT = 6.75; // including clearence
//
//// Based on NodeMCU Amica ESP-8266 board.
//SCREW_DISTANCE_Y = 43.6;
//SCREW_DISTANCE_X = 20.9;
//
//// Usb size
//// Note: to be quite sure that any USB cable can fit
//// here we create a hole quite large (height > 
//// BOARD_HEIGHT)
//// Adjust it based on your needs.
//Z_USB_PORT_HEIGHT = 7;
//X_USB_PORT_LEN = 11;
//
////------------------------------------------------
//// DHT22
//
//X_SENSOR_LEN = 15;
//Y_SENSOR_LEN = 20;
//X_SENSOR_GAP = 0.25;
//Y_SENSOR_GAP = 0.25;
//
//// Used to keep track of the pins that need some
//// clearance to allow cables to be connected.
//Y_SENSOR_DISPLACEMENT = 5;
//
//// Peg
//SENSOR_PEG_RADIUS = 1.25;
//Y_SENSOR_PEG_DISTANCE = 1.8;
//Z_SENSOR_PEG_HEIGHT = 3.0;
//Y_SENSOR_STEP_LEN = 3;
//Z_SENSOR_STEP_HEIGHT = 1.4;
//
////------------------------------------------------
//// Screw sizes (M3)
//
//SCREW_RADIUS = 1.5;
//Z_SCREW_LEN = 30; // used just for simulation
//Z_SCREW_HEAD_LEN = 4.0;

//------------------------------------------------
// Modules

//module corner(radius, height, thickness, gap, position, plane_rotation) {
//    ext_r = radius + thickness;
//    
//    translate(position)
//    rotate([0, 0, plane_rotation])
//    difference() {
//        union() {
//            cube([ext_r + gap, ext_r + gap, height]);
//            translate([0, - ext_r, 0])
//            cube([ext_r + gap, ext_r, height]);
//            translate([- ext_r, 0, 0])
//            cube([ext_r, ext_r + gap, height]);
//            cylinder(h = height, r = ext_r);
//        }
//        cylinder(h = height + POCKET_TOLERANCE, r = radius);
//    }
//}

//------------------------------------------------
// Actual script

// First compute sizes

//x_len_inner = SCREW_DISTANCE_X + 2*(CYLINDER_RADIUS + CYLINDER_THICKNESS + CYLINDER_GAP);
//y_len_inner = SCREW_DISTANCE_Y + 2*(CYLINDER_RADIUS + CYLINDER_THICKNESS + CYLINDER_GAP);
//x_len_outer = x_len_inner + 2*WALL_THICKNESS;
//y_len_outer = y_len_inner + 2*WALL_THICKNESS;
//
//echo("Computed X len = ", x_len_outer, " and Y len = ", y_len_outer);
//
//// actual box
//difference() {
//    // the box
//    difference() {
//        cube([x_len_outer, y_len_outer, Z_LEN + BASE_THICKNESS]);
//        translate([WALL_THICKNESS, WALL_THICKNESS, BASE_THICKNESS])
//        cube([x_len_inner, y_len_inner, Z_LEN + POCKET_TOLERANCE]);
//    }
//    // the sensor hole
//    translate([x_len_outer/2 - X_SENSOR_LEN/2 - X_SENSOR_GAP, y_len_outer/2 - Y_SENSOR_LEN/2 - Y_SENSOR_GAP + Y_SENSOR_DISPLACEMENT, -POCKET_TOLERANCE])
//    cube([X_SENSOR_LEN + 2*X_SENSOR_GAP, Y_SENSOR_LEN + 2*Y_SENSOR_GAP, BASE_THICKNESS + 2*POCKET_TOLERANCE]);
//    // the usb port hole
//    translate([x_len_outer/2 - X_USB_PORT_LEN/2, -POCKET_TOLERANCE, Z_LEN + BASE_THICKNESS - Z_USB_PORT_HEIGHT])
//    cube([X_USB_PORT_LEN, WALL_THICKNESS + 2*POCKET_TOLERANCE, Z_USB_PORT_HEIGHT + POCKET_TOLERANCE]);
//}
//
//// screw holes
//shift_x1 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + WALL_THICKNESS;
//shift_y1 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + WALL_THICKNESS;
//corner(CYLINDER_RADIUS, Z_LEN-BOARD_HEIGHT, CYLINDER_THICKNESS, CYLINDER_GAP, [shift_x1, shift_y1, BASE_THICKNESS], 180);
//
//shift_x2 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + WALL_THICKNESS;
//shift_y2 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_Y + WALL_THICKNESS;
//corner(CYLINDER_RADIUS, Z_LEN-BOARD_HEIGHT, CYLINDER_THICKNESS, CYLINDER_GAP, [shift_x2, shift_y2, BASE_THICKNESS], 90);
//
//shift_x3 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_X + WALL_THICKNESS;
//shift_y3 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + WALL_THICKNESS;
//corner(CYLINDER_RADIUS, Z_LEN-BOARD_HEIGHT, CYLINDER_THICKNESS, CYLINDER_GAP, [shift_x3, shift_y3, BASE_THICKNESS], 270);
//
//shift_x4 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_X + WALL_THICKNESS;
//shift_y4 = CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_Y + WALL_THICKNESS;
//corner(CYLINDER_RADIUS, Z_LEN-BOARD_HEIGHT, CYLINDER_THICKNESS, CYLINDER_GAP, [shift_x4, shift_y4, BASE_THICKNESS], 0);
//
//// sensor peg and step
//translate([x_len_outer/2, y_len_outer/2 + Y_SENSOR_LEN/2 + Y_SENSOR_GAP + Y_SENSOR_DISPLACEMENT + Y_SENSOR_PEG_DISTANCE, BASE_THICKNESS])
//cylinder(h = Z_SENSOR_PEG_HEIGHT, r = SENSOR_PEG_RADIUS);
//translate([x_len_outer/2 - X_SENSOR_LEN/2 - X_SENSOR_GAP, y_len_outer/2 + Y_SENSOR_LEN/2 + Y_SENSOR_GAP + Y_SENSOR_DISPLACEMENT, BASE_THICKNESS])
//cube([X_SENSOR_LEN + 2*X_SENSOR_GAP, Y_SENSOR_STEP_LEN, Z_SENSOR_STEP_HEIGHT]);
//
////------------------------------------------------
//// Size check
//// Draw a simulated version of 4 screws in the right 
//// positions, in order to validate the design.
//
//if (DEBUG_MODE == 1) {
//    screw1_x = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS;
//    screw1_y = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS;
//    color("red", 0.5)
//    translate([screw1_x, screw1_y, 0])
//    cylinder(h = Z_SCREW_LEN, r = SCREW_RADIUS);
//
//    screw2_x = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS;
//    screw2_y = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_Y;
//    color("red", 0.5)
//    translate([screw2_x, screw2_y, 0])
//    cylinder(h = Z_SCREW_LEN, r = SCREW_RADIUS);
//
//    screw3_x = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_X;
//    screw3_y = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS;
//    color("red", 0.5)
//    translate([screw3_x, screw3_y, 0])
//    cylinder(h = Z_SCREW_LEN, r = SCREW_RADIUS);
//
//    screw4_x = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_X;
//    screw4_y = WALL_THICKNESS + CYLINDER_GAP + CYLINDER_THICKNESS + CYLINDER_RADIUS + SCREW_DISTANCE_Y;
//    color("red", 0.5)
//    translate([screw4_x, screw4_y, 0])
//    cylinder(h = Z_SCREW_LEN, r = SCREW_RADIUS);
//}
