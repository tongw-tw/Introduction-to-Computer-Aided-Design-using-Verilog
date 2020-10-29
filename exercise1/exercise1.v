/*
Copyright by Henry Ko and Nicola Nicolici
Developed for the Digital Systems Design course (COE3DQ4)
Department of Electrical and Computer Engineering
McMaster University
Ontario, Canada
*/

`timescale 1ns/100ps
`default_nettype none

// This is the top module
// It utilizes a priority encoder to detect a 1 on the MSB for switches 17 downto 0
// It then displays the switch number onto the 7-segment display
module exercise1 (
		/////// switches                          ////////////
		input logic[17:0] SWITCH_I,               // toggle switches

		/////// 7 segment displays/LEDs           ////////////
		output logic[6:0] SEVEN_SEGMENT_N_O[7:0], // 8 seven segment displays
		output logic[8:0] LED_GREEN_O,            // 9 green LEDs
		output logic[17:0] LED_RED_O              // 18 red LEDs
);

logic [3:0] ms_value; // most significant value
logic [3:0] ls_value; // least significant value
logic [3:0] value3, value2, value1, value0; // the value passed to 7-segment display converter
logic [6:0] value3_7_segment, value2_7_segment, value1_7_segment, value0_7_segment;

// 4 instances of convert_hex_to_seven_segment
convert_hex_to_seven_segment unit0 (
	.hex_value(value0), 
	.converted_value(value0_7_segment)
);

convert_hex_to_seven_segment unit1 (
	.hex_value(value1), 
	.converted_value(value1_7_segment)
);

convert_hex_to_seven_segment unit2 (
	.hex_value(value2), 
	.converted_value(value2_7_segment)
);

convert_hex_to_seven_segment unit3 (
	.hex_value(value3), 
	.converted_value(value3_7_segment)
);

// Priority encoder for the most significant switch from positions 0 to 15
always_comb begin
	ms_value = 4'h0;
	if (SWITCH_I[1]) ms_value = 4'h1;
	if (SWITCH_I[2]) ms_value = 4'h2;
	if (SWITCH_I[3]) ms_value = 4'h3;
	if (SWITCH_I[4]) ms_value = 4'h4;
	if (SWITCH_I[5]) ms_value = 4'h5;
	if (SWITCH_I[6]) ms_value = 4'h6;
	if (SWITCH_I[7]) ms_value = 4'h7;
	if (SWITCH_I[8]) ms_value = 4'h8;
	if (SWITCH_I[9]) ms_value = 4'h9;
	if (SWITCH_I[10]) ms_value = 4'hA;
	if (SWITCH_I[11]) ms_value = 4'hB;
	if (SWITCH_I[12]) ms_value = 4'hC;
	if (SWITCH_I[13]) ms_value = 4'hD;
	if (SWITCH_I[14]) ms_value = 4'hE;
	if (SWITCH_I[15]) ms_value = 4'hF;
end

// Priority encoder for the least significant switch from positions 0 to 15
always_comb begin
	ls_value = 4'hF;
	if (SWITCH_I[14]) ls_value = 4'hE;
	if (SWITCH_I[13]) ls_value = 4'hD;
	if (SWITCH_I[12]) ls_value = 4'hC;
	if (SWITCH_I[11]) ls_value = 4'hB;
	if (SWITCH_I[10]) ls_value = 4'hA;
	if (SWITCH_I[9]) ls_value = 4'h9;
	if (SWITCH_I[8]) ls_value = 4'h8;
	if (SWITCH_I[7]) ls_value = 4'h7;
	if (SWITCH_I[6]) ls_value = 4'h6;
	if (SWITCH_I[5]) ls_value = 4'h5;
	if (SWITCH_I[4]) ls_value = 4'h4;
	if (SWITCH_I[3]) ls_value = 4'h3;
	if (SWITCH_I[2]) ls_value = 4'h2;
	if (SWITCH_I[1]) ls_value = 4'h1;
	if (SWITCH_I[0]) ls_value = 4'h0;
end

always_comb begin
	{value3, value2, value1, value0} = 16'd0;
	if (SWITCH_I[17]) begin 
		value0 = ls_value;
		if (SWITCH_I[16]) begin
			value0 = {3'b000, ls_value[0]};
			value1 = {3'b000, ls_value[1]};
			value2 = {3'b000, ls_value[2]};
			value3 = {3'b000, ls_value[3]};
		end
	end else begin 
		value0 = ms_value;
		if (SWITCH_I[16]) begin
			value0 = {3'b000, ms_value[0]};
			value1 = {3'b000, ms_value[1]};
			value2 = {3'b000, ms_value[2]};
			value3 = {3'b000, ms_value[3]};
		end
	end 
end

assign  SEVEN_SEGMENT_N_O[0] = ~|SWITCH_I[15:0] ? 7'h7f : value0_7_segment,
        SEVEN_SEGMENT_N_O[1] = ~|SWITCH_I[15:0] || ~SWITCH_I[16] ? 7'h7f : value1_7_segment,
        SEVEN_SEGMENT_N_O[2] = ~|SWITCH_I[15:0] || ~SWITCH_I[16]? 7'h7f : value2_7_segment,
        SEVEN_SEGMENT_N_O[3] = ~|SWITCH_I[15:0] || ~SWITCH_I[16]? 7'h7f : value3_7_segment,
        SEVEN_SEGMENT_N_O[4] = 7'h7f,
        SEVEN_SEGMENT_N_O[5] = 7'h7f,
        SEVEN_SEGMENT_N_O[6] = 7'h7f,
        SEVEN_SEGMENT_N_O[7] = 7'h7f;

assign LED_RED_O = SWITCH_I;
assign LED_GREEN_O = {5'h00, ms_value};	

endmodule

