with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Types; use MicroBit.Types;
with HAL; use HAL;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Console; use MicroBit.Console;
with Fnatt_Distance; use Fnatt_Distance;

package FnattController is
   type DistanceDirections is (LeftSensor, FrontSensor, RightSensor);
  
   protected FnattControl is
      function GetPanicMode return Boolean;
      function GetDirectionChoice return Directions;
      function GetSpeeds return Speeds;
      function GetIteration return UInt12;
      function GetFrontSensorDistance return DistanceCentimeter;
      function GetRightSensorDistance return DistanceCentimeter;
      function GetLeftSensorDistance return DistanceCentimeter;
      function GetDistance (Direction: DistanceDirections) return DistanceCentimeter;
      
      procedure SetPanicMode (P : Boolean);
      procedure SetSpeed (S : UInt12);
      procedure SetSpeeds (S: Speeds);
      procedure SetIteration (I: UInt12);
      procedure SetDistance (Direction: DistanceDirections; Distance: DistanceCentimeter);
      procedure SetDirectionChoice (V : Directions);
      procedure SetFrontSensorDistance (D : DistanceCentimeter);
      procedure SetRightSensorDistance (D : DistanceCentimeter);
      procedure SetLeftSensorDistance (D : DistanceCentimeter);
      
   private
      HasPanic: Boolean := False;
      ChoiceDirection : Directions := Stop;
      Speed: UInt12;
      CustomSpeeds: Speeds;
      Iteration: UInt12 := 0;
      FrontSensorDistance: DistanceCentimeter := 400;
      RightSensorDistance: DistanceCentimeter := 400;
      LeftSensorDistance: DistanceCentimeter := 400;
   end FnattControl;
end FnattController;
