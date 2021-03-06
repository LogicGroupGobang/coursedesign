`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:20:55 12/31/2018 
// Design Name: 
// Module Name:    lower_left_to_upper_right 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module lower_left_to_upper_right(
	input wire [3:0] row,//上一步下棋的行数
	input wire [3:0] col,//上一步下棋的列数
	input wire [224:0] ch,//上一步下棋的棋手对应的棋面
	output reg win_check
    );
	wire [4:0] sw;
	assign sw = row + col; 
	always @(*)begin
		case(sw)
			5'd4:
				if((ch[60]&&ch[46]&&ch[32]&&ch[18]&&ch[4]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd5:
				if((ch[75]&&ch[61]&&ch[47]&&ch[33]&&ch[19])||
					(ch[61]&&ch[47]&&ch[33]&&ch[19]&&ch[5]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd6:
				if((ch[90]&&ch[76]&&ch[62]&&ch[48]&&ch[34])||
					(ch[76]&&ch[62]&&ch[48]&&ch[34]&&ch[20])||
					(ch[62]&&ch[48]&&ch[34]&&ch[20]&&ch[6]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd7:
				if((ch[105]&&ch[91]&&ch[77]&&ch[63]&&ch[49])||
					(ch[91]&&ch[77]&&ch[63]&&ch[49]&&ch[35])||
					(ch[77]&&ch[63]&&ch[49]&&ch[35]&&ch[21])||
					(ch[63]&&ch[49]&&ch[35]&&ch[21]&&ch[7]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd8:
				if((ch[120]&&ch[106]&&ch[92]&&ch[78]&&ch[64])||
					(ch[106]&&ch[92]&&ch[78]&&ch[64]&&ch[50])||
					(ch[92]&&ch[78]&&ch[64]&&ch[50]&&ch[36])||
					(ch[78]&&ch[64]&&ch[50]&&ch[36]&&ch[22])||
					(ch[64]&&ch[50]&&ch[36]&&ch[22]&&ch[8]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd9:
				if((ch[135]&&ch[121]&&ch[107]&&ch[93]&&ch[79])||
					(ch[121]&&ch[107]&&ch[93]&&ch[79]&&ch[65])||
					(ch[107]&&ch[93]&&ch[79]&&ch[65]&&ch[51])||
					(ch[93]&&ch[79]&&ch[65]&&ch[51]&&ch[37])||
					(ch[79]&&ch[65]&&ch[51]&&ch[37]&&ch[23])||
					(ch[65]&&ch[51]&&ch[37]&&ch[23]&&ch[9]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd10:
				if((ch[150]&&ch[136]&&ch[122]&&ch[108]&&ch[94])||
					(ch[136]&&ch[122]&&ch[108]&&ch[94]&&ch[80])||
					(ch[122]&&ch[108]&&ch[94]&&ch[80]&&ch[66])||
					(ch[108]&&ch[94]&&ch[80]&&ch[66]&&ch[52])||
					(ch[94]&&ch[80]&&ch[66]&&ch[52]&&ch[38])||
					(ch[80]&&ch[66]&&ch[52]&&ch[38]&&ch[24])||
					(ch[66]&&ch[52]&&ch[38]&&ch[24]&&ch[10]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd11:
				if((ch[165]&&ch[151]&&ch[137]&&ch[123]&&ch[109])||
					(ch[151]&&ch[137]&&ch[123]&&ch[109]&&ch[95])||
					(ch[137]&&ch[123]&&ch[109]&&ch[95]&&ch[81])||
					(ch[123]&&ch[109]&&ch[95]&&ch[81]&&ch[67])||
					(ch[109]&&ch[95]&&ch[81]&&ch[67]&&ch[53])||
					(ch[95]&&ch[81]&&ch[67]&&ch[53]&&ch[39])||
					(ch[81]&&ch[67]&&ch[53]&&ch[39]&&ch[25])||
					(ch[67]&&ch[53]&&ch[39]&&ch[25]&&ch[11]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd12:
				if((ch[180]&&ch[166]&&ch[152]&&ch[138]&&ch[124])||
					(ch[166]&&ch[152]&&ch[138]&&ch[124]&&ch[110])||
					(ch[152]&&ch[138]&&ch[124]&&ch[110]&&ch[96])||
					(ch[138]&&ch[124]&&ch[110]&&ch[96]&&ch[82])||
					(ch[124]&&ch[110]&&ch[96]&&ch[82]&&ch[68])||
					(ch[110]&&ch[96]&&ch[82]&&ch[68]&&ch[54])||
					(ch[96]&&ch[82]&&ch[68]&&ch[54]&&ch[40])||
					(ch[82]&&ch[68]&&ch[54]&&ch[40]&&ch[26])||
					(ch[68]&&ch[54]&&ch[40]&&ch[26]&&ch[12]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd13:
				if((ch[195]&&ch[181]&&ch[167]&&ch[153]&&ch[139])||
					(ch[181]&&ch[167]&&ch[153]&&ch[139]&&ch[125])||
					(ch[167]&&ch[153]&&ch[139]&&ch[125]&&ch[111])||
					(ch[153]&&ch[139]&&ch[125]&&ch[111]&&ch[97])||
					(ch[139]&&ch[125]&&ch[111]&&ch[97]&&ch[83])||
					(ch[125]&&ch[111]&&ch[97]&&ch[83]&&ch[69])||
					(ch[111]&&ch[97]&&ch[83]&&ch[69]&&ch[55])||
					(ch[97]&&ch[83]&&ch[69]&&ch[55]&&ch[41])||
					(ch[83]&&ch[69]&&ch[55]&&ch[41]&&ch[27])||
					(ch[69]&&ch[55]&&ch[41]&&ch[27]&&ch[13]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd14:
				if((ch[210]&&ch[196]&&ch[182]&&ch[168]&&ch[154])||
					(ch[196]&&ch[182]&&ch[168]&&ch[154]&&ch[140])||
					(ch[182]&&ch[168]&&ch[154]&&ch[140]&&ch[126])||
					(ch[168]&&ch[154]&&ch[140]&&ch[126]&&ch[112])||
					(ch[154]&&ch[140]&&ch[126]&&ch[112]&&ch[98])||
					(ch[140]&&ch[126]&&ch[112]&&ch[98]&&ch[84])||
					(ch[126]&&ch[112]&&ch[98]&&ch[84]&&ch[70])||
					(ch[112]&&ch[98]&&ch[84]&&ch[70]&&ch[56])||
					(ch[98]&&ch[84]&&ch[70]&&ch[56]&&ch[42])||
					(ch[84]&&ch[70]&&ch[56]&&ch[42]&&ch[28])||
					(ch[70]&&ch[56]&&ch[42]&&ch[28]&&ch[14]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd15:
				if((ch[211]&&ch[197]&&ch[183]&&ch[169]&&ch[155])||
					(ch[197]&&ch[183]&&ch[169]&&ch[155]&&ch[141])||
					(ch[183]&&ch[169]&&ch[155]&&ch[141]&&ch[127])||
					(ch[169]&&ch[155]&&ch[141]&&ch[127]&&ch[113])||
					(ch[155]&&ch[141]&&ch[127]&&ch[113]&&ch[99])||
					(ch[141]&&ch[127]&&ch[113]&&ch[99]&&ch[85])||
					(ch[127]&&ch[113]&&ch[99]&&ch[85]&&ch[71])||
					(ch[113]&&ch[99]&&ch[85]&&ch[71]&&ch[57])||
					(ch[99]&&ch[85]&&ch[71]&&ch[57]&&ch[43])||
					(ch[85]&&ch[71]&&ch[57]&&ch[43]&&ch[29]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd16:
				if((ch[212]&&ch[198]&&ch[184]&&ch[170]&&ch[156])||
					(ch[198]&&ch[184]&&ch[170]&&ch[156]&&ch[142])||
					(ch[184]&&ch[170]&&ch[156]&&ch[142]&&ch[128])||
					(ch[170]&&ch[156]&&ch[142]&&ch[128]&&ch[114])||
					(ch[156]&&ch[142]&&ch[128]&&ch[114]&&ch[100])||
					(ch[142]&&ch[128]&&ch[114]&&ch[100]&&ch[86])||
					(ch[128]&&ch[114]&&ch[100]&&ch[86]&&ch[72])||
					(ch[114]&&ch[100]&&ch[86]&&ch[72]&&ch[58])||
					(ch[100]&&ch[86]&&ch[72]&&ch[58]&&ch[44]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd17:
				if((ch[213]&&ch[199]&&ch[185]&&ch[171]&&ch[157])||
					(ch[199]&&ch[185]&&ch[171]&&ch[157]&&ch[143])||
					(ch[185]&&ch[171]&&ch[157]&&ch[143]&&ch[129])||
					(ch[171]&&ch[157]&&ch[143]&&ch[129]&&ch[115])||
					(ch[157]&&ch[143]&&ch[129]&&ch[115]&&ch[101])||
					(ch[143]&&ch[129]&&ch[115]&&ch[101]&&ch[87])||
					(ch[129]&&ch[115]&&ch[101]&&ch[87]&&ch[73])||
					(ch[115]&&ch[101]&&ch[87]&&ch[73]&&ch[59]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd18:
				if((ch[214]&&ch[200]&&ch[186]&&ch[172]&&ch[158])||
					(ch[200]&&ch[186]&&ch[172]&&ch[158]&&ch[144])||
					(ch[186]&&ch[172]&&ch[158]&&ch[144]&&ch[130])||
					(ch[172]&&ch[158]&&ch[144]&&ch[130]&&ch[116])||
					(ch[158]&&ch[144]&&ch[130]&&ch[116]&&ch[102])||
					(ch[144]&&ch[130]&&ch[116]&&ch[102]&&ch[88])||
					(ch[130]&&ch[116]&&ch[102]&&ch[88]&&ch[74]))
					win_check =1'b1;
				else win_check = 1'b0;				
			5'd19:
				if((ch[215]&&ch[201]&&ch[187]&&ch[173]&&ch[159])||
					(ch[201]&&ch[187]&&ch[173]&&ch[159]&&ch[145])||
					(ch[187]&&ch[173]&&ch[159]&&ch[145]&&ch[131])||
					(ch[173]&&ch[159]&&ch[145]&&ch[131]&&ch[117])||
					(ch[159]&&ch[145]&&ch[131]&&ch[117]&&ch[103])||
					(ch[145]&&ch[131]&&ch[117]&&ch[103]&&ch[89]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd20:
				if((ch[216]&&ch[202]&&ch[188]&&ch[174]&&ch[160])||
					(ch[202]&&ch[188]&&ch[174]&&ch[160]&&ch[146])||
					(ch[188]&&ch[174]&&ch[160]&&ch[146]&&ch[132])||
					(ch[174]&&ch[160]&&ch[146]&&ch[132]&&ch[118])||
					(ch[160]&&ch[146]&&ch[132]&&ch[118]&&ch[104]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd21:
				if((ch[217]&&ch[203]&&ch[189]&&ch[175]&&ch[161])||
					(ch[203]&&ch[189]&&ch[175]&&ch[161]&&ch[147])||
					(ch[189]&&ch[175]&&ch[161]&&ch[147]&&ch[133])||
					(ch[175]&&ch[161]&&ch[147]&&ch[133]&&ch[119]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd22:
				if((ch[218]&&ch[204]&&ch[190]&&ch[176]&&ch[162])||
					(ch[204]&&ch[190]&&ch[176]&&ch[162]&&ch[148])||
					(ch[190]&&ch[176]&&ch[162]&&ch[148]&&ch[134]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd23:
				if((ch[219]&&ch[205]&&ch[191]&&ch[177]&&ch[163])||
					(ch[205]&&ch[191]&&ch[177]&&ch[163]&&ch[149]))
					win_check = 1'b1;
				else win_check = 1'b0;
			5'd24:
				if((ch[220]&&ch[206]&&ch[192]&&ch[178]&&ch[164]))
					win_check = 1'b1;
				else win_check = 1'b0;
			default: win_check = 1'b0;
			endcase
		end
endmodule
