onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /exdes_tb/exdes_top/dut/aclk
add wave -noupdate /exdes_tb/exdes_top/dut/aresetn
add wave -noupdate /exdes_tb/exdes_top/dut/aresetn_out

add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_arvalid
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_arready
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_araddr
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_arburst
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_arid
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_arlen
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_arsize
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_rready
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_rvalid
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_rresp
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_rlast
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_rid
add wave -noupdate -group m0_rd /exdes_tb/exdes_top/dut/m00_axi_rdata

add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_awready
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_awvalid
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_awaddr
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_awburst
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_awid
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_awlen
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_awsize
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_wready
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_wvalid
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_wlast
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_wdata
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_bready
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_bvalid
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_bid
add wave -noupdate -group m0_wr /exdes_tb/exdes_top/dut/m00_axi_bresp

add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_arvalid
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_arready
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_araddr
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_arburst
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_arid
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_arlen
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_arsize
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_rready
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_rvalid
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_rresp
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_rlast
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_rid
add wave -noupdate -group m1_rd /exdes_tb/exdes_top/dut/m01_axi_rdata

add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_awready
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_awvalid
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_awaddr
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_awburst
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_awid
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_awlen
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_awsize
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_wready
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_wvalid
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_wlast
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_wdata
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_bready
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_bvalid
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_bid
add wave -noupdate -group m1_wr /exdes_tb/exdes_top/dut/m01_axi_bresp

add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_arvalid
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_arready
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_araddr
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_arburst
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_arid
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_arlen
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_arsize
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_rready
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_rvalid
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_rresp
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_rlast
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_rid
add wave -noupdate -group s0_rd /exdes_tb/exdes_top/dut/s00_axi_rdata

add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_awready
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_awvalid
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_awaddr
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_awburst
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_awid
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_awlen
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_awsize
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_wready
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_wvalid
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_wlast
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_wdata
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_bready
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_bvalid
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_bid
add wave -noupdate -group s0_wr /exdes_tb/exdes_top/dut/s00_axi_bresp

add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_arvalid
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_arready
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_araddr
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_arburst
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_arid
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_arlen
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_arsize
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_rready
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_rvalid
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_rresp
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_rlast
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_rid
add wave -noupdate -group s1_rd /exdes_tb/exdes_top/dut/s01_axi_rdata

add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_awready
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_awvalid
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_awaddr
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_awburst
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_awid
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_awlen
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_awsize
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_wready
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_wvalid
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_wlast
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_wdata
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_bready
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_bvalid
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_bid
add wave -noupdate -group s1_wr /exdes_tb/exdes_top/dut/s01_axi_bresp

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {23013009 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 255
configure wave -valuecolwidth 81
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {25096347 ps} {25888307 ps}
