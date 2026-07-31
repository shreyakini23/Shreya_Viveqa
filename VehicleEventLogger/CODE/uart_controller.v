module uart_controller(
    input clk,
    input rst,                 // active-high, matches uart_transmitter now

    input send_trigger,        // debounced, one-shot button pulse

    output reg read_rst,       // resets read_pointer to entry 0
    output reg read_advance,   // pulses to move to next entry
    input [15:0] timestamp,    // from read_controller
    input [2:0]  event_id,     // from read_controller
    input [4:0]  log_count,    // from entry_counter

    output reg       tx_load,
    output reg [7:0] tx_data,
    input             tx_busy,
    input             tx_done
);

//------------------------------------------------------
// Fixed strings, packed MSB-first
//------------------------------------------------------
localparam [8*40-1:0] STR_BORDER = "========================================";
localparam [8*30-1:0] STR_TITLE  = "        VEHICLE BLACK BOX LOG";
localparam [8*26-1:0] STR_COLHDR = "No.    Timestamp    Event";
localparam [8*40-1:0] STR_DASHES = "----------------------------------------";
localparam [8*10-1:0] STR_END    = "End of Log";

localparam LN_BORDER=3'd0, LN_TITLE=3'd1, LN_COLHDR=3'd2, LN_DASHES=3'd3, LN_END=3'd4;

reg [2:0] cur_line;
reg [5:0] char_idx;
reg [5:0] line_len;

wire [7:0] rom_char =
    (cur_line==LN_BORDER) ? STR_BORDER[8*(40-1-char_idx) +: 8] :
    (cur_line==LN_TITLE)  ? STR_TITLE [8*(30-1-char_idx) +: 8] :
    (cur_line==LN_COLHDR) ? STR_COLHDR[8*(26-1-char_idx) +: 8] :
    (cur_line==LN_DASHES) ? STR_DASHES[8*(40-1-char_idx) +: 8] :
    (cur_line==LN_END)    ? STR_END   [8*(10-1-char_idx) +: 8] :
    8'h20;

//------------------------------------------------------
// bin2ascii / event_ascii instances
//------------------------------------------------------
wire [7:0] ascii3, ascii2, ascii1, ascii0;
bin2ascii U_B2A(
    .binary(timestamp),
    .ascii3(ascii3), .ascii2(ascii2), .ascii1(ascii1), .ascii0(ascii0)
);

reg  [4:0] evt_idx;
wire [7:0] evt_char;
wire       evt_last;
event_ascii U_EA(
    .event_id(event_id),
    .char_index(evt_idx),
    .ascii_char(evt_char),
    .last_char(evt_last)
);

//------------------------------------------------------
// States
//------------------------------------------------------
localparam
    S_IDLE       = 6'd0,
    S_BORDER1    = 6'd1,
    S_TITLE      = 6'd2,
    S_BORDER2    = 6'd3,
    S_BLANK1     = 6'd4,
    S_COLHDR     = 6'd5,
    S_DASHES     = 6'd6,
    S_BLANK2     = 6'd7,
    S_ENTRY_INIT = 6'd8,
    S_WAIT_RADDR = 6'd9,
    S_NUM_TENS   = 6'd10,
    S_NUM_ONES   = 6'd11,
    S_NUM_SP     = 6'd12,
    S_TS3        = 6'd13,
    S_TS2        = 6'd14,
    S_TS1        = 6'd15,
    S_TS0        = 6'd16,
    S_TS_SP      = 6'd17,
    S_EVT        = 6'd18,
    S_ENTRY_CRLF = 6'd19,
    S_ENTRY_NEXT = 6'd20,
    S_BLANK3     = 6'd21,
    S_FOOTER     = 6'd22,
    S_BLANK4     = 6'd23,
    S_ENDSTR     = 6'd24,
    S_DONE       = 6'd25,
    S_PRINT_LINE = 6'd26,
    S_TX_BYTE    = 6'd27,
    S_WAIT_DONE  = 6'd28,
    S_SP_LOOP    = 6'd29,
    S_CRLF_CR    = 6'd30,
    S_CRLF_LF    = 6'd31;

reg [5:0] state, ret_state, after_line, after_sp, after_crlf;
reg [4:0] entry_index;
reg [3:0] sp_count, sp_target;

