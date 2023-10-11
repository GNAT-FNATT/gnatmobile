package body Sense_Task_Pkg is

   task body sense is
      myClock: Time;
      
      forwardDistance: Distance_cm;
      rightDistance: Distance_cm;
      
      -- wait: WaitTime;
   
   begin
      loop
         myClock := Clock;
         -- wait := 70;
         
         forwardDistance := forwardSensor.Read;
         rightDistance := rightSensor.Read;
         
         Put_Line("Forward distance " & forwardDistance'Image & " right distance: " & rightDistance'Image); 
         
         -- Put_Line ("Direction is: " & Directions'Image (FnattControl.GetDirectionChoice));
         
         FnattControl.SetFrontSensorDistance(forwardDistance);
         FnattControl.SetRightSensorDistance(rightDistance);
         
         -- FnattControl.SetDirectionChoice(Stop);
         
         delay until myClock + Milliseconds(70);
      end loop;
   end sense;

end Sense_Task_Pkg;
