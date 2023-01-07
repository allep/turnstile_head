//------------------------------------------------
// 1 - Turnstile Antenna Reflector holders
//
// author: Alessandro Paganelli, Alberto Trentadue
// e-mail: alessandro.paganelli@gmail.com
// github: https://github.com/allep
// license: GPL-3.0-or-later
// 
// Description
// This is the reflector holding part
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
SCREW_DEPTH = 20.0;

// Antenna elements
// 4mm +8% tolerance
ANENNA_ELEMENT_EXTERNAL_RADIUS = 4.32;

ANTENNA_ELEMENT_HOLDER_LENGTH = 55.0;
ANTENNA_ELEMENT_HOLDER_THICKNESS = 15.0;
ANTENNA_ELEMENT_SIDE_DISPLACEMENT = 12.5;

// Cables holes
CABLE_HOLE_RADIUS = 7.0;

// Body
CYLINDER_RADIUS_INNER = 30.0;
CYLINDER_SIDE_THICKNESS = 10.0;
CYLINDER_INNER_HEIGHT = 13.0;
CYLINDER_BASE_THICKNESS = 3.0;

// Boom connector
BOOM_CONNECTOR_HEIGHT = 20.0;
BOOM_CONNECTOR_INNER_RADIUS = 12.50; 
BOOM_CONNECTOR_OUTER_RADIUS = 15.0;
BOOM_CONNECTOR_SCREW_HEIGHT = 20.0;

//------------------------------------------------
// Modules

