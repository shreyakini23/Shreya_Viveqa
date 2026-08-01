# IMPLEMENTATION_APPROACH.md

## Implementation Approach

The Vehicle Black Box Event Logger was developed using a modular, bottom-up design methodology in Verilog HDL. Each hardware module was designed, simulated, and verified independently before being integrated into the complete system. After successful simulation, the integrated design was synthesized, implemented, and programmed onto a Xilinx Artix-7 FPGA using the Xilinx Vivado Design Suite.

The implementation begins with the **Timestamp Counter**, which continuously generates a 16-bit timestamp synchronized with the FPGA clock. This timestamp serves as a time reference for every vehicle event that is recorded.

The **Event Encoder** continuously monitors the six vehicle event inputs: Brake, Overspeed, Airbag Deployment, Engine Start, Engine Stop, and Collision. Whenever an event is detected, the encoder assigns a corresponding 3-bit Event ID based on a predefined priority and asserts the `event_valid` signal. This signal indicates that a valid event has occurred and is ready to be logged.

The **Logger Finite State Machine (FSM)** supervises the logging operation. It monitors the `event_valid` signal and generates a single write enable (`wr_en`) pulse for each valid event. This ensures that every event is recorded exactly once, preventing duplicate memory writes even if the event signal remains active for multiple clock cycles.

Before storing the event, the current timestamp and Event ID are latched to ensure that the correct data is written into memory. The **Write Pointer** generates the next available memory address, while the **Log Memory** stores the event information as a 32-bit word consisting of the timestamp, Event ID, and reserved bits for future expansion. Simultaneously, the **Entry Counter** increments to maintain the total number of valid log entries stored in memory.

When the user presses any key on the keypad, the input first passes through the **Debounce** module. This module filters out switch bouncing and generates a clean single-cycle pulse, preventing multiple transmission requests from a single key press.

The debounced pulse activates the **UART Controller**, which begins retrieving stored log entries from memory. The **Read Pointer** sequentially accesses each stored memory location, while the **Read Controller** extracts the timestamp and Event ID from each 32-bit memory word.

The extracted timestamp is converted into readable decimal characters using the **Binary-to-ASCII Converter**, and the Event ID is translated into descriptive event names such as **BRAKE**, **OVERSPEED**, or **ENGINE_START** using the **Event ASCII** module. These converted values are then formatted into a structured log containing headers, entry numbers, timestamps, and event names.

The formatted data is loaded into the **UART Transmitter**, which serially transmits each character according to the UART protocol at a baud rate of **9600 bps**. The transmitted data is received by a host computer and displayed on a serial terminal such as **PuTTY**, allowing the user to view the complete event log in a human-readable format.

Finally, all modules are integrated within the **vehicle_blackbox_top** module. This top-level module establishes communication between every functional block and interfaces with the FPGA clock, switches, keypad, LEDs, and UART output pins, enabling the complete Vehicle Black Box Event Logger to operate as a unified hardware system.

## Implementation Workflow

The overall implementation follows the sequence below:

1. The Timestamp Counter continuously generates a 16-bit timestamp.
2. Vehicle events are detected through FPGA switches.
3. The Event Encoder assigns a unique Event ID and generates an `event_valid` signal.
4. The Logger FSM produces a single write enable pulse.
5. The current timestamp and Event ID are latched.
6. The Write Pointer generates the next memory address.
7. The Log Memory stores the event record.
8. The Entry Counter updates the number of stored events.
9. A keypad press generates a debounced transmission request.
10. The Read Pointer sequentially retrieves stored log entries.
11. The Read Controller extracts timestamps and Event IDs.
12. Binary timestamps are converted into ASCII characters.
13. Event IDs are converted into readable event names.
14. The UART Controller formats the complete log.
15. The UART Transmitter sends the formatted log to a host computer, where it is displayed on PuTTY.

## Development Methodology

The project was developed following these stages:

* Individual design and coding of each Verilog module.
* Functional simulation of every module using dedicated testbenches.
* Incremental integration of all modules into the top-level design.
* Behavioral simulation of the complete system in Xilinx Vivado.
* Synthesis and implementation targeting the Artix-7 FPGA.
* Hardware validation using FPGA switches, LEDs, keypad, and UART communication.
* Verification of event logging, memory storage, log retrieval, and UART output on PuTTY.
