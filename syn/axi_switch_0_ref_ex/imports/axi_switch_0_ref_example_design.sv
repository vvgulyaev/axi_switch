// -----------------------------------------------------------------------------
// (c) Copyright 2024 Advanced Micro Devices, Inc. All rights reserved.                
//                                                                              
// This file contains confidential and proprietary information                  
// of Advanced Micro Devices, Inc. and is protected under U.S. and                              
// international copyright and other intellectual property                      
// laws.                                                                        
//                                                                              
// DISCLAIMER                                                                   
// This disclaimer is not a license and does not grant any                      
// rights to the materials distributed herewith. Except as                      
// otherwise provided in a valid license issued to you by                       
// AMD, and to the maximum extent permitted by applicable                    
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND                    
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES                  
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING                    
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-                       
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and                     
// (2) AMD shall not be liable (whether in contract or tort,                 
// including negligence, or under any other theory of                           
// liability) for any loss or damage of any kind or nature                      
// related to, arising under or in connection with these                        
// materials, including for any direct, or any indirect,                        
// special, incidental, or consequential loss or damage                         
// (including loss of data, profits, goodwill, or any type of                   
// loss or damage suffered as a result of any action brought                    
// by a third party) even if such damage or loss was                            
// reasonably foreseeable or AMD had been advised of the                     
// possibility of the same.                                                     
//                                                                              
// CRITICAL APPLICATIONS                                                        
// AMD products are not designed or intended to be fail-                     
// safe, or for use in any application requiring fail-safe                      
// performance, such as life-support or safety devices or                       
// systems, Class III medical devices, nuclear facilities,                      
// applications related to the deployment of airbags, or any                    
// other applications that could lead to death, personal                        
// injury, or severe property or environmental damage                           
// (individually and collectively, "Critical                                   
// Applications"). Customer assumes the sole risk and                          
// liability of any use of AMD products in Critical                          
// Applications, subject only to applicable laws and                            
// regulations governing limitations on product liability.                      
//                                                                              
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS                     
// PART OF THIS FILE AT ALL TIMES.                                              
// -----------------------------------------------------------------------------

`timescale 1ps / 1ps

`default_nettype none

