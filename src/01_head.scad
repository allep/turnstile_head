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

// Screws
// M3 screws - 1.5 + 5% tolerance
SCREW_RADIUS = 1.575;

// Antenna elements
// 4mm +5% tolerance
ANENNA_ELEMENT_EXTERNAL_RADIUS = 4.2;

ANTENNA_ELEMENT_HOLDER_LENGTH = 55.0;
ANTENNA_ELEMENT_HOLDER_THICKNESS = 15.0;
ANTENNA_ELEMENT_SIDE_DISPLACEMENT = 12.5;

// Cables holes
CABLE_HOLE_RADIUS = 7.0;

// Body
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

module antenna_holders_bodies(length, thickness, height, displacement) {
    translate([displacement, 0, 0])
    single_antenna_holder_body(length, thickness, height);
    
    rotate([0, 0, 90])
    translate([displacement, 0, 0])
    single_antenna_holder_body(length, thickness, height);
    
    rotate([0, 0, 180])
    translate([displacement, 0, 0])
    single_antenna_holder_body(length, thickness, height);
    
    rotate([0, 0, 270])
    translate([displacement, 0, 0])
    single_antenna_holder_body(length, thickness, height);
}

// To be subtracted from the assembly
module antenna_elements_holes(hole_length, hole_radius, height, displacement) {
    translate([displacement, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length, r = hole_radius, center = true);
    
    rotate([0, 0, 90])
    translate([displacement, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length, r = hole_radius, center = true);
    
    rotate([0, 0, 180])
    translate([displacement, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length, r = hole_radius, center = true);

    rotate([0, 0, 270])
    translate([displacement, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length, r = hole_radius, center = true);    
}

// To be subtracted from the assembly
module cable_holes(hole_radius, displacement, height) {
    rotate([0, 0, 45])
    translate([displacement, 0, height/2])
    cylinder(h = height, r = hole_radius, center = true);
    
    rotate([0, 0, 135])
    translate([displacement, 0, height/2])
    cylinder(h = height, r = hole_radius, center = true);

    rotate([0, 0, 225])
    translate([displacement, 0, height/2])
    cylinder(h = height, r = hole_radius, center = true);

    rotate([0, 0, 315])
    translate([displacement, 0, height/2])
    cylinder(h = height, r = hole_radius, center = true);
}

// To be subtracted from the assembly
module screw_holes() {
    // TODO
}

// To be subtracted from the assembly
module boom_connector() {
    // TODO
}

// To be used to quickly print a prototype to be used for
// calibration purposes and tolerance investigations.
module debug_tolerances_boom_and_holes() {
    // TODO
}

//------------------------------------------------
// Actual script

side_displacement = CYLINDER_RADIUS_INNER + CYLINDER_SIDE_THICKNESS/2 + ANTENNA_ELEMENT_SIDE_DISPLACEMENT;

if (DEBUG_MODE == 0) {
    difference() {
        union() {
            cylinder_body(CYLINDER_RADIUS_INNER, CYLINDER_SIDE_THICKNESS, CYLINDER_INNER_HEIGHT, CYLINDER_BASE_THICKNESS);
            antenna_holders_bodies(ANTENNA_ELEMENT_HOLDER_LENGTH, ANTENNA_ELEMENT_HOLDER_THICKNESS, CYLINDER_INNER_HEIGHT + CYLINDER_BASE_THICKNESS, side_displacement);
        }
        antenna_elements_holes(ANTENNA_ELEMENT_HOLDER_LENGTH, ANENNA_ELEMENT_EXTERNAL_RADIUS, (CYLINDER_INNER_HEIGHT + CYLINDER_BASE_THICKNESS)/2, side_displacement);
        cable_holes(CABLE_HOLE_RADIUS, CYLINDER_RADIUS_INNER - CABLE_HOLE_RADIUS, CYLINDER_BASE_THICKNESS);
    }
}
else {
    cable_holes(CABLE_HOLE_RADIUS, CYLINDER_RADIUS_INNER - CABLE_HOLE_RADIUS, CYLINDER_BASE_THICKNESS);
}
