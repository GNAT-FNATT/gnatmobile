with MicroBit.MotorDriver; use MicroBit.MotorDriver;

package FnattController is
   type DistanceCM is new Natural range 0 .. 400;
   
   
   --ask Sense with Priority => 1;
  
   --task Think with Priority=> 1; -- what happens for the set direction if think and sense have the same prio and period?
                                 -- what happens if think has a higher priority? Why is think' set direction overwritten by sense' set direction?
   
   --task Act with Priority=> 3;

   protected FnattControl is
      function GetDirectionChoice return Directions;
      function GetFrontSensorDistance return DistanceCM;
      function GetRightSensorDistance return DistanceCM;
      -- function GetLeftSensorDistance return DistanceCM; 
      
      
      procedure SetDirectionChoice (V : Directions);
      procedure SetFrontSensorDistance (D : DistanceCM);
      procedure SetRightSensorDistance (D : DistanceCM);
      -- procedure SetLeftSensorDistance (D : DistanceCM);
      
   private
      ChoiceDirection : Directions := Stop;
      FrontSensorDistance: DistanceCM := 400;
      RightSensorDistance: DistanceCM := 400;
      -- LeftSensorDistance: DistanceCM := 400;
   end FnattControl;

end FnattController;
