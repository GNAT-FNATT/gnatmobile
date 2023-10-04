with FnattController; use FnattController;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;

package Sense_Task_Pkg is

   task sense with Priority => 1;

end Sense_Task_Pkg;
