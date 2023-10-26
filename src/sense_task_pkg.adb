package body Sense_Task_Pkg is

   task body sense is
      myClock: Time;
      
      forwardDistance: Distance_cm;
      rightDistance: Distance_cm;
      leftDistance: Distance_cm;
      panicThreshold: Distance_cm := 10;
      panicDirection: Directions;
      
      inPanic: Boolean;
      isReallyClose: Boolean;
      isReallyCloseFront: Boolean;
      isReallyCloseRight: Boolean;
      isReallyCloseLeft: Boolean;
      
      waitTime: Integer := 200;
   begin
      loop
         myClock := Clock;
         
         inPanic := False;
         isReallyClose := False;
         isReallyCloseFront := False;
         isReallyCloseRight := False;
         isReallyCloseLeft := False;
         
         forwardDistance := forwardSensor.Read;
         rightDistance := rightSensor.Read;
         leftDistance := leftSensor.Read;
         
         Put_Line("Sensor read");
         
         Put_Line("Forward distance " & forwardDistance'Image);
         Put_Line("Right distance " & rightDistance'Image);
         Put_Line("Left distance " & leftDistance'Image);
         
         -- if we are really close to something => skip think
         if forwardDistance /= 0 and rightDistance /= 0 and leftDistance /= 0 then
            
            if forwardDistance <= panicThreshold then
               isReallyCloseFront := True;
               isReallyClose := True;
            end if;
            
            if rightDistance <= panicThreshold then
               isReallyCloseRight := True;
               isReallyClose := True;
            end if;
            
            if leftDistance <= panicThreshold then
               isReallyCloseLeft := True;
               isReallyClose := True;
            end if;
            
         end if;
         
         
         if isReallyClose then
            inPanic := True;
            
            -- move opposite direction quickly
            if isReallyCloseFront then
               if isReallyCloseRight and not isReallyCloseLeft then
                  panicDirection := Backward_Left;
               elsif not isReallyCloseRight and isReallyCloseLeft then
                  panicDirection := Backward_Right;
               else
                  -- close left and right or only close front
                  panicDirection := Backward;
               end if;
            else
               if isReallyCloseRight and not isReallyCloseLeft then
                  panicDirection := Forward_Left;
               elsif not isReallyCloseRight and isReallyCloseLeft then
                  panicDirection := Forward_Right;
               else
                  -- close left and right or only not close front
                  -- let think decide, no good way for handling this
                  inPanic := False;
                  -- panicDirection := Forward;
               end if;
            end if;
         else
            inPanic := False;
         end if;
         
         -- set direction if in panic mode 
         if inPanic then
            FnattControl.SetPanicMode(True);
            FnattControl.SetDirectionChoice(panicDirection);
         else
            FnattControl.SetPanicMode(False);
         end if;
         
         FnattControl.SetFrontSensorDistance(forwardDistance);
         FnattControl.SetRightSensorDistance(rightDistance);
         FnattControl.SetLeftSensorDistance(leftDistance);
         
         delay until myClock + Milliseconds(waitTime);
      end loop;
   end sense;

end Sense_Task_Pkg;
