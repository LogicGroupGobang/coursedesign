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
    output wire [3:0] b   // VGA blue component
    );
    

    
    wire [3:0] display_i;
  
    wire [31:0] clk_div;
    
    // Turn off the arduino buzzer
    //assign buz = 1'b1;
    
    
    
    disp_chess_board
        display(
            .clk(clk_div[1]),
            .rst(rst),
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
    
endmodule

