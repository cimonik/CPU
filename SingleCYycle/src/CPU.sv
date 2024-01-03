module CPU #(parameter width=32)(
    input clk,rst,
    input start,
    output valid
    );
    
    wire We_Data_Mem,We_Reg,Pc_Select,Alu_Select,Result_Select,alu_flag;
    wire [1:0]Imm_Select;
   
    wire [width-1:0]alu_in1,alu_in2;
    wire [4:0] Alu_Func;
    wire [width-1:0] result; 
    
    ALU alu1(
        .alu_in1(alu_in1),   
        .alu_in2(alu_in2),   
        .opcode(Alu_Func),          
        .result(result),
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
    wire [width-1:0] Ins_Out;
    
    Instruction_memory Ins_Mem(
        .adr(Pc),
        .data_out(Ins_Out)
    );
    
     Control_Unit CU(
        .opcode(Ins_Out[6:0]),
        .func3(Ins_Out[14:12]),
        .func7(Ins_Out[31:25]),
        .alu_flag(alu_flag),
        .We_Data_Mem(We_Data_Mem),
        .We_Reg(We_Reg),
        .Pc_Select(Pc_Select),
        .Alu_Select(Alu_Select),
        .Result_Select(Result_Select),
        .Imm_Select(Imm_Select),
        .Alu_Func(Alu_Func)
        ); 
    
       
    wire [width-1:0]Imm_Ext;
    Extend ext(
        .Imm_in(Ins_Out[31:7]),
        .Imm_Select(Imm_Select),
        .Imm_Ext(Imm_Ext)
        ); 
    
    //instruction mem input side
    wire [6:0] Pc_Inc;
    assign Pc_Inc = Pc+1;
    
    wire [6:0] Pc_Jump;
    assign Pc_Jump =Pc + Imm_Ext[6:0];
    
    wire [6:0] Pc_Next;
    assign Pc_Next = Pc_Select ?  Pc_Jump  : Pc_Inc  ;
    
    //register file connection
    
    assign A1 = Ins_Out[19:15];
    assign A2 = Ins_Out[24:20];
    assign A3 = Ins_Out[11:7];
    
    
    //Alu input side
    
    assign alu_in1 = RD1;
    assign alu_in2 = Alu_Select ? Imm_Ext : RD2 ;
    
    
    //Data Memory input
    
    assign Data_Write = RD2;
    assign Data_Adr = result;
    
    assign Write_Data_Reg = Result_Select ? Data_Read :  result ;
    reg [6:0] temp_pc;
    assign Pc = temp_pc;
    always @(posedge clk) begin
        if(rst)begin
        temp_pc<=0;
        end
        else begin
        temp_pc<=Pc_Next;
        end
    end

    
endmodule
