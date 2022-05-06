///// CU的译码方式不一样，随便参考下得了
一、增添指令一般步骤
1. 明确指令RTL
该步骤需要结合题目弄懂指令行为，包括明确指令类型（R型？I型？J型？即明确读和写的目标）、opcode和funct域数据、执行功能（计算？跳转？访存？）
最好可以先用MARS模拟下，以免对指令行为理解不到位。
2. 明确非转发数据通路
在该步骤中，可以在单周期中思考新指令的行为，构思出该新指令的数据通路，然后修改控制器中的相关控制信号——包括使能信号（P5中的DM和GRF的写使能、P6中的GRF写使能和新加的byteen）、功能MUX的选择信号（GRF写入地址的选择、ALU的B端口数据的选择、GRF写入数据的选择等等）和模块功能的选择信号（ALU功能选择、NPC功能选择）。
3. 考虑转发
考虑新指令作为提供者：
首先考虑它是否及时将已经计算出来的将要被写入GRF的数据转发；
例如，计算类指令在E级ALU会生成GRF写入数据，那么需要在后面的M级、W级的流水寄存器设置接口这个数据转发
例如，跳转并链接类指令在D级就可以生成GRF写入数据pc+8,那么需要E级、M级和W级的流水寄存器设置接口将这个数据转发
然后考虑GRF的5位写入地址是否正确。
一般在第2步已经调整完毕，但是像lwer、lhso等条件存储类指令只有在M级从DM中取出数据后才能明确写入地址，需要在M级将GRF写入地址再次修改
考虑新指令作为接受者：明确需要使用GPR[rs]、GPR[rt]的功能部件和相应接口（CMP的D1和D2？ALU的A和B？乘除模块的A和B？DM的WD？），课上可能需要设置新的接口。
4. 考虑暂停
明确新指令的Tuse_rs、Tuse_rt以及在各级流水的Tnew，直接在主控制器中修改即可（千万不要忘记）。
二、课上测试题型分析
注：笔者课下cpu设计采用的是集中式译码和暴力转发。

1. 计算类
P5中一般只需要增加ALU的功能，但一定要看清楚新指令的计算行为，最好在MARS里先模拟一下。

