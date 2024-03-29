module Data_Memory #(parameter width=32) (
input clk,rst,We,
input [width-1:0] Data_Adr,
input [width-1:0] WD,
output [width-1:0] RD    
);
    reg [width-1:0] data [0:123];
    integer i;
    
    always @(posedge clk)begin
        if(rst)begin
data[0] <= 0;        data[1] <= 0;        data[2] <= 0;        data[3] <= 0;        data[4] <= 0;        data[5] <= 0;        data[6] <= 0;        data[7] <= 0;        data[8] <= 0;        data[9] <= 0;
data[10] <= 0;       data[11] <= 0;        data[12] <= 0;        data[13] <= 0;        data[14] <= 0;        data[15] <= 0;        data[16] <= 0;        data[17] <= 0;        data[18] <= 0;        data[19] <= 0;
data[20] <= 0;        data[21] <= 0;        data[22] <= 0;        data[23] <= 0;        data[24] <= 0;        data[25] <= 0;        data[26] <= 0;        data[27] <= 0;        data[28] <= 0;        data[29] <= 0;
data[30] <= 0;        data[31] <= 0;        data[32] <= 0;        data[33] <= 0;        data[34] <= 0;        data[35] <= 0;        data[36] <= 0;        data[37] <= 0;        data[38] <= 0;        data[39] <= 0;
data[40] <= 0;        data[41] <= 0;        data[42] <= 0;        data[43] <= 0;        data[44] <= 0;        data[45] <= 0;        data[46] <= 0;        data[47] <= 0;        data[48] <= 0;        data[49] <= 0;
data[50] <= 0;        data[51] <= 0;        data[52] <= 0;        data[53] <= 0;        data[54] <= 0;        data[55] <= 0;        data[56] <= 0;        data[57] <= 0;        data[58] <= 0;        data[59] <= 0;
data[60] <= 0;        data[61] <= 0;        data[62] <= 0;        data[63] <= 0;        data[64] <= 0;        data[65] <= 0;        data[66] <= 0;        data[67] <= 0;        data[68] <= 0;        data[69] <= 0;
data[70] <= 0;        data[71] <= 0;        data[72] <= 0;        data[73] <= 0;        data[74] <= 0;        data[75] <= 0;        data[76] <= 0;        data[77] <= 0;        data[78] <= 0;        data[79] <= 0;
data[80] <= 0;        data[81] <= 0;        data[82] <= 0;        data[83] <= 0;        data[84] <= 0;        data[85] <= 0;        data[86] <= 0;        data[87] <= 0;        data[88] <= 0;        data[89] <= 0;
data[90] <= 0;        data[91] <= 0;        data[92] <= 0;        data[93] <= 0;        data[94] <= 0;        data[95] <= 0;        data[96] <= 0;        data[97] <= 0;        data[98] <= 0;        data[99] <= 0;
data[100] <= 0;       data[101] <= 0;       data[102] <= 0;       data[103] <= 0;       data[104] <= 0;       data[105] <= 0;       data[106] <= 0;       data[107] <= 0;       data[108] <= 0;       data[109] <=0;
data[110] <= 0;      data[111] <= 0;        data[112] <= 0;       data[113] <= 0;        data[114] <= 0;        data[115] <= 0;        data[116] <= 0;        data[117] <= 0;        data[118] <= 0;        data[119] <= 0;       data[120] <= 0;        data[121] <= 0;      data[122] <= 0;        data[123] <= 0;           
        end
        else begin
            if(We)begin
               data[Data_Adr[7:0]]<=WD; 
            end
        end
    end
     assign RD=data[Data_Adr[7:0]];
    
endmodule
