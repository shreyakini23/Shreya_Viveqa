module memory_tb;
reg clk;
reg rst;
reg write_enable;
reg [15:0] timestamp;
reg [3:0] event_id;
reg read_enable;
reg [3:0] read_address;
wire [15:0] read_timestamp;
wire [3:0] read_event;
 
vehicle_memory_top DUT(
 .clk(clk),
 .rst(rst),
 .write_enable(write_enable),
 .timestamp(timestamp),
 .event_id(event_id),
 .read_enable(read_enable),
 .read_address(read_address),
 .read_timestamp(read_timestamp),
 .read_event(read_event)
 );
 
always #5 clk = ~clk;
initial
begin
clk = 0;
rst = 1;
write_enable = 0;
read_enable = 0;
#10;
rst = 0;
 
// First Event
timestamp = 16'd50;
event_id = 4'b0001;
write_enable = 1;
#10;
write_enable = 0;
 
// Second Event
timestamp = 16'd100;
event_id = 4'b0010;
write_enable = 1;
#10;
write_enable = 0;
 
// Read first event
 
read_enable = 1;
read_address = 4'd0;
#10;
 
// Read second event
 
read_address = 4'd1;
#10;
$finish;
end
 
endmodule