module axi_switch_0_ref_example_design
  (
    input  wire  clk_p,
    input  wire  clk_n,
    input  wire  sys_rstn,
    output wire done);


   (* MARK_DEBUG *) logic [32-1:0] m00_axi_araddr;
   (* MARK_DEBUG *) logic [3-1:0] m00_axi_arprot;
   (* MARK_DEBUG *) logic m00_axi_arready;
   (* MARK_DEBUG *) logic m00_axi_arvalid;
   (* MARK_DEBUG *) logic [32-1:0] m00_axi_rdata;
   (* MARK_DEBUG *) logic m00_axi_rready;
   (* MARK_DEBUG *) logic [2-1:0] m00_axi_rresp;
   (* MARK_DEBUG *) logic m00_axi_rvalid;
   (* MARK_DEBUG *) logic m00_axi_rlast;
   (* MARK_DEBUG *) logic [2-1:0] m00_axi_arburst;
   (* MARK_DEBUG *) logic [4-1:0] m00_axi_arcache;
   (* MARK_DEBUG *) logic [8-1:0] m00_axi_arlen;
   (* MARK_DEBUG *) logic [1-1:0] m00_axi_arlock;
   (* MARK_DEBUG *) logic [4-1:0] m00_axi_arqos;
   (* MARK_DEBUG *) logic [3-1:0] m00_axi_arsize;
   (* MARK_DEBUG *) logic [1-1:0] m00_axi_aruser;
   (* MARK_DEBUG *) logic [1-1:0] m00_axi_ruser;
   (* MARK_DEBUG *) logic  m00_axi_arid;
   (* MARK_DEBUG *) logic  m00_axi_rid;
   (* MARK_DEBUG *) logic [32-1:0] m00_axi_awaddr;
   (* MARK_DEBUG *) logic [3-1:0] m00_axi_awprot;
   (* MARK_DEBUG *) logic m00_axi_awready;
   (* MARK_DEBUG *) logic m00_axi_awvalid;
   (* MARK_DEBUG *) logic m00_axi_bready;
   (* MARK_DEBUG *) logic [2-1:0] m00_axi_bresp;
   (* MARK_DEBUG *) logic m00_axi_bvalid;
   (* MARK_DEBUG *) logic [32-1:0] m00_axi_wdata;
   (* MARK_DEBUG *) logic m00_axi_wready;
   (* MARK_DEBUG *) logic [32/8-1:0] m00_axi_wstrb;
   (* MARK_DEBUG *) logic m00_axi_wvalid;
   (* MARK_DEBUG *) logic m00_axi_wlast;
   (* MARK_DEBUG *) logic [2-1:0] m00_axi_awburst;
   (* MARK_DEBUG *) logic [4-1:0] m00_axi_awcache;
   (* MARK_DEBUG *) logic [8-1:0] m00_axi_awlen;
   (* MARK_DEBUG *) logic [1-1:0] m00_axi_awlock;
   (* MARK_DEBUG *) logic [4-1:0] m00_axi_awqos;
   (* MARK_DEBUG *) logic [3-1:0] m00_axi_awsize;
   (* MARK_DEBUG *) logic [1-1:0] m00_axi_awuser;
   (* MARK_DEBUG *) logic [1-1:0] m00_axi_buser;
   (* MARK_DEBUG *) logic [1-1:0] m00_axi_wuser;
   (* MARK_DEBUG *) logic  m00_axi_awid;
   (* MARK_DEBUG *) logic  m00_axi_bid;
   (* MARK_DEBUG *) logic  m00_axi_wid = 'b0;

   (* MARK_DEBUG *) logic [32-1:0] m01_axi_araddr;
   (* MARK_DEBUG *) logic [3-1:0] m01_axi_arprot;
   (* MARK_DEBUG *) logic m01_axi_arready;
   (* MARK_DEBUG *) logic m01_axi_arvalid;
   (* MARK_DEBUG *) logic [32-1:0] m01_axi_rdata;
   (* MARK_DEBUG *) logic m01_axi_rready;
   (* MARK_DEBUG *) logic [2-1:0] m01_axi_rresp;
   (* MARK_DEBUG *) logic m01_axi_rvalid;
   (* MARK_DEBUG *) logic m01_axi_rlast;
   (* MARK_DEBUG *) logic [2-1:0] m01_axi_arburst;
   (* MARK_DEBUG *) logic [4-1:0] m01_axi_arcache;
   (* MARK_DEBUG *) logic [8-1:0] m01_axi_arlen;
   (* MARK_DEBUG *) logic [1-1:0] m01_axi_arlock;
   (* MARK_DEBUG *) logic [4-1:0] m01_axi_arqos;
   (* MARK_DEBUG *) logic [3-1:0] m01_axi_arsize;
   (* MARK_DEBUG *) logic [1-1:0] m01_axi_aruser;
   (* MARK_DEBUG *) logic [1-1:0] m01_axi_ruser;
   (* MARK_DEBUG *) logic  m01_axi_arid;
   (* MARK_DEBUG *) logic  m01_axi_rid;
   (* MARK_DEBUG *) logic [32-1:0] m01_axi_awaddr;
   (* MARK_DEBUG *) logic [3-1:0] m01_axi_awprot;
   (* MARK_DEBUG *) logic m01_axi_awready;
   (* MARK_DEBUG *) logic m01_axi_awvalid;
   (* MARK_DEBUG *) logic m01_axi_bready;
   (* MARK_DEBUG *) logic [2-1:0] m01_axi_bresp;
   (* MARK_DEBUG *) logic m01_axi_bvalid;
   (* MARK_DEBUG *) logic [32-1:0] m01_axi_wdata;
   (* MARK_DEBUG *) logic m01_axi_wready;
   (* MARK_DEBUG *) logic [32/8-1:0] m01_axi_wstrb;
   (* MARK_DEBUG *) logic m01_axi_wvalid;
   (* MARK_DEBUG *) logic m01_axi_wlast;
   (* MARK_DEBUG *) logic [2-1:0] m01_axi_awburst;
   (* MARK_DEBUG *) logic [4-1:0] m01_axi_awcache;
   (* MARK_DEBUG *) logic [8-1:0] m01_axi_awlen;
   (* MARK_DEBUG *) logic [1-1:0] m01_axi_awlock;
   (* MARK_DEBUG *) logic [4-1:0] m01_axi_awqos;
   (* MARK_DEBUG *) logic [3-1:0] m01_axi_awsize;
   (* MARK_DEBUG *) logic [1-1:0] m01_axi_awuser;
   (* MARK_DEBUG *) logic [1-1:0] m01_axi_buser;
   (* MARK_DEBUG *) logic [1-1:0] m01_axi_wuser;
   (* MARK_DEBUG *) logic  m01_axi_awid;
   (* MARK_DEBUG *) logic  m01_axi_bid;
   (* MARK_DEBUG *) logic  m01_axi_wid = 'b0;

   (* MARK_DEBUG *) logic [32-1:0] s00_axi_araddr;
   (* MARK_DEBUG *) logic [3-1:0] s00_axi_arprot;
   (* MARK_DEBUG *) logic s00_axi_arready;
   (* MARK_DEBUG *) logic s00_axi_arvalid;
   (* MARK_DEBUG *) logic [32-1:0] s00_axi_rdata;
   (* MARK_DEBUG *) logic s00_axi_rready;
   (* MARK_DEBUG *) logic [2-1:0] s00_axi_rresp;
   (* MARK_DEBUG *) logic s00_axi_rvalid;
   (* MARK_DEBUG *) logic s00_axi_rlast;
   (* MARK_DEBUG *) logic [2-1:0] s00_axi_arburst;
   (* MARK_DEBUG *) logic [4-1:0] s00_axi_arcache;
   (* MARK_DEBUG *) logic [8-1:0] s00_axi_arlen;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_arlock;
   (* MARK_DEBUG *) logic [4-1:0] s00_axi_arqos;
   (* MARK_DEBUG *) logic [3-1:0] s00_axi_arsize;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_aruser;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_ruser;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_arid;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_rid;
   (* MARK_DEBUG *) logic [32-1:0] s00_axi_awaddr;
   (* MARK_DEBUG *) logic [3-1:0] s00_axi_awprot;
   (* MARK_DEBUG *) logic s00_axi_awready;
   (* MARK_DEBUG *) logic s00_axi_awvalid;
   (* MARK_DEBUG *) logic s00_axi_bready;
   (* MARK_DEBUG *) logic [2-1:0] s00_axi_bresp;
   (* MARK_DEBUG *) logic s00_axi_bvalid;
   (* MARK_DEBUG *) logic [32-1:0] s00_axi_wdata;
   (* MARK_DEBUG *) logic s00_axi_wready;
   (* MARK_DEBUG *) logic [32/8-1:0] s00_axi_wstrb;
   (* MARK_DEBUG *) logic s00_axi_wvalid;
   (* MARK_DEBUG *) logic s00_axi_wlast;
   (* MARK_DEBUG *) logic [2-1:0] s00_axi_awburst;
   (* MARK_DEBUG *) logic [4-1:0] s00_axi_awcache;
   (* MARK_DEBUG *) logic [8-1:0] s00_axi_awlen;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_awlock;
   (* MARK_DEBUG *) logic [4-1:0] s00_axi_awqos;
   (* MARK_DEBUG *) logic [3-1:0] s00_axi_awsize;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_awuser;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_buser;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_wuser;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_awid;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_bid;
   (* MARK_DEBUG *) logic [1-1:0] s00_axi_wid;

   (* MARK_DEBUG *) logic [32-1:0] s01_axi_araddr;
   (* MARK_DEBUG *) logic [3-1:0] s01_axi_arprot;
   (* MARK_DEBUG *) logic s01_axi_arready;
   (* MARK_DEBUG *) logic s01_axi_arvalid;
   (* MARK_DEBUG *) logic [32-1:0] s01_axi_rdata;
   (* MARK_DEBUG *) logic s01_axi_rready;
   (* MARK_DEBUG *) logic [2-1:0] s01_axi_rresp;
   (* MARK_DEBUG *) logic s01_axi_rvalid;
   (* MARK_DEBUG *) logic s01_axi_rlast;
   (* MARK_DEBUG *) logic [2-1:0] s01_axi_arburst;
   (* MARK_DEBUG *) logic [4-1:0] s01_axi_arcache;
   (* MARK_DEBUG *) logic [8-1:0] s01_axi_arlen;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_arlock;
   (* MARK_DEBUG *) logic [4-1:0] s01_axi_arqos;
   (* MARK_DEBUG *) logic [3-1:0] s01_axi_arsize;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_aruser;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_ruser;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_arid;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_rid;
   (* MARK_DEBUG *) logic [32-1:0] s01_axi_awaddr;
   (* MARK_DEBUG *) logic [3-1:0] s01_axi_awprot;
   (* MARK_DEBUG *) logic s01_axi_awready;
   (* MARK_DEBUG *) logic s01_axi_awvalid;
   (* MARK_DEBUG *) logic s01_axi_bready;
   (* MARK_DEBUG *) logic [2-1:0] s01_axi_bresp;
   (* MARK_DEBUG *) logic s01_axi_bvalid;
   (* MARK_DEBUG *) logic [32-1:0] s01_axi_wdata;
   (* MARK_DEBUG *) logic s01_axi_wready;
   (* MARK_DEBUG *) logic [32/8-1:0] s01_axi_wstrb;
   (* MARK_DEBUG *) logic s01_axi_wvalid;
   (* MARK_DEBUG *) logic s01_axi_wlast;
   (* MARK_DEBUG *) logic [2-1:0] s01_axi_awburst;
   (* MARK_DEBUG *) logic [4-1:0] s01_axi_awcache;
   (* MARK_DEBUG *) logic [8-1:0] s01_axi_awlen;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_awlock;
   (* MARK_DEBUG *) logic [4-1:0] s01_axi_awqos;
   (* MARK_DEBUG *) logic [3-1:0] s01_axi_awsize;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_awuser;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_buser;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_wuser;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_awid;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_bid;
   (* MARK_DEBUG *) logic [1-1:0] s01_axi_wid;

   logic clk;
   (* DONT_TOUCH *) logic rstn;
   (* MARK_DEBUG *) logic locked;
   logic [2-1:0] s_done;
   assign done = &s_done;

  //**********************************************
  // Instantiate Clock Generator module
  //**********************************************
  axi_switch_0_ref_example_clk_wiz_0
  clk_wiz_0
  (
    .clk_in1_p ( clk_p ),
    .clk_in1_n ( clk_n ),
    .clk_out1  ( clk ),
    .locked (locked)
  );

  //**********************************************
  // Instantiate MASTER 0
  //**********************************************
  axi_switch_0_ref_example_axi4_master_0 #(
    .C_AXI_ID_WIDTH       (0),
    .C_AXI_ADDR_WIDTH     (32),
    .C_AXI_DATA_WIDTH     (32),
    .C_AXI_PROTOCOL       (0),
	.C_AXI_AWUSER_WIDTH   (0),
	.C_AXI_ARUSER_WIDTH   (0),
	.C_AXI_BUSER_WIDTH    (0),
	.C_SUPPORTS_NARROW    (1),
	.C_SUPPORTS_WRAP      (1),
    .C_AXI_SUPPORTS_WRITE (1),
	.C_AXI_SUPPORTS_READ  (1),
	.C_AXI_ADDR           (64'h0000000000000000))  // Base address
  axi_master_m00 (
    /**************** Write Address Channel Signals ****************/
    .m_axi_awaddr    (s00_axi_awaddr),
    .m_axi_awprot    (s00_axi_awprot),
    .m_axi_awvalid   (s00_axi_awvalid),
    .m_axi_awready   (s00_axi_awready),
    .m_axi_awsize    (s00_axi_awsize),
    .m_axi_awburst   (s00_axi_awburst),
    .m_axi_awcache   (s00_axi_awcache),
    .m_axi_awlen     (s00_axi_awlen),
    .m_axi_awlock    (s00_axi_awlock),
    .m_axi_awqos     (s00_axi_awqos),
    .m_axi_awid      (s00_axi_awid),
    .m_axi_awuser    (s00_axi_awuser),
    /**************** Write Data Channel Signals ****************/
    .m_axi_wid       (s00_axi_wid),
    .m_axi_wlast     (s00_axi_wlast),
    .m_axi_wuser     (s00_axi_wuser),
    .m_axi_wdata     (s00_axi_wdata),
    .m_axi_wstrb     (s00_axi_wstrb),
    .m_axi_wvalid    (s00_axi_wvalid),
    .m_axi_wready    (s00_axi_wready),
    /**************** Write Response Channel Signals ****************/
    .m_axi_bresp     (s00_axi_bresp),
    .m_axi_bvalid    (s00_axi_bvalid),
    .m_axi_bready    (s00_axi_bready),
    .m_axi_buser     (s00_axi_buser),
    .m_axi_bid       (s00_axi_bid),
    /**************** Read Address Channel Signals ****************/
    .m_axi_araddr    (s00_axi_araddr),
    .m_axi_arprot    (s00_axi_arprot),
    .m_axi_arvalid   (s00_axi_arvalid),
    .m_axi_arready   (s00_axi_arready),
    .m_axi_arsize    (s00_axi_arsize),
    .m_axi_arburst   (s00_axi_arburst),
    .m_axi_arcache   (s00_axi_arcache),
    .m_axi_arlen     (s00_axi_arlen),
    .m_axi_arlock    (s00_axi_arlock),
    .m_axi_arqos     (s00_axi_arqos),
    .m_axi_arid      (s00_axi_arid),
    .m_axi_aruser    (s00_axi_aruser),
    /**************** Read Data Channel Signals ****************/
    .m_axi_rdata     (s00_axi_rdata),
    .m_axi_rresp     (s00_axi_rresp),
    .m_axi_rvalid    (s00_axi_rvalid),
    .m_axi_rready    (s00_axi_rready),
    .m_axi_rlast     (s00_axi_rlast),
    .m_axi_ruser     (s00_axi_ruser),
    .m_axi_rid       (s00_axi_rid),
    /**************** System Signals ****************/
    .aclk            (clk),
    .aresetn         (rstn),
    .done            (s_done[0]),
    .dummy           ('0) // Tie to zero externally (prevents logic trimming)
   );

  //**********************************************
  // Instantiate MASTER 1
  //**********************************************
  axi_switch_0_ref_example_axi4_master_1 #(
    .C_AXI_ID_WIDTH       (0),
    .C_AXI_ADDR_WIDTH     (32),
    .C_AXI_DATA_WIDTH     (32),
    .C_AXI_PROTOCOL       (0),
	.C_AXI_AWUSER_WIDTH   (0),
	.C_AXI_ARUSER_WIDTH   (0),
	.C_AXI_BUSER_WIDTH    (0),
	.C_SUPPORTS_NARROW    (1),
	.C_SUPPORTS_WRAP      (1),
    .C_AXI_SUPPORTS_WRITE (1),
	.C_AXI_SUPPORTS_READ  (1),
	.C_AXI_ADDR           (64'h0000000000000000))  // Base address
  axi_master_m01 (
    /**************** Write Address Channel Signals ****************/
    .m_axi_awaddr    (s01_axi_awaddr),
    .m_axi_awprot    (s01_axi_awprot),
    .m_axi_awvalid   (s01_axi_awvalid),
    .m_axi_awready   (s01_axi_awready),
    .m_axi_awsize    (s01_axi_awsize),
    .m_axi_awburst   (s01_axi_awburst),
    .m_axi_awcache   (s01_axi_awcache),
    .m_axi_awlen     (s01_axi_awlen),
    .m_axi_awlock    (s01_axi_awlock),
    .m_axi_awqos     (s01_axi_awqos),
    .m_axi_awid      (s01_axi_awid),
    .m_axi_awuser    (s01_axi_awuser),
    /**************** Write Data Channel Signals ****************/
    .m_axi_wid       (s01_axi_wid),
    .m_axi_wlast     (s01_axi_wlast),
    .m_axi_wuser     (s01_axi_wuser),
    .m_axi_wdata     (s01_axi_wdata),
    .m_axi_wstrb     (s01_axi_wstrb),
    .m_axi_wvalid    (s01_axi_wvalid),
    .m_axi_wready    (s01_axi_wready),
    /**************** Write Response Channel Signals ****************/
    .m_axi_bresp     (s01_axi_bresp),
    .m_axi_bvalid    (s01_axi_bvalid),
    .m_axi_bready    (s01_axi_bready),
    .m_axi_buser     (s01_axi_buser),
    .m_axi_bid       (s01_axi_bid),
    /**************** Read Address Channel Signals ****************/
    .m_axi_araddr    (s01_axi_araddr),
    .m_axi_arprot    (s01_axi_arprot),
    .m_axi_arvalid   (s01_axi_arvalid),
    .m_axi_arready   (s01_axi_arready),
    .m_axi_arsize    (s01_axi_arsize),
    .m_axi_arburst   (s01_axi_arburst),
    .m_axi_arcache   (s01_axi_arcache),
    .m_axi_arlen     (s01_axi_arlen),
    .m_axi_arlock    (s01_axi_arlock),
    .m_axi_arqos     (s01_axi_arqos),
    .m_axi_arid      (s01_axi_arid),
    .m_axi_aruser    (s01_axi_aruser),
    /**************** Read Data Channel Signals ****************/
    .m_axi_rdata     (s01_axi_rdata),
    .m_axi_rresp     (s01_axi_rresp),
    .m_axi_rvalid    (s01_axi_rvalid),
    .m_axi_rready    (s01_axi_rready),
    .m_axi_rlast     (s01_axi_rlast),
    .m_axi_ruser     (s01_axi_ruser),
    .m_axi_rid       (s01_axi_rid),
    /**************** System Signals ****************/
    .aclk            (clk),
    .aresetn         (rstn),
    .done            (s_done[1]),
    .dummy           ('0) // Tie to zero externally (prevents logic trimming)
   );


  //**********************************************
  // Instantiate DUT
  //**********************************************
  axi_switch_0_ref
  dut (
    .s00_axi_arburst,
    .s00_axi_arcache,
    .s00_axi_arlen,
    .s00_axi_arlock,
    .s00_axi_arqos,
    .s00_axi_arsize,
    .s00_axi_aruser,
    .s00_axi_rlast,
    .s00_axi_ruser,
    .s00_axi_arid,
    .s00_axi_rid,
    .s00_axi_araddr,
    .s00_axi_arprot,
    .s00_axi_arready,
    .s00_axi_arvalid,
    .s00_axi_rdata,
    .s00_axi_rready,
    .s00_axi_rresp,
    .s00_axi_rvalid,
    .s00_axi_awburst,
    .s00_axi_awcache,
    .s00_axi_awlen,
    .s00_axi_awlock,
    .s00_axi_awqos,
    .s00_axi_awsize,
    .s00_axi_awuser,
    .s00_axi_buser,
    .s00_axi_wlast,
    .s00_axi_wuser,
    .s00_axi_awid,
    .s00_axi_bid,
    .s00_axi_awaddr,
    .s00_axi_awprot,
    .s00_axi_awready,
    .s00_axi_awvalid,
    .s00_axi_bready,
    .s00_axi_bresp,
    .s00_axi_bvalid,
    .s00_axi_wdata,
    .s00_axi_wready,
    .s00_axi_wstrb,
    .s00_axi_wvalid,

    .s01_axi_arburst,
    .s01_axi_arcache,
    .s01_axi_arlen,
    .s01_axi_arlock,
    .s01_axi_arqos,
    .s01_axi_arsize,
    .s01_axi_aruser,
    .s01_axi_rlast,
    .s01_axi_ruser,
    .s01_axi_arid,
    .s01_axi_rid,
    .s01_axi_araddr,
    .s01_axi_arprot,
    .s01_axi_arready,
    .s01_axi_arvalid,
    .s01_axi_rdata,
    .s01_axi_rready,
    .s01_axi_rresp,
    .s01_axi_rvalid,
    .s01_axi_awburst,
    .s01_axi_awcache,
    .s01_axi_awlen,
    .s01_axi_awlock,
    .s01_axi_awqos,
    .s01_axi_awsize,
    .s01_axi_awuser,
    .s01_axi_buser,
    .s01_axi_wlast,
    .s01_axi_wuser,
    .s01_axi_awid,
    .s01_axi_bid,
    .s01_axi_awaddr,
    .s01_axi_awprot,
    .s01_axi_awready,
    .s01_axi_awvalid,
    .s01_axi_bready,
    .s01_axi_bresp,
    .s01_axi_bvalid,
    .s01_axi_wdata,
    .s01_axi_wready,
    .s01_axi_wstrb,
    .s01_axi_wvalid,

    .m00_axi_arburst,
    .m00_axi_arcache,
    .m00_axi_arlen,
    .m00_axi_arlock,
    .m00_axi_arqos,
    .m00_axi_arsize,
    .m00_axi_aruser,
    .m00_axi_rlast,
    .m00_axi_ruser,
    .m00_axi_arid,
    .m00_axi_rid,
    .m00_axi_araddr,
    .m00_axi_arprot,
    .m00_axi_arready,
    .m00_axi_arvalid,
    .m00_axi_rdata,
    .m00_axi_rready,
    .m00_axi_rresp,
    .m00_axi_rvalid,
    .m00_axi_awburst,
    .m00_axi_awcache,
    .m00_axi_awlen,
    .m00_axi_awlock,
    .m00_axi_awqos,
    .m00_axi_awsize,
    .m00_axi_awuser,
    .m00_axi_buser,
    .m00_axi_wlast,
    .m00_axi_wuser,
    .m00_axi_awid,
    .m00_axi_bid,
    .m00_axi_awaddr,
    .m00_axi_awprot,
    .m00_axi_awready,
    .m00_axi_awvalid,
    .m00_axi_bready,
    .m00_axi_bresp,
    .m00_axi_bvalid,
    .m00_axi_wdata,
    .m00_axi_wready,
    .m00_axi_wstrb,
    .m00_axi_wvalid,

    .m01_axi_arburst,
    .m01_axi_arcache,
    .m01_axi_arlen,
    .m01_axi_arlock,
    .m01_axi_arqos,
    .m01_axi_arsize,
    .m01_axi_aruser,
    .m01_axi_rlast,
    .m01_axi_ruser,
    .m01_axi_arid,
    .m01_axi_rid,
    .m01_axi_araddr,
    .m01_axi_arprot,
    .m01_axi_arready,
    .m01_axi_arvalid,
    .m01_axi_rdata,
    .m01_axi_rready,
    .m01_axi_rresp,
    .m01_axi_rvalid,
    .m01_axi_awburst,
    .m01_axi_awcache,
    .m01_axi_awlen,
    .m01_axi_awlock,
    .m01_axi_awqos,
    .m01_axi_awsize,
    .m01_axi_awuser,
    .m01_axi_buser,
    .m01_axi_wlast,
    .m01_axi_wuser,
    .m01_axi_awid,
    .m01_axi_bid,
    .m01_axi_awaddr,
    .m01_axi_awprot,
    .m01_axi_awready,
    .m01_axi_awvalid,
    .m01_axi_bready,
    .m01_axi_bresp,
    .m01_axi_bvalid,
    .m01_axi_wdata,
    .m01_axi_wready,
    .m01_axi_wstrb,
    .m01_axi_wvalid,

    .aclk               (clk),
    .aresetn            (sys_rstn),
    .aresetn_out        (rstn)
    );

  //**********************************************
  // Instantiate SLAVE 0
  //**********************************************
  axi_switch_0_ref_example_axi4_slave_0 #(
    .C_AXI_ADDR_WIDTH   (32),
    .C_AXI_DATA_WIDTH   (32),
    .C_AXI_PROTOCOL     (0),
    .C_AXI_AWUSER_WIDTH (0),
    .C_AXI_ARUSER_WIDTH (0),
    .C_AXI_BUSER_WIDTH  (0))
  axi_slave_s00 (
  /**************** Write Address Channel Signals ****************/
    .s_axi_awaddr   (m00_axi_awaddr),
    .s_axi_awprot   (m00_axi_awprot),
    .s_axi_awvalid  (m00_axi_awvalid),
    .s_axi_awready  (m00_axi_awready),
    .s_axi_awsize   (m00_axi_awsize),
    .s_axi_awburst  (m00_axi_awburst),
    .s_axi_awcache  (m00_axi_awcache),
    .s_axi_awlen    (m00_axi_awlen),
    .s_axi_awlock   (m00_axi_awlock),
    .s_axi_awqos    (m00_axi_awqos),
    .s_axi_awid     (m00_axi_awid),
    .s_axi_awuser   (m00_axi_awuser),
  /**************** Write Data Channel Signals ****************/
    .s_axi_wdata    (m00_axi_wdata),
    .s_axi_wstrb    (m00_axi_wstrb),
    .s_axi_wvalid   (m00_axi_wvalid),
    .s_axi_wready   (m00_axi_wready),
    .s_axi_wlast    (m00_axi_wlast),
    .s_axi_wuser    (m00_axi_wuser),
  /**************** Write Response Channel Signals ****************/
    .s_axi_bresp    (m00_axi_bresp),
    .s_axi_bvalid   (m00_axi_bvalid),
    .s_axi_bready   (m00_axi_bready),
    .s_axi_buser    (m00_axi_buser),
    .s_axi_bid      (m00_axi_bid),
    .s_axi_wid      (m00_axi_wid),
  /**************** Read Address Channel Signals ****************/
    .s_axi_araddr   (m00_axi_araddr),
    .s_axi_arprot   (m00_axi_arprot),
    .s_axi_arvalid  (m00_axi_arvalid),
    .s_axi_arready  (m00_axi_arready),
    .s_axi_arsize   (m00_axi_arsize),
    .s_axi_arburst  (m00_axi_arburst),
    .s_axi_arcache  (m00_axi_arcache),
    .s_axi_arlock   (m00_axi_arlock),
    .s_axi_arlen    (m00_axi_arlen),
    .s_axi_arqos    (m00_axi_arqos),
    .s_axi_aruser   (m00_axi_aruser),
    .s_axi_arid     (m00_axi_arid),
    /**************** Read Data Channel Signals ****************/
    .s_axi_rdata    (m00_axi_rdata),
    .s_axi_rresp    (m00_axi_rresp),
    .s_axi_rvalid   (m00_axi_rvalid),
    .s_axi_rready   (m00_axi_rready),
    .s_axi_rlast    (m00_axi_rlast),
    .s_axi_ruser    (m00_axi_ruser),
    .s_axi_rid      (m00_axi_rid),
  /**************** System Signals ****************/
    .aclk            (clk),
    .aresetn         (rstn)
   );


  //**********************************************
  // Instantiate SLAVE 1
  //**********************************************
  axi_switch_0_ref_example_axi4_slave_1 #(
    .C_AXI_ADDR_WIDTH   (32),
    .C_AXI_DATA_WIDTH   (32),
    .C_AXI_PROTOCOL     (0),
    .C_AXI_AWUSER_WIDTH (0),
    .C_AXI_ARUSER_WIDTH (0),
    .C_AXI_BUSER_WIDTH  (0))
  axi_slave_s01 (
  /**************** Write Address Channel Signals ****************/
    .s_axi_awaddr   (m01_axi_awaddr),
    .s_axi_awprot   (m01_axi_awprot),
    .s_axi_awvalid  (m01_axi_awvalid),
    .s_axi_awready  (m01_axi_awready),
    .s_axi_awsize   (m01_axi_awsize),
    .s_axi_awburst  (m01_axi_awburst),
    .s_axi_awcache  (m01_axi_awcache),
    .s_axi_awlen    (m01_axi_awlen),
    .s_axi_awlock   (m01_axi_awlock),
    .s_axi_awqos    (m01_axi_awqos),
    .s_axi_awid     (m01_axi_awid),
    .s_axi_awuser   (m01_axi_awuser),
  /**************** Write Data Channel Signals ****************/
    .s_axi_wdata    (m01_axi_wdata),
    .s_axi_wstrb    (m01_axi_wstrb),
    .s_axi_wvalid   (m01_axi_wvalid),
    .s_axi_wready   (m01_axi_wready),
    .s_axi_wlast    (m01_axi_wlast),
    .s_axi_wuser    (m01_axi_wuser),
  /**************** Write Response Channel Signals ****************/
    .s_axi_bresp    (m01_axi_bresp),
    .s_axi_bvalid   (m01_axi_bvalid),
    .s_axi_bready   (m01_axi_bready),
    .s_axi_buser    (m01_axi_buser),
    .s_axi_bid      (m01_axi_bid),
    .s_axi_wid      (m01_axi_wid),
  /**************** Read Address Channel Signals ****************/
    .s_axi_araddr   (m01_axi_araddr),
    .s_axi_arprot   (m01_axi_arprot),
    .s_axi_arvalid  (m01_axi_arvalid),
    .s_axi_arready  (m01_axi_arready),
    .s_axi_arsize   (m01_axi_arsize),
    .s_axi_arburst  (m01_axi_arburst),
    .s_axi_arcache  (m01_axi_arcache),
    .s_axi_arlock   (m01_axi_arlock),
    .s_axi_arlen    (m01_axi_arlen),
    .s_axi_arqos    (m01_axi_arqos),
    .s_axi_aruser   (m01_axi_aruser),
    .s_axi_arid     (m01_axi_arid),
    /**************** Read Data Channel Signals ****************/
    .s_axi_rdata    (m01_axi_rdata),
    .s_axi_rresp    (m01_axi_rresp),
    .s_axi_rvalid   (m01_axi_rvalid),
    .s_axi_rready   (m01_axi_rready),
    .s_axi_rlast    (m01_axi_rlast),
    .s_axi_ruser    (m01_axi_ruser),
    .s_axi_rid      (m01_axi_rid),
  /**************** System Signals ****************/
    .aclk            (clk),
    .aresetn         (rstn)
   );



endmodule

`default_nettype wire

