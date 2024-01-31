module Instruction_memory #(parameter width=32)(
input clk,write,rst,
input  [6:0]adr,
input [width-1:0] data_in,
output [width-1:0] data_out
);
    
reg [width-1:0] data [0:127];  
reg [5:0]counter;

assign data_out = data[adr];

always @(posedge clk)begin
    if(rst)
        counter<=0;
        
    else begin
        if(write)begin
            data[counter]<=data_in;
            counter<=counter+1;
        end
    end

end


endmodule