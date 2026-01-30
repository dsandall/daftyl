// Polygonal Case Generator for OpenSCAD
// Creates a D20-like polygonal case with custom STL geometries
// Each face can be different using imported STL files

// ===============================================
// CONFIGURATION VARIABLES
// ===============================================

// STL file paths - replace with your actual STL files
STL_BASE_PATH = "./stls/";  // Directory containing your STL files
MAIN_STL_FILE = "cosmotyl-caseleft.stl";  // Your primary STL file

// Polygonal case parameters
NUM_FACES = 20;  // Total number of faces (like a D20)
CASE_RADIUS = 50;  // Overall radius of the polygonal case
FACE_SCALE = 1.0;  // Scale factor for imported STLs

// Positioning parameters
STL_HEIGHT = 10;  // Height of your STL after import
UPRIGHT_OFFSET = CASE_RADIUS - STL_HEIGHT/2;  // Distance from center

// Visualization settings
SHOW_ALL_FACES = true;  // Set to false to show only one face for testing
DEBUG_MODE = false;  // Shows guide geometry when true

// ===============================================
// CORE MODULES
// ===============================================

// Module to import and position an STL file
module positioned_stl(stl_filename, rotation = [0, 0, 0], position = [0, 0, 0]) {
    translate(position)
    rotate(rotation)
    scale([FACE_SCALE, FACE_SCALE, FACE_SCALE])
    import(str(STL_BASE_PATH, stl_filename), convexity = 10);
}

// Module to create a single face of the polygonal case
module case_face(face_index, total_faces) {
    // Calculate angles for spherical positioning
    angle_step = 360 / total_faces;
    
    // Golden ratio for better distribution (D20-like)
    golden_angle = 137.508;  // degrees
    
    // Position on sphere surface
    theta = face_index * golden_angle;
    phi = acos(1 - 2 * (face_index + 0.5) / total_faces);
    
    // Convert spherical to Cartesian coordinates
    x = CASE_RADIUS * sin(phi) * cos(theta);
    y = CASE_RADIUS * sin(phi) * sin(theta);
    z = CASE_RADIUS * cos(phi);
    
    // Position and orient the STL to face outward
    translate([x, y, z])
    rotate([0, 0, theta])  // Rotate around local Z axis
    rotate([phi, 0, 0])     // Tilt outward from center
    positioned_stl(MAIN_STL_FILE);
}

// Module to create symmetrical pairs using mirror
module mirrored_pair(base_face_index, mirror_axis) {
    case_face(base_face_index, NUM_FACES);
    mirror(mirror_axis)
    case_face(base_face_index, NUM_FACES);
}

// ===============================================
// MAIN ASSEMBLY
// ===============================================

module polygonal_case() {
    if (DEBUG_MODE) {
        // Show reference sphere
        %sphere(r = CASE_RADIUS, $fn = 32);
        
        // Show coordinate axes
        color("red") cylinder(h = CASE_RADIUS * 2, r = 0.5, center = true);
        rotate([0, 90, 0]) color("green") cylinder(h = CASE_RADIUS * 2, r = 0.5, center = true);
        rotate([90, 0, 0]) color("blue") cylinder(h = CASE_RADIUS * 2, r = 0.5, center = true);
    }
    
    if (SHOW_ALL_FACES) {
        // Generate all faces using different strategies for symmetry
        for (i = [0:NUM_FACES-1]) {
            case_face(i, NUM_FACES);
        }
    } else {
        // Show only one face for testing
        case_face(0, NUM_FACES);
    }
}

// ===============================================
// EXAMPLE SYMMETRY PATTERNS
// ===============================================

// Example: Create 4-fold symmetry using mirror
module fourfold_symmetry_example() {
    mirrored_pair(0, [1, 0, 0]);  // Mirror across X axis
    mirror([0, 1, 0]) {  // Mirror across Y axis
        mirrored_pair(0, [1, 0, 0]);
    }
}

// Example: Create D20-like icosahedron pattern
module icosahedral_pattern() {
    // Top and bottom poles
    translate([0, 0, CASE_RADIUS]) rotate([90, 0, 0]) positioned_stl(MAIN_STL_FILE);
    translate([0, 0, -CASE_RADIUS]) rotate([-90, 0, 0]) positioned_stl(MAIN_STL_FILE);
    
    // Middle ring with 10 faces each
    for (i = [0:9]) {
        // Upper ring
        rotate([0, 0, i * 36]) 
        translate([CASE_RADIUS * 0.618, 0, CASE_RADIUS * 0.786])
        rotate([26.565, 0, 0])
        positioned_stl(MAIN_STL_FILE);
        
        // Lower ring  
        rotate([0, 0, i * 36 + 18])
        translate([CASE_RADIUS * 0.618, 0, -CASE_RADIUS * 0.786])
        rotate([-26.565, 0, 0])
        positioned_stl(MAIN_STL_FILE);
    }
}

// ===============================================
// RENDERING
// ===============================================

// Uncomment the pattern you want to use:
polygonal_case();
// fourfold_symmetry_example();
// icosahedral_pattern();

// Add comment with usage instructions
/*
USAGE INSTRUCTIONS:

1. Place your STL files in the "./stls/" directory (or update STL_BASE_PATH)
2. Update MAIN_STL_FILE to point to your primary STL file
3. Adjust NUM_FACES and CASE_RADIUS as needed
4. Press F5 for preview, F6 for render
5. Export as STL when ready

TIPS:
- Set DEBUG_MODE = true to see reference geometry
- Set SHOW_ALL_FACES = false to test single face positioning
- Use the fourfold_symmetry_example() for simpler symmetrical designs
- Use icosahedral_pattern() for true D20-like arrangements
*/
