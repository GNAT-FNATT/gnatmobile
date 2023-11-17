with Ada.Real_Time; use Ada.Real_Time;
with Fnatt_Distance; use Fnatt_Distance;
with HAL; use HAL;


package body Think_Task_Pkg is
   task body think is
      myClock: Time;
      frontDistance: DistanceCentimeter;
      rightDistance: DistanceCentimeter;
      leftDistance: DistanceCentimeter;
      chosenDirection: Directions;
      chosenSpeed: Speeds;
      -- timeTaken: Time_Span;
      
      -- turn on pid if within
      distanceThreshold: DistanceCentimeter := 30;
      -- pid goal, if further from this 
      -- turn pid off
      distanceGoal: DistanceCentimeter := 30;
      
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
      waitTime: Time_Span := Milliseconds(51);
   begin
      loop
         myClock := Clock;
         
         shouldThink := True;
         
         -- is in panic mode
         if FnattControl.GetPanicMode then
            shouldThink := False;
         end if;

         isCloseFront := False;
         isCloseRight := False;
         isCloseLeft := False;
         
         frontDistance := FnattControl.GetFrontSensorDistance;
         rightDistance := FnattControl.GetRightSensorDistance;
         leftDistance := FnattControl.GetLeftSensorDistance;
         
         if frontDistance < distanceThreshold then
            isCloseFront := True;
         end if;
         
         if rightDistance < distanceThreshold then
            isCloseRight := True;
         end if;
         
         if leftDistance < distanceThreshold then
            isCloseLeft := True;
         end if;
         
         -- set speeds
         if not shouldThink then
            -- Put_Line("In panic mode!");
            null;
         elsif isCloseFront or isCloseRight or isCloseLeft then
            -- take the smallest distance and pid to goal
            --Put_Line("Doing PID");
            PIDi(DistanceCentimeter'Min(DistanceCentimeter'Min(frontDistance,rightDistance),leftDistance), distanceGoal);
            --Put_Line("PID result" & GetPIDResult'Image);
            FnattControl.SetSpeed(GetPIDResult);
         else 
            --Put_Line("Flushing and setting speeds");
            Flush;
            -- not close to anything -> flush
            chosenSpeed := (4095, 4095, 4095, 4095);
            -- reset speed back to normal
            FnattControl.SetSpeeds(chosenSpeed);
         end if;
         
         -- set direction
         if not shouldThink then
            --Put_Line("Should not think!");
            null;
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
                  chosenDirection := Rotating_Left; -- ikke testa
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
                  
                  -- overwrite speeds for turning
                  FnattControl.SetSpeeds(chosenSpeed);
                  currentIteration := currentIteration + 1;
                  FnattControl.SetIteration(currentIteration);
                    
                  decision := 8;
               end if;
               
               FnattControl.SetDirectionChoice(chosenDirection);
               --Put_Line("Descision " & decision'Image);
            end if;
            
         end if;
         
         -- timeTaken := Clock-myClock;
         
         -- Put_Line(To_Duration(timeTaken)'Image);
         
         delay until myClock + waitTime;
      end loop;
   end think;

end Think_Task_Pkg;
