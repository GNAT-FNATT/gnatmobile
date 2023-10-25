package body Act_Task_Pkg is

   task body act is
      myClock: Time;
      driveDirection: Directions;
      waitTime: Integer := 200;
   begin
      loop
         myClock := Clock;
       
         driveDirection := FnattControl.GetDirectionChoice;
         
         Put_Line ("Driving direction: " & Directions'Image(driveDirection));
         
         -- actually drive
         MicroBit.MotorDriver.Drive(driveDirection);
         
         delay until myClock + Milliseconds(waitTime);
      end loop;
   end act;

end Act_Task_Pkg;
