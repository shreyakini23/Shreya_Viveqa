# DESIGN_AND_ARCHITECTURE.md

## Design and Architecture

The Vehicle Black Box Event Logger is designed using a modular and hierarchical architecture implemented in Verilog HDL on a Xilinx Artix-7 FPGA. Each module performs a dedicated function and communicates with other modules through well-defined control and data signals. This modular approach improves readability, simplifies debugging, allows independent testing of each module, and makes future upgrades easier.

The system continuously monitors vehicle events including Brake, Overspeed, Airbag Deployment, Engine Start, Engine Stop, and Collision. Whenever one of these events is detected, the Event Encoder assigns a unique 3-bit Event ID based on a predefined priority and generates an `event_valid` signal. At the same time, the Timestamp Counter continuously generates a 16-bit timestamp that represents the time at which the event occurred.

The Logger Finite State Machine (FSM) controls the entire logging process. When a valid event is detected, the FSM generates a single write enable (`wr_en`) pulse to ensure that each event is recorded only once. This prevents duplicate logging while maintaining reliable operation.

The Write Pointer generates sequential memory addresses where each new event is stored. The Log Memory stores the timestamp and Event ID together as a 32-bit data word. An Entry Counter keeps track of the total number of valid log entries stored in memory, ensuring that only valid records are retrieved during read operations.

For log retrieval, the Read Pointer sequentially accesses each stored memory location. The Read Controller extracts the timestamp and Event ID from the stored 32-bit data. The timestamp is converted into ASCII characters using the Binary-to-ASCII Converter, while the Event ASCII module converts the Event ID into a readable event name such as **BRAKE**, **OVERSPEED**, or **ENGINE_START**.

The UART Controller coordinates the transmission process by formatting the retrieved information into a structured text output. It controls the reading of memory entries, generates headers and separators, and loads ASCII characters into the UART Transmitter. The UART Transmitter serially transmits the formatted data to a host computer at a baud rate of 9600 bps, where the logs are displayed on a serial terminal such as PuTTY.

To ensure reliable hardware operation, the design includes a Debounce module that removes mechanical switch bouncing from the keypad input. This guarantees that a single key press generates only one transmission request, preventing multiple unintended UART transmissions.

The entire system is integrated within the `vehicle_blackbox_top` module, which instantiates all functional modules and manages communication between them. The top module interfaces directly with the FPGA clock, input switches, keypad, LEDs, and UART output, providing complete system functionality on the Artix-7 FPGA.

### System Architecture Flow

```text
Vehicle Event Inputs (Switches)
            │
            ▼
     Event Encoder
            │
            ▼
    Timestamp Counter
            │
            ▼
       Logger FSM
            │
      Write Enable
            │
            ▼
      Write Pointer
            │
            ▼
       Log Memory
            │
            ▼
      Read Pointer
            │
            ▼
    Read Controller
      │             │
      ▼             ▼
Binary-to-ASCII   Event ASCII
      │             │
      └──────┬──────┘
             ▼
      UART Controller
             │
             ▼
     UART Transmitter
             │
             ▼
      PC Terminal (PuTTY)
```

### Memory Organization

Each memory location stores one complete event record in a 32-bit word.

| Bits  | Description                   |
| ----- | ----------------------------- |
| 31:16 | 16-bit Timestamp              |
| 15:13 | 3-bit Event ID                |
| 12:0  | Reserved for future expansion |

The memory consists of **16 entries**, allowing up to **16 vehicle events** to be stored before the memory becomes full.

### Design Advantages

* Modular architecture for easy development and debugging.
* Hierarchical integration of all functional modules.
* Reliable event logging using FSM-based control.
* Efficient sequential memory management using read and write pointers.
* Human-readable UART output through ASCII conversion.
* Debounced user input for dependable hardware operation.
* Scalable architecture that can be extended with external memory, GPS, CAN bus communication, and additional vehicle sensors.
