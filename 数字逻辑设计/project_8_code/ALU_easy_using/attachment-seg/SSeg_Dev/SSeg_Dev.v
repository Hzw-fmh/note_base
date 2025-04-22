`timescale 1ns / 1ps

module Hex2Seg(input [3:0] Hex,
					input LE,
					input point,
					input flash,
					output [7:0] Segment
    );
	 wire en = LE & flash;
	 MyMC14495 MSEG(.D3(Hex[3]), .D2(Hex[2]), .D1(Hex[1]), .D0(Hex[0]), .LE(en), .point(point),
							.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .p(p));
	 assign Segment = {a, b, c, d, e, f, g, p};

endmodule



`timescale 1ns / 1ps

module HexTo8SEG(input [31:0] Hexs,
					  input [7:0] points,
					  input [7:0] LES,
					  input flash,
					  output [63:0] SEG_TXT
    );
	 
	 Hex2Seg HTS0(Hexs[31:28], LES[7], points[7], flash, SEG_TXT[7:0]);
	 Hex2Seg HTS1(Hexs[27:24], LES[6], points[6], flash, SEG_TXT[15:8]);
	 Hex2Seg HTS2(Hexs[23:20], LES[5], points[5], flash, SEG_TXT[23:16]);
	 Hex2Seg HTS3(Hexs[19:16], LES[4], points[4], flash, SEG_TXT[31:24]);
	 
	 Hex2Seg HTS4(Hexs[15:12], LES[3], points[3], flash, SEG_TXT[39:32]);
	 Hex2Seg HTS5(Hexs[11:8], LES[2], points[2], flash, SEG_TXT[47:40]);
	 Hex2Seg HTS6(Hexs[7:4], LES[1], points[1], flash, SEG_TXT[55:48]);
	 Hex2Seg HTS7(Hexs[3:0], LES[0], points[0], flash, SEG_TXT[63:56]);

endmodule


module  		  P2S#(
    parameter DATA_BITS = 64,  											// data length
	parameter DATA_COUNT_BITS = 6 									// data shift bits

)(  input wire clk,		//parallel to serial
						input wire rst,
						input wire Serial,
						input wire[DATA_BITS-1:0] P_Data,
						output reg  s_clk,
						output wire s_clrn,
						output wire sout,
						output reg  EN
);

endmodule








module SSeg_Dev(
    input clk,
    input flash,
    input [31:0] Hexs,
    input [7:0] LES,
    input [7:0] point,
    input rst,
    input Start,
    output seg_clk,
    output seg_clrn,
    output SEG_PEN,
    output seg_sout
);

   wire [63:0] SEGMENT;

   P2S  M2 (.clk(clk), 
           .P_Data(SEGMENT[63:0]), 
           .rst(rst), 
           .Serial(Start), 
           .EN(SEG_PEN), 
           .sout(seg_sout), 
           .s_clk(seg_clk), 
           .s_clrn(seg_clrn));

   HexTo8SEG  SM1 (.flash(flash), 
                  .Hexs(Hexs[31:0]), 
                  .LES(LES[7:0]), 
                  .points(point[7:0]), 
                  .SEG_TXT(SEGMENT[63:0]));

endmodule
