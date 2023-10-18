--with MyController; -- This embeds and instantiates the MyController package
--with FnattController;

-- NOTE ----------
-- See the MyController_empty package first for a single file empty Sense-Think-Act (STA) template
-- The MyController package contains a better structured STA template with each task having its own file
-- Build your own controller from scratch using the template and structured coding principles as a guide line.
-- Use
------------------

--Empty main running as a task currently set to lowest priority. Can be used as it is a normal task!
-- with MicroBit.MotorDriver; use MicroBit.MotorDriver;
-- with MicroBit.Ultrasonic;

with Sense_Task_Pkg;
with Think_Task_Pkg;
with Act_Task_Pkg;

procedure Main with Priority => 0 is
   -- package forwardSensor is new MicroBit.Ultrasonic(MicroBit.MB_P1, MicroBit.MB_P0);
   -- package rightSensor is new MicroBit.Ultrasonic(MicroBit.MB_P12, MicroBit.MB_P8);

   begin
       -- MicroBit.MotorDriver.Servo(1, 90);

   loop -- We need a main loop, otherwise it constantly reboots!
        -- A reboot can be seen in the Serial Ports (View -> Serial Port, select com port, set baudrate to 115200 and press reset button on Microbit)
        -- Every time the Micro:Bit reboots it will begin with a "0" symbol in your Serial Port monitor.
      null;
   end loop;
end Main;
