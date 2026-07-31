module logger_FSM(
    input clk,
    input rst,
    input event_valid,

    output reg wr_en
);

//--------------------------------------------------
// State Encoding
//--------------------------------------------------
parameter IDLE = 2'b00;
parameter LOG  = 2'b01;
parameter DONE = 2'b10;

reg [1:0] state;

//--------------------------------------------------
// FSM
//--------------------------------------------------
always @(posedge clk) begin

    if (rst) begin
        state <= IDLE;
        wr_en <= 1'b0;
    end

    else begin

        case(state)

            //--------------------------------------
            IDLE:
            //--------------------------------------
            begin
                wr_en <= 1'b0;

                if(event_valid)
                    state <= LOG;
                else
                    state <= IDLE;
            end

            //--------------------------------------
            LOG:
            //--------------------------------------
            begin
                wr_en <= 1'b1;
                state <= DONE;
            end

            //--------------------------------------
            DONE:
            //--------------------------------------
            begin
                wr_en <= 1'b0;
                state <= IDLE;
            end

            //--------------------------------------
            default:
            //--------------------------------------
            begin
                state <= IDLE;
                wr_en <= 1'b0;
            end

        endcase

    end

end

endmodule
