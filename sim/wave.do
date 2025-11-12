onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_axi4_switch/dut/rstn
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_arready
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_arvalid
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_araddr
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_arburst
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_arid
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_arlen
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_arsize
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_rready
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_rvalid
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_rlast
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_rresp
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_rdata
add wave -noupdate -group m_axi_rd /tb_axi4_switch/dut/m_axi_rid
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_awready
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_awvalid
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_awaddr
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_awburst
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_awid
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_awlen
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_awsize
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_wready
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_wvalid
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_wlast
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_wstrb
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_wdata
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_bready
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_bvalid
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_bresp
add wave -noupdate -group m_axi_wr /tb_axi4_switch/dut/m_axi_bid
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_arready
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_arvalid
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_araddr
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_arburst
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_arid
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_arlen
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_arsize
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_rdata
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_rready
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_rvalid
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_rlast
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_rresp
add wave -noupdate -group s_axi_rd /tb_axi4_switch/dut/s_axi_rid
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_awready
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_awvalid
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_awaddr
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_awburst
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_awid
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_awlen
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_awsize
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_wready
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_wvalid
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_wlast
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_wstrb
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_wdata
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_bready
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_bvalid
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_bresp
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_bid
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
WaveRestoreZoom {933460472638 ps} {933461264598 ps}
