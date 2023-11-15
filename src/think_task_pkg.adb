with Ada.Real_Time; use Ada.Real_Time;
with HAL; use HAL;


package body Think_Task_Pkg is
   task body think is
      myClock: Time;
      frontDistance: Distance_cm;
      rightDistance: Distance_cm;
      leftDistance: Distance_cm;
      chosenDirection: Directions;
      chosenSpeed: Speeds;
      -- previousDirection: Directions;
      
      distanceThreshold: Distance_cm := 30;
      
      shouldThink: Boolean := True;
      isCloseFront: Boolean := False;
      isCloseRight: Boolean := False;
      isCloseLeft: Boolean := False;
      
      startUpperCurve: UInt12 := 10; 
      endUpperCurve: UInt12 := 50;
      startLowerCurve: UInt12 := 70;
      endLowerCurve: UInt12 := 110;
      startMiddle: UInt12 := 120;
      
      decision: Natural;
      currentIteration: UInt12 := 0;
      waitTime: Time_Span := Milliseconds(300);
   begin
      loop
         myClock := Clock;
         
         shouldThink := True;
         
         -- is in panic mode
         if FnattControl.GetPanicMode then
            shouldThink := False;
         end if;

         -- previousDirection := FnattControl.GetDirectionChoice;
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

         chosenSpeed := (4095, 4095, 4095, 4095);
         -- reset speed back to normal
         FnattControl.SetSpeeds(chosenSpeed);
         
         -- dont do all this if not shouldthink
         if not shouldThink then
            Put_Line("In panic mode!");
         else
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
                  -- not isclosefront and not iscloseright and not iscloseleft
                  currentIteration := FnattControl.GetIteration;
                  chosenDirection := Forward;
                  
                  if currentIteration >= startMiddle then
                     currentIteration := 0;
                  elsif startUpperCurve <= currentIteration and currentIteration <= endUpperCurve then
                     chosenSpeed := (4095, 4095, 950, 950);
                  elsif startLowerCurve <= currentIteration and currentIteration <= endLowerCurve then
                     chosenSpeed := (950, 950, 4095, 4095);
                  end if;
                  
                  currentIteration := currentIteration + 1;
                  FnattControl.SetIteration(currentIteration);
                    
                  decision := 8;
               end if;
            end if;
         
            -- chosenDirection := Backward_Right;
         
            FnattControl.SetDirectionChoice(chosenDirection);
            FnattControl.SetSpeeds(chosenSpeed);
            Put_Line("Descision " & decision'Image);

         end if;
         
         delay until myClock + waitTime;
      end loop;
   end think;

end Think_Task_Pkg;
