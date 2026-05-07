import listmode
import os

while True:
    srb2dir = input("Enter your SRB2 directory path: ")
    
    exe_path = os.path.join(srb2dir, "srb2win.exe")
    
    if os.path.exists(exe_path):
        print("Valid SRB2 directory found\n")
        break
    else:
        print("'srb2win.exe' not found in that folder. Please try again.")

print("""
=========================
=  NotAMudkip's         =
=      SONIC  ROBO      =
=        BLAST 2        =
=      Mod Profile      =
=        Manager v0.6.0 =
=========================

Modes:
0 - exit
1 - list mode
2 - create shortcut from addons
""")

while True:
    mode = int(input("Select a mode: "))
    if mode == 0:
        exit()
    elif mode not in [1, 2]:
        print("Not a valid mode.")
    else:
        break

print(mode)

if mode == 1:
    listmode.list_files(srb2dir)
elif mode == 2:
    print("Mode 2 not yet implemented.")
