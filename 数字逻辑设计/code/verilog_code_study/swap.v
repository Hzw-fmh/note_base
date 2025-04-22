module test;

reg a=1'b0;
reg b=1'b1;
//这是属于verilog的非阻塞性赋值的特性利用！！！
always begin
    a<=b;
    #10;
end



always begin
    b<=a;
    #10;
end

initial begin
  if($time>100)
  $finish;
end

endmodule