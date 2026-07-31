module event_encoder(brake,overspeed,airbag,collision,engine_start,engine_stop,event_valid,event_id);
input brake,overspeed,airbag,collision,engine_start,engine_stop;
output reg [2:0]event_id;
output reg event_valid;

always@(*)begin

    //default outputs
    event_id=3'b000;
    event_valid=1'b0;
    
    //priority encoder
    if(brake) begin
        event_id=3'b001;
    event_valid=1'b1;
    end
    else if (overspeed) begin
    event_id=3'b010;
    event_valid=1'b1;
    end
    else if(airbag) begin
    event_id=3'b011;
    event_valid=1'b1;
    end
    else if(engine_start) begin
    event_id=3'b100;
    event_valid=1'b1;
    end
    else if(engine_stop) begin
    event_id=3'b101;
    event_valid=1'b1;
    end
      else if(collision) begin
    event_id=3'b110;
    event_valid=1'b1;
   end
   end
   endmodule
