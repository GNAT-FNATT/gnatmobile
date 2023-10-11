with FnattController; use FnattController;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Types; use MicroBit.Types;
with MicroBit.Ultrasonic; -- generic package
-- with Main;
with MicroBit.Console; use MicroBit.Console;


package Sense_Task_Pkg is

   package forwardSensor is new MicroBit.Ultrasonic(MicroBit.MB_P1, MicroBit.MB_P0);
   package rightSensor is new MicroBit.Ultrasonic(MicroBit.MB_P12, MicroBit.MB_P8);
   task sense with Priority => 3;

end Sense_Task_Pkg;
