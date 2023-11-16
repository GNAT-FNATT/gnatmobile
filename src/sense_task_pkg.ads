with FnattController; use FnattController;
with Fnatt_Distance; use Fnatt_Distance;
with Fnatt_Ultrasonic_Sensor;
with Fnatt_Crash;
with Ada.Real_Time;
with MicroBit.MotorDriver;
with System;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.Console;
use MicroBit;
with nRF.Device; use nRF.Device;
with HAL;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;


package Sense_Task_Pkg is

   package frontUltrasonicSensor is new Fnatt_Ultrasonic_Sensor(MicroBit.MB_P0, MicroBit.MB_P1);
   package rightUltrasonicSensor is new Fnatt_Ultrasonic_Sensor(MicroBit.MB_P8, MicroBit.MB_P2);
   package leftUltrasonicSensor is new Fnatt_Ultrasonic_Sensor(MicroBit.MB_P13, MicroBit.MB_P12);
   --  package detection is new fnatt.crash_detection(fnatt.crash.X);
   MaximumDistance: constant DistanceCentimeter:=50;
   ThresholdValue: constant DistanceCentimeter:= 5;
  -- type A is array(Natural range <>) of fnatt.Ultrasonic_sensor;
   type State is (Init, Normal, Panic);
   type Measurement is record
      Distance: DistanceCentimeter;
      Direction: DistanceDirections;
   --   Sensor: fnatt.Ultrasonic_sensor;
      Threshold: DistanceCentimeter;
      WithinThreshold: Boolean;
   end record;
   type MeasurementAccess is access all Measurement;
   type MeasurementsArray is array(DistanceDirections) of Measurement;
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
