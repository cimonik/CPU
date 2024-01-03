module Cpu_multi_tb();
reg clk,rst,start;
wire valid;

 CPU cpu_test(
    .clk(clk),
    .rst(rst),
    .start(start),
    .valid(valid)
    );



always begin
#5 clk=~clk;
end


initial begin
clk=0;
rst=1;
#50
rst=0;




end
endmodule
