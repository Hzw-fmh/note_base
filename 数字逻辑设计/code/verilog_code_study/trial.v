
parameter ab=32'd17;//这是一个宏定义，将ab这个参数恒赋值为17，并且作用范围为从定义开始的下方所有函数内·


reg rstn; //reg变量为无符号数
reg [32:0] rstn;
reg [0:32] rstn_1;   //这些是叫向量！！！
wire [0:32] a=1'b1;//可以在创建变量的时候赋值
wire [1:0] b;

wire[7:0] byte[8:0]//这个是数组
wire[7:0] byte[8:0][1:0]//这就是一个二维数组

integer i[7:0];

i[2]=32'd0//将322位的十进制0赋值给i


integer j;//integer是有符号数
integer j;//一般用作循环用的辅助信号
integer i;

real p=1.89;
i=parameter //此时i的数值会是1，，，，，意思就是将实数赋值给整数，会直接去尾

time cur_time;//time其实是一个特殊的寄存器，其位宽位64位

```
整数，实数，时间都属于寄存器的类型
因为都是在改变数据之前，都存着之前的数值嘛
```

wire[]

initial begin
    b[2:0]=3b'100;
    rstn[32:30]= b[2:0];
    rstn[32-:3]=b[2:0];//这一种方式和上面的那一种是等价的
    rstn_1[0+:3]=b[2:0];
    rstn=b[23:0]+1'b1;//这里会自动将加上的数字扩展为两位,高位会被补零！！
    rstn_1={rstn[24:0],rstn[32:25]};//用大括号括起来，中间用逗号隔开
    //可以拼接两个及以上的数据，超出位数和位数不够都会发生报错
    #100
    time_cur=$time;//用当前的时间获取函数将时间：100赋值给time_cur
    
    for(j=0;j<16;j++) begin
        b[0:1]=a[j:j+1];//将a的每两位依次赋值给b；
    end



  rstn = 1'b0;
  #100
  rstn 1'1;

end



reg a=4'b1001
reg b=4'b0010

a+b=1011

但是如果溢出的化，就截去高位


& | ^ ~
与 或 异或 取反

&A |A ~&A ~|A ~^A 这一行都是归约运算符,按照顺序从高到底进逐位与，或。。。。。

对wire变量去做连接！！！用assign语句


wire[0:1] i9;
assign i9=2'b01;



全加器

module full_adder1(
    input Ai,Bi,Ci,//记住在变量赋值的时候中间不用分号，用逗号
    output So,Co);
    assign So=Ai^Bi^Ci;
    assign Si=(Ai&Bi)|(Ci&(Ai|Bi));
endmodule


//在设计模块中输入的电线就用input来表示，输出的变量用output来表示

module full_adder1(
    input Ai,Bi,Ci.
    output Si,Ci)
)
assign {Ci,Si}=Ai+Bi+Ci;   //相当于将三位的和自动分配到这个合并起来的结果上！！！
endmodule


integer j;
j=0;
for(j=0;j<3;j++)begin
    j++;
end

module test;
    reg Ai,Bi,Ci;
    wire So,Co;

    initial begin
        {Ai,Bi,Ci}=3'b0;
        forever begin 
            #10
            {Ai,Bi,Ci}={Ai,Bi,Ci}+1'b1;//相当于每次都给这个数字加1；
        end
    end

    full_adder1 u_adder(
        .Ai(Ai)//前面加上点就表示这个是电线的名称
        .Bi(Bi)
        .Ci(Ci)
        .So(So)
        .Co(Co));
    )
    
    initial begin
        forever begin
          #100
          if($time>=1000)begin
            
            $finish;
          end
        end
    end

endmodule




always表示循环模块
initial表示只进行一次的模块

我们通常同时进行一个initial从而让其能在想要的时间停止


所谓的阻塞性赋值就是，利用<=来进行对寄存器的赋值，并且这些语句会与下面的语句同时进行

一般的所语句都是阻塞性赋值，也就是这一行执行完了之后再执行下一行！！！



verilog的时序控制

1. 一般操作就是是将时间延迟操作当作一个单独的语句放在需要进行时间间隔的语句之间；
2. 为了实现将一个计算结果延迟一段时间之后再赋值给一个寄存器，就采用将延时语句整合到语句的最开始;
e.g.   
reg a;
reg b;
reg c;
a=1'b1;
b=1'b0;
#10 c=a+b;//这个语句的含义就是将a+b的计算结果延迟10时刻再赋值给c
3. 内嵌延时



多路分支语句：
case (sel)
    4'b1011:
    4'b0100:
    4'b1111:
    4'b0011:

    default: 
endcase



模块的输入输出信号如果位宽不一致，就会进行低位截取，或者高位补齐