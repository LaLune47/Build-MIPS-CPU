22222  一般是条件跳转 + 条件写。 
跳转指令一个好处在于它是在 D 级决定是否跳转的，
也就是说在 D 级你可以获得全部的正确信息
（相反如果是类似于 lwso 这种，你必须要读出 DM 的值才能决定怎么做）。

所以我们的方案是 D 级生成一个 D_check 信号然后流水它。然后每一级根据这个信号判断写入地址/写入值之类的。
// D级生成的 检测信号
D_check = D_bgezalc & D_b_jump;
// CU
assign RFDst = // ...
               bgezalc ? (check ? 5'd31 : 5'd0) :
               5'd0;




33333   条件存储
条件存储的特点是必须要到 M 级才知道要写啥，这就给转发之类的造成了困难
策略： 如果 D 级要读寄存器，而且新指令可能要写这个寄存器，那么就 stall。
//stall
  // lwso
  wire stall_rs_e = (TuseRS < TnewE) && D_rs_addr && (D_lwso ? D_rs_addr == 5'd31 : D_rs_addr == E_RFDst);
  // lrm
  wire stall_rs_e = (TuseRS < TnewE) && D_rs_addr && (D_lrm ? D_rs_addr : D_rs_addr == E_RFDst);     // 冒号后面就是正常的，没有那么苛刻的条件。

改完暂停之后，跟条件存储基本没有区别！！！
// M级生成的 检测信号
 M_check = D_lwso && condition;
// CU
 assign RFDst = // ...
               lwso ? (check===1'd1 ? 5'd31 : 5'd0) : // 注意不是直接一个 check ( === 排除x的干扰)
               5'd0;
