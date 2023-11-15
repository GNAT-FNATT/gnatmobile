--with Ada.Real_Time; use Ada.Real_Time;
--with MicroBit.Console; use MicroBit.Console;
--with MicroBit.Types; use MicroBit.Types;
--with HAL; use HAL;

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
      
      procedure SetLeftSensorDistance (D : DistanceCentimeter) is
      begin 
          LeftSensorDistance := D;
      end SetLeftSensorDistance;
      
      procedure SetSpeed (S : UInt12) is 
      begin
         Speed := S;
      end SetSpeed;
      
      procedure SetSpeeds (S : Speeds) is 
      begin
         CustomSpeeds := S;
      end SetSpeeds;

      procedure SetIteration (I : UInt12) is
      begin
         Iteration := I;
      end SetIteration;
      
      procedure SetPanicMode (P : Boolean) is 
      begin
         HasPanic := P;
      end SetPanicMode;
      
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
      
      function GetLeftSensorDistance return DistanceCentimeter is
      begin
         return LeftSensorDistance;
      end GetLeftSensorDistance;
      
      function GetSpeed return Speeds is 
      begin
         return (Speed,Speed,Speed,Speed);
      end GetSpeed;
      
      function GetSpeeds return Speeds is
      begin
         return CustomSpeeds;
      end GetSpeeds;
      
      function GetIteration return UInt12 is
      begin
         return Iteration;
      end GetIteration;
      
      function GetPanicMode return Boolean is 
      begin
         return HasPanic;
      end GetPanicMode;
      
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
