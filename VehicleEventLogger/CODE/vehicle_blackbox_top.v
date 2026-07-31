`timescale 1ns / 1ps

module vehicle_blackbox_top(

    input clk_24mhz,
    input [7:0] sw,
    input [15:0] keypad,        // CHANGED: was "input log_button"

    output [7:0] led,
    output uart_tx

);

//==========================================================
// Internal Signals
//==========================================================

wire [15:0] timestamp;
wire [2:0]  event_id;
wire         event_valid;
wire         wr_en;

wire [3:0] write_address;
wire [3:0] read_address;
wire [31:0] memory_data;

wire [15:0] read_timestamp;
wire [2:0]  read_event_id;

wire [4:0] log_count;
wire       read_rst;
wire       read_advance;
wire       send_trigger;

wire       uart_load, uart_busy, uart_done;
wire [7:0] uart_data;

reg [2:0]  event_id_latched;
reg [15:0] timestamp_latched;

//==========================================================
// Any key pressed = trigger
//==========================================================
wire raw_button;
assign raw_button = |keypad;   // NEW: OR-reduce all 16 keypad pins
// NOTE: flip to  assign raw_button = ~&keypad;  if your keypad is
// active-LOW (idle high, pulled low when pressed) - verify on hardware.

//==========================================================
// Latch event data at the moment event_valid fires
//==========================================================
always @(posedge clk_24mhz)
begin
    if(sw[6])
    begin
        event_id_latched  <= 3'd0;
        timestamp_latched <= 16'd0;
    end
    else if(event_valid)
    begin
        event_id_latched  <= event_id;
        timestamp_latched <= timestamp;
    end
end

//==========================================================
timestamp_counter U1(
    .clk(clk_24mhz),
    .rst(sw[6]),
    .timestamp(timestamp)
);

event_encoder U2(
    .brake(sw[0]),
    .overspeed(sw[1]),
    .airbag(sw[2]),
    .collision(sw[3]),
    .engine_start(sw[4]),
    .engine_stop(sw[5]),
    .event_valid(event_valid),
    .event_id(event_id)
);

logger_FSM U3(
    .clk(clk_24mhz),
    .rst(sw[6]),
    .event_valid(event_valid),
    .wr_en(wr_en)
);

write_pointer U4(
    .clk(clk_24mhz),
    .rst(sw[6]),
    .write_enable(wr_en),
    .write_address(write_address)
);

log_memory U5(
    .clk(clk_24mhz),
    .write_enable(wr_en),
    .write_address(write_address),
    .read_address(read_address),
    .timestamp(timestamp_latched),
    .event_id(event_id_latched),
    .memory_data(memory_data)
);

read_pointer U6(
    .clk(clk_24mhz),
    .rst(sw[6]),
    .read_rst(read_rst),
    .read_enable(read_advance),
    .read_address(read_address)
);

read_controller U7(
    .read_enable(1'b1),
    .memory_data(memory_data),
    .timestamp(read_timestamp),
    .event_id(read_event_id)
);

entry_counter U_CNT(
    .clk(clk_24mhz),
    .rst(sw[6]),
    .wr_en(wr_en),
    .log_count(log_count)
);

debounce #(.DEBOUNCE_COUNT(5)) U_DB(
    .clk(clk_24mhz),
    .rst(sw[6]),
    .btn_in(raw_button),
    .pulse_out(send_trigger)
);

uart_controller U_UC(
    .clk(clk_24mhz),
    .rst(sw[6]),
    .send_trigger(send_trigger),
    .read_rst(read_rst),
    .read_advance(read_advance),
    .timestamp(read_timestamp),
    .event_id(read_event_id),
    .log_count(log_count),
    .tx_load(uart_load),
    .tx_data(uart_data),
    .tx_busy(uart_busy),
    .tx_done(uart_done)
);

uart_transmitter U9(
    .clk(clk_24mhz),
    .rst(sw[6]),
    .load(uart_load),
    .data_tx(uart_data),
    .tx(uart_tx),
    .busy(uart_busy),
    .done(uart_done)
);

//==========================================================
// LED Debug
//==========================================================
assign led[2:0] = event_id;
assign led[3] = event_valid;
assign led[4] = wr_en;
assign led[5] = sw[6];
assign led[6] = write_address[3];
assign led[7] = timestamp[15];

endmodule
