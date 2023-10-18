package body Think_Task_Pkg is
   task body think is
      myClock: Time;
      frontDistance: Distance_cm;
      rightDistance: Distance_cm;
      chosenDirection: Directions;
      -- wait: Natural;
      decision: Natural;
   begin
      loop
         myClock := Clock;
         -- wait := 100;
         
         frontDistance := FnattControl.GetFrontSensorDistance;
         rightDistance := FnattControl.GetRightSensorDistance;
         
         -- lastDirection := FnattControl.GetDirectionChoice;
         
         
         if frontDistance = 0 or rightDistance = 0 then
            -- we could have crashed or are more than 400 cm away
            -- drive the route we have set up
            chosenDirection := FnattControl.GetDirectionChoice;
            decision := 1;
         else
            if 1 <= frontDistance and frontDistance <= 50 then
               chosenDirection := Backward_Left;
               decision := 2;
            elsif 1 <= rightDistance and rightDistance <= 50 then
               chosenDirection := Lateral_Left;
               decision := 3;
            else
               chosenDirection := Forward;
               decision := 4;
            end if;
         end if;
         
         FnattControl.SetDirectionChoice(chosenDirection);
         
         Put_Line("Descision " & decision'Image);
         
         delay until myClock + Milliseconds(60);
      end loop;
   end think;

end Think_Task_Pkg;
