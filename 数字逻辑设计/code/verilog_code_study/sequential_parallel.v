module test;
reg a=1'b0;
reg b=1'b1;
initial fork
    #10  a=b;
    #10  b=a;
join


initial begin
  if($time>100)$finish;
end
endmodule