module mux4to1(
    input[1:0] P0,P1,P2,P3,sel,
    output[1:0] sout
);


reg[1:0] temp;

always @(*) begin
case(sel)
2'b00:temp=P0;
2'b01:temp=P1;
2'b10:temp=P2;
2'b11:temp=P3;
endcase
end

assign sout=temp;
endmodule


module test();

reg[1:0] sel;
wire[1:0] sout; 
mux4to1 mux(
    .P0(2'b00),
    .P1(2'b01),
    .P2(2'b10),
    .P3(2'b11),
    .sel(sel),
    .sout(sout)
);

initial begin
  sel=2'b00;
  #10;
  sel=2'b01;
  #10;
  sel=2'b10;
  #10;
  sel=2'b11;
  #10;
end


initial begin
  if($time>100)$finish;
end

endmodule