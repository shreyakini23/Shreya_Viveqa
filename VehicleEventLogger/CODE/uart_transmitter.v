module uart_transmitter(

    input clk,
    input rst,                   // now ACTIVE-HIGH, synchronous
    input load,                  // Pulse high to start transmission
    input [7:0] data_tx,         // ASCII character to transmit

    output reg tx,               // UART TX output
    output reg busy,             // UART is transmitting
    output reg done              // One clock pulse after transmission completes

);

//------------------------------------------------------
// Parameters
//------------------------------------------------------

// FPGA Clock = 24 MHz
// UART Baud Rate = 9600 bps
// Baud Count = 24,000,000 / 9600 = 2500

parameter BAUD_COUNT = 24000000/9600;


//------------------------------------------------------
// State Encoding
//------------------------------------------------------

localparam IDLE      = 3'd0,
           LOAD      = 3'd1,
           TRANSMIT  = 3'd2,
           STOP      = 3'd3;


//------------------------------------------------------
// Registers
//------------------------------------------------------

reg [2:0] state;

// 10-bit frame
// [Stop][D7:D0][Start]

reg [9:0] shift_reg;

// Counts clock cycles for one UART bit

reg [11:0] baud_tik;

// Counts transmitted bits (0-9)

reg [3:0] bit_count;


//------------------------------------------------------
// UART FSM
//------------------------------------------------------

always @(posedge clk)          // CHANGED: removed "or negedge rst"
begin

    //--------------------------------------------------
    // RESET
    //--------------------------------------------------

    if(rst)                    // CHANGED: was !rst
    begin

        tx        <= 1'b1;       // UART line idle = HIGH
        busy      <= 1'b0;
        done      <= 1'b0;

        state     <= IDLE;

        shift_reg <= 10'd0;

        baud_tik  <= 12'd0;

        bit_count <= 4'd0;

    end

    //--------------------------------------------------
    // STATE MACHINE
    //--------------------------------------------------

    else
    begin

        case(state)

        //--------------------------------------------------
        // IDLE STATE
        //--------------------------------------------------
        // Wait for load signal

        IDLE:
        begin

            tx <= 1'b1;          // Idle line stays HIGH

            busy <= 1'b0;

            done <= 1'b0;

            baud_tik <= 0;

            bit_count <= 0;

            if(load)
            begin

                busy <= 1'b1;

                state <= LOAD;

            end

        end


        //--------------------------------------------------
        // LOAD STATE
        //--------------------------------------------------
        // Load UART frame into shift register
        //
        // shift_reg =
        //
        // Stop | D7 D6 D5 D4 D3 D2 D1 D0 | Start
        //
        //--------------------------------------------------

        LOAD:
 begin

            shift_reg <= {1'b1,data_tx,1'b0};

            state <= TRANSMIT;

        end


        //--------------------------------------------------
        // TRANSMIT STATE
        //--------------------------------------------------
        // Send one bit every BAUD_COUNT clocks
        //--------------------------------------------------

        TRANSMIT:
        begin

            // Wait until one baud period finishes

            if(baud_tik == BAUD_COUNT-1)
            begin

                // Restart baud counter

                baud_tik <= 0;

                // Send current LSB

                tx <= shift_reg[0];

                // Shift next bit into position

                shift_reg <= shift_reg >> 1;

                // Check if entire frame transmitted

                if(bit_count == 9)
                begin

                    bit_count <= 0;

                    state <= STOP;

                end

                else
                begin

                    bit_count <= bit_count + 1;

                end

            end

            else
            begin

                // Continue counting clock cycles

                baud_tik <= baud_tik + 1;

            end

        end


        //--------------------------------------------------
        // STOP STATE
        //--------------------------------------------------
        // Transmission Complete
        //--------------------------------------------------

        STOP:
        begin

            tx <= 1'b1;          // Return line to idle

            busy <= 1'b0;

            done <= 1'b1;

            state <= IDLE;

        end


        //--------------------------------------------------
        // DEFAULT
        //--------------------------------------------------

        default:

            state <= IDLE;

        endcase

    end

end

endmodule
