package body Sense_Task_Pkg is
   
   task body sense is
      leftMeasurement: Measurement :=(Distance=> MaximumDistance,
                                      Threshold => ThresholdValue,
                                      WithinThreshold => False,
                                      Direction =>FnattController.Left);
      frontMeasurement: Measurement :=(Distance=> MaximumDistance,
                                       Threshold => ThresholdValue,
                                       WithinThreshold => False,
                                      Direction => FnattController.Front);
      rightMeasurement: Measurement :=(Distance=> MaximumDistance,
                                       Threshold => ThresholdValue,
                                       WithinThreshold => False,
                                       Direction => FnattController.Right);
      Measurements: MeasurementsArray := (leftMeasurement, frontMeasurement, rightMeasurement);
      Deadline: Ada.Real_Time.Time;
      currentState: State;     
    begin
      currentState := Init;
      Microbit.Console.Put_Line("Sense: " & currentState'Image);
      
      leftSensor.SetMaximumDistance(MaximumDistance);
      frontSensor.SetMaximumDistance(MaximumDistance);
      rightSensor.SetMaximumDistance(MaximumDistance);

      currentState:= Normal;
      loop
         Deadline:= Ada.Real_Time.Clock + Ada.Real_Time.Milliseconds(1000);
         
         --Microbit.Console.Put_Line("P025: " & nRF.Device.P25.Set'Image);

         for index in Measurements'Range loop
            case Measurements(index).Direction is 
              when Left => Measurements(index).Distance:= leftSensor.Read;
              when Front => Measurements(index).Distance:= frontSensor.Read;
              when Right => Measurements(index).Distance:= rightSensor.Read;
            end case;
              MicroBit.Console.Put_Line(Measurements(index).Direction'Image & ": " & Measurements(index).Distance'Image);
              FnattControl.SetDistance(Measurements(index).Direction, Measurements(index).Distance);
            Measurements(index).WithinThreshold := (if Measurements(index).Distance <= Measurements(index).Threshold then True else False);
         end loop;
         
         
         
         --  if frontMeasurement.WithinThreshold  then
         --     if leftMeasurement.WithinThreshold and rightMeasurement.Threshold then
         --        FnattControl.ChoiceDirection(Backward);
         --     elsif leftMeasurement.WithinThreshold and not rightMeasurement.Threshold then
         --        FnattControl.ChoiceDirection(Backward_Right);
         --     else
         --        FnattControl.SetDirectionChoice(Backward_Left);
         --     end if;
         --  else
         --     if leftMeasurement.WithinThreshold and rightMeasurement.Threshold then
         --        FnattControl.ChoiceDirection(Forward);
         --     elsif leftMeasurement.WithinThreshold and not rightMeasurement.Threshold then
         --        FnattControl.ChoiceDirection(Forward_Right);
         --     else
         --        FnattControl.ChoiceDirection(Forward_Left);
         --     end if;
         --  end if;
           
         delay until Deadline;
      end loop;
         end sense;
end Sense_Task_Pkg;
