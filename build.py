import os
import shutil
import zipfile
import time
from pathlib import Path

def build_extension():
    start_time = time.time()
    
    # Paths relative to this script (assumed to be at the project root)
    project_root = Path(__file__).parent.resolve()
    out_dir = project_root / "out"
    temp_dir = out_dir / "Theme_SirMotte_Hearth"
    output_ext_file = out_dir / "Theme_SirMotte_Hearth.ext"
    
    print("==================================================")
    print("Building Fantasy Grounds Hearth Theme Extension...")
    print(f"Project root: {project_root}")
    print(f"Output file:  {output_ext_file}")
    print("==================================================\n")
    
    # 1. Clean and recreate temp and output directories
    if temp_dir.exists():
        shutil.rmtree(temp_dir)
    if output_ext_file.exists():
        output_ext_file.unlink()
    
    # Create the out directory if missing
    out_dir.mkdir(parents=True, exist_ok=True)
    temp_dir.mkdir(parents=True, exist_ok=True)
    
    # 2. Define files and directories to copy
    # format: (source_path_relative_to_root, destination_subpath)
    assets_to_copy = [
        ("extension.xml", ""),
        ("SirMotte_footface.png", ""),
        ("common", "common"),
        ("graphics", "graphics"),
        ("rulesets", "rulesets"),
        ("scripts", "scripts")
    ]
    
    # 3. Copy assets to the temporary directory
    print("Copying assets...")
    for rel_src, rel_dest in assets_to_copy:
        src_path = project_root / rel_src
        dest_path = temp_dir / rel_dest
        
        if not src_path.exists():
            print(f"Warning: Source path does not exist: {src_path}")
            continue
            
        if src_path.is_file():
            shutil.copy2(src_path, dest_path)
        elif src_path.is_dir():
            shutil.copytree(src_path, dest_path, dirs_exist_ok=True)
            
    # 4. Create the ZIP/EXT archive using Python's native zipfile module
    print(f"\nCompressing into {output_ext_file.name} (Level 9)...")
    
    # Use ZIP_DEFLATED for standard compression.
    # Level 9 is the highest standard compression level.
    with zipfile.ZipFile(output_ext_file, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as zipf:
        # Walk through the temp dir and add files relative to it
        for root, dirs, files in os.walk(temp_dir):
            for file in files:
                file_path = Path(root) / file
                # Write file with a path relative to temp_dir (so they sit at the zip root)
                arcname = file_path.relative_to(temp_dir)
                zipf.write(file_path, arcname)
                
    # 5. Clean up temporary directory
    print("Cleaning up temporary build folder...")
    shutil.rmtree(temp_dir)
    
    elapsed_time = time.time() - start_time
    print(f"\nBuild successfully completed in {elapsed_time:.3f} seconds!")

if __name__ == "__main__":
    build_extension()