always @(posedge clk)
begin
    if(rst)
    begin
        state <= S_IDLE;
        tx_load <= 0; tx_data <= 0;
        read_rst <= 0; read_advance <= 0;
        char_idx <= 0; entry_index <= 0; evt_idx <= 0;
        sp_count <= 0;
    end
    else
    begin
        tx_load <= 0;
        read_rst <= 0;
        read_advance <= 0;

        case(state)

        S_IDLE: if(send_trigger) state <= S_BORDER1;

        S_BORDER1: begin cur_line<=LN_BORDER; line_len<=40; char_idx<=0; after_line<=S_TITLE;  state<=S_PRINT_LINE; end
        S_TITLE:   begin cur_line<=LN_TITLE;  line_len<=30; char_idx<=0; after_line<=S_BORDER2; state<=S_PRINT_LINE; end
        S_BORDER2: begin cur_line<=LN_BORDER; line_len<=40; char_idx<=0; after_line<=S_BLANK1;  state<=S_PRINT_LINE; end
        S_BLANK1:  begin after_crlf<=S_COLHDR; state<=S_CRLF_CR; end
        S_COLHDR:  begin cur_line<=LN_COLHDR; line_len<=26; char_idx<=0; after_line<=S_DASHES;  state<=S_PRINT_LINE; end
        S_DASHES:  begin cur_line<=LN_DASHES; line_len<=40; char_idx<=0; after_line<=S_BLANK2;  state<=S_PRINT_LINE; end
        S_BLANK2:  begin after_crlf<=S_ENTRY_INIT; state<=S_CRLF_CR; end

        S_ENTRY_INIT: begin
            entry_index <= 0;
            read_rst <= 1;
            state <= (log_count==0) ? S_BLANK3 : S_WAIT_RADDR;
        end

        S_WAIT_RADDR: state <= S_NUM_TENS;

        S_NUM_TENS: begin
            tx_data <= (entry_index+1 >= 10) ? "1" : " ";
            tx_load <= 1; ret_state <= S_NUM_ONES; state <= S_TX_BYTE;
        end
        S_NUM_ONES: begin
            tx_data <= ((entry_index+1) % 10) + 8'd48;
            tx_load <= 1; ret_state <= S_NUM_SP; state <= S_TX_BYTE;
        end
        S_NUM_SP: begin sp_target<=5; after_sp<=S_TS3; state<=S_SP_LOOP; end

        S_TS3: begin tx_data<=ascii3; tx_load<=1; ret_state<=S_TS2; state<=S_TX_BYTE; end
        S_TS2: begin tx_data<=ascii2; tx_load<=1; ret_state<=S_TS1; state<=S_TX_BYTE; end
        S_TS1: begin tx_data<=ascii1; tx_load<=1; ret_state<=S_TS0; state<=S_TX_BYTE; end
        S_TS0: begin tx_data<=ascii0; tx_load<=1; ret_state<=S_TS_SP; state<=S_TX_BYTE; end
        S_TS_SP: begin sp_target<=9; after_sp<=S_EVT; evt_idx<=0; state<=S_SP_LOOP; end

        S_EVT: begin
            if(evt_last)
                state <= S_ENTRY_CRLF;
            else begin
                tx_data <= evt_char; tx_load <= 1;
                evt_idx <= evt_idx + 1'b1;
                ret_state <= S_EVT; state <= S_TX_BYTE;
            end
        end

        S_ENTRY_CRLF: begin after_crlf <= S_ENTRY_NEXT; state <= S_CRLF_CR; end

        S_ENTRY_NEXT: begin
            entry_index <= entry_index + 1'b1;
            if(entry_index + 1'b1 == log_count)
                state <= S_BLANK3;
            else begin
                read_advance <= 1;
                state <= S_WAIT_RADDR;
            end
        end

        S_BLANK3: begin after_crlf<=S_FOOTER; state<=S_CRLF_CR; end
        S_FOOTER: begin cur_line<=LN_BORDER; line_len<=40; char_idx<=0; after_line<=S_BLANK4; state<=S_PRINT_LINE; end
        S_BLANK4: begin after_crlf<=S_ENDSTR; state<=S_CRLF_CR; end
        S_ENDSTR: begin cur_line<=LN_END; line_len<=10; char_idx<=0; after_line<=S_DONE; state<=S_PRINT_LINE; end
        S_DONE:   state <= S_IDLE;

        S_PRINT_LINE: begin
            if(char_idx == line_len) begin
                after_crlf <= after_line;
                state <= S_CRLF_CR;
            end else begin
                tx_data <= rom_char; tx_load <= 1;
                char_idx <= char_idx + 1'b1;
                ret_state <= S_PRINT_LINE;
                state <= S_TX_BYTE;
            end
        end

        S_TX_BYTE: state <= S_WAIT_DONE;

        S_WAIT_DONE: if(tx_done) state <= ret_state;

        S_SP_LOOP: begin
            if(sp_count == sp_target) begin
                sp_count <= 0;
                state <= after_sp;
            end else begin
                tx_data <= " "; tx_load <= 1;
                sp_count <= sp_count + 1'b1;
                ret_state <= S_SP_LOOP;
                state <= S_TX_BYTE;
            end
        end

        S_CRLF_CR: begin tx_data<=8'h0D; tx_load<=1; ret_state<=S_CRLF_LF; state<=S_TX_BYTE; end
        S_CRLF_LF: begin tx_data<=8'h0A; tx_load<=1; ret_state<=after_crlf; state<=S_TX_BYTE; end

        default: state <= S_IDLE;

        endcase
    end
end 
endmodule
