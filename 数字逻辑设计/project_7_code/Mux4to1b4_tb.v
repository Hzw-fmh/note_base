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





module test;
reg[3:0] D0,D1,D2,D3;//输入可以用寄存器
reg[1:0] S;

wire[3:0] Y; //输出必须用wire

initial begin
D0=4'b0001;
D1=4'b0010;
D2=4'b0100;
D3=4'b1000;
end



Mux4to1b4 mux(
    .S(S),
    .Y(Y),
    .D0(D0),
    .D1(D1),
    .D2(D2),
    .D3(D3)
);


integer i;


initial begin
    for(i=0;i<4;i=i+1)
    begin
        S=i[1:0];
        #10;
    end
end



always forever begin
    #10;
    if($time>100)
    $finish;
end

endmodule