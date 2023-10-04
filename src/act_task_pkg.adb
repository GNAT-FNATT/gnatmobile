package body Act_Task_Pkg is

   task body act is
      myClock: Time;
   begin
      loop
         myClock := Clock;
       
         Put_Line ("Direction is: " & Directions'Image (MotorDriver.GetDirection));
         
         -- actually drive
         MicroBit.MotorDriver.Drive(Motordriver.GetDirection);
         
         delay until myClock + Milliseconds(40);
      end loop;
   end act;

end Act_Task_Pkg;
