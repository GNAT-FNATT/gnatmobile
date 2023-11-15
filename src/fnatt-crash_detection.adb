with nRF.GPIO.Tasks_And_Events;
with nRF.Events;               
with nRF.Interrupts;
with nRF.GPIO;
with nRF.Device;
with NRF_SVD.GPIO; use NRF_SVD.GPIO;
with MicroBit.I2C;
with MicroBit.IOsForTasking;
with HAL.I2C;
with HAL;
with MicroBit.Console;
with nRF; use nRF;
package body fnatt.crash_detection is
   
   --Status: HAL.I2C.I2C_Status;
   
   --Accelerometer: LSM303AGR.LSM303AGR_Accelerometer(MicroBit.I2C.Controller);
   I2CPort: HAL.I2C.Any_I2C_Port:= MicroBit.I2C.Controller;
   function I2C_Write(Address: HAL.I2C.I2C_Address; 
                         Register: HAL.Uint16; 
                         Data: HAL.Uint8) return HAL.I2C.I2C_Status is
         Status : HAL.I2C.I2C_Status := HAL.I2C.Err_Error;      
      begin
       I2CPort.Mem_Write(Addr => Address,
                       Mem_Addr => Register,
                     Mem_Addr_Size => HAL.I2C.Memory_Size_8b,
                   Data => (1 => Data),
                 Status => Status);
      --  I2CPort.Mem_Write_Buffer(Addr => Address,
      --                           Data =>(1, Data),
      --                           Status => Status);
         return Status;
      end I2C_Write;
      function I2C_Read(Address: HAL.I2C.I2C_Address;
                        Register: HAL.UInt16)
                        return HAL.I2C.I2C_Data is
         Status : HAL.I2C.I2C_Status := HAL.I2C.Err_Error;
         Data: HAL.I2C.I2C_Data (1.. 1);
         
      begin
         I2CPort.Mem_Read(Addr => Address,
                          Mem_Addr => Register,
                          Mem_Addr_Size => HAL.I2C.Memory_Size_8b,
                          Data => Data,
                          Status => Status);
      MicroBit.Console.Put_Line("Status of read: " & Status'Image);
         return Data;
      end I2C_Read;
   procedure Initialize is
      
      
     
      Config: nRF.GPIO.GPIO_Configuration:= (Resistors => nRF.GPIO.Pull_Up,
                                           Mode=> nRF.GPIO.Mode_In,
                                           Input_Buffer => nRF.GPIO.Input_Buffer_Connect,
                                           Sense => nRF.GPIO.Sense_For_Low_Level,
                                             Drive => nRF.GPIO.Drive_S0S1);
      --  index : nRF.GPIO.GPIO_Pin_Index:= 25;
      --  InterruptPin: nrf.GPIO.GPIO_Point := index;
      value: HAL.UInt8;
      Stat: HAL.I2C.I2C_Status;
      buffer: HAL.I2C.I2C_Data (1..2);
   begin
     
      -- https://github.com/microbit-foundation/microbit-v2-hardware/blob/main/V2.21/MicroBit_V2.2.1_nRF52820%20schematic.PDF
      --  nRF.GPIO.Tasks_And_Events.Enable_Event(
      --                                        Chan =>nRF.GPIO.Tasks_And_Events.GPIOTE_Channel(0),
      --                                         GPIO_Pin => nRF.Device.P25.Pin, -- Pin P0.25 on nRF52833 is connected to I2C interrupt
      --                                         Polarity => nRF.GPIO.Tasks_And_Events.Rising_Edge);
     -- nRF.Events.Disable_Interrupt (nRF.Events.GPIOTE_PORT);
     -- NRF_SVD.GPIO.GPIO_Periph.DETECTMODE.DETECTMODE := NRF_SVD.GPIO.Default;
     -- nRF.Events.Clear (nRF.Events.GPIOTE_PORT); --clear any prior events of GPIOTE_PORT
     -- https://github.com/microbit-foundation/microbit-v2-hardware/blob/main/V2.21/MicroBit_V2.2.1_nRF52820%20schematic.PDF
     -- Pin P0.25 on nRF52833 is connected to I2C interrupt
      --InterruptPin.Configure_IO(Config);
     
      --nrf.Device.P25.Set;
      
    
      --nRF.Events.Enable_Interrupt (nRF.Events.GPIOTE_PORT); --enable interrupt of event
      --nRF.Interrupts.Enable (nRF.Interrupts.GPIOTE_Interrupt); --enable interrupt of device
      nRf.Device.P25.Configure_IO(Config);
      
      --  MicroBit.Console.Put_Line("P25 " & nRF.Device.p25.Set'Image);
      --  DataWrite := 16#57#;
      --  DataWrite:= 2#01010111#;
      --  DataRead := (1 => DataWrite);
       
      
      MicroBit.Console.Put_Line("Begin");
      --DataRead:= (16#08#,16#01#, 16#00#);
     
      MicroBit.I2C.Initialize;
     
      --I2CPort.Mem_Write(16#70#, 16#12#,HAL.I2C.Memory_Size_8b, DataRead, Status);
       --Microbit.Console.Put_Line("Turning off Target MCU: " & I2C_Write(16#70#,16#08#,d)'Image);
      --Microbit.Console.Put_Line("Turning off Target MCU: " & I2C_Write(16#70#,16#07#,16#08#)'Image);
      --  Interrupt1.AsValue := 2#00111111#;
      --  MicroBit.Console.Put_Line("Before I2C Read" & DataRead'Image);
      --  -- Setup LSM303AGR
      value:=2#00010111#;
      MicroBit.Console.Put_Line("Writing CTRL_REG1_A: " & I2C_Write(Accelerometer_Address, CTRL_REG1_A, 2#00010111#)'Image);
      MicroBit.Console.Put_Line("Reading CTRL_REG1_A |"&value'Image &" : " & I2C_Read(Accelerometer_Address, CTRL_REG1_A)'Image);
      
      value := 0;
      MicroBit.Console.Put_Line("Writing Act_THS_A: " & I2C_Write(Accelerometer_Address, Act_THS_A, value)'Image);
      MicroBit.Console.Put_Line("Reading Act_THS_A |"&value'Image &" : " & I2C_Read(Accelerometer_Address, Act_THS_A)'Image);
      
      
      --  value := 2#10000000;
      --  MicroBit.Console.Put_Line("Writing Act_THS_A: " & I2C_Write(Accelerometer_Address, CTRL_REG5_A, value)'Image);
      --  MicroBit.Console.Put_Line("Reading Act_THS_A |"&value'Image &" : " & I2C_Read(Accelerometer_Address, CTRL_REG5_A)'Image);
  
      MicroBit.Console.Put_Line("WHOAMI Accelerometer: " & I2C_Read(Accelerometer_Address, 16#0F#)'Image);
        
      MicroBit.Console.Put_Line("WHOAMI Magnetometer: " & I2C_Read(Magnetometer_Address, 16#4F#)'Image);
  ----
    
      value := 2#01000011#;
      MicroBit.Console.Put_Line("Writing CFG_REG_A_M: " & I2C_Write(Magnetometer_Address, CFG_REG_A_M, value)'Image);
delay 0.01;
      MicroBit.Console.Put_Line("Reading CFG_REG_A_M |"&value'Image &" : " & I2C_Read(Magnetometer_Address, CFG_REG_A_M)'Image);

      
      --  MicroBit.Console.Put_Line("Writing_buff CFG_REG_A_M: ");
      --  buffer(1) := HAL.UInt8(CFG_REG_A_M);
      --  buffer(2) := value;
      --  I2CPort.Mem_Write_Buffer(
      --                           Addr=> Magnetometer_Address,
      --                           Data=> buffer,
      --                           Status=>Stat);
      --  MicroBit.Console.Put_Line("Reading CFG_REG_A_M |"&value'Image &" : " & I2C_Read(Magnetometer_Address, CFG_REG_A_M)'Image);
      --  
      
      value:=2#00000011#;
      MicroBit.Console.Put_Line("Writing CFG_REG_A_M: " & I2C_Write(Magnetometer_Address, CFG_REG_A_M,value)'Image);
delay 0.01;
      MicroBit.Console.Put_Line("Reading CFG_REG_A_M |"& value'Image &" : " & I2C_Read(Magnetometer_Address, CFG_REG_A_M)'Image);
      
      value:=2#00001010#;
      MicroBit.Console.Put_Line("Writing CFG_REG_C_M: " & I2C_Write(Magnetometer_Address, CFG_REG_C_M,value)'Image);
delay 0.01;
      MicroBit.Console.Put_Line("Reading CFG_REG_C_M |"& value'Image &" : " & I2C_Read(Magnetometer_Address, CFG_REG_C_M)'Image);
      
      value:=2#00000100#;
      MicroBit.Console.Put_Line("Writing INT_CTRL_REG_M: " & I2C_Write(Magnetometer_Address, INT_CTRL_REG_M, value)'Image);
      MicroBit.Console.Put_Line("Reading INT_CTRL_REG_M |"& value'Image &" : " & I2C_Read(Magnetometer_Address, INT_CTRL_REG_M)'Image);
      --MicroBit.Console.Put_Line("Writing LSM303AGR CTRL_REG3_A " & I2C_Write(Accelerometer_Address, CTRL_REG4_A, 16#80#)'Image);
     --   MicroBit.Console.Put_Line("Writing INT1_CFG_A " & I2C_Write(Accelerometer_Address, INT1_CFG_A, 2#00111111#)'Image);
     --   MicroBit.Console.Put_Line("Writing INT1_CFG_A " & I2C_Read(Accelerometer_Address, INT1_CFG_A)'Image);
     --   MicroBit.Console.Put_Line("Writing INT1_THS_A " & I2C_Write(Accelerometer_Address, INT1_THS_A, 2#00000000#)'Image);
     --   MicroBit.Console.Put_Line("Writing INT1_DURATION_A " & I2C_Write(Accelerometer_Address, INT1_DURATION_A, 2#11111111#)'Image);
     --   MicroBit.Console.Put_Line("Writing CTRL_REG5_A " & I2C_Write(Accelerometer_Address, CTRL_REG5_A, 2#00000000#)'Image);
     --   MicroBit.Console.Put_Line("Writing CTRL_REG5_A " & I2C_Write(Accelerometer_Address, INT_CTRL_REG_M, 2#11100111#)'Image);
     --   MicroBit.Console.Put_Line("Writing CTRL_REG3_A " & I2C_Write(Accelerometer_Address, CTRL_REG3_A, 2#01100000#)'Image);
     --   --  MicroBit.Console.Put_Line("Writing LSM303AGR CTRL_REG3_A " & I2C_Write(Accelerometer_Address, 16#26#, 2#11111111#)'Image);
     --  MicroBit.Console.Put_Line("Writing CTRL_REG3_A " & I2C_Write(Accelerometer_Address, 16#25#, 2#0000000#)'Image);
     --  MicroBit.Console.Put_Line("Writing CTRL_REG3_A " & I2C_Write(Accelerometer_Address, 16#63#, 2#0000100#)'Image);
      --  Interrupt1.AsValue := 2#11111111#;
      --  MicroBit.Console.Put_Line("Writing LSM303AGR INT1_THS_A " & I2C_Write(Accelerometer_Address, INT1_THS_A, Interrupt1.AsValue)'Image);
      --  MicroBit.Console.Put_Line("Read INT1: " & I2C_Read(Accelerometer_Address, INT1_CFG_A)'Image);
      --  MicroBit.Console.Put_Line("Read CTRL_REG3: " & I2C_Read(Accelerometer_Address, CTRL_REG3_A)'Image);
      --  MicroBit.Console.Put_Line("Read INT1_THS_A: " & I2C_Read(Accelerometer_Address, INT1_THS_A)'Image);
      --  MicroBit.Console.Put_Line("Read INT1_SRC_A: " & I2C_Read(Accelerometer_Address, INT1_SRC_A)'Image);
      

   end Initialize;
    protected body Handler is
         procedure InterruptServiceRoutine is
            LatchRegisterPort0: NRF_SVD.GPIO.LATCH_Register;
         begin
     
          MicroBit.Console.Put_Line("Interrupt");
         nRF.Events.Disable_Interrupt (nRF.Events.GPIOTE_PORT); --disable interrupt of event so that we do things without interruption
         LatchRegisterPort0 := NRF_SVD.GPIO.GPIO_Periph.LATCH;
         NRF_SVD.GPIO.GPIO_Periph.LATCH := NRF_SVD.GPIO.GPIO_Periph.LATCH;
        
            if LatchRegisterPort0.Arr(nRF.Device.P25.Pin) = NRF_SVD.GPIO.Latched then
               MicroBit.Console.Put_Line("Event");
               --MicroBit.Console.Put_Line(I2C_Read(Accelerometer_Address, INT1_SRC_A)'Image);
            end if;
            nRF.Events.Clear (nRF.Events.GPIOTE_PORT); --we must clear the event otherwise it will trigger again. If LDETECT it will always trigger if LATCH is not zero
            nRF.Events.Enable_Interrupt (nRF.Events.GPIOTE_PORT); --enable interrupt of event   
         end InterruptServiceRoutine;
      end Handler;
begin
   Initialize;
end fnatt.crash_detection;
