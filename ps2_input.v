`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Dealing with the input data of the PS2 keyboard
//------------------------------------------------------------------------------
module ps2_input(
    input wire clk_slow,      // Slower clock for this module
    input wire clk_fast,      // Faster clock for the PS2 scanner
    input wire rst,           // Reset
    input wire ps2_clk,       // PS2 clock
    input wire ps2_data,      // PS2 data
    
    output wire key_up,       // If UP key is pressed
    output wire key_down,     // If DOWN key is pressed
    output wire key_left,     // If LEFT key is pressed
    output wire key_right,    // If RIGHT key is pressed
    output wire key_ok,       // If OK key is pressed
    output wire key_switch,    // If SWITCH key is pressed
	 output wire key_reverse,   // If REVERSE key is pressed
	 output reg [3:0] whichkey
    );
    
    wire [8:0] crt_data;    // Input data of the PS2 keyboard
    
    // Key state recorders
    reg [1:0] key_up_state, key_down_state, key_left_state,
              key_right_state, key_ok_state, key_switch_state,key_reverse_state;
    // Only becomes true at the posedge of each key
    assign key_up = key_up_state[0] & ~key_up_state[1];
    assign key_down = key_down_state[0] & ~key_down_state[1];
    assign key_left = key_left_state[0] & ~key_left_state[1];
    assign key_right = key_right_state[0] & ~key_right_state[1];
    assign key_ok = key_ok_state[0] & ~key_ok_state[1];
    assign key_switch = key_switch_state[0] & ~key_switch_state[1];
    assign key_reverse = key_reverse_state[0] & ~key_reverse_state[1];    
	 initial begin whichkey <= 4'h0;
	 end
    // PS2 keyboard scanner
    ps2_scan
        scanner(
            .clk(clk_fast),
            .rst(rst),
            .ps2_clk(ps2_clk),
            .ps2_data(ps2_data),
            .crt_data(crt_data)
        );
    
    always @ (posedge clk_slow or negedge rst)
        if (!rst) begin
            key_up_state <= 2'b0;		
            key_down_state <= 2'b0;
            key_left_state <= 2'b0;
            key_right_state <= 2'b0;
            key_ok_state <= 2'b0;
            key_switch_state <= 2'b0;
				key_reverse_state <= 2'b0;
        end
        else begin
            // Record the key state
            key_up_state <= {key_up_state[0], crt_data == 9'h175};				//"UP"
            key_down_state <= {key_down_state[0], crt_data == 9'h172};			//"DOWN"
            key_left_state <= {key_left_state[0], crt_data == 9'h16b};			//"LEFT"
            key_right_state <= {key_right_state[0], crt_data == 9'h174};		//"RIGHT"
            key_ok_state <= {key_ok_state[0], crt_data == 9'h029};				//"Space"
            key_switch_state <= {key_switch_state[0], crt_data == 9'h014}; 	//"Ctrl"
				key_reverse_state <= {key_reverse_state[0], crt_data == 9'h02D};  //"R"
				//The corresponding keyboard code is scanned to the crt_data, output the corresponding value
				if (key_up_state[0] | key_up_state[1]) whichkey <= 4'h1;                      //"UP" 		1
				else if (key_down_state[0] | key_down_state[1]) whichkey <= 4'h2;					//"DOWN" 	2
				else if (key_left_state[0] | key_left_state[1]) whichkey <= 4'h3;					//"LEFT" 	3
				else if (key_right_state[0] | key_right_state[1]) whichkey <= 4'h4;				//"RIGHT" 	4
				else if (key_ok_state[0] | key_ok_state[1]) whichkey <= 4'h5;						//"Space" 	5
				else if (key_switch_state[0] | key_switch_state[1]) whichkey <= 4'b1000;		//"Ctrl"    8
				else if (key_reverse_state[0] | key_reverse_state[1]) whichkey <= 4'b1010;    //"R"			10
				else whichkey <= 4'h0;																			//no button is pressed 0
        end

endmodule
