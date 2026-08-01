# OVERVIEW.md

## Project Overview

The FPGA-Based Vehicle Black Box Event Logger is a real-time embedded system designed to monitor, record, and retrieve critical vehicle events. Inspired by automotive Event Data Recorders (EDRs), the system captures important vehicle events such as Brake, Overspeed, Airbag Deployment, Engine Start, Engine Stop, and Collision. Each detected event is assigned a unique Event ID and paired with a continuously generated timestamp before being stored in on-chip memory.

The entire system is implemented using Verilog HDL on a Xilinx Artix-7 FPGA. A modular design approach has been followed, where individual modules perform dedicated tasks including event detection, timestamp generation, event logging, memory management, UART communication, and user interaction. This modular architecture simplifies development, testing, debugging, and future expansion.

When a valid vehicle event is detected, the Event Encoder generates the corresponding Event ID and asserts the event valid signal. The Logger Finite State Machine (FSM) produces a single write enable pulse, ensuring that each event is logged only once. The Timestamp Counter provides the exact time of occurrence, while the Write Pointer determines the next available memory location for storing the event. Each log entry consists of the timestamp and event information, which are stored sequentially in a 16 × 32-bit memory.

For retrieving stored logs, the Read Pointer and Read Controller sequentially access the memory contents. The UART Controller formats the retrieved data into a readable format by converting timestamps and event names into ASCII characters. Finally, the UART Transmitter sends the formatted log records to a host computer, where they can be viewed on a serial terminal such as PuTTY.

The project demonstrates several important concepts in digital system design, including finite state machines, memory management, synchronous sequential circuits, UART communication, and FPGA-based hardware implementation. It provides a practical prototype of an automotive event recording system and serves as a strong foundation for future enhancements such as external memory support, GPS integration, CAN bus communication, wireless monitoring, and real-time clock implementation.

### Key Features

* Real-time monitoring of vehicle events
* 16-bit timestamp generation for every logged event
* Priority-based event encoding
* FSM-controlled event logging
* Sequential memory storage using a 16 × 32-bit log memory
* UART-based retrieval of stored logs
* Human-readable event names through ASCII conversion
* Debounced keypad input for reliable user interaction
* LED indicators for debugging and system status
* Modular Verilog HDL implementation on Artix-7 FPGA

### Applications

* Automotive Event Data Recorders (EDRs)
* Vehicle diagnostics
* Accident investigation systems
* Fleet monitoring
* Embedded systems education
* FPGA-based digital design projects

