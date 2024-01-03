module Data_Memory #(parameter width=32) (
input clk,rst,We,
input [width-1:0] Data_Adr,
input [width-1:0] WD,
output [width-1:0] RD    
);
    reg [width-1:0] data [0:511];
    integer i;
    
    always @(posedge clk)begin
        if(rst)begin
            for(i=0;i<512;i++)begin
                data[i]<=0;
            end 
        end
        else begin
            if(We)begin
               data[Data_Adr]<=WD; 
            end
        end
    end
     assign RD=data[Data_Adr];
    
endmodule