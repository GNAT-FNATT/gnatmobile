package body Think_Task_Pkg is
   task body think is
      myClock: Time;
   begin
      loop
         myClock := Clock;
         
         delay (0.05); --simulate 50 ms execution time, replace with your 
         
         MotorDriver.SetDirection(Forward);
         
         delay until myClock + Milliseconds(100);
      end loop;
   end think;

end Think_Task_Pkg;
