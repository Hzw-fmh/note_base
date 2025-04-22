module Mux4to1(
    input[3:0] D,
    input[1:0] S,
    output Y
);

assign Y=D[S];//二进制数也可以直接作为索引
endmodule