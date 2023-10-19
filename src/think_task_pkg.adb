with Ada.Real_Time; use Ada.Real_Time;



package body Think_Task_Pkg is
   task body think is
      myClock: Time;
      frontDistance: Distance_cm;
      rightDistance: Distance_cm;
      leftDistance: Distance_cm;
      chosenDirection: Directions;
      -- wait: Natural;
      
      distanceThreshold: Distance_cm := 20;
      
      isCloseFront: Boolean := False;
      isCloseRight: Boolean := False;
      isCloseLeft: Boolean := False;
      
      decision: Natural;
      waitTime: Integer := 300;
   begin
      loop
         myClock := Clock;
         -- wait := 100;
         
         isCloseFront := False;
         isCloseRight := False;
         isCloseLeft := False;
         
         
         frontDistance := FnattControl.GetFrontSensorDistance;
         rightDistance := FnattControl.GetRightSensorDistance;
         leftDistance := FnattControl.GetLeftSensorDistance;
         
         -- lastDirection := FnattControl.GetDirectionChoice;
         -- Put_Line("Making drive decision");
         
         if frontDistance /= 0 and frontDistance <= distanceThreshold then
            isCloseFront := True;
         end if;
         
         if rightDistance /= 0 and rightDistance <= distanceThreshold then
            isCloseRight := True;
         end if;
         
         if leftDistance /= 0 and leftDistance <= distanceThreshold then
            isCloseLeft := True;
         end if;
         
         
         if isCloseFront then
            if isCloseRight and isCloseLeft then
               chosenDirection := Backward;
               decision := 1;
            elsif not isCloseRight and isCloseLeft then
               chosenDirection := Backward_Right;
               decision := 2;
            elsif isCloseRight and not isCloseLeft then
               chosenDirection := Backward_Left;
               decision := 3;
            else
               -- not iscloseright and not iscloseleft
               chosenDirection := Rotating_Left;
               decision := 4;
            end if;
         else
            if isCloseRight and isCloseLeft then
               chosenDirection := Forward;
               decision := 5;
            elsif not isCloseRight and isCloseLeft then
               chosenDirection := Forward_Right;
               decision := 6;
            elsif isCloseRight and not isCloseLeft then
               chosenDirection := Forward_Left;
               decision := 7;
            else
               -- not iscloseright and not iscloseleft
               chosenDirection := Forward;
               decision := 8;
            end if;
         end if;
        
         
         -- chosenDirection := Lateral_Left;
         
         FnattControl.SetDirectionChoice(chosenDirection);
         
         Put_Line("Descision " & decision'Image);
         
         delay until myClock + Milliseconds(waitTime);
      end loop;
   end think;

end Think_Task_Pkg;
