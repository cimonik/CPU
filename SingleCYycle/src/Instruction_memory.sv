module Instruction_memory #(parameter width=32)(
input  [6:0]adr,
output [width-1:0] data_out
);
    
reg [width-1:0] data [0:127];  
 
initial begin
   $readmemb("Instruction.mem",data);   
end

assign data_out = data[adr];

endmodule