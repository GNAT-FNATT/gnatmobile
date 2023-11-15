
with fnatt.crash;
with MicroBit.I2C;
with LSM303AGR;
with HAL;
with HAL.I2C;
with System;
With Ada.Interrupts.Names;
generic
--     CrashDirection: fnatt.crash.Crash;
   
package fnatt.crash_detection is
   protected Handler is
     -- pragma Interrupt_Priority (System.Interrupt_Priority'First);
   private
      procedure InterruptServiceRoutine;
     -- pragma Attach_Handler (InterruptServiceRoutine, Ada.Interrupts.Names.GPIOTE_Interrupt);
   end Handler;
private 
  
   procedure Initialize;
   type Register is new HAL.UInt16;
   CTRL_REG1_A : constant HAL.UInt16 := 16#20#;
   CTRL_REG2_A : constant HAL.UInt16 := 16#21#;
   CTRL_REG3_A : constant HAL.UInt16:= 16#22#;
   CTRL_REG4_A : constant  HAL.UInt16 := 16#23#;
   CTRL_REG5_A : constant HAL.UInt16 := 16#24#;
   CTRL_REG6_A : constant Register := 16#25#;
   Act_THS_A: constant HAL.UInt16:= 16#3E#;
   
   -- https://www.st.com/resource/en/datasheet/lsm303agr.pdf
   -- Page 44
   -- Interrupt 1
   INT1_CFG_A: constant HAL.UInt16 := 16#30#;
   INT1_SRC_A: constant  HAL.UInt16:= 16#31#;
   INT1_THS_A: constant HAL.UInt16 := 16#32#;
   INT1_DURATION_A: constant HAL.UInt16 := 16#33#;
   -- Interrupt 2
   INT2_CFG_A: constant HAL.UInt16 := 16#34#;
   INT2_SRC_A: constant HAL.UInt16 := 16#35#;
   INT2_THS_A: constant HAL.UInt16 := 16#36#;
   INT2_DURATION_A: constant HAL.UInt16 := 16#37#;
   -- Interrupt Magnetometer
   INT_CTRL_REG_M: constant HAL.UInt16 :=16#63#;
   INT_SOURCE_REG_M: constant HAL.UInt16:=16#64#;
   INT_THS_L_REG_M: constant HAL.UInt16:=16#65#;
   INT_THS_R_REG_M: constant HAL.UInt16:=16#66#;
   
   CFG_REG_A_M: constant HAL.UInt16 := 16#60#;
   CFG_REG_B_M: constant HAL.UInt16 := 16#61#;
   CFG_REG_C_M: constant HAL.UInt16 := 16#62#;
   Accelerometer_Address   : constant HAL.I2C.I2C_Address:= 16#32#;
   Accelerometer_Device_Id : constant HAL.UInt8 := 2#0011_0011#;

   Magnetometer_Address   : constant HAL.I2C.I2C_Address:= 16#3C#;
   Magnetometer_Device_Id : constant HAL.UInt8 := 2#0100_0000#;
   
   
   --  Type RegisterValue is array(0 ..7) of Boolean with Pack;
  
   
   
   Type RegisterValue(As_Array: Boolean) is record
      case As_Array is
      when False => AsValue: HAL.UInt8;
      when True => AsArray: HAL.UInt8_Array(1..1);
   end case;
   end record;
   Interrupt1: RegisterValue(As_Array => False);
   
   Type Config is record
      AOI: HAL.Bit := 0;    -- AOI         | And/Or combination of interrupt events
      SIXD: HAL.Bit :=0;    -- 6D          | 6-direction detection function enabled
      Z_HIGH: HAL.Bit:= 1;  -- ZHIE/ZUPE   | Enables interrupt generation on Z high event or on direction recognition
      Z_LOW: HAL.Bit:= 1;   -- ZLIE/ZDOWNE | Enables interrupt generation on Z low event or on direction recognition
      Y_HIGH: HAL.Bit:= 1;  -- YHIE/YUPE   | Enables interrupt generation on Y high event or on direction recognition
      Y_LOW: HAL.Bit:= 1;   -- YLIE/YDOWNE | Enables interrupt generation on Y low event or on direction recognition
      X_HIGH: HAL.Bit:= 1;  -- XHIE/XUPE   | Enables interrupt generation on X high event or on direction recognition
      X_LOW: HAL.Bit:= 1;   -- XLIE/XDOWNE | Enables interrupt generation on X low event or on direction recognition
   end record;
  -- a: RegisterValue => (1 => Config);
   
end fnatt.crash_detection;
