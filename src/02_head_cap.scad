//------------------------------------------------
// 2 - Turnstile Antenna head - Cap
//
// author: Alessandro Paganelli, Alberto Trentadue 
// e-mail: alessandro.paganelli@gmail.com
// github: https://github.com/allep
// license: GPL-3.0-or-later
// 
// Description
// This is overhead cap to protect electrical connections
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
SCREW_DEPTH = 12.0;

// Body
CYLINDER_RADIUS_INNER = 30.0;
CYLINDER_SIDE_MAX_THICKNESS = 10.0;
CYLINDER_SIDE_MIN_THICKNESS = 3.0;
CYLINDER_INNER_HEIGHT = 8.0;
CYLINDER_BASE_THICKNESS = 3.0;

// Taken from 01_head.scad
ANTENNA_ELEMENT_SIDE_DISPLACEMENT = 12.5;


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


// To be subtracted from the assembly
module screw_holes(screw_radius, screw_depth, body_displacement) {
    // main body screw holes
    HOLE_VIS_CRR = 1;
    crr_screw_depth = screw_depth + HOLE_VIS_CRR;
    
    rotate([0, 0, 45])
    translate([body_displacement, 0, crr_screw_depth/2])
    cylinder(h = crr_screw_depth, r = screw_radius, center = true);
    
    rotate([0, 0, 135])
    translate([body_displacement, 0, crr_screw_depth/2])
    cylinder(h = crr_screw_depth, r = screw_radius, center = true);
    
    rotate([0, 0, 225])
    translate([body_displacement, 0, crr_screw_depth/2])
    cylinder(h = crr_screw_depth, r = screw_radius, center = true);
    
    rotate([0, 0, 315])
    translate([body_displacement, 0, crr_screw_depth/2])
    cylinder(h = crr_screw_depth, r = screw_radius, center = true);
    
}

// Single side reduction
module side_redux(redux_angle, rot_angle) {
    
    VIS_CRR = 1; //Visualization correction

    XP = CYLINDER_SIDE_MAX_THICKNESS-CYLINDER_SIDE_MIN_THICKNESS+VIS_CRR;
    YP = CYLINDER_INNER_HEIGHT+CYLINDER_BASE_THICKNESS+VIS_CRR;
    P1 = [XP,YP];
    P2 = [XP,0];
    P3 = [0,YP];
    
    translate([0,0,-VIS_CRR/2])
    rotate([0,0,rot_angle])
    rotate_extrude(convexity = 10, angle=redux_angle)
    translate([CYLINDER_RADIUS_INNER+CYLINDER_SIDE_MIN_THICKNESS, 0, 0])
    polygon(points=[P1,P2,[0,0],P3]);
}

// All side reductions to be subtracted from assembly
module all_sides_redux() {
    
    REDUX_ANGLE = 75;
    START_ANGLE = 90-REDUX_ANGLE/2;
    side_redux(REDUX_ANGLE, START_ANGLE);
    side_redux(REDUX_ANGLE, START_ANGLE + 90);
    side_redux(REDUX_ANGLE, START_ANGLE + 180);
    side_redux(REDUX_ANGLE, START_ANGLE + 270);
}

//------------------------------------------------
// Actual script

if (DEBUG_MODE == 0) {
    // release mode
    difference() {

        cylinder_body(CYLINDER_RADIUS_INNER, CYLINDER_SIDE_MAX_THICKNESS, CYLINDER_INNER_HEIGHT, CYLINDER_BASE_THICKNESS);

        translate([0, 0, CYLINDER_BASE_THICKNESS + CYLINDER_INNER_HEIGHT - SCREW_DEPTH])
        screw_holes(SCREW_RADIUS, SCREW_DEPTH, CYLINDER_RADIUS_INNER + CYLINDER_SIDE_MAX_THICKNESS/2);
        all_sides_redux();
    }
}
else {
    // debug mode
    // IF NEEDED
    all_side_redux();
}