一般来说新指令的计算行为会稍微复杂一点，用always @（*）写会比较简单，用assign的话可以定义一个function。
一般情况下，Tnew和Tuse与calc_R型指令保持一致即可。
循环移位可以采用以下写法——
//以循环左移为例
if(B[4:0] == 5'd0) out = A;
else out = A << B[4:0] | A >> (5'd31 - B[4:0] + 5'd1);
P6的计算会涉及到乘除模块，也相对比较简单。需要注意madd、maddu、msub、msubu等指令（roife博客有讲到）。

以madd为例（将两个数有符号相乘，计算结果与之前的HI、LO寄存器中的值相加，而不是覆盖），如果是以下写法会出现问题
//错误写法1
{HI_temp, LO_temp} <= {HI, LO} + $signed(A) * $signed(B);
//错误写法2
{HI_temp, LO_temp} <= {HI, LO} + $signed($signed(A) * $signed(B));
错误写法1出现问题的原因是： 位拼接{HI, LO}默认被当做无符号数， 无符号性传递到$signed(A) * $signed(B)，因此即使使用了$signed()还是会被当成无符号数进行乘法运算
错误写法2出现问题的原因是：虽然使用了$signed()屏蔽了外界符号性的传入，但是也屏蔽了位宽信息的传入，所以$signed($signed(A) * $signed(B))的结果实际上是32位(因为$signed(A)和$signed(B)都是32位，又没有外界位宽信息的传入，因此结果被强制规定为32位)，即高32位的数据被截去，在参与后续运算时自然会出现问题。
为了避免上述情况，我们需要在错误写法2的最外层$signed()中人为传入64位位宽信息，学长博客的写法如下——
//正确写法1
{HI_temp, LO_temp} <= {HI, LO} + $signed($signed(64'd0) + $signed(A) * $signed(B));
//正确写法2
{HI_temp, LO_temp} <= {HI, LO} + $signed($signed({{32{A[31]}}, A[31]}) * $signed({{32{B[31]}}, B[31]}));
我认为还可以对错误写法1进行修改——
//正确写法3
{HI_temp, LO_temp} <= $sigend({HI, LO}) + $signed(A) * $signed(B);
2.条件跳转类
一般跳转类指令有以下几种要求——

条件跳转+无条件链接
条件跳转+条件链接
条件跳转+条件（无条件）链接+不跳转时清空延迟槽
条件跳转比较好做，一般只需增加CMP模块中的判断功能即可。
如果是无条件链接的话也比较简单，可以直接在D级将RFWrite（GRF写入使能）置1并让它流水，并更改一下A3(GRF写入地址，一般是要链接到31号寄存器)，最后在W级将GRF写入数据选择成PC+8即可。
如果是条件链接，则需要在D级根据CMP模块的输出结果判断RFWrite是否有效，写法如下——
//为了确定当前指令是新指令，我们设置一个check信号随新指令一起流水，check有效则表示当前指令是新指令
//D_RFWrite是从D级主控制器输出的信号
wire D_RFWrite_new = check_D ? (D_CMP_out ? 1'b1 : 1'b0) : D_RFWrite;
//这时我们流水到下一级的就是D_RFWrite_new，而不是D_RFWrite
E_Reg  u_E_Reg (//input
                //…………………………………………
                .RFWrite_D               ( RFWrite_D_new      ),

                //output
                //…………………………………………
                .RFWrite_E               ( RFWrite_E          ),
                );
如果题目要求不跳转时清空延迟槽，则需要根据当前CMP模块输出结果判断是否清空D级流水寄存器。需要注意的是，如果当前正在处于stall状态时，不能清空延迟槽（stall说明前面指令的Tnew大于新指令的Tuse，即需要传入CMP模块的两个值的最新值还没有计算出来，因此还无法转发到CMP中）。写法如下——
wire D_Reg_clr = check_D & ~D_CMP_out & ~stall;
3.条件存储类
条件存储，也就是从DM取出值之后，根据这个值是否满足某个condition，再判断要往哪个寄存器写。 和前两种题型相比更复杂，但是总结下来也就只有以下三种类型——

condition成立： 将DM中的值写入A号寄存器 condition不成立： 写入B号寄存器
condition成立： 将DM中的值写入A号寄存器 condition不成立： 不写入
写入目标完全取决于DM的读取值（如将DM读取值的低5位作为写入目标）
对于第二种不写入的情况，我们可以将写入地址设置为0号寄存器。因此这三种类型本质上是一种。

对于条件存储类指令，我们只有到M级才知道写入目标是什么，这对会我们的转发和暂停造成影响。我们需要对 stall信号的生成逻辑进行修改，引用学长的话说就是——“如果 D 级的指令要读寄存器，而且后面的新指令 可能 要写这个寄存器，那么就 stall”。代码如下——

//笔者采用的命名方法是——A1和A2表示该流水级指令的GRF读地址,A3表示指令的GRF写地址
//例如，如果E级指令为addu，则E_A1为rs域数据，E_A2为rt域数据，E_A3为rd域数据
//RFWrite表示GRF写入使能信号
//check信号有效则表示该流水级指令为新指令
////////////////////////////////////////////////////
//第一种题型(eg：condition满足向rt号写，否则写31号)
    assign   stall_rs_E = (D_A1 != 5'd0) & (check_E ? (D_A1 == E_A3 | D_A1 == 5'd31) : D_A1 == E_A3) & (RFWrite_E) & (Tuse_rs < Tnew_E);
    assign   stall_rs_M = (D_A1 != 5'd0) & (check_M ? (D_A1 == M_A3 | D_A1 == 5'd31) : D_A1 == M_A3) & (RFWrite_M) & (Tuse_rs < Tnew_M);
    assign   stall_rt_E = (D_A2 != 5'd0) & (check_E ? (D_A2 == E_A3 | D_A2 == 5'd31) : D_A2 == E_A3) & (RFWrite_E) & (Tuse_rt < Tnew_E);
    assign   stall_rt_M = (D_A2 != 5'd0) & (check_M ? (D_A2 == M_A3 | D_A2 == 5'd31) : D_A2 == M_A3) & (RFWrite_M) & (Tuse_rt < Tnew_M);
