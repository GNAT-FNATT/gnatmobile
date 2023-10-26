with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Types; use MicroBit.Types;

package FnattController is   
   --ask Sense with Priority => 1;
  
   --task Think with Priority=> 1; -- what happens for the set direction if think and sense have the same prio and period?
                                 -- what happens if think has a higher priority? Why is think' set direction overwritten by sense' set direction?
   
   --task Act with Priority=> 3;

   protected FnattControl is
      function GetPanicMode return Boolean;
      function GetDirectionChoice return Directions;
      function GetFrontSensorDistance return Distance_cm;
      function GetRightSensorDistance return Distance_cm;
      function GetLeftSensorDistance return Distance_cm;
      
      procedure SetPanicMode (P : Boolean);
      procedure SetDirectionChoice (V : Directions);
      procedure SetFrontSensorDistance (D : Distance_cm);
      procedure SetRightSensorDistance (D : Distance_cm);
      procedure SetLeftSensorDistance (D : Distance_cm);
      
   private
      HasPanic: Boolean := False;
      ChoiceDirection : Directions := Stop;
      FrontSensorDistance: Distance_cm := 400;
      RightSensorDistance: Distance_cm := 400;
      LeftSensorDistance: Distance_cm := 400;
   end FnattControl;

end FnattController;
