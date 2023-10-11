with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Console; use MicroBit.Console;
--with MicroBit.MotorDriver; use MicroBit.MotorDriver;

--with DFR0548;

--with Think_Task_Pkg;


package body FnattController is
   
   protected body FnattControl is
      --  procedures can modify the data
      procedure SetDirectionChoice (V : Directions) is
      begin
          ChoiceDirection := V;
      end SetDirectionChoice;
      
      procedure SetFrontSensorDistance (D : DistanceCM) is
      begin
          FrontSensorDistance := D;
      end SetFrontSensorDistance;
      
      procedure SetRightSensorDistance (D : DistanceCM) is
      begin 
          RightSensorDistance := D;
      end SetRightSensorDistance;

      --  functions cannot modify the data
      function GetDirectionChoice return Directions is
      begin
         return ChoiceDirection;
      end GetDirectionChoice;

      function GetFrontSensorDistance return DistanceCM is
      begin
          return FrontSensorDistance;
      end GetFrontSensorDistance;

      function GetRightSensorDistance return DistanceCM is
      begin
         return RightSensorDistance;
      end GetRightSensorDistance;
      
   end FnattControl;
   
end FnattController;
