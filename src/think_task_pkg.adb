with Ada.Real_Time; use Ada.Real_Time;



package body Think_Task_Pkg is
   task body think is
      myClock: Time;
      frontDistance: Distance_cm;
      rightDistance: Distance_cm;
      leftDistance: Distance_cm;
      chosenDirection: Directions;
      
      distanceThreshold: Distance_cm := 20;
      
      isCloseFront: Boolean := False;
      isCloseRight: Boolean := False;
      isCloseLeft: Boolean := False;
      
      decision: Natural;
      waitTime: Integer := 300;
   begin
      loop
         myClock := Clock;

         isCloseFront := False;
         isCloseRight := False;
         isCloseLeft := False;
         
         frontDistance := FnattControl.GetFrontSensorDistance;
         rightDistance := FnattControl.GetRightSensorDistance;
         leftDistance := FnattControl.GetLeftSensorDistance;
         
         if frontDistance /= 0 and frontDistance <= distanceThreshold then
            isCloseFront := True;
         end if;
         
         if rightDistance /= 0 and rightDistance <= distanceThreshold then
            isCloseRight := True;
         end if;
         
         if leftDistance /= 0 and leftDistance <= distanceThreshold then
            isCloseLeft := True;
         end if;
         
         -- directions which are tested and correct:
         -- backward
         -- forward
         -- rotating left
         -- forward right
         -- forward left
         -- backward right
         -- backward left
         
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
               -- add some cooler movement here?
               chosenDirection := Forward;
               decision := 8;
            end if;
         end if;
         
         -- chosenDirection := Backward_Right;
         
         FnattControl.SetDirectionChoice(chosenDirection);
         
         Put_Line("Descision " & decision'Image);
         
         delay until myClock + Milliseconds(waitTime);
      end loop;
   end think;

end Think_Task_Pkg;
