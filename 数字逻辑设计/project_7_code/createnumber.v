
//num最终告诉你需要输出的数字是几  
//输入当前被按下的按钮数字

module CreateNumber(//num最终告诉你需要输出的数字是几    
    input [3:0]         btn,
    output reg [15:0]   num
);

    wire [3:0] A, B, C, D;

    initial num <= 16'b1010_1011_1100_1101;//16位寄存器    ///可以通过位数的改变，来很好的做频率吧的修改
    //很巧妙的运用了截取这一个特性

    assign A = num[15:12] + 4'b1;//计算每一个子块加1的结果
    assign B = num[11: 8] + 4'b1;
    assign C = num[ 7: 4] + 4'b1;
    assign D = num[ 3: 0] + 4'b1;

    always @(posedge btn[0]) num[15:12] <= A;//如btn[0]这一位产生了上升沿，那么久对其做自加；
    always @(posedge btn[1]) num[11: 8] <= B;
    always @(posedge btn[2]) num[ 7: 4] <= C;
    always @(posedge btn[3]) num[ 3: 0] <= D;

    //四位都使用非阻塞赋值，可以同时进行

endmodule