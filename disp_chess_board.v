`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:54:58 12/27/2018 
// Design Name: 
// Module Name:    disp_chess_board 
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
module disp_chess_board(
    input wire clk,                     // Clock (25MHz)
    input wire rst,                     // Reset
	 input wire data_ram_we,
    output wire sync_h,                 // VGA horizontal sync
    output wire sync_v,                 // VGA vertical sync
    output wire [3:0] r,                // VGA red component
    output wire [3:0] g,                // VGA green component
    output wire [3:0] b,                 // VGA blue component
	 output wire [11:0] douta
    );
	 
	
	  // Side parameters

					
    localparam GRID_X_BEGIN = 80,
               GRID_X_END = 559,
               GRID_Y_BEGIN = 0,
               GRID_Y_END = 479;
					
	 
					
	 
	 
	 //current display color: in the display area and out of the area
	 
	 reg [11:0] rgb;
	 reg [17:0] ram_addr;
	 //reg [11:0] douta;
	 
    assign r = video_on ? rgb[11:8] : 4'b0;
    assign g = video_on ? rgb[7:4]  : 4'b0;
    assign b = video_on ? rgb[3:0]  : 4'b0;
	 assign data_ram_we = 1'b0;
	 
	 initial begin ram_addr = 18'b0;
	 end

 // VGA control signal generator
    wire video_on;
    wire [9:0] x, y;
    vga_sync
        sync(
            .clk(clk),
            .rst(rst),
            .sync_h(sync_h),
            .sync_v(sync_v),
            .video_on(video_on),
            .x(x),
            .y(y)
        );
		  
	
	rom_cb U3 (
	.clka(clk), 	  // input clka
	.wea(data_ram_we),  // input [0 : 0] wea
	.addra(ram_addr),      // input [17 : 0] addra
	.dina(12'b0),   // input [11:0] dina
	.douta(douta)// output [11:0] douta
   );


	//get rgb information in ram
	always @ (posedge clk) begin
        if (x >= GRID_X_BEGIN && x <= GRID_X_END &&
            y >= GRID_Y_BEGIN && y <= GRID_Y_END) begin
            // Draw the chessboard
				ram_addr = y*480+(x-80) ;
				rgb <= douta; 
		      end
		else  rgb <= 12'hfff;
	end
	 
endmodule
