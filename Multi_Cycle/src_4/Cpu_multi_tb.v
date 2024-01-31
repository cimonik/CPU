module Cpu_multi_tb();
reg clk,rst,start,load;
wire valid;
reg [31:0]ins;
integer i;
reg [31:0]data[0:128];
 CPU cpu_test(
    .clk(clk),
    .rst(rst),
    .load(load),
    .ins(ins),
    .start(start)
    );


always begin
#5 clk=~clk;
end


initial begin
 data[0]=000000010011_00001_000_00001_0010011; // addi x1, x1 ,19
 data[1]=000000000000_00000_010_00010_0000011 ;//load [x0+0] to x2
 data[2]=0000000_00011_00010_000_00011_0110011; // add x3,x2,x3 
 data[3]=000000000001_00000_000_00000_0010011; // addi x0, x0 , 1
 data[4]=1111111_00001_00000_001_11011_1100011; // bneq x1,x0,3

clk=0;
rst=1;
start=0;
#50
rst=0;

load=1;
    for(i=0;i<20;i=i+1) begin
        ins<=data[i];
    #10;
    end
load=0;
#20;
start=1;



end
endmodule
