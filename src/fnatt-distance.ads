package Fnatt.Distance is

   type DistanceCentimeter is new Float range 0.0 .. 400.0;
   type DistanceMillimeter is new Float range 0.0 .. 4000.0;
   type DistanceMeter is new Float range 0.0 .. 4.0;
   --  type UnitOfMeasurement is (MillimeterUnit, CentimeterUnit);
   --  type Value
   --    (unit: UnitOfMeasurement) is
   --   record
   --     case unit is
   --        when CentimeterUnit =>
   --           Centimeter : Float range 0.0 .. 400.0;
   --        when MillimeterUnit =>
   --           Millimeter : Float range 0.0 .. 4000.0;
      --end case;
      --end record;
end Fnatt.Distance;
