with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with MicroBit.Types; use MicroBit.Types;
with HAL; use HAL;

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
      function GetSpeed return Speeds;
      function GetSpeeds return Speeds;
      function GetIteration return UInt12;
      
      procedure SetPanicMode (P : Boolean);
      procedure SetDirectionChoice (V : Directions);
      procedure SetFrontSensorDistance (D : Distance_cm);
      procedure SetRightSensorDistance (D : Distance_cm);
      procedure SetLeftSensorDistance (D : Distance_cm);
      procedure SetSpeed (S : UInt12);
      procedure SetSpeeds (S: Speeds);
      procedure SetIteration (I: UInt12);
      
   private
      HasPanic: Boolean := False;
      ChoiceDirection : Directions := Stop;
      Speed: UInt12;
      CustomSpeeds: Speeds;
      FrontSensorDistance: Distance_cm := 400;
      RightSensorDistance: Distance_cm := 400;
      LeftSensorDistance: Distance_cm := 400;
      Iteration: UInt12 := 0;
   end FnattControl;

end FnattController;
