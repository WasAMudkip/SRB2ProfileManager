import os

def list_files():
    print("\n--- Listing all mod files --- ---")
    
    for root, dirs, files in os.walk("."):
        for file in files:
            if file.endswith((".soc", ".wad", ".pk3", ".lua")):
                path = os.path.join(root, file)
                print(path)
                
    print("--- End of list ---\n")