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
   
   procedure SetMaximumDistance(Distance: DistanceCentimeter);
   procedure SetAmountOfMeasurements(amount: Natural);
   function ReadRaw return DistanceCentimeter;
   function Read return DistanceCentimeter;
private
 
   FallingEdgeDeadline: Time_Span:= Milliseconds(20);
   AmountOfMeasurements: Natural:=6;
   ConversionFactor: constant Integer := 100*400/2;
   type DistanceArray is array(Natural range <>) of DistanceCentimeter;
   type Edge is (Falling, Rising);
   --  --    with Size => 1;
   --  for Edge use (Falling => False, Rising => True);
   procedure Initialize;
   procedure SendTrigger;
   function WaitForEdge(Timeout: Time_Span; State: Boolean) return Time;
   procedure Sort is new Ada.Containers.Generic_Array_Sort(Natural, DistanceCentimeter, DistanceArray);
end Fnatt_Ultrasonic_Sensor;
