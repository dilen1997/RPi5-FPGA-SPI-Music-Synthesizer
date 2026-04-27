# RPi5 to FPGA SPI Music Synthesizer

## Project Overview
This project demonstrates a hardware-software co-design approach to real-time audio synthesis. A **Raspberry Pi 5** (Master) communicates with an **Altera DE10-Lite FPGA** (Slave) via the **SPI protocol** to generate musical tones and visual patterns based on character inputs.

## Technical Architecture
The system is built on the MAX 10 FPGA using several custom Verilog modules:
* **SPI Slave Interface (`spi_slave.v`):** Handles synchronous serial communication and data latching from the Pi.
* **Frequency Generator (`square_wave_gen.v`):** Converts received data into precise square wave frequencies for audio output.
* **Visual Integration (`led_dancer.v` & `stopwatch_display.v`):** Provides real-time visual feedback and timing status on the FPGA's LEDs and 7-segment displays.
* **Activity Detection (`activity_detector.v`):** Monitors the bus for active communication to manage system states.

## Tools & Technologies
* **Hardware:** Raspberry Pi 5, Altera DE10-Lite (MAX 10) FPGA.
* **Languages/Tools:** Verilog, Quartus Prime, Python/C (for the Pi Master).
* **Protocols:** SPI (Serial Peripheral Interface).
