package body Act_Task_Pkg is

   task body act is
      myClock: Time;
   begin
      loop
         myClock := Clock;
       
         Put_Line ("Direction is: " & Directions'Image (FnattControl.GetDirectionChoice));
         
         -- actually drive
         MicroBit.MotorDriver.Drive(FnattControl.GetDirectionChoice);
         
         delay until myClock + Milliseconds(100);
      end loop;
   end act;

end Act_Task_Pkg;
