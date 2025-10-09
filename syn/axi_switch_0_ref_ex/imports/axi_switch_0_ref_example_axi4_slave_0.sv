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

`timescale 1ns/1ns

`default_nettype none

module
axi_switch_0_ref_example_axi4_slave_0 #(
  parameter integer C_AXI_ID_WIDTH = 0,
  parameter integer C_AXI_ADDR_WIDTH = 32,
  parameter integer C_AXI_DATA_WIDTH = 32,
  parameter integer C_AXI_PROTOCOL = 0,
  parameter integer C_AXI_AWUSER_WIDTH = 0,
  parameter integer C_AXI_ARUSER_WIDTH = 0,
  parameter integer C_AXI_BUSER_WIDTH = 0)
(
  /**************** Write Address Channel Signals ****************/
  input  wire [C_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr,
  input  wire [3-1:0]                   s_axi_awprot,
  input  wire                           s_axi_awvalid,
  output wire                            s_axi_awready,
  input  wire [3-1:0]                   s_axi_awsize,
  input  wire [2-1:0]                   s_axi_awburst,
  input  wire [4-1:0]                   s_axi_awcache,
  input  wire [((C_AXI_PROTOCOL == 1) ? 4 : 8)-1:0]      s_axi_awlen,
  input  wire [((C_AXI_PROTOCOL == 1) ? 2 : 1)-1:0]     s_axi_awlock,
  input  wire [4-1:0]                   s_axi_awqos,
  input  wire [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]       s_axi_awid,
  input  wire [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]       s_axi_wid,
  input  wire [(C_AXI_AWUSER_WIDTH==0?1:C_AXI_AWUSER_WIDTH)-1:0] s_axi_awuser,
  /**************** Write Data Channel Signals ****************/
  input  wire [C_AXI_DATA_WIDTH-1:0]     s_axi_wdata,
  input  wire [C_AXI_DATA_WIDTH/8-1:0]   s_axi_wstrb,
  input  wire                           s_axi_wvalid,
  output wire                            s_axi_wready,
  input  wire                           s_axi_wlast,
  input  wire [1-1:0]    s_axi_wuser,
  /**************** Write Response Channel Signals ****************/
  output reg [2-1:0]                    s_axi_bresp = 2'b0,
  output wire                            s_axi_bvalid,
  input  wire                           s_axi_bready,
  output wire [(C_AXI_BUSER_WIDTH==0?1:C_AXI_BUSER_WIDTH)-1:0]    s_axi_buser,
  output wire [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]        s_axi_bid,
  /**************** Read Address Channel Signals ****************/
  input  wire [C_AXI_ADDR_WIDTH-1:0]     s_axi_araddr,
  input  wire [3-1:0]                   s_axi_arprot,
  input  wire                           s_axi_arvalid,
  output wire                            s_axi_arready,
  input  wire [3-1:0]                   s_axi_arsize,
  input  wire [2-1:0]                   s_axi_arburst,
  input  wire [4-1:0]                   s_axi_arcache,
  input  wire [((C_AXI_PROTOCOL == 1) ? 2 : 1)-1:0]     s_axi_arlock,
  input  wire [((C_AXI_PROTOCOL == 1) ? 4 : 8)-1:0]      s_axi_arlen,
  input  wire [4-1:0]                   s_axi_arqos,
  input  wire [(C_AXI_ARUSER_WIDTH==0?1:C_AXI_ARUSER_WIDTH)-1:0]   s_axi_aruser,
  input  wire [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]       s_axi_arid,
  /**************** Read Data Channel Signals ****************/
  output wire [C_AXI_DATA_WIDTH-1:0]     s_axi_rdata,
  output reg [2-1:0]                    s_axi_rresp = 2'b0,
  output wire                            s_axi_rvalid,
  input  wire                           s_axi_rready,
  output wire                            s_axi_rlast,
  output wire [1-1:0]    s_axi_ruser,
  output wire [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]        s_axi_rid,
  /**************** System Signals ****************/
  input  wire                           aclk,
  input  wire                           aresetn
   );


  /**************** Local Parameters ****************/
  localparam integer  P_LEN_WIDTH = (C_AXI_PROTOCOL == 1) ? 4 : 8;
  localparam integer  P_LOCK_WIDTH = (C_AXI_PROTOCOL == 1) ? 2 : 1;
  localparam integer P_S_AXI_DATA_BYTES = 32/8;
  localparam integer P_ID_WIDTH = C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH;

  /**************** Internal Wires/Regs - Global ****************/
  reg                   areset = 1'b0;
  always @(posedge aclk) begin
      areset <= ~aresetn;
  end


    /**************** Internal Wires/Regs - Read Channels ****************/
    reg [8-1:0]                   xfer_r_cnt = 8'h00;
    reg [8-1:0]                   rlast_cnt = 8'h00;
    reg [16-1:0]                  arcnt_i = 16'h0000;
    reg [16-1:0]                  rcnt_i = 16'h0000;
    wire                          rlast_xfer;
    wire                          ar_xfer;
    wire                          r_valid;
    reg [C_AXI_DATA_WIDTH-1:0]     rdata_i = {C_AXI_DATA_WIDTH{1'b0}};
    reg [P_LEN_WIDTH-1:0]      arlen_i = {P_LEN_WIDTH{1'b0}};
    wire [P_LEN_WIDTH-1:0]      rlen;
    reg                           arvalid_i = 1'b0;
    reg [C_AXI_ADDR_WIDTH-1:0]     araddr_i = {C_AXI_ADDR_WIDTH{1'b0}};
    reg [3-1:0]                   arprot_i = 3'b000;
    reg [3-1:0]                   arsize_i = 3'b000;
    reg [2-1:0]                   arburst_i = 2'b00;
    reg [4-1:0]                   arcache_i = 4'b0000;
    reg [((C_AXI_PROTOCOL == 1) ? 2 : 1)-1:0] arlock_i    = 'b0;
    wire [8-1:0]                   axi_arlen_i;
    reg [4-1:0]                   arqos_i = 4'b0000;
    reg [C_AXI_ARUSER_WIDTH:0]    aruser_i = {(C_AXI_ARUSER_WIDTH+1){1'b0}};
    reg [1:0]      ruser_i = {(1+1){1'b0}};
    reg [7:0]                     acc_ar_i = 8'b0;
    reg                            s_axi_rvalid_i = 1'b0;
    wire                           s_axi_arready_i;
    reg                            s_axi_rlast_i = 1'b0;
    reg [P_ID_WIDTH-1:0]          s_axi_rid_i = 0;
    wire r_pop;
    wire ar_push;
    wire [P_ID_WIDTH-1:0] rid;
    wire [P_ID_WIDTH-1:0] bid = 0;
    wire s_arlen_ready;
    wire s_arid_ready;

    /**************** Assign Read Channel Outputs ****************/
    assign s_axi_rdata = rdata_i;
    assign rlast_xfer = (s_axi_rready & s_axi_rvalid_i & s_axi_rlast_i);
    assign s_axi_rvalid = s_axi_rvalid_i;
    assign s_axi_arready = s_axi_arready_i;
    assign s_axi_rlast = s_axi_rlast_i;
    assign ar_xfer = s_axi_arready_i & s_axi_arvalid;
    assign ar_push = ar_xfer;
    assign r_pop = rlast_xfer | ~s_axi_rvalid_i;
    assign s_axi_rid = s_axi_rid_i;
    assign s_axi_ruser = ruser_i;
    assign s_axi_arready_i = s_arlen_ready & s_arid_ready;
    //**********************************************
    // Read Channel: ARREADY, RVALID, RLAST, RID
    //**********************************************
    always @(posedge aclk) begin
      if(areset) begin
        // s_axi_arready_i <= 1'b0;
        s_axi_rvalid_i <= 1'b0;
        xfer_r_cnt <= 8'h00;
        rlast_cnt <= 8'h00;
        arcnt_i <= 16'h0000;
        rcnt_i <= 16'h0000;
        arlen_i <= {P_LEN_WIDTH{1'b0}};
        s_axi_rlast_i <= 1'b0;
      end else begin
        // s_axi_arready_i <= 1'b1;
        if (ar_xfer) begin
          arcnt_i <= arcnt_i + 1;
        end
        if (ar_xfer & ~rlast_xfer) begin
          rcnt_i <= rcnt_i + 1'b1;
        end else if (~ar_xfer & rlast_xfer) begin
          rcnt_i <= rcnt_i - 1'b1;
        end
        if (s_axi_rvalid_i) begin
          if (s_axi_rready) begin
            if (s_axi_rlast_i) begin
              rlast_cnt <= rlast_cnt + 1;
              if (r_valid) begin
                xfer_r_cnt <= rlen;
                s_axi_rlast_i <= (rlen==0);
                s_axi_rid_i <= rid;
              end else begin
                s_axi_rvalid_i <= 1'b0;
              end
            end else if (xfer_r_cnt == 1) begin
              s_axi_rlast_i <= 1'b1;
              xfer_r_cnt <= 8'h00;
            end else begin
              xfer_r_cnt <= xfer_r_cnt - 1;
            end
          end
        end else if (r_valid) begin
          s_axi_rvalid_i <= 1'b1;
          xfer_r_cnt <= rlen;
          s_axi_rlast_i <= (rlen==0);
          s_axi_rid_i <= rid;
        end
      end
    end

    //**********************************************
    // Read Channel: RDATA
    //**********************************************
    always @(posedge aclk) begin
      if(areset) begin
        rdata_i <= C_AXI_DATA_WIDTH'(
         {16'hA01F, rlast_cnt, xfer_r_cnt,
          16'hA01E, rlast_cnt, xfer_r_cnt,
          16'hA01D, rlast_cnt, xfer_r_cnt,
          16'hA01C, rlast_cnt, xfer_r_cnt,
          16'hA01B, rlast_cnt, xfer_r_cnt,
          16'hA01A, rlast_cnt, xfer_r_cnt,
          16'hA019, rlast_cnt, xfer_r_cnt,
          16'hA018, rlast_cnt, xfer_r_cnt,
          16'hA017, rlast_cnt, xfer_r_cnt,
          16'hA016, rlast_cnt, xfer_r_cnt,
          16'hA015, rlast_cnt, xfer_r_cnt,
          16'hA014, rlast_cnt, xfer_r_cnt,
          16'hA013, rlast_cnt, xfer_r_cnt,
          16'hA012, rlast_cnt, xfer_r_cnt,
          16'hA011, rlast_cnt, xfer_r_cnt,
          16'hA010, rlast_cnt, xfer_r_cnt,
          16'hA00F, rlast_cnt, xfer_r_cnt,
          16'hA00E, rlast_cnt, xfer_r_cnt,
          16'hA00D, rlast_cnt, xfer_r_cnt,
          16'hA00C, rlast_cnt, xfer_r_cnt,
          16'hA00B, rlast_cnt, xfer_r_cnt,
          16'hA00A, rlast_cnt, xfer_r_cnt,
          16'hA009, rlast_cnt, xfer_r_cnt,
          16'hA008, rlast_cnt, xfer_r_cnt,
          16'hA007, rlast_cnt, xfer_r_cnt,
          16'hA006, rlast_cnt, xfer_r_cnt,
          16'hA005, rlast_cnt, xfer_r_cnt,
          16'hA004, rlast_cnt, xfer_r_cnt,
          16'hA003, rlast_cnt, xfer_r_cnt,
          16'hA002, rlast_cnt, xfer_r_cnt,
          16'hA001, rlast_cnt, xfer_r_cnt,
          16'hA000, rlast_cnt, xfer_r_cnt});

      end else begin
        rdata_i <= (s_axi_rready && s_axi_rvalid_i) ?
         C_AXI_DATA_WIDTH'({16'hA01F, rlast_cnt, ~xfer_r_cnt,
          16'hA01E, rlast_cnt, ~xfer_r_cnt,
          16'hA01D, rlast_cnt, ~xfer_r_cnt,
          16'hA01C, rlast_cnt, ~xfer_r_cnt,
          16'hA01B, rlast_cnt, ~xfer_r_cnt,
          16'hA01A, rlast_cnt, ~xfer_r_cnt,
          16'hA019, rlast_cnt, ~xfer_r_cnt,
          16'hA018, rlast_cnt, ~xfer_r_cnt,
          16'hA017, rlast_cnt, ~xfer_r_cnt,
          16'hA016, rlast_cnt, ~xfer_r_cnt,
          16'hA015, rlast_cnt, ~xfer_r_cnt,
          16'hA014, rlast_cnt, ~xfer_r_cnt,
          16'hA013, rlast_cnt, ~xfer_r_cnt,
          16'hA012, rlast_cnt, ~xfer_r_cnt,
          16'hA011, rlast_cnt, ~xfer_r_cnt,
          16'hA010, rlast_cnt, ~xfer_r_cnt,
          16'hA00F, rlast_cnt, ~xfer_r_cnt,
          16'hA00E, rlast_cnt, ~xfer_r_cnt,
          16'hA00D, rlast_cnt, ~xfer_r_cnt,
          16'hA00C, rlast_cnt, ~xfer_r_cnt,
          16'hA00B, rlast_cnt, ~xfer_r_cnt,
          16'hA00A, rlast_cnt, ~xfer_r_cnt,
          16'hA009, rlast_cnt, ~xfer_r_cnt,
          16'hA008, rlast_cnt, ~xfer_r_cnt,
          16'hA007, rlast_cnt, ~xfer_r_cnt,
          16'hA006, rlast_cnt, ~xfer_r_cnt,
          16'hA005, rlast_cnt, ~xfer_r_cnt,
          16'hA004, rlast_cnt, ~xfer_r_cnt,
          16'hA003, rlast_cnt, ~xfer_r_cnt,
          16'hA002, rlast_cnt, ~xfer_r_cnt,
          16'hA001, rlast_cnt, ~xfer_r_cnt,
          16'hA000, rlast_cnt, ~xfer_r_cnt})
          : rdata_i;
      end
    end


    //**********************************************
    // Read Channel: RRESP
    //**********************************************
    always @(posedge aclk) begin
      if(areset) begin
        s_axi_rresp <= {2{1'b0}};
      end else if (~s_axi_rvalid_i) begin
        s_axi_rresp <= {acc_ar_i[0], 1'b0};
      end
    end

    //**********************************************
    // Read Channel: RUSER
    //**********************************************
    always @(posedge aclk) begin
      if (areset) begin
        ruser_i <= 512'hf0030201e0030201d0030201c0030201b0030201a003020190030201800302017003020160030201500302014003020130030201200302011003020100030201;
      end else begin
        if (s_axi_rready & s_axi_rvalid_i) begin
          ruser_i <= ruser_i + 512'h00010101000101010001010100010101000101010001010100010101000101010001010100010101000101010001010100010101000101010001010100010101;
        end
      end
    end

    //**********************************************
    // Read Channel: PROCESS INPUTS
    //**********************************************
    always @(posedge aclk) begin
      if(areset) begin
        araddr_i <= {C_AXI_ADDR_WIDTH{1'b0}};
        arprot_i <= {3{1'b0}};
        arsize_i <= {3{1'b0}};
        arburst_i <= {2{1'b0}};
        arcache_i <= {4{1'b0}};
        arlock_i <= {1{1'b0}};
        arqos_i <= {4{1'b0}};
        aruser_i <= {(C_AXI_ARUSER_WIDTH+1){1'b0}};
        acc_ar_i <= 8'b0;
      end else if (s_axi_arvalid) begin
        // Register Inputs
        araddr_i <= s_axi_araddr;
          acc_ar_i[0] <= araddr_i[0];
        arprot_i <= s_axi_arprot;
          acc_ar_i[1] <= arprot_i[0];
        arsize_i <= s_axi_arsize;
          acc_ar_i[2] <= arsize_i[0];
        arburst_i <= s_axi_arburst;
          acc_ar_i[3] <= arburst_i[0];
        arcache_i <= s_axi_arcache;
          acc_ar_i[4] <= arcache_i[0];
        arlock_i <= s_axi_arlock;
          acc_ar_i[5] <= arlock_i[0];
        arqos_i <= s_axi_arqos;
          acc_ar_i[6] <= arqos_i[0];
        aruser_i <= s_axi_aruser;
          acc_ar_i[7] <= aruser_i[0];
      end else begin
        araddr_i <= araddr_i>>1;
        arprot_i <= arprot_i>>1;
        arsize_i <= arsize_i>>1;
        arburst_i <= arburst_i>>1;
        arcache_i <= arcache_i>>1;
        arlock_i <= arlock_i>>1;
        arqos_i <= arqos_i>>1;
        aruser_i <= aruser_i>>1;
        acc_ar_i <= acc_ar_i>>1;
      end
    end


    /**************** Internal Wires/Regs - Write Channels ****************/
    wire                          wlast_xfer;
    wire                          aw_xfer;
    wire                          b_xfer;
    wire                          b_valid;
    reg [16-1:0]                  awcnt_i = 16'h0000;
    reg [16-1:0]                  bcnt_i = 16'h0000;
    reg                            awvalid_i = 1'b0;
    reg [C_AXI_ADDR_WIDTH-1:0]    awaddr_i = {C_AXI_ADDR_WIDTH{1'b0}};
    reg [3-1:0]                   awprot_i = 3'b000;
    reg [3-1:0]                   awsize_i = 3'b000;
    reg [2-1:0]                   awburst_i = 2'b00;
    reg [4-1:0]                   awcache_i = 4'b0000;
    reg [P_LEN_WIDTH-1:0]         awlen_i = {P_LEN_WIDTH{1'b0}};
    reg [((C_AXI_PROTOCOL == 1) ? 2 : 1)-1:0] awlock_i = 'b0;
    reg [4-1:0]                   awqos_i = 4'b0000;
    reg [C_AXI_AWUSER_WIDTH:0]    awuser_i = {(C_AXI_AWUSER_WIDTH+1){1'b0}};
    reg [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]       awid_i;
    reg [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]       wid_i;
    reg                           wvalid_i = 1'b0;
    reg [C_AXI_DATA_WIDTH-1:0]     wdata_i = {C_AXI_DATA_WIDTH{1'b0}};
    reg [C_AXI_DATA_WIDTH/8-1:0]   wstrb_i = {(C_AXI_DATA_WIDTH/8){1'b0}};
    reg [1:0]     wuser_i = {(1+1){1'b0}};
    reg [C_AXI_BUSER_WIDTH:0]     buser_i = {(C_AXI_BUSER_WIDTH+1){1'b0}};
    reg [8:0]                     acc_aw_i = 9'b0;
    reg [3:0]                     acc_w_i = 4'b0;
    reg                           s_axi_bvalid_i = 1'b0;
    reg                           s_axi_awready_i = 1'b0;
    wire                          s_axi_wready_i;
    reg [7:0]                    s_axi_bid_int;
    reg [7:0]                    rid_int;
    /**************** Assign Write Channel Outputs ****************/
    assign wlast_xfer = s_axi_wready_i & s_axi_wvalid & ((C_AXI_PROTOCOL == 2) ? 1'b1 : s_axi_wlast);
    assign s_axi_bvalid = s_axi_bvalid_i;
    assign s_axi_awready = s_axi_awready_i;
    assign s_axi_wready = s_axi_wready_i;
    assign aw_xfer = s_axi_awready_i & s_axi_awvalid;
    assign b_xfer = s_axi_bready & s_axi_bvalid_i;
    assign s_axi_buser = buser_i;
    assign s_axi_bid = s_axi_bid_int[0];
    assign rid = rid_int[0];

    //**********************************************
    // Write Channel: AWREADY, WREADY, BVALID, BID
    //**********************************************
    always @(posedge aclk) begin
      if (areset) begin
        awcnt_i <= 16'h0000;
        bcnt_i <= 16'h0000;
        s_axi_awready_i <= 1'b0;
        // s_axi_wready_i <= 1'b0;
        s_axi_bvalid_i <= 1'b0;
      end else begin
        s_axi_awready_i <= 1'b1;
        // s_axi_wready_i <= 1'b1;
        if (aw_xfer) begin
          awcnt_i <= awcnt_i + 1'b1;
        end
        if (wlast_xfer & ~b_xfer) begin
          bcnt_i <= bcnt_i + 1'b1;
        end else if (~wlast_xfer & b_xfer) begin
          bcnt_i <= bcnt_i - 1'b1;
        end
        if (b_xfer) begin
          s_axi_bvalid_i <= 1'b0;
        end else begin
          s_axi_bvalid_i <= b_valid;
        end
      end
    end


    //**********************************************
    // B Channel
    //**********************************************
    always @(posedge aclk) begin
      if(areset) begin
        s_axi_bresp <= {2{1'b0}};
        buser_i <= 512'hf0030201e0030201d0030201c0030201b0030201a003020190030201800302017003020160030201500302014003020130030201200302011003020100030201;
      end else if (b_xfer) begin
        s_axi_bresp <= {(acc_aw_i[0] ^ acc_w_i[0]), 1'b0};
        buser_i <= buser_i + 512'h00010101000101010001010100010101000101010001010100010101000101010001010100010101000101010001010100010101000101010001010100010101;
      end
    end

    //**********************************************
    // Write Address Channel: PROCESS INPUTS
    //**********************************************
    always @(posedge aclk) begin
      if (areset) begin
        awaddr_i <= {C_AXI_ADDR_WIDTH{1'b0}};
        awprot_i <= {3{1'b0}};
        awsize_i <= {3{1'b0}};
        awburst_i <= {2{1'b0}};
        awcache_i <= {4{1'b0}};
        awlen_i <= {P_LEN_WIDTH{1'b0}};
        awlock_i <= 'b0;
        awqos_i <= {4{1'b0}};
        awuser_i <= {(C_AXI_AWUSER_WIDTH+1){1'b0}};
        acc_aw_i <= 9'b0;
      end else if (s_axi_awvalid) begin
        // Register Inputs
        awaddr_i <= s_axi_awaddr;
          acc_aw_i[0] <= awaddr_i[0];
        awprot_i <= s_axi_awprot;
          acc_aw_i[1] <= awprot_i[0];
        awsize_i <= s_axi_awsize;
          acc_aw_i[2] <= awsize_i[0];
        awburst_i <= s_axi_awburst;
          acc_aw_i[3] <= awburst_i[0];
        awcache_i <= s_axi_awcache;
          acc_aw_i[4] <= awcache_i[0];
        awlock_i <= s_axi_awlock;
          acc_aw_i[5] <= awlock_i[0];
        awqos_i <= s_axi_awqos;
          acc_aw_i[6] <= awqos_i[0];
        awuser_i <= s_axi_awuser;
          acc_aw_i[7] <= awuser_i[0];
        awid_i <= s_axi_awid;
          acc_aw_i[8] <= awid_i[0];
      end else begin
        awaddr_i <= awaddr_i>>1;
        awprot_i <= awprot_i>>1;
        awsize_i <= awsize_i>>1;
        awburst_i <= awburst_i>>1;
        awcache_i <= awcache_i>>1;
        awlock_i <= awlock_i>>1;
        awqos_i <= awqos_i>>1;
        awuser_i <= awuser_i>>1;
        awid_i <= awid_i>>1;
        acc_aw_i <= acc_aw_i>>1;
      end
    end

    //**********************************************
    // Write Data Channel: PROCESS INPUTS
    //**********************************************
    always @(posedge aclk) begin
      if(areset) begin
        wdata_i <= {C_AXI_DATA_WIDTH{1'b0}};
        wstrb_i <= {(C_AXI_DATA_WIDTH/8){1'b0}};
        wuser_i <= {(1+1){1'b0}};
        acc_w_i <= 4'b0;
      end else if (s_axi_wvalid) begin
        // Register Inputs
        wdata_i <= s_axi_wdata;
          acc_w_i[0] <= wdata_i[0];
        wstrb_i <= s_axi_wstrb;
          acc_w_i[1] <= wstrb_i[0];
        wuser_i <= s_axi_wuser;
          acc_w_i[2] <= wuser_i[0];
        wid_i <= s_axi_wid;
          acc_w_i[3] <= wid_i[0];
      end else begin
        wdata_i <= wdata_i>>1;
        wstrb_i <= wstrb_i>>1;
        wuser_i <= wuser_i>>1;
        wid_i   <= wid_i>>1;
        acc_w_i <= acc_w_i>>1;
      end
    end

assign axi_arlen_i = (C_AXI_PROTOCOL == 0) ? s_axi_arlen : {4'b0,s_axi_arlen};
axi_switch_0_ref_example_example_reg_srl_fifo_0 
rlen_fifo (
  .aclk    (aclk),
  .areset  (areset),
  .aclken  (1'b1),
  .s_mesg  (axi_arlen_i),
  .s_valid (ar_push),
  .s_ready (s_arlen_ready),
  .s_afull (),
  .m_mesg  (rlen),
  .m_valid (r_valid),
  .m_ready  (r_pop)
  );

axi_switch_0_ref_example_example_reg_srl_fifo_0 
rid_fifo (
  .aclk    (aclk),
  .areset  (areset),
  .aclken  (1'b1),
  .s_mesg  ({7'd0, s_axi_arid}),
  .s_valid (ar_push),
  .s_ready (s_arid_ready),
  .s_afull (),
  .m_mesg  (rid_int),
  .m_valid (),
  .m_ready  (r_pop)
  );

axi_switch_0_ref_example_example_reg_srl_fifo_0 
bid_fifo (
  .aclk    (aclk),
  .areset  (areset),
  .aclken  (1'b1),
  .s_mesg  ({7'd0, bid}),
  .s_valid (wlast_xfer),
  .s_ready (s_axi_wready_i),
  .s_afull (),
  .m_mesg  (s_axi_bid_int),
  .m_valid (b_valid),
  .m_ready  (b_xfer)
  );

endmodule

`default_nettype wire

