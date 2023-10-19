package body Act_Task_Pkg is

   task body act is
      myClock: Time;
      waitTime: Integer := 200;
   begin
      loop
         myClock := Clock;
       
         Put_Line ("Direction is: " & Directions'Image (FnattControl.GetDirectionChoice));
         
         -- actually drive
         MicroBit.MotorDriver.Drive(FnattControl.GetDirectionChoice);
         
         delay until myClock + Milliseconds(waitTime);
      end loop;
   end act;

end Act_Task_Pkg;
