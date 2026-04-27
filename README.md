# RPi5 to FPGA SPI Music Synthesizer

## 📖 Project Overview
This project demonstrates a high-performance **Hardware-Software Co-Design** approach to real-time audio synthesis. It establishes a synchronous communication link between a **Raspberry Pi 5** (acting as the SPI Master) and an **Altera DE10-Lite (MAX 10) FPGA** (acting as the SPI Slave). 

The system processes character-based commands sent from the Pi via the SPI protocol to generate precise musical tones, visual LED patterns, and real-time status updates on the FPGA.

## 🚀 Key Features
* **Real-time SPI Bridge:** Low-latency data transfer between Linux-based software and hardware logic.
* **Modular Audio Synthesis:** Dynamic frequency generation based on character inputs (e.g., playing the "Imperial March").
* **Visual Synchronization:** Integrated LED "dancer" and 7-segment display for system monitoring.
* **Robust Hardware Design:** Custom RTL modules designed for timing accuracy and signal integrity.

## 🛠️ System Architecture
The FPGA logic is structured around a central **Block Design File (BDF)** that integrates several specialized Verilog modules:

* **`spi_slave.v`**: Handles the physical layer of the SPI protocol, latching data from the MOSI line.
* **`square_wave_gen.v`**: The core synthesizer engine that maps characters to specific audio frequencies.
* **`led_dancer.v`**: Controls the LED array to provide visual feedback synchronized with the audio output.
* **`stopwatch_display.v`**: Manages the 7-segment display for real-time diagnostics.
* **`activity_detector.v`**: Monitors bus activity to ensure stable system transitions.

## 🔌 Hardware Connectivity
The connection utilizes the Raspberry Pi 5 GPIO header and the FPGA GPIO pins, operating at **3.3V LVTTL** logic levels:

| Signal | RPi 5 Pin (GPIO) | FPGA Pin |
| :--- | :--- | :--- |
| **SCLK** | GPIO 11 (Pin 23) | GPIO_0[1] |
| **MOSI** | GPIO 10 (Pin 19) | GPIO_0[3] |
| **CS (SS)** | GPIO 8 (Pin 24) | GPIO_0[5] |
| **GND** | Pin 25 | GND |

## 📄 Documentation & Results
For a comprehensive analysis of the circuit design, pin assignments, and experimental validation, please refer to the technical report:
* **[Technical Lab Report - SPI Synthesizer]())**

### System Preview
* **RTL Viewer / BDF Diagram:** Detailed logic flow within the FPGA.
* **Signal Verification:** Timing diagrams and logic analyzer captures included in the report.

## 💻 How to Run
1. **FPGA:** Load the `.sof` file (generated from the included Verilog source) to the DE10-Lite using Quartus Prime.
2. **Raspberry Pi:** Execute the Python script (e.g., `synth_controller.py`) to start sending SPI data packets.

---
*Developed as part of the Digital Systems Lab at **Ruppin Academic Center**.*
