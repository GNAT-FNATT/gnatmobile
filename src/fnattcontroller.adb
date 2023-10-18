with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Console; use MicroBit.Console;
--with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Types; use MicroBit.Types;
--with DFR0548;

--with Think_Task_Pkg;


package body FnattController is
   
   protected body FnattControl is
      --  procedures can modify the data
      procedure SetDirectionChoice (V : Directions) is
      begin
          ChoiceDirection := V;
      end SetDirectionChoice;
      
      procedure SetFrontSensorDistance (D : Distance_cm) is
      begin
          FrontSensorDistance := D;
      end SetFrontSensorDistance;
      
      procedure SetRightSensorDistance (D : Distance_cm) is
      begin 
          RightSensorDistance := D;
      end SetRightSensorDistance;
      
      procedure SetLeftSensorDistance (D : Distance_cm) is
      begin 
          LeftSensorDistance := D;
      end SetLeftSensorDistance;

      --  functions cannot modify the data
      function GetDirectionChoice return Directions is
      begin
         return ChoiceDirection;
      end GetDirectionChoice;

      function GetFrontSensorDistance return Distance_cm is
      begin
          return FrontSensorDistance;
      end GetFrontSensorDistance;

      function GetRightSensorDistance return Distance_cm is
      begin
         return RightSensorDistance;
      end GetRightSensorDistance;
      
      function GetLeftSensorDistance return Distance_cm is
      begin
         return LeftSensorDistance;
      end GetLeftSensorDistance;
      
   end FnattControl;
   
end FnattController;
