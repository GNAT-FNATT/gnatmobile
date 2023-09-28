# gnatmobile

## Setup
```bash
git clone git@github.com:GNAT-FNATT/gnatmobile.git --recurse-submodules
```

Open the `gnatmobile` file using GNAT Studio.

Zero footprint profile (ZFP)
```
with "Ada_Drivers_Library\boards\MicroBit_v2\microbit_v2_zfp.gpr";

project Gnatmobile is

   for Source_Dirs use ("src");
   for Object_Dir use "obj";
   for Main use ("main.adb");
   for Target use "arm-eabi";
   for Runtime ("ada") use "zfp-cortex-m4f";

   package Ide is
      for Connection_Tool use "pyocd";
   end Ide;

   package Linker is
      for Switches ("ada") use ("-T", "Ada_Drivers_Library/boards/MicroBit_v2/src/zfp/link.ld");
   end Linker;

end Gnatmobile;
```