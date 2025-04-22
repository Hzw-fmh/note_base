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