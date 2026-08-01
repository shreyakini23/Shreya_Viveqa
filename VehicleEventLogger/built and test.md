

# BUILD_AND_TEST.md

## Build Instructions

The Vehicle Black Box Event Logger is developed using Verilog HDL and implemented on a Xilinx Artix-7 FPGA using the Xilinx Vivado Design Suite. The following steps describe the procedure to build the project and generate the FPGA bitstream.

### Software Requirements

* Xilinx Vivado Design Suite (2020.2 or later)
* Serial Terminal Software (PuTTY, Tera Term, or RealTerm)

### Hardware Requirements

* Xilinx Artix-7 FPGA Development Board
* USB Programming Cable
* USB-to-UART Interface (if not integrated)
* 4×4 Keypad
* Slide Switches
* LEDs

---

## Project Setup

1. Open Xilinx Vivado.
2. Create a new RTL project.
3. Select the target Artix-7 FPGA device or development board.
4. Add all Verilog source files to the project.
5. Add all Verilog testbench files.
6. Add the XDC constraints file.
7. Set `vehicle_blackbox_top.v` as the Top Module.
8. Save the project.

---

## Build Procedure

### Step 1: Run Synthesis

Execute synthesis to verify that all Verilog modules are free from syntax and elaboration errors.

During synthesis, Vivado checks:

* Module connectivity
* Signal declarations
* RTL correctness
* Resource utilization

Correct any synthesis warnings or errors before proceeding.

---

### Step 2: Run Implementation

After successful synthesis, run the implementation stage.

Implementation performs:

* Logic optimization
* Placement
* Routing
* Timing analysis

Verify that all timing constraints are successfully met before generating the bitstream.

---

### Step 3: Generate Bitstream

Once implementation completes successfully, generate the FPGA programming bitstream.

The generated `.bit` file is then ready for hardware programming.

---

### Step 4: Program the FPGA

1. Connect the Artix-7 FPGA board to the computer.
2. Open Vivado Hardware Manager.
3. Detect the FPGA device.
4. Program the FPGA using the generated bitstream.
5. Wait until programming completes successfully.

---

# Running the Project

After programming the FPGA, perform the following steps to operate the Vehicle Black Box Event Logger.

### Step 1: Reset the System

Set the reset switch (`sw[6]`) HIGH for a few clock cycles and then release it.

This operation:

* Clears the timestamp counter
* Resets memory pointers
* Clears stored log entries
* Initializes the entire system

---

### Step 2: Generate Vehicle Events

Use the FPGA switches to simulate vehicle events.

| Switch | Vehicle Event     |
| ------ | ----------------- |
| sw[0]  | Brake             |
| sw[1]  | Overspeed         |
| sw[2]  | Airbag Deployment |
| sw[3]  | Collision         |
| sw[4]  | Engine Start      |
| sw[5]  | Engine Stop       |

Activate one switch at a time to generate the corresponding event. Each event is automatically assigned a timestamp and stored in the log memory.

---

### Step 3: Observe LED Outputs

The onboard LEDs indicate the current operating status of the system.

| LED      | Description         |
| -------- | ------------------- |
| LED[2:0] | Current Event ID    |
| LED[3]   | Event Valid         |
| LED[4]   | Memory Write Enable |
| LED[5]   | Reset Status        |
| LED[6]   | Write Pointer Debug |
| LED[7]   | Timestamp Activity  |

These LEDs help verify that events are being detected and stored correctly.

---

### Step 4: Retrieve Stored Logs

Press any key on the 4×4 keypad.

The Debounce module generates a clean pulse that initiates the UART Controller. The controller sequentially reads every stored log entry from memory and prepares the data for transmission.

---

### Step 5: View Logs on a Serial Terminal

Open a serial terminal application such as PuTTY.

Configure the UART settings as follows:

| Parameter    | Value |
| ------------ | ----- |
| Baud Rate    | 9600  |
| Data Bits    | 8     |
| Stop Bits    | 1     |
| Parity       | None  |
| Flow Control | None  |

Connect to the appropriate COM port.

After pressing the keypad, the stored event logs are displayed in a formatted table containing:

* Entry Number
* Timestamp
* Event Name

---

# Testing Instructions

The project was verified through both simulation and hardware testing.

### Functional Simulation

Individual testbenches were created for the following modules:

* Timestamp Counter
* Event Encoder
* Logger FSM
* Log Memory
* Vehicle Black Box Top Module

Each module was simulated independently to verify its functionality before system integration.

---

### Integration Testing

After integrating all modules, the complete system was simulated to verify:

* Event detection
* Timestamp generation
* FSM-controlled logging
* Memory write operations
* Sequential memory read operations
* UART data formatting
* UART transmission
* End-to-end system functionality

---

### Hardware Testing

The implemented FPGA design was tested using the Artix-7 development board.

The following functionality was verified:

* System reset
* Detection of each vehicle event
* Correct Event ID generation
* Timestamp recording
* Sequential memory storage
* Accurate memory retrieval
* UART transmission
* Correct display of logs on PuTTY
* LED status indicators

---

## Expected Output

After generating several vehicle events and pressing the keypad, the serial terminal displays the stored logs in the following format:

```text
========================================
        VEHICLE BLACK BOX LOG
========================================

No.    Timestamp    Event
----------------------------------------
 1        0001      ENGINE_START
 2        0015      BRAKE
 3        0048      OVERSPEED
 4        0062      AIRBAG

========================================

End of Log
```

This output confirms that the FPGA successfully detects vehicle events, timestamps them, stores them in memory, and retrieves them correctly through the UART interface.
