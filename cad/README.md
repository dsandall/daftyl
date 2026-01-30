# Polygonal Case Generator

An OpenSCAD project for creating D20-like polygonal cases with custom STL geometries. Each face can use different STL files and the system uses mirror transformations for symmetrical arrangements.

## Quick Start

1. **Place your STL files** in the `stls/` directory
2. **Open `polygonal_case.scad`** in OpenSCAD
3. **Update configuration** at the top of the file:
   - Set `MAIN_STL_FILE` to your STL filename
   - Adjust `CASE_RADIUS` for overall size
   - Set `NUM_FACES` for the number of faces needed
4. **Press F5** for preview, **F6** to render
5. **Export** as STL when ready

## Key Features

### Configuration Variables
```openscad
STL_BASE_PATH = "./stls/";     // Directory with your STLs
MAIN_STL_FILE = "part1.stl";    // Your primary STL file
NUM_FACES = 20;                 // Total faces (like a D20)
CASE_RADIUS = 50;               // Overall case radius
FACE_SCALE = 1.0;              // Scale factor for STLs
```

### Symmetry Patterns

1. **Spherical Distribution** (`polygonal_case()`)
   - Uses golden ratio spacing for even distribution
   - Automatically orients each face to point outward

2. **Four-fold Symmetry** (`fourfold_symmetry_example()`)
   - Creates symmetrical pairs using `mirror()`
   - Perfect for simpler 4-sided designs

3. **Icosahedral Pattern** (`icosahedral_pattern()`)
   - True D20 arrangement with 20 faces
   - Top/bottom poles + two rings of 10 faces each

### Mirror Transformation Usage

The project uses OpenSCAD's `mirror()` function extensively:

```openscad
mirror([1,0,0])  // Mirror across X-axis plane
mirror([0,1,0])  // Mirror across Y-axis plane  
mirror([0,0,1])  // Mirror across Z-axis plane
mirror([1,1,0])  // Mirror across diagonal plane
```

## Testing and Debugging

### Debug Mode
Set `DEBUG_MODE = true` to see:
- Reference sphere showing case boundaries
- Coordinate axes for orientation
- Helper geometry for positioning

### Single Face Testing
Set `SHOW_ALL_FACES = false` to render only one face for testing positioning and orientation.

## Advanced Usage

### Multiple STL Files
To use different STLs for different faces, modify the `case_face` module:

```openscad
module case_face(face_index, total_faces) {
    // ... positioning code ...
    
    // Use different STLs based on face index
    stl_file = face_index == 0 ? "part1.stl" : 
               face_index == 1 ? "part2.stl" : 
               "default.stl";
               
    positioned_stl(stl_file);
}
```

### Custom Face Orientations
Override automatic orientation by modifying the rotation in `positioned_stl()` calls:

```openscad
positioned_stl(MAIN_STL_FILE, 
    rotation = [custom_x, custom_y, custom_z],
    position = [x, y, z]
);
```

## File Structure

```
.
├── polygonal_case.scad    # Main project file
├── stls/                   # Directory for your STL files
│   ├── part1.stl          # Your primary STL
│   └── part2.stl          # Additional STLs (optional)
└── README.md              # This file
```

## Common Issues

1. **STL not found**: Ensure files are in `stls/` directory and `STL_BASE_PATH` is correct
2. **Incorrect positioning**: Enable `DEBUG_MODE` to see reference geometry
3. **Overlapping faces**: Adjust `CASE_RADIUS` or `FACE_SCALE` values
4. **Export errors**: Ensure model is rendered (F6) before exporting

## Tips for FreeCAD Users

- OpenSCAD is **programmatic**, not interactive like FreeCAD
- Think in terms of **transformations** and **modular components**
- Use the **preview (F5)** frequently while developing
- The **mirror()** function is your friend for symmetry
- **Modules** are like FreeCAD's PartDesign features - reusable building blocks

## Getting Help

- OpenSCAD Documentation: https://openscad.org/documentation.html
- OpenSCAD Cheat Sheet: https://openscad.org/cheatsheet/
- Community Forums: https://forum.openscad.org/