module Instruction_memory #(parameter width=32)(
input clk,
input rst,
input  [6:0]adr,
output [width-1:0] data_out
);
    
reg [width-1:0] data [0:11];  
 
always @(posedge clk)begin
	if(rst)begin
	data[0]<=32'b000000000111_00000_000_00001_0010011; // addi x1, x0 , 7
	data[1]<=32'b000000000011_00000_000_00010_0010011; // addi x2, x0 , 3
	data[2]<=32'b0000000_00001_00010_000_00011_0110011; // add x3,x2,x1 
	data[3]<=32'b000000001010_00000_000_00100_0010011; // addi x4, x0 , 10
	data[4]<=32'b0000000_00100_00011_111_00101_0110011; // and x5,x4,x3 
	data[5]<=32'b0000000_00100_00011_000_00010_1100011; // beq x3,x4,2 
	data[6]<=32'b0000000_00100_00011_111_00110_0110011; // and x6,x4,x3 
	data[7]<=32'b0000000_00100_00011_111_00111_0110011; // and x7,x4,x3 
	data[8]<=32'b0000000_00100_00011_111_01000_0110011; // and x8,x4,x3 
	data[9]<=32'b000000000010_00000_000_01001_0010011 ;// addi x9, x0 ,2
	data[10]<=32'b0110000_01001_01000_000_01010_0110011; // Div x10, x8,x9 
	data[11]<=32'b0010000_01001_01000_000_01011_0110011; // Mul x11, x8,x9
	end
end

assign data_out = data[adr];

endmodule
