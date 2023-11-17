with System;
with Ada.Interrupts;
with nRF.GPIO; use nRF.GPIO;
with NRF_SVD.GPIO; use NRF_SVD.GPIO;
with nRF.Interrupts;
with nRF.Events;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Interrupts.Names; 
with MicroBit.Console; use MicroBit.Console;
use MicroBit;
with HAL; use HAL;
with Ada.Containers.Generic_Array_Sort;
with Fnatt_Distance; use Fnatt_Distance;

generic
   TriggerPin: GPIO_Point;
   EchoPin: GPIO_Point;
package Fnatt_Ultrasonic_Sensor is
   type MeasurementArrayRange is new Natural range 0..6;
   procedure SetMaximumDistance(Distance: DistanceCentimeter);
   --  procedure SetAmountOfMeasurements(amount: MeasurementArrayRange);
   function ReadRaw return DistanceCentimeter;
   function Read return DistanceCentimeter;
private
   
  
   ConversionFactor: constant Integer := 100*343/2;--Should be calibrated with temperature.
 
   type DistanceArray is array(Natural range <>) of DistanceCentimeter;
   type Edge is (Falling, Rising);
   --  --    with Size => 1;
   --  for Edge use (Falling => False, Rising => True);
   procedure Initialize;
   procedure SendTrigger;
   function WaitForEdge(Timeout: Time_Span; State: Boolean) return Time;
   procedure Sort is new Ada.Containers.Generic_Array_Sort(Natural, DistanceCentimeter, DistanceArray);
   FallingEdgeDeadline: Time_Span:= Milliseconds(20);
   --  AmountOfMeasurements: MeasurementArrayRange:=6;
end Fnatt_Ultrasonic_Sensor;
