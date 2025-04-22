module test;
    reg[3:0] a,b;
    initial begin
      a=4'b0000;
      #10;
      a=4'b0001;
      #10;
      a=4'b0010;
      #10;
      a=4'b0011;
      #10;
      a=4'b0100;
      #10;
      a=4'b0101;
      #10;
      a=4'b0110;
      #10;
      a=4'b0111;
      #10;
      a=4'b1000;
      #10;
    end

    initial begin
      b=4'b0000;
      #10;
      b=4'b0001;
      #10;
      b=4'b0010;
      #10;
      b=4'b0011;
      #10;
      b=4'b0100;
      #10;
      b=4'b0101;
      #10;
      b=4'b0110;
      #10;
      b=4'b0111;
      #10;
      b=4'b1000;
      #10;
    end

initial begin
    forever begin
        #100
      if($time>100)
      $finish;
    end
end


endmodule