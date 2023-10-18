with Ada.Real_Time; use Ada.Real_Time;



package body Think_Task_Pkg is
   task body think is
      myClock: Time;
      frontDistance: Distance_cm;
      rightDistance: Distance_cm;
      leftDistance: Distance_cm;
      chosenDirection: Directions;
      -- wait: Natural;
      decision: Natural;
   begin
      loop
         myClock := Clock;
         -- wait := 100;
         
         frontDistance := FnattControl.GetFrontSensorDistance;
         rightDistance := FnattControl.GetRightSensorDistance;
         leftDistance := FnattControl.GetLeftSensorDistance;
         -- lastDirection := FnattControl.GetDirectionChoice;
         Put_Line("Making drive decision");
         
         if frontDistance = 0 or rightDistance = 0 or leftDistance = 0 then
            -- we could have crashed or are more than 400 cm away
            -- drive the route we have set up
            chosenDirection := FnattControl.GetDirectionChoice;
            decision := 1;
         elsif frontDistance <= 50 then
            chosenDirection := Backward_Left;
            decision := 2;
         elsif rightDistance <= 50 then
            chosenDirection := Left;
            decision := 3;
         elsif leftDistance <= 50 then 
            chosenDirection := Right;
            decision := 4;
         else
            chosenDirection := Forward;
            decision := 5;
         end if;
                  
         FnattControl.SetDirectionChoice(chosenDirection);
         
         Put_Line("Descision " & decision'Image);
         
         delay until myClock + Milliseconds(40);
      end loop;
   end think;

end Think_Task_Pkg;
