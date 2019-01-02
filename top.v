`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:17:26 12/27/2018 
// Design Name: 
// Module Name:    top 
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
module top(

    input wire clk,         // Clock (100MHz)
    input wire rst,         // Reset button, 0 = pressed, 1 = released
    input wire ps2_clk,     // PS2 clock
    input wire ps2_data,    // PS2 data
    output wire sync_h,     // VGA horizontal sync
    output wire sync_v,     // VGA vertical sync
    output wire [3:0] r,    // VGA red component
    output wire [3:0] g,    // VGA green component
    output wire [3:0] b,   // VGA blue component
	  
	 //for test 
	 output wire seg_clk,
	 output wire seg_sout,
	 output wire SEG_PEN,
	 output wire seg_clrn
    );
    

    
    wire [3:0] display_i;
  
    wire [31:0] clk_div;
	 wire key_up, key_down, key_left, key_right, key_ok, key_switch;
    
    // Turn off the arduino buzzer
    //assign buz = 1'b1;
    reg [224:0] display_black,display_white;
	 reg [3:0] choose_row,choose_col;
    wire [3:0] whichkey;
	 
	 initial begin
		display_black <= 225'd5;
		display_white <= 225'd144;
		choose_row <= 4'd7;
		choose_col <= 4'd7;
    end
    
    disp_chess_board
        display(
            .clk(clk_div[1]),
            .rst(rst),
				.display_black(display_black),
				.display_white(display_white),
				.choose_row(choose_row), 
				.chosse_col(chosse_col), 
            .sync_h(sync_h),
            .sync_v(sync_v),
            .r(r),
            .g(g),
            .b(b)
        );
    
  
    clk_div
        divider(
            .clk(clk),
            .rst(rst),
            .clk_div(clk_div)
        );
	 ps2_input
		  myinput(
            .clk_slow(clk_div[16]),
            .clk_fast(clk_div[6]),
            .rst(rst),
            .ps2_clk(ps2_clk),
            .ps2_data(ps2_data),
            .key_up(key_up),
            .key_down(key_down),
            .key_left(key_left),
            .key_right(key_right),
            .key_ok(key_ok),
            .key_switch(key_switch),
				.whichkey(whichkey)
     );  



	//LED输出对应功能键的数字
	SSeg7_Dev m4(.clk(clk),.rst(1'b0),.Start(clk_div[20]),.SW0(1'b1),.flash(1'b0),.Hexs({28'h0_00_00_00,whichkey[3],whichkey[2],whichkey[1],whichkey[0]}),
	.point(8'b1111_1111),.LES(8'b1111_1111),.seg_clk(seg_clk),.seg_sout(seg_sout),.SEG_PEN(SEG_PEN),.seg_clrn(seg_clrn));
	
		
endmodule

