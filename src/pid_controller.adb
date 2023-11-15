with MicroBit.Types; use MicroBit.Types;
with Ada.Real_Time; use Ada.Real_Time;
with HAL; use HAL;
with MicroBit.Console; use MicroBit.Console;
with Ada.Unchecked_Conversion;

package body pid_controller is

   --subtype LLI is Long_Long_Integer;

   --function To_LLI is
     --new Ada.Unchecked_Conversion (Time_Span, LLI);

   --function To_Integer is
     --new Ada.Unchecked_Conversion (LLI, Integer);

   -- varmesokker todo
   LastPIDTime : Time := Clock;

   -- The integral component has to be declared here so that it doesnt reset each cycle
   Integral : Float := 0.0;

   -- Previous error has to be declared here so that it doesnt reset each cycle
   PreviousError : Float := 0.0;



   procedure PIDi (Target_Distance : in Distance_cm; Actual_Distance : in Distance_cm) is


      -- The target distance we want to achieve
      TargetDistance : Distance_cm;

      -- Current Distance
      CurrentDistance : Distance_cm;

      -- The error between actual distance and target
      ErrorDistance : Distance_cm := 0;
      temp_ErrorDistance : Float;

      -- The coefficients
      Kp : Float := 10.0;
      Ki : Float := 10.0;

        -- The proportional component
      Proportional : Float := 0.0;

      -- Time scope of PID cycles

      dt : Duration;
      temp_dt : float;
      NowTime : Time ;

      -- The output from the PID Controller
      PIDOut : Float := 0.0;


   begin
      --Put_Line("Start PID");

      delay 0.1;
      NowTime := Clock;

      dt := To_Duration(NowTime - LastPIDTime);

      --Put_Line("dt: " & dt'Image);
      --Put_Line("dt float" & Float(dt)'Image);
      --Put_Line("NowTime: " & NowTime'Image);
      --Put_Line("Last PID Time: " & LastPIDTime'Image);

      --Put_Line("Duration:" & To_Duration(dt)'Image);


      --Put_Line("Int convert:" & new_dt'Image);

      TargetDistance := Target_Distance;
      CurrentDistance := Actual_Distance;

      ErrorDistance := TargetDistance - CurrentDistance;
      Put_Line ("ErrorDistance: " & ErrorDistance'Image);

      Proportional := Kp*Float(Integer(ErrorDistance));
      Put_Line ("Proportional:" & Proportional'Image);

      --Put_Line("Error distance float" & Float(ErrorDistance)'Image);
      --Put_Line("Ki" & Ki'Image);



      temp_ErrorDistance := Float(ErrorDistance);
      --Put_Line("Temp Error Distance" & temp_ErrorDistance'Image);

      temp_dt := Float(dt);
     -- Put_Line("Temp dt" & temp_dt'Image);

      Integral := Integral + Float(ErrorDistance)*Ki*Float(dt);
      Put_Line("Integral: " & Integral'Image);

      PIDOut := Proportional + Integral;
      Put_Line("PIDOut:" & PIDOut'Image);

      PreviousError := PIDOut;
      -- Last_Time := NowTime;

      --PIDResult := PIDOut;






     -- if PIDOut >= 4095.0 then
       --  PIDResult := 4095.0;

      --elsif PIDOut <= 500.0 then
        -- PIDResult := 500.0;
      --else
       --  PIDResult := PIDOut;
       -- end if ;

      if PIDOut >= (4095.0 - 500.0) then
         PIDResult := 500.0;
      else
         PIDResult := 4095.0 - PIDOut;

      end if;
       Put_Line("PIDResult " & PIDResult'Image);
      Put_Line("End PID");
      LastPIDTime := Clock;
     end PIDi;

   function GetPIDResult return Float is
   begin
      return PIDResult;
   end GetPIDResult;


   procedure Flush is
   begin
      Integral := 0.0;
      PreviousError := 0.0;
      PIDResult := 0.0;
   end Flush;



end pid_controller;
