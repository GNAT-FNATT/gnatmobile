with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with fnatt.Distance; use fnatt.Distance;
package FnattController is
   
   
   --ask Sense with Priority => 1;
  
   --task Think with Priority=> 1; -- what happens for the set direction if think and sense have the same prio and period?
                                 -- what happens if think has a higher priority? Why is think' set direction overwritten by sense' set direction?
   
   --task Act with Priority=> 3;
   type DistanceDirections is (Left, Front, Right);
  
   protected FnattControl is
      function GetDirectionChoice return Directions;
      function GetFrontSensorDistance return DistanceCentimeter;
      function GetRightSensorDistance return DistanceCentimeter;
      --  function GetLeftSensorDistance return DistanceCentimeter;
      function GetDistance(Direction: DistanceDirections) return DistanceCentimeter;
      
      procedure SetDistance(Direction: DistanceDirections; Distance: DistanceCentimeter);
      procedure SetDirectionChoice (V : Directions);
      procedure SetFrontSensorDistance (D : DistanceCentimeter);
      procedure SetRightSensorDistance (D : DistanceCentimeter);
      --  procedure SetLeftSensorDistance (D : DistanceCentimeter);
      
   private
      ChoiceDirection : Directions := Stop;
      FrontSensorDistance: DistanceCentimeter := 400;
      RightSensorDistance: DistanceCentimeter := 400;
      LeftSensorDistance: DistanceCentimeter := 400;
   end FnattControl;

end FnattController;
