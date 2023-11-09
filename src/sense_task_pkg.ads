with FnattController; use FnattController;
with Fnatt.Distance; use Fnatt.Distance;
with Ada.Real_Time; use Ada.Real_Time;
with MicroBit.IOsForTasking; use MicroBit.IOsForTasking;
with MicroBit.MotorDriver; use MicroBit.MotorDriver;
with Ada.Execution_Time; use Ada.Execution_Time;
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

package Sense_Task_Pkg is


   type Pin_Status is (No_Pin, DOUBLE_PIN, Pin_0, Pin_1, Pin_2);

   type Signal_Edge is (Rising_Edge, Falling_Edge, Unknown);
    type UltrasonicSensor is record
      EchoPin: nRF.GPIO.GPIO_Point;
               TriggerPin: nRF.GPIO.GPIO_Point;
               RisingTimestamp: Time;
               FallingTimestamp: Time;
               Handled: Boolean := True;
               EchoStartTrigger: Boolean:= False;
               EchoStopTrigger: Boolean:= False;
               Distance: DistanceCentimeter;

   end record;
   FallingEdgeConfiguration: GPIO_Configuration := (Mode => Mode_In, Resistors=> Pull_Up,
                                                       Input_Buffer => Input_Buffer_Connect,
                                                       Sense => Sense_For_Low_Level,
                                                      Drive => Drive_S0S1);
   RisingEdgeConfiguration: GPIO_Configuration := (Mode => Mode_In, Resistors=> Pull_Down,
                                                       Input_Buffer => Input_Buffer_Connect,
                                                       Sense => Sense_For_High_Level,
                                                   Drive => Drive_S0S1);
   OutputConfiguration: GPIO_Configuration :=(Mode=> Mode_Out, Resistors => No_Pull,
                                              Input_Buffer => Input_Buffer_Connect,
                                              Sense => Sense_Disabled,
                                              Drive=> Drive_S0S1);
   UltrasonicConfiguration: GPIO_Configuration := (Mode => Mode_In, Resistors => Pull_Up,
                                                   Input_Buffer => Input_Buffer_Connect,
                                                   Sense => Sense_Disabled,
                                                  Drive => Drive_S0S1);


   type UltrasonicSensors is array(Natural range<>) of UltrasonicSensor;
   protected UltrasonicHandler is

      pragma Interrupt_Priority (System.Interrupt_Priority'First);

   private
      procedure InterruptServiceRoutine;
      pragma Attach_Handler(InterruptServiceRoutine, Ada.Interrupts.Names.GPIOTE_Interrupt);
   end UltrasonicHandler;
   --  protected Receiver is
   --
   --
   --  end Receiver;
   --   protected Receiver is  -- the first-level handler using interrupt priorities (all higher than application)
   --     function GetStatus return Pin;
   --     procedure SetStatus (S : Pin);
   --
    --pragma Interrupt_Priority (System.Interrupt_Priority'First);
   --
   --  private
   --     procedure InterruptServiceRoutine;
   --     pragma Attach_Handler (InterruptServiceRoutine, Ada.Interrupts.Names.GPIOTE_Interrupt);
   --     Status : Pin;
   --  end Receiver;
   task sense with Priority => 1;
end Sense_Task_Pkg;
