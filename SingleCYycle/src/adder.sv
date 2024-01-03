module adder#(parameter width=32)(
    input [width-1:0] in1,
    input [width-1:0] in2,
    output [width-1:0] out,
    output overflow    
);

wire [width:0] temp_out;

assign temp_out = in1+in2;
assign overflow= temp_out[width] ? 1 : 0 ; 
assign out = temp_out[width-1:0]; 

endmodule