module increment(
    input[3:0] start,
    output[3:0] current
);
integer i;
reg[3:0] cur;//寄存器在申明的时候只能用常量来赋值
initial begin
  cur=start;
  for(i=0;i<16;i=i+1)
    begin
    #10;
        cur=cur+4'b0001;
    end
end
assign current=cur;
endmodule




module test;


wire[3:0] current;
reg[3:0] start=4'b0000; 


increment incre(
    .start(start),
    .current(current)
);


always forever begin
    #10  //最好是有时间间隔，因为没有时间间隔会出不了仿真！
    if($time>200)$finish;
end

endmodule