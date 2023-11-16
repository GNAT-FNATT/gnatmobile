package body Sense_Task_Pkg is
   
   task body sense is
      leftMeasurement: Measurement :=(Distance=> MaximumDistance,
                                      Threshold => ThresholdValue,
                                      WithinThreshold => False,
                                      Direction =>FnattController.LeftSensor);
      frontMeasurement: Measurement :=(Distance=> MaximumDistance,
                                       Threshold => ThresholdValue,
                                       WithinThreshold => False,
                                      Direction => FnattController.FrontSensor);
      rightMeasurement: Measurement :=(Distance=> MaximumDistance,
                                       Threshold => ThresholdValue,
                                       WithinThreshold => False,
                                       Direction => FnattController.RightSensor);
      Measurements: MeasurementsArray := (leftMeasurement, frontMeasurement, rightMeasurement);
      Deadline: Ada.Real_Time.Time;
      currentState: State;     
    begin
      currentState := Init;
      Microbit.Console.Put_Line("Sense: " & currentState'Image);
      
      leftUltrasonicSensor.SetMaximumDistance(MaximumDistance);
      frontUltrasonicSensor.SetMaximumDistance(MaximumDistance);
      rightUltrasonicSensor.SetMaximumDistance(MaximumDistance);

      currentState:= Normal;
      loop
         Deadline:= Ada.Real_Time.Clock + Ada.Real_Time.Milliseconds(50);
         
         for index in Measurements'Range loop
            case Measurements(index).Direction is 
              when LeftSensor => Measurements(index).Distance:= leftUltrasonicSensor.ReadRaw;
              when frontSensor => Measurements(index).Distance:= frontUltrasonicSensor.ReadRaw;
              when RightSensor => Measurements(index).Distance:= rightUltrasonicSensor.ReadRaw;
            end case;
              MicroBit.Console.Put_Line(Measurements(index).Direction'Image & ": " & Measurements(index).Distance'Image);
             -- FnattControl.SetDistance(Measurements(index).Direction, Measurements(index).Distance);
            Measurements(index).WithinThreshold := (if Measurements(index).Distance <= Measurements(index).Threshold then True else False);
         end loop;
         
        
         if Measurements(FrontSensor).WithinThreshold  then
            if Measurements(LeftSensor).WithinThreshold and Measurements(RightSensor).WithinThreshold then
               FnattControl.SetDirectionChoice(Backward);
            elsif Measurements(LeftSensor).WithinThreshold and  not Measurements(RightSensor).WithinThreshold then
               FnattControl.SetDirectionChoice(Backward_Right);
            else
               FnattControl.SetDirectionChoice(Backward_Left);
            end if;
         else
            if Measurements(LeftSensor).WithinThreshold and Measurements(RightSensor).WithinThreshold then
               FnattControl.SetDirectionChoice(Forward);
            elsif Measurements(LeftSensor).WithinThreshold and  not Measurements(RightSensor).WithinThreshold then
               FnattControl.SetDirectionChoice(Forward_Right);
            else
               FnattControl.SetDirectionChoice(Forward_Left);
            end if;
         end if;
           
         delay until Deadline;
      end loop;
         end sense;
end Sense_Task_Pkg;
