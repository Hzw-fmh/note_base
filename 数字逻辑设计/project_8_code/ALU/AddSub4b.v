module AddSub4b(
    input [3:0] A,
    input [3:0] B,
    input       Ctrl,
    output[3:0] S,
    output      Cout
);

assign {Cout,S}=A+(B^{4{Ctrl}})+Ctrl;//记住异或的运算有限级是低于加法的
endmodule

