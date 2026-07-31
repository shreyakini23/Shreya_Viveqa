module read_controller(

    input              read_enable,
    input  [31:0]      memory_data,

    output reg [15:0]  timestamp,
    output reg [2:0]   event_id,
    output reg [1:0]   priority

);

always @(*) begin

    if(read_enable) begin

        timestamp = memory_data[31:16];
        event_id  = memory_data[15:13];
        priority  = memory_data[12:11];

    end
    else begin

        timestamp = 16'd0;
        event_id  = 3'd0;
        priority  = 2'd0;

    end

end

endmodule
