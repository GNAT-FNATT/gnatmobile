with FnattController; use FnattController;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Types; use MicroBit.Types;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Console; use MicroBit.Console;

package Think_Task_Pkg is

   task think with Priority => 1;

end Think_Task_Pkg;
