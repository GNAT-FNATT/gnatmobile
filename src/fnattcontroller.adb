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
      
      procedure SetFrontSensorDistance (D : DistanceCentimeter) is
      begin
          FrontSensorDistance := D;
      end SetFrontSensorDistance;
      
      procedure SetRightSensorDistance (D : DistanceCentimeter) is
      begin 
          RightSensorDistance := D;
      end SetRightSensorDistance;

      procedure SetDistance(Direction: DistanceDirections; Distance: DistanceCentimeter) is
      begin
         case Direction is
         when Front=>
            FrontSensorDistance:= Distance;
         when Left=>
            LeftSensorDistance:= Distance;
         when Right=>
            RightSensorDIstance := Distance;
         end case;
      end SetDistance;

      
      --  functions cannot modify the data
      function GetDirectionChoice return Directions is
      begin
         return ChoiceDirection;
      end GetDirectionChoice;

      function GetFrontSensorDistance return DistanceCentimeter is
      begin
          return FrontSensorDistance;
      end GetFrontSensorDistance;

      function GetRightSensorDistance return DistanceCentimeter is
      begin
         return RightSensorDistance;
      end GetRightSensorDistance;
      
      function GetDistance(Direction: DistanceDirections) return DistanceCentimeter is
      begin
         case Direction is
            when Front => return FrontSensorDistance;
            when Left => return LeftSensorDistance;
            when Right => return RightSensorDistance;
         end case;
      end GetDistance;
        
   end FnattControl;
   
end FnattController;
