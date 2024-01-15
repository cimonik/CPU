module ALU #(parameter width=32)
(
input clk,rst,
input [width-1:0] alu_in1,
input [width-1:0] alu_in2,
input [4:0] opcode,
input alu_start,
output reg [width-1:0] result,
output reg alu_flag ,
output reg valid  
);

// 00000 add , 00001 substract , 00010  mult , 00011 div , 00100 and , 
// 00101 or  , 00110 xor       , 00111 nor   , 01000 not , 01001 sl  ,
// 01010 sr  , 01011 rl        , 01100 rr    , 01101 inc , 01110 dec ,
wire [2*width-1:0]temp;
wire signed [width-1:0] temp_alu1,temp_alu2;
assign temp = alu_in1 * alu_in2;
assign temp_alu1=alu_in1;
assign temp_alu2=alu_in2;

reg start_div;
wire busy_div,valid_div,error_div;
wire [31:0]result_div;
Divider Div(
     .clk_i(clk),
     .rst_i(rst),
     .divident(alu_in1),
     .divisor(alu_in2),   // 1 = remainder , 0 = queotient
     .start_flag(start_div),
     .busy_o(busy_div),
     .valid_o(valid_div),
     .error_o(error_div),
     .result_o(result_div)
    );

reg mult_start;
wire mult_valid,mult_busy,mult_signed;
wire[63:0] mult_result;
Multiplier Mul(
     .clk(clk),
     .rst(rst),
     .rs1(alu_in1),
     .rs2(alu_in2),
     .signed_mul(mult_signed),
     .start(mult_start),
     .result(mult_result),
     .valid(mult_valid),
     .busy(mult_busy)
);
assign mult_signed=1;
always@(*)begin
    case(opcode)
        5'b00000:begin //add
            result=alu_in1+alu_in2;
            alu_flag = (alu_in1 == alu_in2 );
            valid=0;
        end
        5'b00001:begin // substract
            result=alu_in1-alu_in2;
            valid=0;
        end
        5'b00010:begin //mult
            result=mult_result[31:0];
            valid=mult_valid;
            mult_start=alu_start;
        end
        5'b00011:begin // div
            result = result_div;
            valid=valid_div;
            start_div=alu_start;
        end
        5'b00100:begin // and
            result = alu_in1&alu_in2;
            valid=0;
        end
        5'b00101:begin // or
            result = alu_in1|alu_in2;
            valid=0;
        end
        5'b00110:begin // xor
            result=alu_in1^alu_in2;
            valid=0;
        end
        5'b00111:begin // nor
            result= ~(alu_in1 | alu_in2);
            valid=0;
        end
        5'b01000:begin // not
            result = ~alu_in1; 
            alu_flag = (alu_in1 != alu_in2 );  
            valid=0;     
        end
        5'b01001:begin // shift_left
            result = alu_in1 << alu_in2[4:0];
            valid=0;
        end
        5'b01010:begin // shift_right
            result = alu_in1 >> alu_in2[4:0];
            valid=0;
        end
        5'b01011:begin // less than  signed?
            result = ( temp_alu1 < temp_alu2 );
            alu_flag = ( temp_alu1 < temp_alu2 );
            valid=0;
        end
        5'b01100:begin // less than unsigned
            result = ( alu_in1 < alu_in2 ) ;
            alu_flag = ( temp_alu1 < temp_alu2 );
            valid=0;
        end
        5'b01101:begin // inc
            result = alu_in1+1;
            valid=0;
        end
        5'b01110:begin // dec
            result = alu_in1-1;
            valid=0;
        end
    default:begin
         result=32'hzzzzzzzz;
         mult_start=0;
         start_div=0;
    end   
    endcase
end

endmodule
