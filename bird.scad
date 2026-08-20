//
// Next-bird top view only (flat top)
// Units: mm
//

$fn = 64;

// --- Given sketch lengths ---
top_flat = 10;
left_diag = 89;
right_diag = 68;
right_drop = 25;
left_top_run = 71;
right_top_run = 71;
right_bottom_run = 90;
long_diag = 140;
bottom_flat = 24;
left_vertical = 134;

// Tune these 3 angles to match your sketch visually (lengths stay exact)
a_left_diag  = 228;  // from left top shelf toward top
a_right_diag = 312;  // from top toward right shoulder
a_long_diag  = 242;  // from right bottom shelf toward bottom center-left

function step(p, len, ang) = [p[0] + len*cos(ang), p[1] + len*sin(ang)];

// Build from top edge
A = [0, 0];                 // top-left
B = [top_flat, 0];          // top-right (flat top = 10mm)

// Right side chain
C = step(B, right_diag, a_right_diag);   // 68
D = [C[0], C[1] - right_drop];           // 25 drop
E = [D[0] + right_top_run, D[1]];        // 71 right
F = [E[0] - right_bottom_run, E[1] - 70];// move down a bit then 90 shelf start (visual layout)
G = [F[0] + right_bottom_run, F[1]];     // 90 right shelf
H = step(F, long_diag, a_long_diag);     // 140 down-left
I = [H[0] - bottom_flat, H[1]];          // 24 bottom flat
J = [I[0], I[1] + left_vertical];        // 134 up
K = [J[0] - left_top_run, J[1]];         // 71 left
L = step(K, left_diag, a_left_diag);     // 89 back toward top

module top_profile() {
    polygon(points=[A,B,C,D,E,G,H,I,J,K,L]);
}

color("deepskyblue") top_profile();
