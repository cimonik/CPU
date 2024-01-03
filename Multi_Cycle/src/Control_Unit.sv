module  Control_Unit(
input clk,rst,
input [6:0] opcode,
input [2:0] func3,
input [6:0] func7,
input alu_flag,
input alu_valid,
output reg We_Data_Mem,
output reg We_Reg,
output reg [1:0]Alu_Select1,
output reg Alu_Select2,
output reg [1:0]Result_Select,
output reg [1:0]Imm_Select,
output reg [4:0] Alu_Func,   
output reg F_En ,
output reg Instr_En,
output reg alu_start
);


parameter Fetch=0;
parameter Decode=1;
parameter Execute=2;

reg [1:0]main_state;
reg [1:0]inner_state;

always @(*)begin

case(main_state)
        
            Fetch:begin
            F_En=1; Instr_En=1; We_Data_Mem=0; We_Reg=0; Alu_Select1=2'b00; Alu_Select2=1; Alu_Func=5'b01101; Result_Select=2'b10;
            
            end 
            Decode:begin
             Alu_Select1=2'b01; Alu_Select2=1;  F_En=0; Instr_En=0; Alu_Func=5'b00000; Imm_Select=2'b10;
            end
            
            Execute:begin
                
                    case (opcode)
                        
                        6'b0000011:begin //3 --> load adrres of [rs1+immediate] load operation 
                            case(func3)
                                3'b010:begin
                                    if(inner_state==2'b00) begin
                                        Alu_Func = 5'b00000;  Alu_Select2 = 1'b1; Alu_Select1 = 2'b10; We_Data_Mem=0;  Imm_Select=2'b00;
                                    end
                                    if(inner_state==2'b01) begin
                                        Result_Select=2'b00;
                                    end
                                    if(inner_state==2'b10) begin
                                        Result_Select=2'b01; We_Reg=1;
                                    end    
                                end
                            endcase
                    
                        end
                        
                        6'b0010011:begin //19 --> immediate Alu op
                            if(inner_state==2'b00) begin
                            Alu_Select2 = 1; Alu_Select1 = 2'b10; Imm_Select=2'b00;
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
                            
                            if(inner_state==2'b01) begin
                                We_Reg=1; Result_Select=2'b00;
                            end
                            
                        end
                        
                        7'b0100011:begin // 35 S type Ins
                            case(func3)
                            3'b010:begin //store word
                                 if(inner_state==2'b00) begin
                                        Alu_Func = 5'b00000;  Alu_Select2 = 1'b1; Alu_Select1 = 2'b10; We_Data_Mem=0;  Imm_Select=2'b00;
                                 end
                                 if(inner_state==2'b01) begin
                                     We_Data_Mem=1; Result_Select=2'b00;
                                end 
                            end
                            endcase
                    end
                    
                    
                        7'b0110011 :begin // 53 R type Ins
                            if(inner_state==2'b00) begin
                                Alu_Select2 = 0; Alu_Select1 = 2'b10; Imm_Select=2'b00; 
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
                            if(inner_state==2'b01) begin
                                if(func7==7'b0010000 || func7==7'b0110000 )begin
                                if(alu_valid)begin
                                end
                                end
                                else begin
                               We_Reg=1; Result_Select=2'b00;  
                                end 
                            end
                            
                            if(inner_state==2'b10) begin
                                We_Reg=1; Result_Select=2'b00;
                            end
                        end
                        
                 
                        7'b1100011:begin // 99 B type Instructions
                            
                            Alu_Select2 = 1'b0;Alu_Select1 = 2'b10; We_Data_Mem=0; Result_Select =2'b00; We_Reg=0; 
                            case(func3)
                                3'b000:begin // branch if =
                                    Alu_Func = 5'b00000;  F_En=alu_flag;
                                end
                                3'b001:begin // branch if not =
                                    Alu_Func = 5'b01011; F_En=alu_flag;
                                end
                                3'b100:begin // branch if <
                                    Alu_Func = 5'b01000; F_En=alu_flag;
                                end
                                3'b101:begin // branch if >=
                                    Alu_Func = 5'b01000; F_En=alu_flag;
                                end
                                3'b110:begin // branch if < unsigned
                                    Alu_Func = 5'b01100; F_En=alu_flag;
                                end
                                3'b111:begin // branch if >= unsigned
                                    Alu_Func = 5'b01100; F_En=alu_flag;
                                end
                            endcase
                        end
                    endcase                         
                            end           
                endcase
end



always @(posedge clk)begin
    if(rst)begin
         inner_state <=0;
         main_state <=0;
    end
    
    else begin
    
        case(main_state)
        
            Fetch:begin
            main_state<=Decode;
            inner_state<=2'b00;
            end
            
            Decode:begin
             main_state<=Execute;
            end
            
            Execute:begin
                    case (opcode)
                        6'b0000011:begin //3 --> load adrres of [rs1+immediate] load operation 
                            case(func3)
                                3'b010:begin
                                    if(inner_state==2'b00) begin
                                        inner_state<=2'b01;
                                    end
                                    if(inner_state==2'b01) begin
                                        inner_state<=2'b10;
                                    end
                                    if(inner_state==2'b10) begin
                                        inner_state<=2'b00;
                                        main_state<=Fetch;
                                    end
                                end
                            endcase
                        end
                        6'b0010011:begin //19 --> immediate Alu op
                            if(inner_state==2'b00) begin
                            inner_state<=2'b01;
                            end
                            if(inner_state==2'b01) begin
                                main_state<=Fetch;
                                inner_state<=2'b00;
                            end
                        end
                        7'b0100011:begin // 35 S type Ins
                            case(func3)
                            3'b010:begin //store word
                                 if(inner_state==2'b00) begin
                                        inner_state<=2'b01;
                                 end
                                 if(inner_state==2'b01) begin
                                     inner_state<=2'b00;
                                     main_state<=Fetch;
                                end 
                            end
                            endcase
                    end
                        7'b0110011 :begin // 53 R type Ins
                            if(inner_state==2'b00) begin
                                inner_state<=2'b01;
                                alu_start<=1;
                            end
                            if(inner_state==2'b01) begin
                                alu_start<=0;
                                if(func7==7'b0010000 || func7==7'b0110000 )begin
                                if(alu_valid)begin
                                inner_state<=2'b10;
                                end
                                end
                                else begin
                                inner_state<=0;
                                main_state<=Fetch;     
                                end 
                            end
                            
                            if(inner_state==2'b10) begin
                                inner_state<=0;
                                main_state<=Fetch; 
                            end
                        end
                        7'b1100011:begin // 99 B type Instructions
                            main_state<=Fetch;
                        end
                    endcase    
                            end
                        endcase
    end
end    
endmodule