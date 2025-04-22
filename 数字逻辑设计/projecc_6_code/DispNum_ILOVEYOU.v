module MyMC14495(
    input D0,D1,D2,
    input LE,
    output  reg a,b,c,d,e,f,g,p
    );

always @(*) begin
    if(!LE) begin
        case({D2,D1,D0})
            4'b000:{a,b,c,d,e,f,g}=7'b1111001;
            4'b001:{a,b,c,d,e,f,g}=7'b1110001;
            4'b010:{a,b,c,d,e,f,g}=7'b1100010;
            4'b011:{a,b,c,d,e,f,g}=7'b1100011;
            4'b100:{a,b,c,d,e,f,g}=7'b0110000;
            4'b101:{a,b,c,d,e,f,g}=7'b1000100;
            4'b110:{a,b,c,d,e,f,g}=7'b0000001;
            4'b111:{a,b,c,d,e,f,g}=7'b1000001;
        endcase
    end
    else {a,b,c,d,e,f,g}=7'b1111111;
end
endmodule



module DispNum(
    input[5:0] SW,
    input BTN,
    output[7:0] SEGMENT,
    output[2:0] AN,
    output BTN_X
);

// Inputs
wire D0,D1,D2,LE;
// Output
wire a,b,c,d,e,f,g;//信号是从MyMC14485模块传递出来的，所以不是很合是用reg

assign SEGMENT[7:0]={p,g,f,e,d,c,b,a};
assign LE=BTN;
assign {D2,D1,D0}=SW[2:0];
assign AN[2:0]=~SW[5:3];
assign BTN_X=1'b0;



MyMC14495 MC14495_inst (
.D0(D0), 
.D1(D1), 
.D2(D2), 
.LE(LE), 
.p(p), 
.a(a), 
.b(b), 
.c(c), 
.d(d), 
.e(e), 
.f(f), 
.g(g)
);


endmodule