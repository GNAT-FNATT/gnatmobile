with FnattController; use FnattController;
with Fnatt.Distance; use Fnatt.Distance;
with fnatt.Ultrasonic_sensor;
with fnatt.crash_detection;
with fnatt.crash;
with Ada.Real_Time;
with MicroBit.MotorDriver;
with System;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Console;
use MicroBit;
with nRF.Device; use nRF.Device;
with HAL;

package Sense_Task_Pkg is

   package frontSensor is new fnatt.Ultrasonic_sensor(MicroBit.MB_P0, MicroBit.MB_P1);
   package rightSensor is new fnatt.Ultrasonic_sensor(MicroBit.MB_P8, MicroBit.MB_P2);
   package leftSensor is new fnatt.Ultrasonic_sensor(MicroBit.MB_P13, MicroBit.MB_P12);
   package detection is new fnatt.crash_detection;
   MaximumDistance: constant fnatt.Distance.DistanceCentimeter:=50;
   ThresholdValue: constant fnatt.Distance.DistanceCentimeter:= 5;
  -- type A is array(Natural range <>) of fnatt.Ultrasonic_sensor;
   type State is (Init, Normal, Panic);
   type Measurement is record
      Distance: fnatt.Distance.DistanceCentimeter;
      Direction: FnattController.DistanceDirections;
   --   Sensor: fnatt.Ultrasonic_sensor;
      Threshold: fnatt.Distance.DistanceCentimeter;
      WithinThreshold: Boolean;
   end record;
   type MeasurementsArray is array(Natural range <>) of Measurement;
   type ByteArray is array(0 ..7) of HAL.Bit
     with Component_Size => 1, Size => 8;

   type PanicDirection(As: Boolean:= False) is record
      case As is
         when True =>
            AsArray: ByteArray;
         when False =>
            AsValue: HAL.Uint8;
      end case;
    end record
    with Unchecked_Union;
   --    for PanicDirection use record
   --     AsValue at 0 range 0 .. 8;
   --     AsArray at 0 range 0 .. 8;
   --  end record;
    --  type Distance (Precise: Boolean:= False)
   --  is record
   --     case Precise is
   --        when True =>
   --           CentimeterPrecise: DistanceCentimeterPrecise;
   --        when False =>
   --           Centimeter: DistanceCentimeter;
   --     end case;
   --  end record
   --  with Unchecked_Union;
   task sense with Priority => 1;
end Sense_Task_Pkg;
