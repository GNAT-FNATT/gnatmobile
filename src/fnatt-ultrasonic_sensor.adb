with MicroBit.TimeHighspeed; use MicroBit.TimeHighspeed;
with nRF; use nRF;
with System;
with Ada.Interrupts;
with HAL; use HAL;
with System.Machine_Code; use System.Machine_Code;
with fnatt.Distance; use fnatt.Distance;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Containers.Generic_Array_Sort;
package body Fnatt.ultrasonic_sensor is
   Trigger: GPIO_Point;
   Echo: GPIO_Point;
   
   
   procedure Initialize is
   begin
      Trigger:= TriggerPin;
      Echo := EchoPin;
      Trigger.Configure_IO ((Mode=> Mode_Out,
                             Resistors => No_Pull,
                             Input_Buffer => Input_Buffer_Disconnect,
                             Drive => Drive_S0S1,
                             Sense=> Sense_Disabled));
      Trigger.Clear;
      Echo.Configure_IO((Mode=> Mode_In,
                         Resistors => No_Pull,
                         Input_Buffer => Input_Buffer_Connect,
                         Drive => Drive_S0S1,
                         Sense=> Sense_Disabled));
      Echo.Clear;
   end Initialize;
   procedure SetMaximumDistance(Distance: DistanceCentimeter) is
   begin
       FallingEdgeDeadline:= Microseconds(Integer(Distance)*10**6 /ConversionFactor);
   end SetMaximumDistance;
   procedure SetAmountOfMeasurements(amount: Natural) is
   begin
      AmountOfMeasurements:= amount;
   end SetAmountOfMeasurements;
     
   function Read return DistanceCentimeter is
      Measurements: DistanceArray(0..AmountOfMeasurements);
   begin
      
      for i in Measurements'Range loop
         Measurements(i):=ReadRaw;
      end loop;
      --Put_Line("Measurements: " & Measurements'Image);
      Sort(Measurements);
      --Put_Line("Measurements: " & Measurements'Image);
      return Measurements(Measurements'Length/2);
   end Read;
   
   -- Function to read distance from sensor
   -- @returns Distance | If sensor is degraded or does not respond within given timeframe, maximum distance is assumed. 
   function ReadRaw return DistanceCentimeter is
      RisingTimestamp: Time;
      FallingTimestamp: Time;
   begin
      SendTrigger;
      RisingTimestamp := WaitForEdge(Milliseconds(1), True);
      if RisingTimestamp = Time_First then
         --Sensor is regarded as degraded if it does not reply within deadline
         return DistanceCentimeter(To_Duration(FallingEdgeDeadline) * ConversionFactor);
      end if;
        
      FallingTimestamp:= WaitForEdge(FallingEdgeDeadline, False);
      if FallingTimestamp = Time_First then
         return DistanceCentimeter(To_Duration(FallingEdgeDeadline) * ConversionFactor);
      end if;
      return DistanceCentimeter(To_Duration(FallingTimestamp - RisingTimestamp)* ConversionFactor);
   end ReadRaw;
   -- Procedure for triggering measurement of HC-SR04.
   -- Will send a high pulse of about 10uS. Sensor seems to accept pulses upwards to 100uS, 
   -- timing does not seem to be that sensitive.
   procedure SendTrigger is
   begin
      Trigger.Set;
      Delay_Us(10);
      Trigger.Clear;
   end SendTrigger;
   
   -- Generalized function to measure for a state within a timeout.
   -- @param Timeout: Time_Span | Amount of time given before discarding result.
   -- @param State: Boolean     | State/Edge to look for. 
   -- @returns Time             | Will return timestamp if successful within timeout, else Time_First. 
   function WaitForEdge(Timeout: Time_Span; State: Boolean) return Time is
      Deadline: constant Time:= Clock + Timeout;
   begin
      Wait: loop
         exit Wait when Clock > Deadline;
         if Echo.Set = State then
            return Clock;
         end if;
      end loop Wait;
      return Time_First;
   end WaitForEdge;  
begin
   Initialize;
end Fnatt.ultrasonic_sensor;
