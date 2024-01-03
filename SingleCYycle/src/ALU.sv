module ALU #(parameter width=32)
(
input [width-1:0] alu_in1,
input [width-1:0] alu_in2,
input [4:0] opcode,
output reg [width-1:0] result,
output reg alu_flag   
);

// 00000 add , 00001 substract , 00010  mult , 00011 div , 00100 and , 
// 00101 or  , 00110 xor       , 00111 nor   , 01000 not , 01001 sl  ,
// 01010 sr  , 01011 rl        , 01100 rr    , 01101 inc , 01110 dec ,
wire [2*width-1:0]temp;
wire signed [width-1:0] temp_alu1,temp_alu2;
assign temp = alu_in1 * alu_in2;
assign temp_alu1=alu_in1;
assign temp_alu2=alu_in2;
always@(*)begin
    case(opcode)
        5'b00000:begin //add
            result=alu_in1+alu_in2;
            alu_flag = (alu_in1 == alu_in2 );
        end
        5'b00001:begin // substract
            result=alu_in1-alu_in2;
        end
        5'b00010:begin //mult
            result=temp[width-1:0];
        end
        5'b00011:begin // div
            result = alu_in1/alu_in2;
        end
        5'b00100:begin // and
            result = alu_in1&alu_in2;
        end
        5'b00101:begin // or
            result = alu_in1|alu_in2;
        end
        5'b00110:begin // xor
            result=alu_in1^alu_in2;
        end
        5'b00111:begin // nor
            result= ~(alu_in1 | alu_in2);
        end
        5'b01000:begin // not
            result = ~alu_in1; 
            alu_flag = (alu_in1 != alu_in2 );       
        end
        5'b01001:begin // shift_left
            result = alu_in1 << alu_in2[4:0];
        end
        5'b01010:begin // shift_right
            result = alu_in1 >> alu_in2[4:0];
        end
        5'b01011:begin // less than  signed?
            result = ( temp_alu1 < temp_alu2 );
            alu_flag = ( temp_alu1 < temp_alu2 );
        end
        5'b01100:begin // less than unsigned
            result = ( alu_in1 < alu_in2 ) ;
            alu_flag = ( temp_alu1 < temp_alu2 );
        end
        5'b01101:begin // inc
            result = alu_in1+1;
        end
        5'b01110:begin // dec
            result = alu_in1-1;
        end
    default:begin
         result=32'hzzzzzzzz;
    end   
    endcase
end

endmodule