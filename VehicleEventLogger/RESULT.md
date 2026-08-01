RESULT

The Vehicle Black Box Event Logger was successfully designed, simulated, and implemented on the Xilinx Artix-7 FPGA using Verilog HDL and the Vivado Design Suite. Functional simulations verified the correct operation of each module, including the Timestamp Counter, Event Encoder, Logger FSM, Log Memory, Write and Read Pointers, Entry Counter, Debounce Module, and UART Communication modules.

Hardware validation confirmed the successful detection and logging of all six vehicle events: Brake, Overspeed, Airbag Deployment, Engine Start, Engine Stop, and Collision. Each detected event generated the corresponding Event ID, which was stored sequentially in the 16 × 32-bit Log Memory along with its timestamp. The Logger FSM generated a single write enable pulse for every valid event, ensuring that duplicate entries were avoided.

The stored event records were successfully retrieved using the Read Controller and transmitted to a PC through the UART interface. The logged timestamps and event names were correctly displayed on the PuTTY terminal, demonstrating reliable serial communication. The FPGA LEDs also provided real-time visual feedback for the Event ID, event validity, write enable signal, and timestamp heartbeat, confirming the correct execution of the complete system.

Overall, both simulation and hardware results matched the expected behavior, validating the correctness and reliability of the proposed Vehicle Black Box Event Logger
