# MODULE_DESCRIPTION.md

## Module Description

The Vehicle Black Box Event Logger is composed of several independent hardware modules, each responsible for a specific function within the system. This modular approach improves maintainability, simplifies testing, and enables seamless integration of all functional blocks.

---

### 1. Timestamp Counter (`timestamp_counter.v`)

The Timestamp Counter generates a continuous 16-bit timestamp that provides a chronological reference for every logged vehicle event. The counter increments on every rising edge of the FPGA clock and resets to zero when the reset signal is asserted.

**Inputs**

* Clock (`clk`)
* Reset (`rst`)

**Output**

* 16-bit Timestamp (`timestamp`)

**Function**

* Continuously increments the timestamp.
* Provides the current timestamp whenever a vehicle event is detected.
* Ensures that each logged event has an associated time reference.

---

### 2. Event Encoder (`event_encoder.v`)

The Event Encoder monitors all vehicle event inputs and assigns a unique 3-bit Event ID according to a predefined priority. Whenever an event is detected, it also generates an `event_valid` signal to initiate the logging process.

**Inputs**

* Brake
* Overspeed
* Airbag
* Collision
* Engine Start
* Engine Stop

**Outputs**

* Event ID
* Event Valid

**Event Mapping**

| Vehicle Event     | Event ID |
| ----------------- | -------- |
| Brake             | 001      |
| Overspeed         | 010      |
| Airbag Deployment | 011      |
| Engine Start      | 100      |
| Engine Stop       | 101      |
| Collision         | 110      |

**Function**

* Detects vehicle events.
* Assigns unique Event IDs.
* Generates the event validation signal.

---

### 3. Logger FSM (`logger_FSM.v`)

The Logger Finite State Machine controls the event logging operation. It ensures that every detected event generates exactly one write operation, preventing duplicate memory entries.

**Inputs**

* Clock
* Reset
* Event Valid

**Output**

* Write Enable (`wr_en`)

**States**

* IDLE
* LOG
* DONE

**Function**

* Waits for a valid event.
* Generates a single write enable pulse.
* Returns to the idle state after logging.

---

### 4. Write Pointer (`write_pointer.v`)

The Write Pointer manages the memory address where the next event record will be stored.

**Inputs**

* Clock
* Reset
* Write Enable

**Output**

* Write Address

**Function**

* Initializes the address to zero after reset.
* Increments after every successful write operation.
* Provides sequential memory locations for storing event logs.

---

### 5. Log Memory (`log_memory.v`)

The Log Memory stores all vehicle event records in a 16 × 32-bit register-based memory array.

Each memory word contains:

| Bits  | Description |
| ----- | ----------- |
| 31–16 | Timestamp   |
| 15–13 | Event ID    |
| 12–0  | Reserved    |

**Inputs**

* Clock
* Write Enable
* Write Address
* Read Address
* Timestamp
* Event ID

**Output**

* Memory Data

**Function**

* Stores event information whenever the write enable signal is asserted.
* Supplies stored records during read operations.

---

### 6. Read Pointer (`read_pointer.v`)

The Read Pointer generates sequential addresses for retrieving stored log entries from memory.

**Inputs**

* Clock
* Reset
* Read Reset
* Read Enable

**Output**

* Read Address

**Function**

* Starts reading from the first memory location.
* Advances to the next stored record after every read operation.
* Allows retrieval to restart from the beginning.

---

### 7. Read Controller (`read_controller.v`)

The Read Controller extracts useful information from the 32-bit memory word and separates it into timestamp and Event ID fields.

**Inputs**

* Read Enable
* Memory Data

**Outputs**

* Timestamp
* Event ID
* Priority

**Function**

* Decodes stored event records.
* Supplies formatted information for UART transmission.

---

### 8. Entry Counter (`entry_counter.v`)

The Entry Counter maintains the total number of valid event records stored in memory.

**Inputs**

* Clock
* Reset
* Write Enable

