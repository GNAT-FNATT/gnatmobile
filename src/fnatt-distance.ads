package Fnatt.Distance is
   type DistanceCentimeterPrecise is new Float range 0.0 .. 400.0;
   type DistanceCentimeter is new Natural range 0 .. 400;

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
end Fnatt.Distance;
