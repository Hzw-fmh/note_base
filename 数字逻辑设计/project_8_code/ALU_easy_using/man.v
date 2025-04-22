module Adder1b(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);
assign S=A^B^Cin;
assign Cout=A&B+(B|A)&Cin;
endmodule

module AddSub4b(
    input [3:0] A,
    input [3:0] B,
    input       Ctrl,
    output[3:0] S,
    output      Cout
);

assign {Cout,S}=A+(B^{4{Ctrl}})+Ctrl;
endmodule

module andd(
    input[3:0] A,
    input[3:0] B,
    output[3:0] res
);

assign res=A&B;
endmodule

module Mux4to1(
    input[3:0] D,
    input[1:0] S,
    output Y
);

assign Y=D[S];//二进制数也可以直接作为索引
endmodule

module Mux4to1b4(
    input  [1:0] S,
    input  [3:0] D0,
    input  [3:0] D1,
    input  [3:0] D2,
    input  [3:0] D3,
    output [3:0] Y
);


reg[3:0] ans;

assign Y=ans;


always @(*) begin
    case(S)
    2'b00:ans=D0;
    2'b01:ans=D1;
    2'b10:ans=D2;
    2'b11:ans=D3;
    endcase
end


endmodule

module orr(
    input[3:0] A,B,
    output[3:0] res
);

assign res=A|B;
endmodule



module ALU(
    input [3:0] A,
    input [3:0] B,
/////// op: 0 for ADD; 1 for SUB; 2 for AND; 3 for OR ///////
    input [1:0] op,
    output[3:0] res,
    output      Cout // 0 when AND & OR
);

wire[3:0] resor,resand,S;
wire couttemp;

orr orr1(
    .A(A),
    .B(B),
    .res(resor)
);

andd add1(
    .A(A),
    .B(B),
    .res(resand)
);
AddSub4b AddSub4b1(
    .A(A),
    .B(B),
    .S(S),
    .Ctrl(op[0]),
    .Cout(couttemp)
);
Mux4to1b4 Mux4to1b41(
    .S(op),
    .D0(S),
    .D1(S),
    .D2(resand),
    .D3(resor),
    .Y(res)
);
Mux4to1 Mux4to11(
    .S(op),
    .D({1'b0,1'b0,couttemp,couttemp}),
    .Y(Cout)
);
endmodule


module clkdiv(
    input               clk,
    input               rst, // Active-high
    output reg [31:0]   div_res
);

    always @(posedge clk) begin     // When postive edge of `clk` comes
        if(rst == 1'b1) begin
            div_res <= 32'b0;
        end else begin
            div_res <= div_res + 32'b1;  // Increase `div_res` by 1
        end
    end

endmodule

/*
Module Name: CreateNumber
Description:
To change the value printed on Arduino using btns.
You will get a initial value printed as the para. INIT_HEXES defined.
After each pression on btn, a number will increase by 1.

This new module can handle i-1 when signal sw is 1
*/

module CreateNumber#(
parameter INIT_HEXES = 16'b1010_1011_1100_1101 // Init with "AbCd"
) (
input[3:0] btn,
input[3:0] sw,
output reg[15:0] num
);
wire[3:0] A, B, C, D;

initial num <= INIT_HEXES;

