module CPU #(parameter width=32)(
    input clk,rst,
    input start,
    output valid
    );
    
    wire We_Data_Mem,We_Reg,Pc_Select,Alu_Select2,alu_flag;
    wire[1:0] Result_Select,Alu_Select1;
    wire [1:0]Imm_Select;
    wire F_En,Instr_En;
    wire [width-1:0]alu_in1,alu_in2;
    wire [4:0] Alu_Func;
    wire [width-1:0] alu_result,result; 
    wire alu_valid;
    wire alu_start;
    ALU alu1(
        .clk(clk),
        .rst(rst),
        .alu_in1(alu_in1),   
        .alu_in2(alu_in2),   
        .opcode(Alu_Func),
        .alu_start(alu_start),        
        .result(alu_result),
        .valid(alu_valid),
        .alu_flag(alu_flag)
    );
    
    wire [width-1:0] Data_Adr, Data_Write, Data_Read;
    
    Data_Memory mem(
        .clk(clk),
        .rst(rst),
        .We(We_Data_Mem),          
        .Data_Adr(Data_Adr),
        .WD(Data_Write),      
        .RD(Data_Read)      
    );
    
    wire [4:0] A1,A2,A3;
    wire [width-1:0] Write_Data_Reg;
    wire [width-1:0] RD1,RD2;
    
    Register_File  Reg_File(
        .clk(clk),
        .rst(rst),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(Write_Data_Reg),
        .WE3(We_Reg),
        .RD1(RD1),
        .RD2(RD2)    
    );
    
    wire [6:0] Pc;
    wire[width-1:0] Ins_Out;
    reg [width-1:0] Ins_Out_reg;
    
    Instruction_memory Ins_Mem(
        .adr(Pc),
        .data_out(Ins_Out)
    );
    
     Control_Unit CU(
        .clk(clk),
        .rst(rst),
        .opcode(Ins_Out_reg[6:0]),
        .func3(Ins_Out_reg[14:12]),
        .func7(Ins_Out_reg[31:25]),
        .alu_flag(alu_flag),
        .alu_valid(alu_valid),
        .We_Data_Mem(We_Data_Mem),
        .We_Reg(We_Reg),
        .Alu_Select1(Alu_Select1),
        .Alu_Select2(Alu_Select2),
        .Result_Select(Result_Select),
        .Imm_Select(Imm_Select),
        .Alu_Func(Alu_Func),
        .F_En(F_En) ,  
        .Instr_En(Instr_En),
        .alu_start(alu_start)
        ); 
    
       
    wire [width-1:0]Imm_Ext;
    Extend ext(
        .Imm_in(Ins_Out_reg[31:7]),
        .Imm_Select(Imm_Select),
        .Imm_Ext(Imm_Ext)
        ); 
    
    //instruction mem input side
  //  wire [6:0] Pc_Inc;
  //  assign Pc_Inc = Pc+1;
    
  //  wire [6:0] Pc_Jump;
  //  assign Pc_Jump =Pc + Imm_Ext[6:0];
    
  //  wire [6:0] Pc_Next;
  //  assign Pc_Next = Pc_Select ?  Pc_Jump  : Pc_Inc  ;
    
    //register file connection
    
    assign A1 = Ins_Out_reg[19:15];
    assign A2 = Ins_Out_reg[24:20];
    assign A3 = Ins_Out_reg[11:7];
    

    wire [width-1:0] Pc_Next;
    assign Pc_Next = result ;
    assign Write_Data_Reg = result;
    reg [6:0] temp_pc;
    assign Pc = temp_pc;
  
    
    reg [31:0]OldPc,Instr;
    reg [31:0] RD1_reg,RD2_reg;
    reg [31:0] alu_result_reg;
    
    
      //Data Memory input
    
    assign Data_Write = RD2_reg;
    assign Data_Adr = alu_result_reg;
    
    assign result = Result_Select[1] ? alu_result : (Result_Select[0] ?Data_Read:alu_result_reg)  ;
    
        
    //Alu input side
    
    assign alu_in1 = Alu_Select1[1] ? RD1_reg : (Alu_Select1[0] ? OldPc :temp_pc);
    assign alu_in2 = Alu_Select2 ? Imm_Ext : RD2_reg ;
    
    always @(posedge clk)begin
        if(rst)begin
         temp_pc<=0;
        end
        
        else begin
                alu_result_reg<=alu_result;
                
                RD1_reg<=RD1;
                RD2_reg<=RD2;
            if(F_En)
                temp_pc<=Pc_Next;
            if(Instr_En)begin
                Ins_Out_reg<=Ins_Out;
                OldPc<=Pc;
            end
            
            
                
        end
        
    end
endmodule
