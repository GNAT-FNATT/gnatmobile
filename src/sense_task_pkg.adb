package body Sense_Task_Pkg is

   task body sense is
      myClock: Time;
   begin
      loop
         myClock := Clock;
         
         delay (0.05); --simulate 50 ms execution time, replace with your 
         
         MotorDriver.SetDirection(Stop);
         
         delay until myClock + Milliseconds(70);
      end loop;
   end sense;

end Sense_Task_Pkg;
