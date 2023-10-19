with FnattController; use FnattController;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Types; use MicroBit.Types;
with MicroBit.Console; use MicroBit.Console;
with MicroBit.Ultrasonic; -- generic package


package Sense_Task_Pkg is

   package forwardSensor is new MicroBit.Ultrasonic(MicroBit.MB_P0, MicroBit.MB_P1);
   package rightSensor is new MicroBit.Ultrasonic(MicroBit.MB_P8, MicroBit.MB_P2);
   package leftSensor is new MicroBit.Ultrasonic(MicroBit.MB_P13, MicroBit.MB_P12);
   task sense with Priority => 2;

end Sense_Task_Pkg;
