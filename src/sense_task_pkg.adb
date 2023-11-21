with ada.Real_Time; use ada.Real_Time;
with MicroBit.Console; use MicroBit.Console;

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
      rightMeasurement: Measurement := (Distance=> MaximumDistance,
                                       Threshold => ThresholdValue,
                                       WithinThreshold => False,
                                       Direction => FnattController.RightSensor);
      Measurements: MeasurementsArray := (leftMeasurement, frontMeasurement, rightMeasurement);
      Deadline: Ada.Real_Time.Time;
      currentState: State;     
      timeTaken: Time_Span;
      myClock: Time;
    begin
      currentState := Init;
      -- Microbit.Console.Put_Line("Sense: " & currentState'Image);
      
      leftUltrasonicSensor.SetMaximumDistance(MaximumDistance);
      frontUltrasonicSensor.SetMaximumDistance(MaximumDistance);
      rightUltrasonicSensor.SetMaximumDistance(MaximumDistance);

      currentState:= Normal;
      loop
         myClock := Clock;
         Deadline:= Ada.Real_Time.Clock + Ada.Real_Time.Milliseconds(200);
         
         for index in Measurements'Range loop
            case Measurements(index).Direction is 
               when LeftSensor => Measurements(index).Distance := leftUltrasonicSensor.ReadRaw;
               when frontSensor => Measurements(index).Distance := frontUltrasonicSensor.ReadRaw;
               when RightSensor => Measurements(index).Distance := rightUltrasonicSensor.ReadRaw;
            end case;
            
            MicroBit.Console.Put_Line(Measurements(index).Direction'Image & ": " & Measurements(index).Distance'Image);
            FnattControl.SetDistance(Measurements(index).Direction, Measurements(index).Distance);
            Measurements(index).WithinThreshold := (if Measurements(index).Distance <= Measurements(index).Threshold then True else False);
         end loop;
         
         
         if Measurements(FrontSensor).WithinThreshold  then
            FnattControl.SetPanicMode(True);
            -- close front, left and right
            if Measurements(LeftSensor).WithinThreshold and Measurements(RightSensor).WithinThreshold then
               FnattControl.SetDirectionChoice(Backward);
            -- close front, left and not right
            elsif Measurements(LeftSensor).WithinThreshold and not Measurements(RightSensor).WithinThreshold then
               FnattControl.SetDirectionChoice(Backward_Right);
            
            -- close front, not left and right
            elsif not Measurements(LeftSensor).WithinThreshold and Measurements(RightSensor).WithinThreshold then
               FnattControl.SetDirectionChoice(Backward_Left);
            else
               -- close front, not left and not right
               FnattControl.SetDirectionChoice(Rotating_Right);
            end if;
         else
            FnattControl.SetPanicMode(True);
            -- not close front
            -- close left and close right
            if Measurements(LeftSensor).WithinThreshold and Measurements(RightSensor).WithinThreshold then
               FnattControl.SetDirectionChoice(Forward);
            -- close left and not close right
            elsif Measurements(LeftSensor).WithinThreshold and  not Measurements(RightSensor).WithinThreshold then
               FnattControl.SetDirectionChoice(Forward_Right);
            -- not close left and close right
            elsif not Measurements(LeftSensor).WithinThreshold and Measurements(RightSensor).WithinThreshold then
               FnattControl.SetDirectionChoice(Forward_Left);
            else
               -- not close to anything
               -- turn off panic mode
               FnattControl.SetPanicMode(False);
            end if;
         end if;
         
         timeTaken := Clock - myClock;
         
         -- Put_Line(To_Duration(timeTaken)'Image);
           
         delay until Deadline;
      end loop;
         end sense;
end Sense_Task_Pkg;