//第二种题型 (eg：condition满足向31号写，否则不写) 
//按照第一种题型以写成  (check_M ? (D_A2 == 5'd31 | D_A2 == 5'd0): D_A2 == M_A3),因为前面有条件 D_A2 != 5'd0，所以可以简化
    assign   stall_rt_M = (D_A2 != 5'd0) & (check_M ? D_A2 == 5'd31 : D_A2 == M_A3) & (RFWrite_M) & (Tuse_rt < Tnew_M);
//第三种题型 (eg：condition满足时写入位置为DM的读取值的低五位)   
    assign   stall_rt_M = (D_A2 != 5'd0) & (check_M ? 1'b1 : D_A2 == M_A3) & (RFWrite_M) & (Tuse_rt < Tnew_M);
此外我们还需要在M级根据DM取出的值修改A3(GRF写入地址),代码如下——

//第一种题型(eg：condition满足向rt号写，否则写31号)
    wire M_A3_new = check_M ? (condition ? `rt : 5'd31) : M_A3; 
//第二种题型 (eg：condition满足向31号写，否则不写) 
    wire M_A3_new = check_M ? (condition ? 5'd31 : 5'd0) : M_A3; 
//第三种题型 (eg：写入位置为DM的读取值的低五位)  
    wire M_A3_new = check_M ? DM_out[4:0] : M_A3; 
这样一来，我们在M级就将可以将正确的GRF写入地址修改，然后再传入下一级流水寄存器(W_Reg)和冒险控制器(HCU)即可。

    W_Reg  u_W_Reg (//input
                  //…………………………………………
                  .M_A3               ( M_A3_new      ),

                  //output
                  //…………………………………………
                  .W_A3               ( W_A3      ),
                  );

      HCU  u_HCU (//input
                  //…………………………………………
                  .M_A3                 ( M_A3_new         ),
                  
                  //output
                  .FwdCMPD1             ( FwdCMPD1   [1:0] ),
                  .FwdCMPD2             ( FwdCMPD2   [1:0] ),
                  .FwdALUA              ( FwdALUA    [1:0] ),
                  .FwdALUB              ( FwdALUB    [1:0] ),
                  .FwdDM                ( FwdDM            ),
                  .stall                ( stall            )
                );
如果你是到W级才修改写入地址（也就是说，M_A3_new只传入了W_Reg而没有传入HCU，HCU的输入端仍然是M_A3）, 这样会有一定问题。通过下面的例子说明——

    lhso    $s1, 1024($0) 
    sw      $s1, 4096($0)
当lhso在M级的时候，M级写入地址还没有被及时更新。因此这时候冒险控制器中lhso的写地址（$s1）和sw的读地址（$s1）还是相等的，所以会向处于E级的sw指令转发一个数据（即教程中采用的暴力转发）。下一时钟上升沿来临时，lhso进入W级，如果这时候lhso的写入地址不再是$s1, 而是根据condition修改成了31号寄存器，那么我们在上一周期向sw指令转发的值就是一个错误值。

为了避免这种情况，我们需要对转发信号做一些调整，策略是：既然我们在lhso进入W级之前不知道要往哪个寄存器写值，那么我们就不向前转发。转发信号的调整如下——

assign FwdCMPD1 = ((D_A1 != 5'd0) & (D_A1 == E_A3) & (RFWrite_E) & ~check_E) ? 2'd2 :
                  ((D_A1 != 5'd0) & (D_A1 == M_A3) & (RFWrite_M) & ~check_M) ? 2'd1 : 
                                                                    2'd0;

assign FwdCMPD2 = ((D_A2 != 5'd0) & (D_A2 == E_A3) & (RFWrite_E) & ~check_E) ? 2'd2 :
                  ((D_A2 != 5'd0) & (D_A2 == M_A3) & (RFWrite_M) & ~check_M) ? 2'd1 :
                                                                    2'd0;

assign FwdALUA  = ((E_A1 != 5'd0) & (E_A1 == M_A3) & (RFWrite_M) & ~check_M) ? 2'd2 :
                  ((E_A1 != 5'd0) & (E_A1 == W_A3) & (RFWrite_W)) ? 2'd1 :
                                                                    2'd0;    

assign FwdALUB  = ((E_A2 != 5'd0) & (E_A2 == M_A3) & (RFWrite_M) & ~check_M) ? 2'd2 :
                  ((E_A2 != 5'd0) & (E_A2 == W_A3) & (RFWrite_W)) ? 2'd1 :
                                                                    2'd0;

assign FwdDM    = ((M_A2 != 5'd0) & (M_A2 == W_A3) & (RFWrite_W)) ? 1'd1 : 
                                                                    1'd0;
这样对于新指令，我们就不再是暴力转发，而是条件转发。我个人还是建议采用第2种方法，我认为这种方法的正确性比第一种更容易证明。另外，建议在课下可以提前设置好一个check信号并让它流水，这样在课上会节省很多时间。

实际上，我们也可以把所有指令的转发都更改为条件转发——即所有的指令只有得到要写入寄存器的结果后才会向前转发，这样只需要将Tnew == 0加入判断条件即可。

//Tnew == 0 表示当前指令已经产生要写入寄存器的结果
//因为W级指令的Tnew都为0，因此不需要再添加(Tnew_W == 0)
assign FwdCMPD1 = ((D_A1 != 5'd0) & (D_A1 == E_A3) & (RFWrite_E) & (Tnew_E == 0)) ? 2'd2 :
                  ((D_A1 != 5'd0) & (D_A1 == M_A3) & (RFWrite_M) & (Tnew_M == 0)) ? 2'd1 : 
                                                                    2'd0;

assign FwdCMPD2 = ((D_A2 != 5'd0) & (D_A2 == E_A3) & (RFWrite_E) & (Tnew_E == 0)) ? 2'd2 :
                  ((D_A2 != 5'd0) & (D_A2 == M_A3) & (RFWrite_M) & (Tnew_M == 0)) ? 2'd1 :
                                                                    2'd0;

assign FwdALUA  = ((E_A1 != 5'd0) & (E_A1 == M_A3) & (RFWrite_M) & (Tnew_M == 0)) ? 2'd2 :
                  ((E_A1 != 5'd0) & (E_A1 == W_A3) & (RFWrite_W)) ? 2'd1 :
                                                                    2'd0;    

assign FwdALUB  = ((E_A2 != 5'd0) & (E_A2 == M_A3) & (RFWrite_M) & (Tnew_M == 0)) ? 2'd2 :
                  ((E_A2 != 5'd0) & (E_A2 == W_A3) & (RFWrite_W)) ? 2'd1 :
                                                                    2'd0;

assign FwdDM    = ((M_A2 != 5'd0) & (M_A2 == W_A3) & (RFWrite_W)) ? 1'd1 : 
                                                                    1'd0;
Q:条件转发会有问题吗？

A:不会。 因为有暂停机制把关，保证了指令获得要写入寄存器的值之前，前面的正常执行的（即不被stall的）指令都不会用到相关寄存器的值，或恰好将要使用，即Tnew <= Tuse，因此不会带来新的问题。