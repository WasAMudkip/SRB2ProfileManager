import os

def list_files(target_dir):
    print(f"\n--- Listing all mod files ---")
    
    for root, dirs, files in os.walk(target_dir):
        for file in files:
            if file.endswith((".soc", ".wad", ".pk3", ".lua")):
                path = os.path.join(root, file)
                print(path)
                
    print("--- End of list ---\n")