module cylinder_body(inner_radius, side_thickness, inner_height, base_thickness) {
    HOLE_VIS_CRR = 1;
    outer_radius = inner_radius + side_thickness;
    outer_height = inner_height + base_thickness;
    difference() {
        cylinder(h = outer_height, r = outer_radius);
        translate([0, 0, base_thickness])
        cylinder(h = inner_height + HOLE_VIS_CRR, r = inner_radius);
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
    HOLE_VIS_CRR = 1;
    translate([displacement, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length + HOLE_VIS_CRR, r = hole_radius, center = true);
    
    rotate([0, 0, 90])
    translate([displacement, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length + HOLE_VIS_CRR, r = hole_radius, center = true);
    
    rotate([0, 0, 180])
    translate([displacement, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length + HOLE_VIS_CRR, r = hole_radius, center = true);

    rotate([0, 0, 270])
    translate([displacement, 0, height])
    rotate([0, 90, 0])
    cylinder(h = hole_length + HOLE_VIS_CRR, r = hole_radius, center = true);    
}

// To be subtracted from the assembly
module cable_holes(hole_radius, displacement, height) {
    HOLE_VIS_CRR = 1;
    rotate([0, 0, 45])
    translate([displacement, 0, height/2])
    cylinder(h = height + HOLE_VIS_CRR, r = hole_radius, center = true);
    
    rotate([0, 0, 135])
    translate([displacement, 0, height/2])
    cylinder(h = height + HOLE_VIS_CRR, r = hole_radius, center = true);

    rotate([0, 0, 225])
    translate([displacement, 0, height/2])
    cylinder(h = height + HOLE_VIS_CRR, r = hole_radius, center = true);

    rotate([0, 0, 315])
    translate([displacement, 0, height/2])
    cylinder(h = height + HOLE_VIS_CRR, r = hole_radius, center = true);
}

// To be subtracted from the assembly
module screw_holes(screw_radius, screw_depth, body_displacement, arm_displacement) {
    HOLE_VIS_CRR = 1;
    crr_screw_depth = screw_depth + HOLE_VIS_CRR;
    
    // arm screw holes
    rotate([0, 0, 0])
    translate([arm_displacement, 0, crr_screw_depth/2])
    cylinder(h = crr_screw_depth, r = screw_radius, center = true);

    rotate([0, 0, 90])
    translate([arm_displacement, 0, crr_screw_depth/2])
    cylinder(h = crr_screw_depth, r = screw_radius, center = true);

    rotate([0, 0, 180])
    translate([arm_displacement, 0, crr_screw_depth/2])
    cylinder(h = crr_screw_depth, r = screw_radius, center = true);

    rotate([0, 0, 270])
    translate([arm_displacement, 0, crr_screw_depth/2])
    cylinder(h = crr_screw_depth, r = screw_radius, center = true); 
    
}

module boom_connector(radius, height, screw_radius) {
    difference() {
        cylinder(h = height, r = radius, center = true);
        
        rotate([0, 90, 45])
        cylinder(h = 2*radius, r = screw_radius, center = true);
    }
}

// To be subtracted from the assembly
module boom_reinforcement_screw_hole(screw_radius, height) {
    cylinder(h = height, r = screw_radius, center = true);
}

// To be used to quickly print a prototype to be used for
// calibration purposes and tolerance investigations.
// Here we need to debug:
// 1. Boom connector radius
// 2. Screw holes
// 3. Antenna element hole
module debug_tolerances_boom_and_holes() {
    height = BOOM_CONNECTOR_HEIGHT/3;
    difference() {
        boom_connector(BOOM_CONNECTOR_INNER_RADIUS, height, SCREW_RADIUS);
        // the antenna element hole
        cylinder(h = height, r = ANENNA_ELEMENT_EXTERNAL_RADIUS, center = true);
    }
}

//------------------------------------------------
// Actual script

if (DEBUG_MODE == 0) {
    // release mode
    side_displacement = CYLINDER_RADIUS_INNER + CYLINDER_SIDE_THICKNESS/2 + ANTENNA_ELEMENT_SIDE_DISPLACEMENT;

    difference() {
        union() {
            translate([0, 0, BOOM_CONNECTOR_HEIGHT/2])
            boom_connector(BOOM_CONNECTOR_OUTER_RADIUS, BOOM_CONNECTOR_HEIGHT, SCREW_RADIUS);
            translate([0, 0, BOOM_CONNECTOR_HEIGHT])
            difference() {
                union() {
                    cylinder_body(CYLINDER_RADIUS_INNER, CYLINDER_SIDE_THICKNESS, CYLINDER_INNER_HEIGHT, CYLINDER_BASE_THICKNESS);
                    antenna_holders_bodies(ANTENNA_ELEMENT_HOLDER_LENGTH, ANTENNA_ELEMENT_HOLDER_THICKNESS, CYLINDER_INNER_HEIGHT + CYLINDER_BASE_THICKNESS, side_displacement);
                }
                antenna_elements_holes(ANTENNA_ELEMENT_HOLDER_LENGTH, ANENNA_ELEMENT_EXTERNAL_RADIUS, (CYLINDER_INNER_HEIGHT + CYLINDER_BASE_THICKNESS)*1/2, side_displacement);
                cable_holes(CABLE_HOLE_RADIUS, CYLINDER_RADIUS_INNER - CABLE_HOLE_RADIUS, CYLINDER_BASE_THICKNESS);
                translate([0, 0, CYLINDER_BASE_THICKNESS + CYLINDER_INNER_HEIGHT - SCREW_DEPTH])
                screw_holes(SCREW_RADIUS, SCREW_DEPTH, CYLINDER_RADIUS_INNER + CYLINDER_SIDE_THICKNESS/2, side_displacement);
            }
        }
        // boom reinforcement
        //translate([0, 0, BOOM_CONNECTOR_HEIGHT + CYLINDER_BASE_THICKNESS - SCREW_DEPTH/2]) 
        //boom_reinforcement_screw_hole(SCREW_RADIUS, SCREW_DEPTH);
        // boom hole
        translate([0,0,BOOM_CONNECTOR_HEIGHT/2])
    cylinder(h = BOOM_CONNECTOR_HEIGHT + 3 * CYLINDER_BASE_THICKNESS, r = BOOM_CONNECTOR_INNER_RADIUS, center = true);
    }

}
else {
    // debug mode
    debug_tolerances_boom_and_holes();
}
