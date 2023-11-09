with MicroBit.Types;
use MicroBit.Types;
with Ada.Real_Time; use Ada.Real_Time;

package pid_controller is

   -- varmesokker todo
   procedure PIDi (Target_Distance : Distance_cm; Actual_Distance : Distance_cm; Last_Time : Time);

   function GetPIDResult return Integer;

private
   PIDResult : Integer := 0;

end pid_controller;
