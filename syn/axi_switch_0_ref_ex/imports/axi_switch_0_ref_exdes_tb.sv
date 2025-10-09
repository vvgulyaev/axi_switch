// -----------------------------------------------------------------------------
// (c) Copyright 2013 Advanced Micro Devices, Inc. All rights reserved.                
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

module exdes_tb;

  /**************** Local Parameters ****************/
  localparam CLK_PERIOD = 5000; //ps
  localparam RESET_PULSE = 5000; // cycles
  localparam TIMEOUT = 120000; // cycles

  //**********************************************
  // Signals
  //**********************************************
  reg                                  clk_p;
  reg                                  clk_n;
  reg                                  sys_rstn;

  wire                                           m00_awvalid;
  wire                                           m00_awready;
  wire [32-1:0]  m00_awaddr;
  wire                                           m00_wvalid;
  wire                                           m00_wready;
  wire [32-1:0]  m00_wdata;
  wire                                           m00_bvalid;
  wire                                           m00_bready;
  wire [1:0]                                    m00_bresp;
  wire                                         m00_wlast;
  wire                                           m00_arvalid;
  wire                                           m00_arready;
  wire [32-1:0]  m00_araddr;
  wire                                           m00_rvalid;
  wire                                           m00_rready;
  wire [32-1:0]  m00_rdata;
  wire                                         m00_rlast;

  wire                                           m01_awvalid;
  wire                                           m01_awready;
  wire [32-1:0]  m01_awaddr;
  wire                                           m01_wvalid;
  wire                                           m01_wready;
  wire [32-1:0]  m01_wdata;
  wire                                           m01_bvalid;
  wire                                           m01_bready;
  wire [1:0]                                    m01_bresp;
  wire                                         m01_wlast;
  wire                                           m01_arvalid;
  wire                                           m01_arready;
  wire [32-1:0]  m01_araddr;
  wire                                           m01_rvalid;
  wire                                           m01_rready;
  wire [32-1:0]  m01_rdata;
  wire                                         m01_rlast;

  wire                                           s00_awvalid;
  wire                                           s00_awready;
  wire [32-1:0]  s00_awaddr;
  wire                                           s00_wvalid;
  wire                                           s00_wready;
  wire [32-1:0]  s00_wdata;
  wire                                           s00_bvalid;
  wire                                           s00_bready;
  wire [1:0]                                    s00_bresp;
  wire                                         s00_wlast;
  wire                                           s00_arvalid;
  wire                                           s00_arready;
  wire [32-1:0]  s00_araddr;
  wire                                           s00_rvalid;
  wire                                           s00_rready;
  wire [32-1:0]  s00_rdata;
  wire                                         s00_rlast;

  wire                                           s01_awvalid;
  wire                                           s01_awready;
  wire [32-1:0]  s01_awaddr;
  wire                                           s01_wvalid;
  wire                                           s01_wready;
  wire [32-1:0]  s01_wdata;
  wire                                           s01_bvalid;
  wire                                           s01_bready;
  wire [1:0]                                    s01_bresp;
  wire                                         s01_wlast;
  wire                                           s01_arvalid;
  wire                                           s01_arready;
  wire [32-1:0]  s01_araddr;
  wire                                           s01_rvalid;
  wire                                           s01_rready;
  wire [32-1:0]  s01_rdata;
  wire                                         s01_rlast;

  wire                                 clk;
  wire                                 rstn;
  wire                                 done;

  /**************** Simulation Variables ****************/
  // Generate clock
  initial begin
    clk_p = 1'b1;
    clk_n = 1'b0;
    forever #(CLK_PERIOD / 2) begin
      clk_p = ~clk_p;
      clk_n = ~clk_n;
    end
  end

  // Generate reset
  initial begin
    $display("%t: %m: Starting testbench", $time);
    $monitor("%t: %m: System reset detected: %0d", $time, sys_rstn);
    sys_rstn = 1'b0;
    #(CLK_PERIOD * RESET_PULSE) sys_rstn = 1'b1;
  end

  //**********************************************
  // Instantiate Example Design
  //**********************************************
  axi_switch_0_ref_example_design
  exdes_top
  (
  .clk_p(clk_p),
  .clk_n(clk_n),
  .sys_rstn(sys_rstn),
  .done(done)
  );

  // Monitor end of simulation
  always @(posedge clk_p) begin
    if (done) begin
      $display("%t: %m: SIMULATION PASSED", $time);
      $display("%t: %m: Test Completed Successfully", $time);
      $stop;
    end
  end

  // Generate simulation error
  initial begin
    #(CLK_PERIOD * TIMEOUT) $display("%t: %m: Error: - Test timed out.", $time);
    $stop;
  end


  assign clk         = exdes_top.clk;
  assign rstn        = exdes_top.rstn;
  assign m00_awvalid = exdes_top.m00_axi_awvalid;
  assign m00_awready = exdes_top.m00_axi_awready;
  assign m00_awaddr  = exdes_top.m00_axi_awaddr;
  assign m00_wvalid  = exdes_top.m00_axi_wvalid;
  assign m00_wready  = exdes_top.m00_axi_wready;
  assign m00_wdata   = exdes_top.m00_axi_wdata;
  assign m00_bvalid  = exdes_top.m00_axi_bvalid;
  assign m00_bready  = exdes_top.m00_axi_bready;
  assign m00_bresp   = exdes_top.m00_axi_bresp;
  assign m00_wlast   = exdes_top.m00_axi_wlast;
  assign m00_arvalid = exdes_top.m00_axi_arvalid;
  assign m00_arready = exdes_top.m00_axi_arready;
  assign m00_araddr  = exdes_top.m00_axi_araddr;
  assign m00_rvalid  = exdes_top.m00_axi_rvalid;
  assign m00_rready  = exdes_top.m00_axi_rready;
  assign m00_rdata   = exdes_top.m00_axi_rdata;
  assign m00_rlast   = exdes_top.m00_axi_rlast;

  assign m01_awvalid = exdes_top.m01_axi_awvalid;
  assign m01_awready = exdes_top.m01_axi_awready;
  assign m01_awaddr  = exdes_top.m01_axi_awaddr;
  assign m01_wvalid  = exdes_top.m01_axi_wvalid;
  assign m01_wready  = exdes_top.m01_axi_wready;
  assign m01_wdata   = exdes_top.m01_axi_wdata;
  assign m01_bvalid  = exdes_top.m01_axi_bvalid;
  assign m01_bready  = exdes_top.m01_axi_bready;
  assign m01_bresp   = exdes_top.m01_axi_bresp;
  assign m01_wlast   = exdes_top.m01_axi_wlast;
  assign m01_arvalid = exdes_top.m01_axi_arvalid;
  assign m01_arready = exdes_top.m01_axi_arready;
  assign m01_araddr  = exdes_top.m01_axi_araddr;
  assign m01_rvalid  = exdes_top.m01_axi_rvalid;
  assign m01_rready  = exdes_top.m01_axi_rready;
  assign m01_rdata   = exdes_top.m01_axi_rdata;
  assign m01_rlast   = exdes_top.m01_axi_rlast;

  assign s00_awvalid = exdes_top.s00_axi_awvalid;
  assign s00_awready = exdes_top.s00_axi_awready;
  assign s00_awaddr  = exdes_top.s00_axi_awaddr;
  assign s00_wvalid  = exdes_top.s00_axi_wvalid;
  assign s00_wready  = exdes_top.s00_axi_wready;
  assign s00_wdata   = exdes_top.s00_axi_wdata;
  assign s00_bvalid  = exdes_top.s00_axi_bvalid;
  assign s00_bready  = exdes_top.s00_axi_bready;
  assign s00_bresp   = exdes_top.s00_axi_bresp;
  assign s00_wlast   = exdes_top.s00_axi_wlast;
  assign s00_arvalid = exdes_top.s00_axi_arvalid;
  assign s00_arready = exdes_top.s00_axi_arready;
  assign s00_araddr  = exdes_top.s00_axi_araddr;
  assign s00_rvalid  = exdes_top.s00_axi_rvalid;
  assign s00_rready  = exdes_top.s00_axi_rready;
  assign s00_rdata   = exdes_top.s00_axi_rdata;
  assign s00_rlast   = exdes_top.s00_axi_rlast;

  assign s01_awvalid = exdes_top.s01_axi_awvalid;
  assign s01_awready = exdes_top.s01_axi_awready;
  assign s01_awaddr  = exdes_top.s01_axi_awaddr;
  assign s01_wvalid  = exdes_top.s01_axi_wvalid;
  assign s01_wready  = exdes_top.s01_axi_wready;
  assign s01_wdata   = exdes_top.s01_axi_wdata;
  assign s01_bvalid  = exdes_top.s01_axi_bvalid;
  assign s01_bready  = exdes_top.s01_axi_bready;
  assign s01_bresp   = exdes_top.s01_axi_bresp;
  assign s01_wlast   = exdes_top.s01_axi_wlast;
  assign s01_arvalid = exdes_top.s01_axi_arvalid;
  assign s01_arready = exdes_top.s01_axi_arready;
  assign s01_araddr  = exdes_top.s01_axi_araddr;
  assign s01_rvalid  = exdes_top.s01_axi_rvalid;
  assign s01_rready  = exdes_top.s01_axi_rready;
  assign s01_rdata   = exdes_top.s01_axi_rdata;
  assign s01_rlast   = exdes_top.s01_axi_rlast;

endmodule

`default_nettype wire

