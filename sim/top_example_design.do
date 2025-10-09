transcript file ""
transcript file simulation.log
transcript on

set XIL_SIM_LIB_PATH "W:/Projects/Vishare/vsRisc5/xilinx_2022_me_10_7_sim_lib"
set REF_PATH ../syn/axi_switch_0_ref_ex
set CLK_WIZ_PATH $REF_PATH/axi_switch_0_ref_ex.gen/sources_1/ip/axi_switch_0_ref_example_clk_wiz_0
set TB_PATH ../tb
set include_path "+incdir+$CLK_WIZ_PATH+incdir+$REF_PATH/imports+incdir+$TB_PATH"

vlib work
vlib msim
vlib msim/xil_defaultlib
vlib blk_mem_gen_v8_4_5
vlib fifo_generator_v13_2_7
vlib unisims_ver
vlib unimacro_ver
vlib secureip
vlib xpm

# ## Xilinx 2022 ##
vmap xil_defaultlib msim/xil_defaultlib
vmap blk_mem_gen_v8_4_5 $XIL_SIM_LIB_PATH/blk_mem_gen_v8_4_5/
vmap fifo_generator_v13_2_7 $XIL_SIM_LIB_PATH/fifo_generator_v13_2_7/
vmap unisims_ver $XIL_SIM_LIB_PATH/unisims_ver/
vmap unimacro_ver $XIL_SIM_LIB_PATH/unimacro_ver/
vmap secureip $XIL_SIM_LIB_PATH/secureip/
vmap xpm $XIL_SIM_LIB_PATH/xpm/

vlog -incr -lint -sv -work xil_defaultlib $include_path $CLK_WIZ_PATH/axi_switch_0_ref_example_clk_wiz_0_clk_wiz.v
vlog -incr -lint -sv -work xil_defaultlib $include_path $CLK_WIZ_PATH/axi_switch_0_ref_example_clk_wiz_0.v

vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/axi_switch_0_ref_ex.gen/sources_1/ip/axi_switch_0_ref/axi_switch_0_ref_sim_netlist.v

vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/imports/axi_switch_0_ref_example_axi4_master_0.sv
vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/imports/axi_switch_0_ref_example_axi4_master_1.sv
vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/imports/axi_switch_0_ref_example_axi4_slave_0.sv
vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/imports/axi_switch_0_ref_example_axi4_slave_1.sv
vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/imports/axi_switch_0_ref_example_design.sv
vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/imports/axi_switch_0_ref_example_example_reg_srl_fifo_0_rtl.sv
vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/imports/axi_switch_0_ref_example_example_reg_srl_fifo_0.sv
vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/imports/axi_switch_0_ref_example_example_reg_srl_fifo_1_rtl.sv
vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/imports/axi_switch_0_ref_example_example_reg_srl_fifo_1.sv
vlog -incr -lint -sv -work xil_defaultlib $include_path $REF_PATH/imports/axi_switch_0_ref_exdes_tb.sv

#compile glbl module
vlog -work xil_defaultlib "glbl.v"

vsim +vopt -voptargs="+acc" +nowarn8233 +nowarn8315 +notimingchecks +nospecify \
     -L xil_defaultlib \
     -L blk_mem_gen_v8_4_5 \
     -L fifo_generator_v13_2_7 \
     -L unisims_ver \
     -L unimacro_ver \
     -L secureip \
     -L xpm \
	 -lib xil_defaultlib xil_defaultlib.exdes_tb xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do wave_example_design.do

run -all

#toggle report -all
#coverage report -html -htmldir covhtmlreport -assert -directive -cvg -code bcefst -threshL 50 -threshH 90
