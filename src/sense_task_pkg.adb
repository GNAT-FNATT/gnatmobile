
--  with Fnatt.Ultrasonic_sensor;
with Fnatt.Distance; use Fnatt.Distance;
with MicroBit; use MicroBit;
with nRF.GPIO; use nRF.GPIO;
with nRF.Device; use nRF.Device;
with nRF; use nRF;
with Ada.Unchecked_Conversion; 
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Types; use MicroBit.Types;
with HAL; use HAL;
with System.Machine_Code; use System.Machine_Code;
--  with MicroBit.Time.Highspeed; use MicroBit.Time.Highspeed;
package body Sense_Task_Pkg is
    startTime: Time;
        
   left: UltrasonicSensor := (EchoPin => MB_P12, 
                              TriggerPin => MB_P13,
                              RisingTimestamp =>CLock ,
                              FallingTimestamp => Clock,
                              Handled => False,
                              EchoStartTrigger => False,
                              EchoStopTrigger => False,
                             Distance => 0.0);
   right: UltrasonicSensor := (EchoPin => MB_P2, 
                               TriggerPin => MB_P8,
                               RisingTimestamp => Clock,
                               FallingTimestamp => Clock,
                               Handled => False,
                               EchoStartTrigger => False,
                               EchoStopTrigger => False,
                              Distance =>0.0);
   front: UltrasonicSensor := (EchoPin => MB_P1,
                               TriggerPin => MB_P0,
                               RisingTimestamp => Clock,
                               FallingTimestamp => Clock,
                               Handled => False,
                               EchoStartTrigger => False,
                               EchoStopTrigger => False,
                              Distance => 0.0);
      
      trigger: GPIO_Point:= MB_P1;
      sensors: UltrasonicSensors:=(left, front, right);
      
   protected body UltrasonicHandler is
      
      procedure InterruptServiceRoutine is
         LatchRegisterPort0 : LATCH_Register; 
      begin
          nRF.Events.Disable_Interrupt (nRF.Events.GPIOTE_PORT); --disable interrupt of event so that we do things without interruption
         --Save Latched register's state
         LatchRegisterPort0 := GPIO_Periph.LATCH;  
         
         
          -- Clear the latched bits by writing High. see page 142 NRF52833 datasheet
         GPIO_Periph.LATCH := GPIO_Periph.LATCH;
        -- Put_Line("Interrupt");
         -- Loop through each sensor representation
         -- Check if latched
         for sensorIndex in sensors'Range  loop
              if GPIO_Periph.LATCH.Arr(sensors(sensorIndex).EchoPin.Pin) = Latched then 
               if sensors(sensorIndex).EchoPin.Set = True then
                  sensors(sensorIndex).RisingTimestamp := Clock;
                  sensors(sensorIndex).EchoPin.Configure_IO(FallingEdgeConfiguration);
                  sensors(sensorIndex).EchoStartTrigger := True;
                  
                  --Put_Line(sensors(sensorIndex).EchoPin'Image & "High " &  sensors(sensorIndex).RisingTimestamp'Image);
               elsif sensors(sensorIndex).EchoPin.Set = False then
                  sensors(sensorIndex).FallingTimestamp:= Clock;
                  sensors(sensorIndex).EchoStopTrigger:= True;
                  sensors(sensorIndex).EchoPin.Configure_IO(RisingEdgeConfiguration);
                -- Put_Line(sensors(sensorIndex).EchoPin'Image &"Low " & sensors(sensorIndex).FallingTimestamp'Image);
               end if;
               
               --  if sensors(sensorIndex).EchoPin.Set = True then
               --     --sensors(sensorIndex).EchoStartTrigger := True;
               --     sensors(sensorIndex).RisingTimestamp := Clock;
               --     sensors(sensorIndex).EchoPin.Configure_IO(FallingEdgeConfiguration);
               -- elsif  sensors(sensorIndex).EchoPin.Set = False then
               --     sensors(sensorIndex).EchoPin.Configure_IO(RisingEdgeConfiguration);
               --     sensors(sensorIndex).FallingTimestamp := Clock;
                 -- sensors(sensorIndex).EchoStopTrigger := True;
               --  end if;
              end if;
         end loop;
         nRF.Events.Clear (nRF.Events.GPIOTE_PORT); --we must clear the event otherwise it will trigger again. If LDETECT it will always trigger if LATCH is not zero
         nRF.Events.Enable_Interrupt (nRF.Events.GPIOTE_PORT); --enable interrupt of event   
      end InterruptServiceRoutine;