// D(the next num[3:0]) is always greater than current num[3:0] by 1
AddSub4b a0(.A(num[15:12]), .B(4'b0001), .Ctrl(sw[3]), .S(A));
AddSub4b a1(.A(num[11: 8]), .B(4'b0001), .Ctrl(sw[2]), .S(B));
AddSub4b a2(.A(num[ 7: 4]), .B(4'b0001), .Ctrl(sw[1]), .S(C));
AddSub4b a3(.A(num[ 3: 0]), .B(4'b0001), .Ctrl(sw[0]), .S(D));

// When pressing btn[0] num[3:0]++
always @(posedge btn[3]) num[15:12] <= A;
always @(posedge btn[2]) num[11: 8] <= B;
always @(posedge btn[1]) num[ 7: 4] <= C;
always @(posedge btn[0]) num[ 3: 0] <= D;

endmodule




module DisplaySync(
    input [ 1:0] scan,//这一个数信号来选择，是让结果输出哪一位
    input [15:0] hexs,//用于记录需要表示的16进制数字。四位一个记录，选择一位就可以
    input [ 3:0] points,
    input [ 3:0] LEs,
    output[ 3:0] HEX,
    output[ 3:0] AN,//这一位信号确定需要亮哪哪一位数字！！！
    output       point,
    output       LE
);
Mux4to1b4 Hexs(
    .S(scan),
    .Y(HEX),
    .D0(hexs[3:0]),
    .D1(hexs[7:4]),
    .D2(hexs[11:8]),
    .D3(hexs[15:12])
);
Mux4to1 Points(
    .S(scan),
    .Y(point),
    .D(points)
);
Mux4to1 LLE(
    .S(scan),
    .Y(LE),
    .D(LEs)
);
Mux4to1b4 AAN(      //选择对应的数码位亮起来
    .S(scan),
    .Y(AN),
    .D0(4'b1110),
    .D1(4'b1101),
    .D2(4'b1011),
    .D3(4'b0111)  
);
endmodule


module MyMC14495(
    input D0,D1,D2,D3,
    input LE,point,
    output  reg a,b,c,d,e,f,g,p
    );

always @(*) begin
    if(point)p=1'b1;
    else p=1'b0;
    if(!LE) begin
        case({D3,D2,D1,D0})
            4'b0000:{a,b,c,d,e,f,g}=7'b0000001;
            4'b0001:{a,b,c,d,e,f,g}=7'b1001111;
            4'b0010:{a,b,c,d,e,f,g}=7'b0010010;
            4'b0011:{a,b,c,d,e,f,g}=7'b0000110;
            4'b0100:{a,b,c,d,e,f,g}=7'b1001100;
            4'b0101:{a,b,c,d,e,f,g}=7'b0100100;
            4'b0110:{a,b,c,d,e,f,g}=7'b0100000;
            4'b0111:{a,b,c,d,e,f,g}=7'b0001111;
            4'b1000:{a,b,c,d,e,f,g}=7'b0000000;
            4'b1001:{a,b,c,d,e,f,g}=7'b0000100;
            4'b1010:{a,b,c,d,e,f,g}=7'b0001000;
            4'b1011:{a,b,c,d,e,f,g}=7'b1100000;
            4'b1100:{a,b,c,d,e,f,g}=7'b0110001;
            4'b1101:{a,b,c,d,e,f,g}=7'b1000010;
            4'b1110:{a,b,c,d,e,f,g}=7'b0110000;
            4'b1111:{a,b,c,d,e,f,g}=7'b0111000;
        endcase
    end
    else {a,b,c,d,e,f,g}=7'b1111111;
end
endmodule

module DisplayNumber(
    input        clk,
    input        rst,
    input [15:0] hexs,
    input [ 3:0] points,
    input [ 3:0] LEs,
    output[ 3:0] AN,
    output[ 7:0] SEGMENT
);
wire [31:0] div_res;
clkdiv clkdiv1(
    .clk(clk),
    .rst(rst),
    .div_res(div_res)
);
wire[3:0] HEX,AN;
wire point,LE;
DisplaySync  select(
    .scan(div_res[18:17]),
    .hexs(hexs),
    .points(points),
    .LEs(LEs),
    .HEX(HEX),
    .AN(AN),
    .point(point),
    .LE(LE)
);
MyMC14495 Segment(
    .D0(HEX[0]),
    .D1(HEX[1]),
    .D2(HEX[2]),
    .D3(HEX[3]),
    .point(point),
    .LE(LE),
    .a(SEGMENT[0]),
    .b(SEGMENT[1]),
    .c(SEGMENT[2]),
    .d(SEGMENT[3]),
    .e(SEGMENT[4]),
    .f(SEGMENT[5]),
    .g(SEGMENT[6]),
    .p(SEGMENT[7])
);
endmodule
//去抖动模块

module pbdebounce(
    input wire clk,
    input wire button, 
    output reg pbreg
    );

    reg [7:0] pbshift;

    always@(posedge clk) begin
        pbshift = pbshift<<1;
        pbshift[0] = button;
        if (pbshift==8'b0)
            pbreg=0;
        if (pbshift==8'hFF)
            pbreg=1;    
    end

endmodule



module Top(
        input wire clk,
        input wire [1:0] BTN,
        input wire [1:0] SW1,  //这里是作为输入的
        input wire [1:0] SW2,  //这个应该使存储操作符号的两位
        input wire [11:0] SW,
        output wire [3:0] AN,
        output wire [7:0] SEGMENT,
        output wire BTNX4,
        output wire seg_clk,
        output wire seg_clrn,
        output wire seg_sout,
        output wire SEG_PEN
);
    wire [15:0] num;
    wire [1:0] btn_out;
    wire [3:0] res;
    wire Co;
    wire [31:0] clk_div;
    wire [15:0] disp_hexs;
    wire [15:0] disp_hexs_my;

    assign disp_hexs[15:12] = num[7:4];            // B
    assign disp_hexs[11:8]  = num[3:0];            // A
    assign disp_hexs[7:4]   = {3'b000, Co};
    assign disp_hexs[3:0]   = res[3:0];                // C

    /* Code here */
    assign disp_hexs_my =16'b0100_1000_0001_0000; // Fill the last four digits of your student id in ()

    assign BTNX4 = 1'b0;

    clkdiv m2(.clk(clk), .rst(1'b0), .div_res(clk_div));
    pbdebounce m0(.clk(clk_div[17]), .button(BTN[0]), .pbreg(btn_out[0]));
    pbdebounce m1(.clk(clk_div[17]), .button(BTN[1]), .pbreg(btn_out[1]));

    CreateNumber m3(.btn({2'b0, btn_out}), .sw({2'b0, SW1}), .num(num)); // Attachment  //但是在这里SW1却当作操作符号输入进去了

    // The ALU module you wrote
    ALU m5(    .A(num[3:0]), 
                    .B(num[7:4]),                             // fill sth. in ()
                    .op(SW2[1:0]),                             // fill sth. in ()  这里填存操作符号的数组 我填了0 现在默认是加法？？？将自增的两个数字做加法
                    .res(res[3:0]),                             // fill sth. in ()
                    .Cout(Co)); 

    // Module you design in Lab7
    DisplayNumber m6(    .clk(clk), .hexs(disp_hexs), .LEs(SW[7:4]),//设置SW[15:4]为控制使能信号（这个需要再去仔细看看学约束文件）(对应控制8个数码管)         // fill sth. in ()，低电平有效，所以我填0让每一位都亮起来
                                .points(SW[3:0]), .rst(1'b0),             //小数点用SW[3:0]  //设置让时钟不断更新吗，所以rst填0              // fill sth. in ()
                                .AN(AN), .SEGMENT(SEGMENT));

    // Attachment
    SSeg_Dev m7(.clk(clk), .flash(clk_div[25]), .Hexs({disp_hexs_my, disp_hexs}), .LES(SW[11:4]),
                    .point({4'b0000, SW[3:0]}), .rst(1'b0), .Start(clk_div[20]), .seg_clk(seg_clk),
                    .seg_clrn(seg_clrn), .SEG_PEN(SEG_PEN), .seg_sout(seg_sout));

endmodule



