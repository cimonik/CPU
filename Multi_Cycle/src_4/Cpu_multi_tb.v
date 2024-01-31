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
 $readmemb("Instruction.mem",data); 
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
