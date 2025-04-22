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


//num最终告诉你需要输出的数字是几  
//输入当前被按下的按钮数字

module CreateNumber(//num最终告诉你需要输出的数字是几    
    input [3:0]         btn,
    output reg [15:0]   num
);

    wire [3:0] A, B, C, D;

    initial num <= 16'b1010_1011_1100_1101;//16位寄存器    ///可以通过位数的改变，来很好的做频率吧的修改
    //很巧妙的运用了截取这一个特性

    assign A = num[15:12] + 4'b1;//计算每一个子块加1的结果
    assign B = num[11: 8] + 4'b1;
    assign C = num[ 7: 4] + 4'b1;
    assign D = num[ 3: 0] + 4'b1;

    always @(posedge btn[0]) num[15:12] <= A;//如btn[0]这一位产生了上升沿，那么久对其做自加；
    always @(posedge btn[1]) num[11: 8] <= B;
    always @(posedge btn[2]) num[ 7: 4] <= C;
    always @(posedge btn[3]) num[ 3: 0] <= D;

    //四位都使用非阻塞赋值，可以同时进行

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


module top(
    input clk,
    input [7:0] SW,
    input [3:0] btn,
    output[3:0] AN,
    output[7:0] SEGMENT,
    output      BTN_X
);

    assign BTN_X = 1'b0;

    wire [15:0] num;

    CreateNumber create_inst(
        .btn(btn),
        .num(num)
    );



    
    DisplayNumber disp_inst(
        .clk(clk),
        .rst(1'b0),
        .hexs(num),
        .points(SW[7:4]),
        .LEs(SW[3:0]),
        .AN(AN),
        .SEGMENT(SEGMENT)
    );

endmodule