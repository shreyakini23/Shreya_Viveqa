module event_encoder_tb( );

reg brake;
reg overspeed;
reg collision;
reg airbag;
reg event_start;
reg event_stop;

wire [2:0]event_id;
wire event_valid;

event_encoder uut(
    .brake(brake),
    .collision(collision),
    .overspeed(overspeed),
    .airbag(airbag),
    .event_start(event_start),
    .event_stop(event_stop),
    .event_id(event_id),
    .event_valid(event_valid)
    );
    
  initial begin
    
   brake = 0;
    overspeed = 0;
    collision = 0;
    airbag = 0;
    event_start = 0;
    event_stop = 0;

    #20 brake = 1;
    #20 brake = 0;

    #20 overspeed = 1;
    #20 overspeed = 0;

    #20 collision = 1;
    #20 collision = 0;

    #20 airbag = 1;
    #20 airbag = 0;

    #20 event_start = 1;
    #20 event_start = 0;

    #20 event_stop = 1;
    #20 event_stop = 0;

    #20 $finish;

end

endmodule
