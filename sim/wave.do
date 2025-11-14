onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_axi4_switch/dut/rstn
add wave -noupdate /tb_axi4_switch/dut/clk
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
add wave -noupdate -expand -group m_axi_wr -expand /tb_axi4_switch/dut/m_axi_awready
add wave -noupdate -expand -group m_axi_wr -expand /tb_axi4_switch/dut/m_axi_awvalid
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_awaddr
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_awburst
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_awid
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_awlen
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_awsize
add wave -noupdate -expand -group m_axi_wr -expand /tb_axi4_switch/dut/m_axi_wready
add wave -noupdate -expand -group m_axi_wr -expand /tb_axi4_switch/dut/m_axi_wvalid
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_wlast
add wave -noupdate -expand -group m_axi_wr -expand /tb_axi4_switch/dut/m_axi_wstrb
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_wdata
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_bready
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_bvalid
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_bresp
add wave -noupdate -expand -group m_axi_wr /tb_axi4_switch/dut/m_axi_bid
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
add wave -noupdate -group s_axi_wr -expand /tb_axi4_switch/dut/s_axi_awready
add wave -noupdate -group s_axi_wr -expand /tb_axi4_switch/dut/s_axi_awvalid
add wave -noupdate -group s_axi_wr -expand /tb_axi4_switch/dut/s_axi_awaddr
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_awburst
add wave -noupdate -group s_axi_wr -expand /tb_axi4_switch/dut/s_axi_awid
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_awlen
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_awsize
add wave -noupdate -group s_axi_wr -expand /tb_axi4_switch/dut/s_axi_wready
add wave -noupdate -group s_axi_wr -expand /tb_axi4_switch/dut/s_axi_wvalid
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_wlast
add wave -noupdate -group s_axi_wr -expand /tb_axi4_switch/dut/s_axi_wstrb
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_wdata
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_bready
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_bvalid
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_bresp
add wave -noupdate -group s_axi_wr /tb_axi4_switch/dut/s_axi_bid
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/ar_packed_data
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/ar_target
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/ar_unpacked_data
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/aw_packed_data
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/aw_target
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/aw_unpacked_data
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busARAddr_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busARBurst_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busARId_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busARLen_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busARRdy_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busARSrc_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busARSz_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busARVld_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busAWAddr_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busAWBurst_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busAWId_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busAWLen_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busAWRdy_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busAWSrc_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busAWSz_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busAWVld_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busBId_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busBRdy_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busBResp_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busBVld_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busRData_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busRId_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busRLast_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busRRdy_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busRResp_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busRVld_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busWData_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busWLast_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busWRdy_i
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busWSrc_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busWStrb_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/busWVld_o
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/clk
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/rstn
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_araddr
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_arburst
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_arid
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_arlen
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_arready
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_arsize
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_arvalid
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_awaddr
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_awburst
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_awid
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_awlen
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_awready
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_awsize
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_awvalid
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_bid
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_bready
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_bresp
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_bvalid
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_rdata
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_rid
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_rlast
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_rready
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_rresp
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_rvalid
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_wdata
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_wlast
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_wready
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_wstrb
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/s_axi_wvalid
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/w_packed_data
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/w_target
add wave -noupdate -group slave_switch /tb_axi4_switch/dut/u_slave_switch/w_unpacked_data
add wave -noupdate -group aw_arb /tb_axi4_switch/dut/u_slave_switch/aw_arbiter/srcVld_i
add wave -noupdate -group aw_arb /tb_axi4_switch/dut/u_slave_switch/aw_arbiter/srcTarget_i
add wave -noupdate -group aw_arb /tb_axi4_switch/dut/u_slave_switch/aw_arbiter/srcDat_i
add wave -noupdate -group aw_arb /tb_axi4_switch/dut/u_slave_switch/aw_arbiter/grantRdy_o
add wave -noupdate -group aw_arb /tb_axi4_switch/dut/u_slave_switch/aw_arbiter/dstRdy_i
add wave -noupdate -group aw_arb /tb_axi4_switch/dut/u_slave_switch/aw_arbiter/dstVld_o
add wave -noupdate -group aw_arb /tb_axi4_switch/dut/u_slave_switch/aw_arbiter/dstSrc_o
add wave -noupdate -group aw_arb /tb_axi4_switch/dut/u_slave_switch/aw_arbiter/dstDat_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/b_src_data
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bid_dest
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bid_valid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_araddr_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_arburst_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_arid_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_arlen_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_arsize_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_arvalid_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_awaddr_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_awburst_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_awid_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_awlen_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_awsize_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_awvalid_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_wdata_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_wlast_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_wstrb_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/bum_axi_wvalid_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARAddr_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARBurst_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARDst_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARId
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARId_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARLen_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARRdy_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARSrc
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARSrc_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARSz_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busARVld_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWAddr_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWBurst_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWDst_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWId
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWId_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWLen_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWRdy_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWSrc
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWSrc_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWSz_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busAWVld_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busBDst_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busBId_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busBRdy_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busBResp_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busBSrc_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busBVld_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busRData_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busRDst_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busRId_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busRLast_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busRRdy_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busRResp_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busRSrc_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busRVld_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busWData_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busWDst_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busWLast_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busWRdy_o
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busWSrc_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busWStrb_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/busWVld_i
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/clk
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_araddr
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_arburst
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_arid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_arlen
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_arready
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_arsize
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_arvalid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_awaddr
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_awburst
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_awid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_awlen
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_awready
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_awsize
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_awvalid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_bid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_bready
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_bresp
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_bvalid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_rdata
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_rid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_rlast
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_rready
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_rresp
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_rvalid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_wdata
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_wlast
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_wready
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_wstrb
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/m_axi_wvalid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/r_src_data
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/rid_dest
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/rid_re
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/rid_valid
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/rstn
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/rtarget
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/rtargetBuf_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/rtargetVld_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/wtarget
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/wtargetBuf_r
add wave -noupdate -group master_switch /tb_axi4_switch/dut/u_master_switch/wtargetVld_r
add wave -noupdate /tb_axi4_switch/dut/u_slave_switch/w_arbiter/grantRdy_o
add wave -noupdate /tb_axi4_switch/dut/u_slave_switch/w_arbiter/srcVld_i
add wave -noupdate /tb_axi4_switch/dut/u_slave_switch/w_arbiter/srcTarget_i
add wave -noupdate /tb_axi4_switch/dut/u_slave_switch/w_arbiter/srcDat_i
add wave -noupdate /tb_axi4_switch/dut/u_slave_switch/w_arbiter/dstRdy_i
add wave -noupdate /tb_axi4_switch/dut/u_slave_switch/w_arbiter/dstVld_o
add wave -noupdate /tb_axi4_switch/dut/u_slave_switch/w_arbiter/dstSrc_o
add wave -noupdate /tb_axi4_switch/dut/u_slave_switch/w_arbiter/dstDat_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {474000 ps} 0}
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
WaveRestoreZoom {399337 ps} {547404 ps}
