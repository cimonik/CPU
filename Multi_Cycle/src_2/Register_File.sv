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
           regs[0]<=0; regs[1]<=0; regs[2]<=0; regs[3]<=0; regs[4]<=0; regs[5]<=0; regs[6]<=0; regs[7]<=0;
	   regs[8]<=0; regs[9]<=0; regs[10]<=0; regs[11]<=0;regs[12]<=0; regs[13]<=0; regs[14]<=0; regs[15]<=0; 
	   regs[16]<=0; regs[17]<=0; regs[18]<=0; regs[19]<=0;regs[20]<=0;regs[21]<=0; regs[22]<=0; regs[23]<=0;
	   regs[24]<=0; regs[25]<=0;regs[26]<=0; regs[27]<=0;regs[28]<=0; regs[29]<=0;regs[30]<=0;regs[31]<=0;
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
