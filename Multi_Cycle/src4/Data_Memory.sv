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
        data[0]<=32'h5; 
        data[1]<=32'h4;
        data[2]<=32'h8; 
        data[3]<=32'h9;
        data[4]<=32'ha; 
        data[5]<=32'h2;
        data[6]<=32'h3;
        data[7]<=32'h4; 
        data[8]<=32'h5;
        data[9]<=32'h6;
        data[10]<=32'h8; 
        data[11]<=32'ha;
        data[12]<=32'h8;
        data[13]<=32'h6;
        data[14]<=32'h5; 
        data[15]<=32'h3;
        data[16]<=32'h2;
        data[17]<=32'h1;
        data[18]<=32'h0;
        
            for(i=19;i<512;i++)begin
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