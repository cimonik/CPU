module Extend(
    input [24:0] Imm_in,
    input [1:0] Imm_Select,
    output reg [31:0] Imm_Ext
    );
    
    
    always @(*) begin
    
        case(Imm_Select)
        2'b00:begin // I type sign extentation
            if(Imm_in[24])
                Imm_Ext = {20'hfffff , Imm_in[24:13]} ;
            else
                Imm_Ext = {20'h0 , Imm_in[24:13]} ;
        end
        2'b01:begin // Extended for Store
            Imm_Ext = {20'h0 , Imm_in[24:18],Imm_in[4:0]} ;
        end
        2'b10:begin // Extended for branch
            if(Imm_in[24])
                Imm_Ext = {19'hfffff , Imm_in[0],Imm_in[23:18],Imm_in[4:1],1'b0} ;
            else
                Imm_Ext = {19'h00000 , Imm_in[0],Imm_in[23:18],Imm_in[4:1],1'b0} ;
        
        end
        2'b11:begin 
        
        end
        
        endcase
    
    
    
    end
    
    
endmodule
