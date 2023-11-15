with MicroBit.Types; use MicroBit.Types;
with Ada.Real_Time; use Ada.Real_Time;
with Fnatt_Distance; use Fnatt_Distance;
with HAL; use HAL;

package pid_controller is

   -- varmesokker todo
   procedure PIDi (Target_Distance : DistanceCentimeter; Actual_Distance : DistanceCentimeter);

   procedure Flush;

   function GetPIDResult return UInt12;

private
   PIDResult : Float := 0.0;


end pid_controller;
