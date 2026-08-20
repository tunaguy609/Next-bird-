//
// Next-bird parametric body (OpenSCAD)
// Units: mm
//

$fn = 64;

// =========================
// Parameters (edit these)
// =========================
thickness = 24;          // overall body thickness (Z)

left_wing_len  = 71;     // from body shoulder to left tip
right_wing_len = 71;     // from body shoulder to right tip

body_left_x  = -35;      // shoulder x (left side)
body_right_x =  35;      // shoulder x (right side)

nose_len = 40;           // front center protrusion (from shoulder line to tip)
rear_notch_depth = 10;   // rear inner notch depth

// fin
fin_thickness = 8;
fin_height    = 68;      // above body top
fin_length    = 160;     // along X direction
fin_round_r   = 22;      // roundness of fin top

// hole / eyelet pilot holes (optional)
make_holes = true;
eyelet_hole_d = 4.5;
left_eyelet_pos  = [-62, -6, thickness/2];
right_eyelet_pos = [ 62, -6, thickness/2];

// =========================
// 2D planform
// =========================
//
// Y+ = "back", Y- = "front" (nose side)
//
module body_2d() {
    polygon(points=[
        // left wing tip (rear and front edges)
        [body_left_x - left_wing_len,  12],
        [body_left_x,                 12],

        // transition to center/rear
        [body_left_x + 8,             28],
        [body_right_x - 8,            28],

        // right rear shoulder and wing
        [body_right_x,                12],
        [body_right_x + right_wing_len, 12],
        [body_right_x + right_wing_len, -12],
        [body_right_x,               -12],

        // slope toward nose
        [16,                         -12],
        [0,                          -(12 + nose_len)],
        [-16,                        -12],

        // back to left side
        [body_left_x,                -12],
        [body_left_x - left_wing_len, -12]
    ]);
}

// =========================
// Fin profile (2D in XZ, then extruded in Y)
// =========================
module fin_profile_2d() {
    // Rounded "sail" style fin
    hull() {
        translate([-fin_length/2 + fin_round_r, 0]) circle(r=fin_round_r);
        translate([ fin_length/2 - fin_round_r, 0]) circle(r=fin_round_r);
        translate([0, fin_height]) circle(r=fin_round_r);
    }
}

// =========================
// Main model
// =========================
module next_bird() {
    difference() {
        union() {
            // Base body
            linear_extrude(height=thickness)
                body_2d();

            // Center fin (mounted on top centerline)
            translate([0, 0, thickness])
            rotate([90,0,0])  // extrude through Y
            linear_extrude(height=fin_thickness, center=true)
                fin_profile_2d();
        }

        // Optional eyelet pilot holes
        if (make_holes) {
            translate(left_eyelet_pos)
                rotate([90,0,0]) cylinder(d=eyelet_hole_d, h=40, center=true);

            translate(right_eyelet_pos)
                rotate([90,0,0]) cylinder(d=eyelet_hole_d, h=40, center=true);
        }
    }
}

next_bird();
