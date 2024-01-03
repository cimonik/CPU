module Control_Unit #(parameter width=32)(
input [6:0] opcode,
input [2:0] func3,
input [6:0] func7,
input alu_flag,
output reg We_Data_Mem,
output reg We_Reg,
output reg Pc_Select,
output reg Alu_Select,
output reg Result_Select,
output reg [1:0]Imm_Select,
output reg [4:0] Alu_Func
); 

always @(*) begin

    case (opcode)
        6'b0000011:begin //3 --> load adrres of [rs1+immediate] load operation 
            case(func3)
                3'b010:begin
                    Alu_Func = 5'b00000;  Alu_Select = 5'd1; We_Data_Mem=0; Pc_Select=0; Result_Select =1; We_Reg=1; Imm_Select=2'b00;
                end
            endcase
    
        end
        
        6'b0010011:begin //19 --> immediate Alu op  
            Alu_Select = 5'd1; We_Data_Mem=0; Pc_Select=0; Result_Select =0; We_Reg=1; Imm_Select=2'b00;
            case(func3)
                3'b000:begin // add
                    Alu_Func = 5'b00000;  
                end
                3'b001:begin // shift left
                    Alu_Func = 5'b01001;  
                end
                3'b010:begin // set less than
                    Alu_Func = 5'b01011;  
                end
                3'b011:begin // set less than unsigned
                    Alu_Func = 5'b01100;     
                end
                3'b100:begin // xor
                    Alu_Func = 5'b00110;         
                end
                3'b101:begin // shift right
                    Alu_Func = 5'b01010;       
                end
                3'b110:begin // orr
                    Alu_Func = 5'b00101;         
                end
                3'b111:begin // and
                    Alu_Func = 5'b00100;          
                end
            endcase
        end
        
        7'b0100011:begin // 35 S type Ins
            case(func3)
            3'b010:begin //store word
                Alu_Func = 5'b00000;  Alu_Select = 5'd1; We_Data_Mem=1; Pc_Select=0; Result_Select =1; We_Reg=0; Imm_Select=2'b01;
            
            end
            endcase
    end
    
    
        7'b0110011 :begin // 53 R type Ins
        Alu_Select = 5'd0; We_Data_Mem=0; Pc_Select=0; Result_Select =0; We_Reg=1; Imm_Select=2'b00; 
            case(func3) //add,sub,multiply,divide
            3'b000:begin        
                case(func7)
                    7'b0000000:begin //add
                        Alu_Func = 5'b00000;
                    end
                    7'b0100000:begin //sub
                        Alu_Func = 5'b00001;
                    end
                    7'b0010000:begin //mul
                        Alu_Func = 5'b00010;
                    end
                    7'b0110000:begin //div
                        Alu_Func = 5'b00011;
                    end
                 endcase
            end
            
            3'b001:begin // shift left
                Alu_Func = 5'b01001; 
            end 
            3'b010:begin // set less than signed
                Alu_Func = 5'b01011; 
            end
            3'b011:begin // set less than unsigned
                Alu_Func = 5'b01100;  
            end
            3'b100:begin // xor
                Alu_Func = 5'b00110; 
            end
            3'b101:begin // shift right
                Alu_Func = 5'b01010; 
            end
            3'b110:begin // orr
                Alu_Func = 5'b00101; 
            end
            3'b111:begin // and
                Alu_Func = 5'b00100; 
            end
            endcase       
        end
 
        7'b1100011:begin // 99 B type Instructions
            Alu_Select = 5'd0; We_Data_Mem=0; Result_Select =0; We_Reg=0; Imm_Select=2'b10;
            case(func3)
                3'b000:begin // branch if =
                    Alu_Func = 5'b00000; Pc_Select=alu_flag;
                end
                3'b001:begin // branch if not =
                    Alu_Func = 5'b01011; Pc_Select=alu_flag;
                end
                3'b100:begin // branch if <
                    Alu_Func = 5'b01000; Pc_Select=alu_flag;
                end
                3'b101:begin // branch if >=
                    Alu_Func = 5'b01000; Pc_Select=~alu_flag;
                end
                3'b110:begin // branch if < unsigned
                    Alu_Func = 5'b01100; Pc_Select=alu_flag;
                end
                3'b111:begin // branch if >= unsigned
                    Alu_Func = 5'b01100; Pc_Select=~alu_flag;
                end
            endcase
        end
    endcase
end

endmodule