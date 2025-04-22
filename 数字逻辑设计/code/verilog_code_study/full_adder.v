module full_adder(
    input Ai,Bi,Ci,
    output So,Co);//这个分号不要漏了

assign {Co,So}=Ai+Bi+Ci;
endmodule


module test;
reg Ai,Bi,Ci;
wire So,Co;

initial begin
  {Ai,Bi,Ci}=3'b0;//这里相当于是做初始化
  forever begin 
        #10
        {Ai,Bi,Ci}={Ai,Bi,Ci}+1'b1;
  end
end


full_adder  u_adder(
        .Ai      (Ai),
        .Bi      (Bi),
        .Ci      (Ci),
        .So      (So),
        .Co      (Co)
        );

initial begin
  forever begin
    #100
    if($time>=1000)begin
        $finish;
    end
  end
end

endmodule




wire a,b,c;
assign #10 a=b^c;//含义是b^c的运算结果经过10个时刻之后再赋值给a



wire a,b;
wire #10 c=a^b;//在定义这个变量的时候将结果延时10个时刻在连续赋值给c