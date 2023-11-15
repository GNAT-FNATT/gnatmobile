with MicroBit.Types;
use MicroBit.Types;
with Ada.Real_Time; use Ada.Real_Time;

package pid_controller is

   -- varmesokker todo
   procedure PIDi (Target_Distance : Distance_cm; Actual_Distance : Distance_cm);

   procedure Flush;

   function GetPIDResult return Float;

private
   PIDResult : Float := 0.0;


end pid_controller;
