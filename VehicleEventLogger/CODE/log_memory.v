module log_memory(
 
input clk,
input write_enable,
 
input [3:0] write_address,
 
input [15:0] timestamp,
input[3:0]read_address,
output[31:0]memory_data,
input [2:0] event_id
 
);
 
reg [31:0] memory [0:15];
 
always @(posedge clk)
 
begin
 
    if(write_enable)
    begin
        memory[write_address] <= {timestamp,event_id,13'b0};
 
end

end

assign memory_data = memory[read_address];

endmodule
