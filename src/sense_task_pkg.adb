package body Sense_Task_Pkg is

   task body sense is
      myClock: Time;
      
      forwardDistance: Distance_cm;
      rightDistance: Distance_cm;
      leftDistance: Distance_cm;
      
      waitTime: Integer := 200;
   
   begin
      loop
         myClock := Clock;
         
         forwardDistance := forwardSensor.Read;
         rightDistance := rightSensor.Read;
         leftDistance := leftSensor.Read;
         
         Put_Line("Sensor read");
         
         Put_Line("Forward distance " & forwardDistance'Image);
         Put_Line("Right distance " & rightDistance'Image);
         Put_Line("Left distance " & leftDistance'Image);
         
         -- Put_Line("Forward distance " & forwardDistance'Image & " right distance: " & rightDistance'Image); 
         
         -- Put_Line ("Direction is: " & Directions'Image (FnattControl.GetDirectionChoice));
         
         FnattControl.SetFrontSensorDistance(forwardDistance);
         FnattControl.SetRightSensorDistance(rightDistance);
         FnattControl.SetLeftSensorDistance(leftDistance);
         
         -- FnattControl.SetDirectionChoice(Stop);
         
         delay until myClock + Milliseconds(waitTime);
      end loop;
   end sense;

end Sense_Task_Pkg;
