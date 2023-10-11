with FnattController; use FnattController;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Console; use MicroBit.Console;


package Act_Task_Pkg is

   task act with Priority => 1;
   
end Act_Task_Pkg;
