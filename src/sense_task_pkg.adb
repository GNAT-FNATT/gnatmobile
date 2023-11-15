package body Sense_Task_Pkg is
   
   task body sense is
      leftMeasurement: Measurement := (Distance=> MaximumDistance,
                                       Threshold => ThresholdValue,
                                       WithinThreshold => False,
                                       Direction =>FnattController.Left);
      frontMeasurement: Measurement := (Distance=> MaximumDistance,
                                        Threshold => ThresholdValue,
                                        WithinThreshold => False,
                                        Direction => FnattController.Front);
      rightMeasurement: Measurement := (Distance=> MaximumDistance,
                                        Threshold => ThresholdValue,
                                        WithinThreshold => False,
                                        Direction => FnattController.Right);
      Measurements: MeasurementsArray := (leftMeasurement, frontMeasurement, rightMeasurement);
      Deadline: Ada.Real_Time.Time;
      currentState: State;
      inPanic: Boolean;
      panicDirection: Directions; 
    begin
      currentState := Init;
      inPanic := False;
      
      Microbit.Console.Put_Line("Sense: " & currentState'Image);
      
      leftSensor.SetMaximumDistance(MaximumDistance);
      frontSensor.SetMaximumDistance(MaximumDistance);
      rightSensor.SetMaximumDistance(MaximumDistance);

      currentState:= Normal;
      loop
         Deadline := Ada.Real_Time.Clock + Ada.Real_Time.Milliseconds(1000);
         
         Microbit.Console.Put_Line("P025: " & nRF.Device.P25.Set'Image);

         leftMeasurement.Distance := leftSensor.Read;
         frontMeasurement.Distance := frontSensor.Read;
         rightMeasurement.Distance := rightSensor.Read;

         for index in Measurements'Range loop
            FnattControl.SetDistance(Measurements(index).Direction, Measurements(index).Distance);
            Measurements(index).WithinThreshold := (if Measurements(index).Distance <= Measurements(index).Threshold then True else False);
         end loop;
         
         if frontMeasurement.WithinThreshold or rightMeasurement.WithinThreshold or leftMeasurement.WithinThreshold then
            inPanic := True;
         end if;
         
         if inPanic then
            if frontMeasurement.WithinThreshold  then
               if rightMeasurement.WithinThreshold and not leftMeasurement.WithinThreshold then
                  panicDirection := Backward_Left;
               elsif not rightMeasurement.WithinThreshold and leftMeasurement.WithinThreshold then
                  panicDirection := Backward_Right;
               else
                  -- close left and right or only close front
                  panicDirection := Backward;
               end if;
            else
               if rightMeasurement.WithinThreshold and not leftMeasurement.WithinThreshold then
                  panicDirection := Forward_Left;
               elsif not rightMeasurement.WithinThreshold and leftMeasurement.WithinThreshold then
                  panicDirection := Forward_Left;
               else
                  -- close left and right or only not close front
                  -- let think decide, no good way for handling this
                  inPanic := False;
               end if;
            end if;
         end if;
         
         FnattControl.SetPanicMode(inPanic);
         
         if inPanic then
            FnattControl.SetDirectionChoice(panicDirection);
         end if;
         
         delay until Deadline;
      end loop;
         end sense;
end Sense_Task_Pkg;
