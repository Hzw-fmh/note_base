module test;
initial clock=1'b0;
reg clock;
always begin
clock=~clock;
#10;
end


initial begin
    #100
    if($time>1000)
    begin
        $finish;
    end
end



endmodule