end UltrasonicHandler;
   task body sense is
      triggerTime: Time;
      deltaTime :Time_Span;
     
   begin
      Put_Line("Init");
      nRF.Events.Disable_Interrupt (nRF.Events.GPIOTE_PORT);
      GPIO_Periph.DETECTMODE.DETECTMODE := NRF_SVD.GPIO.Default;
      nRF.Events.Clear (nRF.Events.GPIOTE_PORT); --clear any prior events of GPIOTE_PORT
      nRF.Events.Enable_Interrupt (nRF.Events.GPIOTE_PORT); --enable interrupt of event
      nRF.Interrupts.Enable (nRF.Interrupts.GPIOTE_Interrupt); --enable interrupt of device
      trigger.Configure_IO(OutputConfiguration);
      trigger.Clear;
      for index in sensors'Range loop
         sensors(index).EchoPin.Clear;
         sensors(index).EchoPin.Configure_IO(FallingEdgeConfiguration);
         sensors(index).TriggerPin.Configure_IO(OutputConfiguration);
         Put_Line("Configuring " & sensors(index)'Image);
         Put_Line(GPIO_Periph.PIN_CNF(sensors(index).EchoPin.Pin).SENSE'Image);
      end loop;	
      --GPIO_Periph.PIN_CNF(MB_BTN_A.Pin).SENSE := High;
      --MB_BTN_A.Configure_IO(RisingEdgeConfiguration);
     
      Put_Line("Configuring " & trigger'Image); 
      loop
         startTime := Clock;
         for sensorIndex in sensors'Range loop
            triggerTime:= Clock;
            sensors(sensorIndex).TriggerPin.Set;
            delay until triggerTime + Microseconds(10);
            sensors(sensorIndex).TriggerPin.Clear;
            while(not(sensors(sensorIndex).EchoStopTrigger = True or Clock - triggerTime > ( Milliseconds(20))))loop
                Asm("nop");
            end loop;
           -- delay until (if sensors(sensorIndex).EchoStopTrigger =  True then Clock else triggerTime + Milliseconds(20));
         end loop;
         
         for index in sensors'Range loop
            if sensors(index).EchoStartTrigger = True then
               
               if sensors(index).EchoStopTrigger = True then
                  sensors(index).EchoStopTrigger:= False;
                  deltaTime := (sensors(index).FallingTimestamp - sensors(index).RisingTimestamp);          
                  deltaTime := (if deltaTime <= Microseconds(116) then Microseconds(116) else deltaTime);
                  deltaTime:= (if deltaTime > Milliseconds(20) then Milliseconds(20) else deltaTime);
                  deltaTime := deltaTime*172;
                  sensors(index).Distance := DistanceCentimeter(To_Duration(deltaTime)*100);
                 
               end if;
            else 
               sensors(index).Distance:= DistanceCentimeter(400);
            end if;
            sensors(index).EchoStartTrigger := False;
             Put_Line(sensors(index).EchoPin.Pin'Image & "| Rising: " & 
                             sensors(index).RisingTimestamp'Image & "| Falling: " & 
                             sensors(index).FallingTimestamp'Image & "| Delta: " &  
                        sensors(index).Distance'Image);
            
         end loop;
         Put_Line("");
         --  deltaTime:= left.FallingTimestamp - left.RisingTimestamp;
         --  Put_Line("'Delta: " & deltaTime'Image);
         --  end if;
         --  for sensorIndex in sensors'Range loop
         --        --  sensors(sensorIndex).EchoStartTrigger:= False;
         --        --  sensors(sensorIndex).EchoStopTrigger:= False;
         --        Put_Line(sensors(sensorIndex).RisingTimestamp'Image);
         --         Put_Line(sensors(sensorIndex).FallingTimestamp'Image);
         --     if sensors(sensorIndex).EchoStopTrigger = True  and sensors(sensorIndex).FallingTimestamp > sensors(sensorIndex).RisingTimestamp then
         --        sensors(sensorIndex).EchoStopTrigger:= False;
         --        deltaTime := sensors(sensorIndex).FallingTimestamp - sensors(sensorIndex).RisingTimestamp;
         --        deltaTime := deltaTime*400;
         --        deltaTime := deltaTime/2;
         --        deltaTime := (if deltaTime <= Time_Span_Zero then Microseconds(100) else deltaTime);
         --        deltaTime:= (if deltaTime > Milliseconds(20) then Milliseconds(20) else deltaTime);
         --        sensors(sensorIndex).Distance := DistanceCentimeter(To_Duration(deltaTime)*100); -- unsfafe
         --        Put_Line(sensors(sensorIndex).Distance'Image);
         --  
         --     end if;
         --       -- Put_Line(distance'Image);
         --  end loop;
         
    
         delay until startTime + Milliseconds(70);
      end loop;
         end sense;
end Sense_Task_Pkg;
