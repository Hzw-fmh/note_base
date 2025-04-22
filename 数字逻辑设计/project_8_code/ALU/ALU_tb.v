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



module test();

reg[3:0] A,B;
wire Cout;
wire[3:0] res;

reg[1:0] op; 


ALU ALU1(
    .A(A),
    .B(B),
    .op(op),
    .res(res),
    .Cout(Cout)

);
//两位整数运算
initial begin
    //数据组1：3，4
    A=4'b0_011;
    B=4'b0_100;
    op=0;
    #10;
    op=1;
    #10;
    op=2;
    #10;
    op=3;
    #10;

    //数据组2：2，4（）
    A=4'b0010;
    B=4'b0100;
    op=0;
    #10;
    op=1;
    #10;
    op=2;
    #10;
    op=3;
    #10;

    //数据组3：11，12（会发生进位）
    A=4'b1011;
    B=4'b1100;
    op=0;
    #10;
    op=1;
    #10;
    op=2;
    #10;
    op=3;
    #10;
    //数据组4：0，15（算出来最小的负数）
    A=4'b0000;
    B=4'b1111;
    op=0;
    #10;
    op=1;
    #10;
    op=2;
    #10;
    op=3;
    #10;
    

end


always forever begin
    #10;
    if($time>180)
    $finish;
end


endmodule