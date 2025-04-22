module DispNum(
    input[7:0] SW,
    input[1:0] BTN,
    output[7:0] SEGMENT,
    output[3:0] AN,
    output BTN_X
);

// Inputs
wire D0,D1,D2,D3,point,LE;
// Output
wire a,b,c,d,e,f,g;//信号是从MyMC14485模块传递出来的，所以不是很合是用reg

assign SEGMENT[7:0]={p,g,f,e,d,c,b,a};
assign point=BTN[0];
assign LE=BTN[1];
assign {D3,D2,D1,D0}=SW[3:0];
assign AN[3:0]=~SW[7:4];
assign BTN_X=1'b0;



MyMC14495 MC14495_inst (
.D0(D0), 
.D1(D1), 
.D2(D2), 
.D3(D3), 
.LE(LE), 
.point(point), 
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