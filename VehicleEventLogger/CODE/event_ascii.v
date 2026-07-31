module event_ascii(

    input  [2:0] event_id,        // 3-bit Event ID
    input  [4:0] char_index,      // Character position

    output reg [7:0] ascii_char,  // ASCII Character
    output reg       last_char    // Goes HIGH after last character

);

always @(*)
begin

    // Default values
    ascii_char = " ";
    last_char  = 1'b0;

    case(event_id)

    //----------------------------------------------------------
    // 001 : BRAKE
    //----------------------------------------------------------

    3'b001:
    begin
        case(char_index)
            0 : ascii_char = "B";
            1 : ascii_char = "R";
            2 : ascii_char = "A";
            3 : ascii_char = "K";
            4 : ascii_char = "E";

            default:
            begin
                ascii_char = 8'h00;
                last_char  = 1'b1;
            end
        endcase
    end

    //----------------------------------------------------------
    // 010 : OVERSPEED
    //----------------------------------------------------------

    3'b010:
    begin
        case(char_index)
            0 : ascii_char = "O";
            1 : ascii_char = "V";
            2 : ascii_char = "E";
            3 : ascii_char = "R";
            4 : ascii_char = "S";
            5 : ascii_char = "P";
            6 : ascii_char = "E";
            7 : ascii_char = "E";
            8 : ascii_char = "D";

            default:
            begin
                ascii_char = 8'h00;
                last_char  = 1'b1;
            end
        endcase
    end

    //----------------------------------------------------------
    // 011 : AIRBAG
    //----------------------------------------------------------

    3'b011:
    begin
        case(char_index)
            0 : ascii_char = "A";
            1 : ascii_char = "I";
            2 : ascii_char = "R";
            3 : ascii_char = "B";
            4 : ascii_char = "A";
            5 : ascii_char = "G";

            default:
            begin
                ascii_char = 8'h00;
                last_char  = 1'b1;
            end
        endcase
    end

    //----------------------------------------------------------
    // 100 : ENGINE_START
    //----------------------------------------------------------

    3'b100:
    begin
        case(char_index)
            0  : ascii_char = "E";
            1  : ascii_char = "N";
            2  : ascii_char = "G";
            3  : ascii_char = "I";
            4  : ascii_char = "N";
            5  : ascii_char = "E";
            6  : ascii_char = "_";
            7  : ascii_char = "S";
            8  : ascii_char = "T";
            9  : ascii_char = "A";
            10 : ascii_char = "R";
            11 : ascii_char = "T";

            default:
            begin
                ascii_char = 8'h00;
                last_char  = 1'b1;
            end
        endcase
    end

    //----------------------------------------------------------
    // 101 : ENGINE_STOP
    //----------------------------------------------------------

    3'b101:
    begin
        case(char_index)
            0  : ascii_char = "E";
            1  : ascii_char = "N";
            2  : ascii_char = "G";
            3  : ascii_char = "I";
            4  : ascii_char = "N";
            5  : ascii_char = "E";
            6  : ascii_char = "_";
            7  : ascii_char = "S";
            8  : ascii_char = "T";
            9  : ascii_char = "O";
            10 : ascii_char = "P";

            default:
            begin
                ascii_char = 8'h00;
                last_char  = 1'b1;
            end
        endcase
    end

    //----------------------------------------------------------
    // 110 : COLLISION
    //----------------------------------------------------------

    3'b110:
    begin
        case(char_index)
            0 : ascii_char = "C";
            1 : ascii_char = "O";
            2 : ascii_char = "L";
            3 : ascii_char = "L";
            4 : ascii_char = "I";
            5 : ascii_char = "S";
            6 : ascii_char = "I";
            7 : ascii_char = "O";
            8 : ascii_char = "N";

            default:
            begin
                ascii_char = 8'h00;
                last_char  = 1'b1;
            end
        endcase
    end

    //----------------------------------------------------------
    // Invalid Event
    //----------------------------------------------------------

    default:
    begin
        ascii_char = "?";
        last_char  = 1'b1;
    end

    endcase

end

endmodule
