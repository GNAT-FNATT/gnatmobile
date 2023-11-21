with MicroBit.Types; use MicroBit.Types;
with ada.Real_Time; use ada.Real_Time;

package body Act_Task_Pkg is

   task body act is
      myClock: Time;
      -- timeTaken: Time_Span;
      driveDirection: Directions;
      speed: Speeds;
      waitTime: Time_Span := Milliseconds(200);
   begin
      loop
         myClock := Clock;
       
         driveDirection := FnattControl.GetDirectionChoice;
         speed := FnattControl.GetSpeeds;
         
         -- actually drive

         MicroBit.MotorDriver.Drive(driveDirection, speed);
         
         Put_Line("Driving direction: " & Directions'Image(driveDirection));
         Put_Line("Driving speed: " & speed'Image);
         
         -- FnattControl.SetSpeeds(Speeds(4095,4095,4095,4095));
         
         --timeTaken := Clock-myClock;
         
         --Put_Line("ACT MS: " & To_Duration(timeTaken)'Image);
         
         delay until myClock + waitTime;
      end loop;
   end act;

end Act_Task_Pkg;
