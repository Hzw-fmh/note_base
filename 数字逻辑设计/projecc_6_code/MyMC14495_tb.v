
module MyMC14495_tb();

// Inputs
reg D0,D1,D2,D3,point,LE;

// Output
wire p;
wire a;
wire b;
wire c;
wire d;
wire e;
wire f;
wire g;
integer i;
// Instantiate the UUT
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





initial begin
    #10;
    LE=1'd0;
    for(i=0;i<16;i=i+1)
    begin
        #10;
        {D3,D2,D1,D0}=i[3:0];//这样写可以确保只取最低的三位做赋值；
    end

    #10;

    LE=1'd1;
    for(i=0;i<16;i=i+1)
    begin
        #10;
        {D3,D2,D1,D0}=i[3:0];
    end
end

initial begin
    #10;
    k=1'd1;
    #10;
    k=1'd0;
    #10;
end




always forever begin
    #10;
    if($time>450)$finish;
end
endmodule