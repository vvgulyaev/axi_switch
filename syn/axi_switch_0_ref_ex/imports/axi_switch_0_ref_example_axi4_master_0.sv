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

module axi_switch_0_ref_example_axi4_master_0 #(
  parameter integer C_AXI_ID_WIDTH = 0,
  parameter integer C_AXI_ADDR_WIDTH = 32,
  parameter integer C_AXI_DATA_WIDTH = 32,
  parameter integer C_AXI_PROTOCOL = 0,
  parameter integer C_AXI_AWUSER_WIDTH = 0,
  parameter integer C_AXI_ARUSER_WIDTH = 0,
  parameter integer C_AXI_BUSER_WIDTH = 0,
  parameter integer C_SUPPORTS_NARROW = 0,
  parameter integer C_SUPPORTS_WRAP = 0,
  parameter integer C_AXI_SUPPORTS_WRITE = 1,
  parameter integer C_AXI_SUPPORTS_READ = 1,
  parameter [C_AXI_ADDR_WIDTH-1:0] C_AXI_ADDR = 0)  // Base address
(
  /**************** Write Address Channel Signals ****************/
  output wire [C_AXI_ADDR_WIDTH-1:0]       m_axi_awaddr,
  output wire [3-1:0]                     m_axi_awprot,
  output wire                             m_axi_awvalid,
  input  wire                            m_axi_awready,
  output wire [3-1:0]                     m_axi_awsize,
  output wire [2-1:0]                     m_axi_awburst,
  output wire [4-1:0]                     m_axi_awcache,
  output wire [8-1:0]        m_axi_awlen,
  output wire [1-1:0]       m_axi_awlock,
  output wire [4-1:0]                     m_axi_awqos,
  output wire [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]         m_axi_awid,
  output wire [(C_AXI_AWUSER_WIDTH==0?1:C_AXI_AWUSER_WIDTH)-1:0]    m_axi_awuser,
  /**************** Write Data Channel Signals ****************/
  output wire [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]         m_axi_wid,
  output wire [C_AXI_DATA_WIDTH-1:0]      m_axi_wdata,
  output wire [C_AXI_DATA_WIDTH/8-1:0]     m_axi_wstrb,
  output wire                             m_axi_wvalid,
  input  wire                            m_axi_wready,
  output wire                             m_axi_wlast,
  output wire [1-1:0]     m_axi_wuser,
  /**************** Write Response Channel Signals ****************/
  input  wire [2-1:0]                    m_axi_bresp,
  input  wire                            m_axi_bvalid,
  output wire                             m_axi_bready,
  input  wire [(C_AXI_BUSER_WIDTH==0?1:C_AXI_BUSER_WIDTH)-1:0]     m_axi_buser,
  input  wire [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]        m_axi_bid,
  /**************** Read Address Channel Signals ****************/
  output wire [C_AXI_ADDR_WIDTH-1:0]       m_axi_araddr,
  output wire [3-1:0]                     m_axi_arprot,
  output wire                             m_axi_arvalid,
  input  wire                            m_axi_arready,
  output wire [3-1:0]                     m_axi_arsize,
  output wire [2-1:0]                     m_axi_arburst,
  output wire [4-1:0]                     m_axi_arcache,
  output wire [8-1:0]        m_axi_arlen,
  output wire [1-1:0]       m_axi_arlock,
  output wire [4-1:0]                     m_axi_arqos,
  output wire [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]         m_axi_arid,
  output wire [(C_AXI_ARUSER_WIDTH==0?1:C_AXI_ARUSER_WIDTH)-1:0]    m_axi_aruser,
  /**************** Read Data Channel Signals ****************/
  input  wire [C_AXI_DATA_WIDTH-1:0]      m_axi_rdata,
  input  wire [2-1:0]                    m_axi_rresp,
  input  wire                            m_axi_rvalid,
  output wire                             m_axi_rready,
  input  wire                            m_axi_rlast,
  input  wire [1-1:0]    m_axi_ruser,
  input  wire [(C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH)-1:0]        m_axi_rid,
  /**************** System Signals ****************/
  input  wire                            aclk,
  input  wire                            aresetn,
  output wire                            done,
  input  wire                            dummy  // Tie to zero externally (prevents logic trimming)
  );


  function integer f_ceil_log2
    (
     input integer x
     );
    integer acc;
    begin
      acc=0;
      while ((2**acc) < x)
        acc = acc + 1;
      f_ceil_log2 = acc;
    end
  endfunction

  /**************** Local Parameters ****************/
  localparam integer C_NUM_ADDR = 1;  // Number of address iterations; range 1..2**16 (fixed increment = 32'h10000
  localparam integer C_NUM_ID = 1;  // Number of ID iterations; range 1..2**C_ID_WIDTH (base = 0; fixed increment = 1)
  localparam integer C_NUM_LEN_MAX = C_AXI_PROTOCOL == 0 ? 255 : 15;  // Number of LEN iterations; range 1..9 (base = 0; value = 2**i - 1)
  localparam integer C_NUM_LEN = 1;  // Number of LEN iterations; range 1..9 (base = 0; value = 2**i - 1)
  localparam integer C_NUM_TRANS = 1;  // Number of transactions; range >=1 (read and write)
  localparam integer  P_ID_WIDTH = C_AXI_ID_WIDTH==0?1:C_AXI_ID_WIDTH;
  localparam integer  P_NUM_ADDR_LOG = f_ceil_log2(C_NUM_ADDR);
  localparam integer  P_M_AXI_DATA_BYTES = (C_AXI_DATA_WIDTH / 8);
  localparam integer  P_M_AXI_DONE_WIDTH = f_ceil_log2(C_NUM_TRANS < 2 ? 2 : C_NUM_TRANS);
  localparam integer  P_M_AXI_SIZE = f_ceil_log2(C_AXI_DATA_WIDTH)-3;

  /**************** Internal Wires/Regs - Global ****************/
  reg                         done_i = 1'b0;
  reg                          done_d1;
  reg                   areset = 1'b0;
  reg [P_M_AXI_DONE_WIDTH:0] arcnt_i = {P_M_AXI_DONE_WIDTH{1'b0}};
  reg [P_M_AXI_DONE_WIDTH:0] rcnt_i = {P_M_AXI_DONE_WIDTH{1'b1}};
  reg [3:0]                    acc_r_i = 4'b0;
  reg [P_M_AXI_DONE_WIDTH:0] awcnt_i = {P_M_AXI_DONE_WIDTH{1'b0}};
  reg [P_M_AXI_DONE_WIDTH:0] wcnt_i = {P_M_AXI_DONE_WIDTH{1'b0}};
  reg [P_M_AXI_DONE_WIDTH:0] bcnt_i = {P_M_AXI_DONE_WIDTH{1'b1}};
  reg [2:0]                    acc_b_i = 3'b0;

  // Register Reset
  always @(posedge aclk) begin
      areset <= ~aresetn;
  end


    /**************** Internal Wires/Regs - Read Channels ****************/
    wire                         read_xaction_done_i;
    reg [C_AXI_ADDR_WIDTH-1:0] m_axi_araddr_i = C_AXI_ADDR;
    reg [P_ID_WIDTH:0]     m_axi_arid_i = 0;
    reg [8-1:0]     m_axi_arlen_i = {8{1'b0}};
    reg [1-1:0]                  m_axi_arlock_i = 'b0;
    reg [C_AXI_ARUSER_WIDTH:0]    aruser_i = {(C_AXI_ARUSER_WIDTH+1){1'b0}};
    reg [C_AXI_DATA_WIDTH-1:0]    rdata_i = {C_AXI_DATA_WIDTH{1'b0}};
    reg [2-1:0]                  rresp_i = 2'b00;
    reg [1:0]   ruser_i = {(1+1){1'b0}};
    reg [P_ID_WIDTH:0]      rid_i = {P_ID_WIDTH{1'b0}};
    reg                        m_axi_arvalid_i = 1'b0;
    reg                        m_axi_rready_i = 1'b0;
    reg [P_NUM_ADDR_LOG:0]    araddr_cnt = 0;

    /**************** Assign Read Channel Outputs ****************/
    assign read_xaction_done_i = m_axi_rvalid && m_axi_rready_i && ((C_AXI_PROTOCOL==2)?1'b1:m_axi_rlast);
    assign m_axi_arvalid = m_axi_arvalid_i;
    assign m_axi_rready = m_axi_rready_i;
    assign m_axi_araddr = m_axi_araddr_i;
    assign m_axi_arlen = m_axi_arlen_i;
    assign m_axi_arlock = m_axi_arlock_i;
    assign m_axi_arid = m_axi_arid_i;
    assign m_axi_arprot = 3'b000;
    assign m_axi_arsize = C_SUPPORTS_NARROW==0 ? P_M_AXI_SIZE : P_M_AXI_SIZE-1;
    assign m_axi_arburst = C_SUPPORTS_WRAP==0 ? 2'b01 : 2'b10;
    assign m_axi_arcache = 4'h3;
    assign m_axi_arqos = 4'h0;
    assign m_axi_aruser = aruser_i;

    //**********************************************
    // Read Channel: ARVALID, ARADDR, ARLEN, RREADY
    //**********************************************
    always @(posedge aclk) begin
      if (areset) begin
        m_axi_arvalid_i <= 1'b0;
        arcnt_i <= C_NUM_TRANS;
        m_axi_arlen_i <= (C_NUM_LEN>C_NUM_LEN_MAX) ? C_NUM_LEN_MAX : C_NUM_LEN;
        m_axi_araddr_i <= C_AXI_ADDR;
        m_axi_arid_i <= 0;
        araddr_cnt <= C_NUM_ADDR;
        m_axi_arlock_i <= 0;
        aruser_i <= 512'hf0030201e0030201d0030201c0030201b0030201a003020190030201800302017003020160030201500302014003020130030201200302011003020100030201;
      end else if (C_AXI_SUPPORTS_READ!=0) begin
        if (m_axi_arready & m_axi_arvalid_i) begin
          arcnt_i <= arcnt_i - 1;
          aruser_i <= aruser_i + 512'h00010101000101010001010100010101000101010001010100010101000101010001010100010101000101010001010100010101000101010001010100010101;
          if (araddr_cnt == 1) begin
            m_axi_araddr_i <= C_AXI_ADDR;
            araddr_cnt <= C_NUM_ADDR;
          end else begin
            m_axi_araddr_i <= m_axi_araddr_i + 32'h10000;
            araddr_cnt <= araddr_cnt - 1;
          end
          if (C_NUM_LEN > C_NUM_LEN_MAX) begin
            if (m_axi_arlen_i == C_NUM_LEN_MAX) begin
              m_axi_arlen_i <= 0;
            end else begin
              m_axi_arlen_i <= (m_axi_arlen_i<<1) | 1'b1;
            end
          end else begin
            m_axi_arlen_i <= C_NUM_LEN;
          end
          m_axi_arid_i <= 0;
          if ((C_NUM_TRANS > 0) && (arcnt_i == 1)) begin
            m_axi_arvalid_i <= 1'b0;
          end
        end else if ((C_NUM_TRANS == 0) || (arcnt_i != 0)) begin
          m_axi_arvalid_i <= 1'b1;
        end
      end
    end

    //**********************************************
    // Read Channel: PROCESS INPUTS
    //**********************************************
    always @(posedge aclk) begin
      if(areset) begin
        m_axi_rready_i <= 1'b0;
        rcnt_i <= C_NUM_TRANS;
        rdata_i <= {C_AXI_DATA_WIDTH{1'b0}};
        rresp_i <= {2{1'b0}};
        ruser_i <= {(1+1){1'b0}};
        rid_i <= {P_ID_WIDTH{1'b0}};
        acc_r_i <= 4'b0;
      end else if (C_AXI_SUPPORTS_READ!=0) begin
        m_axi_rready_i <= 1'b1;
        if (m_axi_rvalid) begin
          rdata_i <= m_axi_rdata;
            acc_r_i[0] <= rdata_i[0];
          rresp_i <= m_axi_rresp;
            acc_r_i[1] <= rresp_i[0];
          ruser_i <= m_axi_ruser;
            acc_r_i[2] <= ruser_i[0];
          rid_i <= m_axi_rid;
            acc_r_i[3] <= rid_i[0];
          if (m_axi_rlast) begin
            rcnt_i <= rcnt_i - 1;
          end
        end else begin
          rdata_i <= rdata_i>>1;
          rresp_i <= rresp_i>>1;
          ruser_i <= ruser_i>>1;
          rid_i <= rid_i>>1;
          acc_r_i <= acc_r_i>>1;
        end
      end
    end



    /**************** Internal Wires/Regs - Write Channels ****************/
    reg [C_AXI_ADDR_WIDTH-1:0]     m_axi_awaddr_i = C_AXI_ADDR;
    reg [P_ID_WIDTH:0]     m_axi_awid_i = 0;
    reg [8-1:0]     m_axi_awlen_i = {8{1'b0}};
    reg [C_AXI_DATA_WIDTH-1:0]    wdata_i = {C_AXI_DATA_WIDTH{1'b0}};
    reg [8-1:0]                  wxfer = 8'h00;
    wire                         write_burst_done_i;
    reg [3-1:0]                  awprot_i = 3'b0;
    reg [8-1:0]     wlen_i = {8{1'b0}};
    reg [1-1:0]    m_axi_awlock_i = 'b0;
    reg [C_AXI_AWUSER_WIDTH:0]    awuser_i = {(C_AXI_AWUSER_WIDTH+1){1'b0}};
    reg [1:0]     wuser_i = {(1+1){1'b0}};
    reg [2-1:0]                  bresp_i = 2'b00;
    reg [C_AXI_BUSER_WIDTH:0]   buser_i = {(C_AXI_BUSER_WIDTH+1){1'b0}};
    reg [P_ID_WIDTH:0]      bid_i = {P_ID_WIDTH{1'b0}};
    reg                        m_axi_awvalid_i = 1'b0;
    reg                        m_axi_wvalid_i = 1'b0;
    reg                        m_axi_bready_i = 1'b0;
    reg                        m_axi_wlast_i = 1'b0;
    reg                        m_axi_wid_i = {P_ID_WIDTH{1'b0}};
    reg [P_NUM_ADDR_LOG:0]    awaddr_cnt = 0;
    reg    aw_issued = 1'b0;
    reg    aw_done = 1'b0;
    reg    w_done = 1'b0;

    /**************** Assign Write Channel Outputs ****************/
    assign m_axi_wdata = wdata_i;
    assign write_burst_done_i = m_axi_wready && m_axi_wvalid_i && ((C_AXI_PROTOCOL==2) || m_axi_wlast_i);
    assign m_axi_awvalid = m_axi_awvalid_i;
    assign m_axi_wvalid = m_axi_wvalid_i;
    assign m_axi_bready = m_axi_bready_i;
    assign m_axi_wlast = m_axi_wlast_i;
    assign m_axi_awaddr = m_axi_awaddr_i;
    assign m_axi_awlen = m_axi_awlen_i;
    assign m_axi_awid = m_axi_awid_i;
    assign m_axi_wid = m_axi_wid_i;
    assign m_axi_awlock = m_axi_awlock_i;
    assign m_axi_awprot = awprot_i;
    assign m_axi_awsize = C_SUPPORTS_NARROW==0 ? P_M_AXI_SIZE : P_M_AXI_SIZE-1;
    assign m_axi_awburst = C_SUPPORTS_WRAP==0 ? 2'b01 : 2'b10;
    assign m_axi_awcache = 4'h3;
    assign m_axi_awqos = 4'h0;
    assign m_axi_wstrb = {P_M_AXI_DATA_BYTES{1'b1}};
    assign m_axi_awuser = awuser_i;
    assign m_axi_wuser = wuser_i;

    //**********************************************
    // Write Channel: AWVALID, AWADDR, AWLEN, WVALID, WLAST, BREADY
    //**********************************************
    always @(posedge aclk) begin
      if (areset) begin
        m_axi_awvalid_i <= 1'b0;
        m_axi_wvalid_i <= 1'b0;
        awcnt_i <= C_NUM_TRANS;
        wcnt_i <= C_NUM_TRANS;
        m_axi_awlen_i <= (C_NUM_LEN>C_NUM_LEN_MAX) ? C_NUM_LEN_MAX : C_NUM_LEN;
        wlen_i <= (C_NUM_LEN>C_NUM_LEN_MAX) ? C_NUM_LEN_MAX : C_NUM_LEN;
        wxfer <= (C_NUM_LEN>C_NUM_LEN_MAX) ? C_NUM_LEN_MAX : C_NUM_LEN;
        m_axi_awaddr_i <= C_AXI_ADDR;
        m_axi_awid_i <= (C_NUM_ID == 0) ? (C_AXI_ADDR >> 16) : 0;
        m_axi_wid_i <= 0;
        m_axi_wlast_i <= C_NUM_LEN == 0;
        awaddr_cnt <= C_NUM_ADDR;
        aw_issued <= 1'b0;
        aw_done <= 1'b0;
        w_done <= 1'b0;
        m_axi_awlock_i <= 0;
        awuser_i <= 512'hf0030201e0030201d0030201c0030201b0030201a003020190030201800302017003020160030201500302014003020130030201200302011003020100030201;
      end else if (C_AXI_SUPPORTS_WRITE!=0) begin
        if (m_axi_awready & m_axi_awvalid_i) begin
          awcnt_i <= awcnt_i - 1;
          awuser_i <= awuser_i + 512'h00010101000101010001010100010101000101010001010100010101000101010001010100010101000101010001010100010101000101010001010100010101;
          if (awaddr_cnt == 1) begin
            m_axi_awaddr_i <= C_AXI_ADDR;
            awaddr_cnt <= C_NUM_ADDR;
          end else begin
            m_axi_awaddr_i <= m_axi_awaddr_i + 32'h10000;
            awaddr_cnt <= awaddr_cnt - 1;
          end
          if (C_NUM_LEN > C_NUM_LEN_MAX) begin
            if (m_axi_awlen_i == C_NUM_LEN_MAX) begin
              m_axi_awlen_i <= 0;
            end else begin
              m_axi_awlen_i <= (m_axi_awlen_i<<1) | 1'b1;
            end
          end else begin
            m_axi_awlen_i <= C_NUM_LEN;
          end
          if (C_NUM_ID == 0) begin
            if (awaddr_cnt == 1) begin
              m_axi_awid_i <= C_AXI_ADDR >> 16;
            end else begin
              m_axi_awid_i <= (m_axi_awaddr_i >> 16) + 1;
            end
          end else begin
            if (C_NUM_ID<2 || (m_axi_awid_i == C_NUM_ID)) begin
              m_axi_awid_i <= 1;
            end else begin
              m_axi_awid_i <= m_axi_awid_i + 1;
            end
          end
          if ((C_NUM_TRANS > 0) && (awcnt_i == 1)) begin
            m_axi_awvalid_i <= 1'b0;
            aw_done <= 1'b1;
          end
        end else if ((C_NUM_TRANS == 0) || (awcnt_i != 0)) begin
          m_axi_awvalid_i <= 1'b1;
        end

        /**************** Write Data Channel ****************/

        if (m_axi_wready && m_axi_wvalid_i) begin
          if (m_axi_wlast_i) begin
            wcnt_i <= wcnt_i - 1'b1;
            if (C_NUM_LEN > C_NUM_LEN_MAX) begin
              if (wlen_i == C_NUM_LEN_MAX) begin
                wlen_i <= 0;
                wxfer <= 0;
                m_axi_wlast_i <= 1'b1;
              end else begin
                wlen_i <= (wlen_i<<1) | 1'b1;
                wxfer <= (wlen_i<<1) | 1'b1;
                m_axi_wlast_i <= 1'b0;
              end
            end else begin
              wlen_i <= C_NUM_LEN;
              wxfer <= C_NUM_LEN;
              m_axi_wlast_i <= C_NUM_LEN == 0;
            end
            if ((C_NUM_TRANS > 0) && (wcnt_i == 1)) begin
              m_axi_wvalid_i <= 1'b0;
              w_done <= 1'b1;
            end
          end else begin
            wxfer <= wxfer - 1'b1;
            m_axi_wlast_i <= wxfer == 1;
          end
        end else if ((C_NUM_TRANS == 0) || (wcnt_i != 0)) begin
          m_axi_wvalid_i <= 1'b1;
        end
      end
    end

    //**********************************************
    // Write Channel: WDATA
    //**********************************************
    always @(posedge aclk) begin
      if (areset) begin
        wdata_i <= 'ha5a5a5a5;
        wuser_i <= 512'hf0030201e0030201d0030201c0030201b0030201a003020190030201800302017003020160030201500302014003020130030201200302011003020100030201;
      end else begin
        wdata_i <= (m_axi_wvalid_i && m_axi_wready) ? {~wdata_i[C_AXI_DATA_WIDTH - 2 : 0], wdata_i[C_AXI_DATA_WIDTH - 1]} : wdata_i;
        if (m_axi_wvalid_i && m_axi_wready) begin
          wuser_i <= wuser_i + 512'h00010101000101010001010100010101000101010001010100010101000101010001010100010101000101010001010100010101000101010001010100010101;
        end
      end
    end

    //**********************************************
    // Write Channel: PROCESS INPUTS
    //**********************************************
    always @(posedge aclk) begin
      if (areset) begin
        m_axi_bready_i <= 1'b0;
        bcnt_i <= C_NUM_TRANS;
        bresp_i <= {2{1'b0}};
        buser_i <= {(C_AXI_BUSER_WIDTH +1){1'b0}};
        bid_i <= {P_ID_WIDTH{1'b0}};
        acc_b_i <= 3'b0;
      end else if (C_AXI_SUPPORTS_WRITE !=0) begin
        m_axi_bready_i <= 1'b1;
        if (m_axi_bvalid & m_axi_bready_i) begin
          bresp_i <= m_axi_bresp;
            acc_b_i[0] <= bresp_i[0];
          buser_i <= m_axi_buser;
            acc_b_i[1] <= buser_i[0];
          bid_i <= m_axi_bid;
            acc_b_i[2] <= bid_i[0];
          bcnt_i <= bcnt_i - 1;
        end else begin
          bresp_i <= bresp_i>>1;
          buser_i <= buser_i>>1;
          bid_i <= bid_i>>1;
          acc_b_i <= acc_b_i>>1;
        end
      end
    end


  //**********************************************
  // Assert Done
  //**********************************************
 always @ (posedge aclk) begin
    if (areset) begin
      done_i <= 1'b0;
    end
    else begin
      if ((C_AXI_SUPPORTS_READ == 1) && (C_AXI_SUPPORTS_WRITE == 0)) begin : gen_readonly_done
        done_i = (rcnt_i==0);
      end else if ((C_AXI_SUPPORTS_READ == 0) && (C_AXI_SUPPORTS_WRITE == 1)) begin : gen_writeonly_done
        done_i = (bcnt_i==0);
      end else if ((C_AXI_SUPPORTS_READ == 1) && (C_AXI_SUPPORTS_WRITE == 1)) begin  : gen_readwrite_done
        done_i = ((rcnt_i==0) && (bcnt_i==0));
      end else
        done_i <= 1'b1;
      end
    end

  assign done = done_i;

endmodule

`default_nettype wire

