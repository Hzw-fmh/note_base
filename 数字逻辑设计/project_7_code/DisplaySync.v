
module DisplaySync(
    input [ 1:0] scan,//这一个数信号来选择，是让结果输出哪一位
    input [15:0] hexs,//用于记录需要表示的16进制数字。四位一个记录，选择一位就可以
    input [ 3:0] points,
    input [ 3:0] LEs,
    output[ 3:0] HEX,
    output[ 3:0] AN,//这一位信号确定需要亮哪哪一位数字！！！
    output       point,
    output       LE
);

Mux4to1b4 Hexs(
    .S(scan),
    .Y(HEX),
    .D0(hexs[3:0]),
    .D1(hexs[7:4]),
    .D2(hexs[11:8]),
    .D3(hexs[15:12])

);
Mux4to1 Points(
    .S(scan),
    .Y(point),
    .D(points)
);

Mux4to1 LLE(
    .S(scan),
    .Y(LE),
    .D(LEs)
);
Mux4to1b4 AAN(      //选择对应的数码位亮起来
    .S(scan),
    .Y(AN),
    .D0(4'b1110),
    .D1(4'b1101),
    .D2(4'b1011),
    .D3(4'b0111)  
);


endmodule