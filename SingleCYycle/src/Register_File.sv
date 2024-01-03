module Register_File #(parameter width=32) (
    input clk,rst,
    input [4:0]A1,
    input [4:0]A2,
    input [4:0]A3,
    input [width-1:0]WD3,
    input WE3,
    output [width-1:0] RD1,
    output [width-1:0] RD2    
);
    reg [width-1:0] regs [0:31];
    integer i;
    always @(posedge clk)begin
        if(rst)begin
            for(i=0;i<32;i++)begin
            regs[i]<=0;    
            end
        end
        
        else begin
             if (WE3) begin
                regs[A3] <= WD3;
             end   
        end
    end
    
   assign  RD1= regs[A1];
   assign  RD2= regs[A2];     
      
endmodule