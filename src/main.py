print("""
=========================
=  NotAMudkip's         =
=      SONIC  ROBO      =
=        BLAST 2        =
=      Mod Profile      =
=        Manager v1.0.0 =
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