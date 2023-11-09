with MicroBit.Types; use MicroBit.Types;
with Ada.Real_Time; use Ada.Real_Time;
with HAL; use HAL;
with MicroBit.Console; use MicroBit.Console;
with Ada.Unchecked_Conversion;

package body pid_controller is
   subtype LLI is Long_Long_Integer;

      function To_LLI is
     new Ada.Unchecked_Conversion (Time_Span, LLI);
      function To_Integer is
     new Ada.Unchecked_Conversion (LLI, Integer);
   -- varmesokker todo
   procedure PIDi (Target_Distance : in Distance_cm; Actual_Distance : in Distance_cm; Last_Time : in Time) is




      -- subtype Distance is new Natural in range 0..400;

      -- The target distance we want to achieve
      TargetDistance : Distance_cm;

      -- Current Distance
      CurrentDistance : Distance_cm;

      -- The error between actual distance and target
      ErrorDistance : Distance_cm := 0;


      -- The coefficient

      Kp : Integer := 5000000;

      Ki : Integer := 3;

      -- Kd : Integer := 2;


      -- The proportional component

      Proportional : Integer := 0;


      -- The integral component

      Integral : Integer := 0;


      -- The derivative component

      -- Derivative : Integer := 0;

      -- Previous error
      PreviousError : Integer := 0;

      -- Time scope of PID cycles

      dt : Time_Span ;

      NowTime : Time ;

      -- The variable to change
      -- PIDVariable : Speeds;

      -- The output from the PID Controller
      PIDOut : Integer := 0;

      --Converted_dt : UInt12;
      temp_dt : LLI;
      new_dt : Integer;

   begin
      Put_Line("Start PID");

      delay 0.1;
      NowTime := Clock;

      dt := NowTime - Last_Time;

      Put_Line("Duration:" & To_Duration(dt)'Image);

      temp_dt := To_LLI(dt);
      Put_Line("LLI convert:" & temp_dt'Image);

      new_dt := To_Integer(temp_dt);
      Put_Line("Int convert:" & new_dt'Image);

      TargetDistance := Target_Distance;
      CurrentDistance := Actual_Distance;

      ErrorDistance := TargetDistance - CurrentDistance;
      Put_Line ("ErrorDistance: " & ErrorDistance'Image);

      Proportional := Kp*Integer(ErrorDistance);
      Put_Line ("Proportional:" & Proportional'Image);

      Integral := Integral + Ki*new_dt;
      Put_Line("Integral: " & Integral'Image);

      PIDOut := Proportional + Integral;
      Put_Line("PIDOut:" & PIDOut'Image);

      PreviousError := PIDOut;
      -- Last_Time := NowTime;

      PIDResult := PIDOut;
     end PIDi;

   function GetPIDResult return Integer is
   begin
      return PIDResult;
   end GetPIDResult;

end pid_controller;