**Output**

* Log Count

**Function**

* Increments after every successful logging operation.
* Prevents retrieval of invalid memory locations.
* Keeps track of memory utilization.

---

### 9. Debounce (`debounce.v`)

The Debounce module removes switch bouncing caused by mechanical keypad presses.

**Inputs**

* Clock
* Reset
* Button Input

**Output**

* One-cycle Pulse Output

**Function**

* Synchronizes asynchronous keypad inputs.
* Filters unstable transitions.
* Generates a clean single-cycle pulse for each button press.

---

### 10. Event ASCII Converter (`event_ascii.v`)

The Event ASCII Converter converts Event IDs into readable event names before UART transmission.

**Input**

* Event ID

**Outputs**

* ASCII Character
* Last Character Indicator

**Supported Event Names**

* BRAKE
* OVERSPEED
* AIRBAG
* ENGINE_START
* ENGINE_STOP
* COLLISION

**Function**

* Maps Event IDs to corresponding ASCII strings.
* Sends one character at a time to the UART Controller.

---

### 11. Binary-to-ASCII Converter (`bin2ascii.v`)

The Binary-to-ASCII Converter converts the binary timestamp into decimal ASCII characters for display on the serial terminal.

**Input**

* 16-bit Binary Timestamp

**Outputs**

* Four ASCII Characters

**Function**

* Separates the timestamp into decimal digits.
* Converts each digit into its corresponding ASCII code.
* Enables human-readable timestamp display.

---

### 12. UART Controller (`uart_controller.v`)

The UART Controller coordinates the retrieval and formatting of stored log records before transmission.

**Inputs**

* Clock
* Reset
* Send Trigger
* Timestamp
* Event ID
* Log Count
* UART Status Signals

**Outputs**

* UART Data
* UART Load
* Read Control Signals

**Function**

* Initiates memory reading.
* Formats timestamps and event names.
* Generates report headers and separators.
* Controls the complete UART transmission sequence.

---

### 13. UART Transmitter (`uart_transmitter.v`)

The UART Transmitter implements asynchronous serial communication between the FPGA and the host computer.

**Specifications**

* Clock Frequency: 24 MHz
* Baud Rate: 9600 bps
* Data Bits: 8
* Stop Bits: 1
* Parity: None

**Inputs**

* Clock
* Reset
* Load Signal
* ASCII Data

**Outputs**

* UART TX
* Busy
* Done

**Function**

* Frames ASCII data according to the UART protocol.
* Serially transmits each character.
* Indicates transmission completion through the `done` signal.

---

### 14. Top Module (`vehicle_blackbox_top.v`)

The Top Module integrates all hardware components into a complete Vehicle Black Box Event Logger.

**External Interfaces**

* 24 MHz FPGA Clock
* Vehicle Event Switches
* Keypad
* LEDs
* UART TX

**Function**

* Instantiates every functional module.
* Connects all data and control signals.
* Coordinates event detection, logging, storage, retrieval, and UART communication.
* Provides the complete hardware implementation of the Vehicle Black Box Event Logger.

---

## Summary of Modules

| Module            | Primary Function                       |
| ----------------- | -------------------------------------- |
| Timestamp Counter | Generates timestamps                   |
| Event Encoder     | Detects and encodes vehicle events     |
| Logger FSM        | Controls logging operation             |
| Write Pointer     | Generates memory write addresses       |
| Log Memory        | Stores event records                   |
| Read Pointer      | Generates memory read addresses        |
| Read Controller   | Extracts stored event data             |
| Entry Counter     | Counts valid log entries               |
| Debounce          | Removes switch bouncing                |
| Event ASCII       | Converts Event IDs into readable names |
| Binary-to-ASCII   | Converts timestamps into ASCII         |
| UART Controller   | Formats and manages UART communication |
| UART Transmitter  | Serially transmits log data            |
| Top Module        | Integrates the complete system         |
