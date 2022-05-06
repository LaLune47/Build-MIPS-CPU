////条件访存类////
///主要也是两类，用M级的数据算出是否写寄存器，又或者是算出写哪个寄存器，
/// 全部归类于写哪个寄存器，如果不写就是写入0   (不影响写入值的，写入值还是和正常的load类似)

//M_DM
		integer i;
		reg [31:0] o = 0;
		reg [31:0] z = 0;
		always@(*)begin
			o = 0;
			z = 0;
            for(i = 0; i < 16; i = i + 1)begin//hf为读出的半字
				if(hf[i] == 1'b1) o = o + 1;
				else z = z + 1;
			end
			if(o > z) lhonez_ch = 1'b1;
			else lhonez_ch = 1'b0;
		end                  //  differ from instructions
    
    //lhonez_ch    流水



// E_CU_2, M_CU_2 ,W_CU -------A3 WD
wire [4:0] lhonez_a = (lhonez_ch === 1'bz || lhonez_ch === 1'bx)? 0 : (lhonez_ch === 1'b1)? rt : 32'd31;
assign gwa_res = ...//grf写入地址
				(lhonez)? lhonez_a :
				 ...   
assign gwd_sel = ... //grf写入什么值
				(lhonez)?((lhonez_ch === 1'b1)? `gwd_dm : `gwd_pc4):
				...


// FWD
assign fw_E_wd = (E_gwd_sel == `gwd_pc8)? E_pc + 8:
				 (E_gwd_sel == `gwd_pc4)? E_pc + 4:  //  new writing data type
				 32'd0;
							
assign fw_M_wd = (M_gwd_sel == `gwd_alu)? M_alu_out:
				 (M_gwd_sel == `gwd_pc8)? M_pc + 8:
				 (M_gwd_sel == `gwd_pc4)? M_pc + 4:  //
				 (M_gwd_sel == `gwd_md)? M_md_out:
				 32'd0;
							
assign fw_W_wd = (W_gwd_sel == `gwd_alu)? W_alu_out:
				 (W_gwd_sel == `gwd_dm)? W_dm_out:
				 (W_gwd_sel == `gwd_pc8)? W_pc + 8:
				 (W_gwd_sel == `gwd_pc4)? W_pc + 4:  // 
				 (W_gwd_sel == `gwd_md)? W_md_out:
				 32'd0;


//STALL 
//当该条指令在E级时要特判一下阻塞，在M级就像正常的load类指令（将该类指令归入load类）用Tuse,Tnew判断
//但是注意上面说的可能有bug,建议该指令在M级的时候也像E那样特判阻塞，
//E
assign stall_lhonez = (E_lhonez && (((D_rs == E_rt || D_rs == 5'd31) && (D_rs != 5'd0) && (Tuse_rs < Tnew_E)) || ((D_rt == E_rt || D_rt == 5'd31) && (D_rs != 5'd0) && (Tuse_rt < Tnew_E))));
//M
assign stall_lhonez = (E_lhonez && (((D_rs == E_rt || D_rs == 5'd31) && (D_rs != 5'd0) && (Tuse_rs < Tnew_E)) || ((D_rt == E_rt || D_rt == 5'd31) && (D_rs != 5'd0) && (Tuse_rt < Tnew_E))));





//是lwer这种需要用dm_out,rt_data计算地址的可以这样写(rt_d记得流水到W级)：
// E_CU_2, M_CU_2 ,W_CU -------A3 WD
wire lwer_ch = lwer && mem_word && rt_d;
assign gwa_res = ...
                 (lwer)? ((lwer_ch !== 1'bz && lwer_ch !== 1'bx)?((mem_word + rt_d)& 5'h1e) : 5'b0) : 
                 ...




// 重点是条件存储！
//最后是movz（rt_data == 0将rs_data写到rd里面否则不写，该指令mars里面有，大家可以练练），它在E级时应该也要特判阻塞，
//因为道理同访存（我刚开始认为它在E级就得到结果了，就和一条正常的calculate_r没有区别了），在E级得到写不写rt也会有组合逻辑延时。