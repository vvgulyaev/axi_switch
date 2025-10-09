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
axi_switch_0_ref_example_example_reg_srl_fifo_0
(
   input  wire                        aclk,    // Clock
   input  wire                        aclken,  // Clock-enable
   input  wire                        areset,  // Reset
   input  wire [8-1:0]     s_mesg,  // Input data
   input  wire                        s_valid, // Input data valid
   output wire                        s_ready, // Input data ready
   output wire                        s_afull, // output almost full
   output wire [8-1:0]     m_mesg,  // Output data
   output wire                        m_valid, // Output data valid
   input  wire                        m_ready  // Output data ready
   );

  genvar i;

  generate

    localparam [5-1:0] P_EMPTY       = {5{1'b1}};
    localparam [5-1:0] P_ALMOSTEMPTY = {5{1'b0}};
    localparam [5-1:0] P_ALMOSTFULL  = {{(5-1){1'b1}}, 1'b0};
    localparam [5-1:0] P_ALMOSTFULL_EARLY  = P_ALMOSTFULL-1'b1;

    reg  push;       // increment fifo pointer
    reg  pop;        // decrement fifo pointer
    reg  shift;      // SRL shift (push or nothing to lose)
    wire shift_qual; 
    wire [8-1:0] srl_reg;
    reg [5-1:0]  fifoaddr = P_EMPTY;
    logic  fifoaddr_afull = 1'b0;

    if (2 == 1) begin : gen_combin  // Zero-latency

      localparam S_VALID_0   = 1'b0;
      localparam S_VALID_1   = 1'b1;
      localparam M_READY_0   = 1'b0;
      localparam M_READY_1   = 1'b1;

      typedef enum bit [1:0] {
        RESET = 2'b00,
        EMPTY = 2'b01,
        MIN1  = 2'b11,
        FULL  = 2'b10 }
        t_state;

      logic             s_ready_i;

      t_state state = RESET;  // State vector register
      t_state next;           // Next state value

      assign s_ready = s_ready_i;
      assign m_valid = (state==EMPTY) ? s_valid : (state!=RESET);  // Propagate combinatorially when empty
      assign m_mesg  = (state==RESET || state==EMPTY) ? s_mesg : srl_reg;  // Propagate combinatorially when empty
      assign shift_qual = shift & aclken;

      always @ * begin
        next = state;  // Default: hold state unless re-assigned
        case (state)
          RESET: begin  // De-assert all handshakes
            s_ready_i = 1'b0;
            push = 1'b0;
            pop = 1'b0;
            shift = 1'b0;
            next = EMPTY;
          end  // RESET

          EMPTY: begin  // FIFO Empty; pre-assert s_ready
            s_ready_i = 1'b1;
            pop = 1'b0;
            shift = 1'b1;  // nothing to lose
            if (s_valid & ~m_ready) begin
              push = 1'b1;
              next = MIN1;
            end else begin
              push = 1'b0;
              next = EMPTY;
            end
          end  // EMPTY

          MIN1: begin  // FIFO contains 1 item (in SRL)
            s_ready_i = 1'b1;
            shift = s_valid;

            casex ({s_valid,m_ready})
              {S_VALID_1,M_READY_0}: begin  // Receive a new item, push into SRL
                push = 1'b1;
                pop = 1'b0;
                next = (fifoaddr_afull) ? FULL : MIN1;
              end

              {S_VALID_0,M_READY_1}: begin  // Pop from SRL
                push = 1'b0;
                pop = 1'b1;
                next = (fifoaddr == P_ALMOSTEMPTY) ? EMPTY : MIN1;
              end

              {S_VALID_1,M_READY_1}: begin  // Push a new item while popping
                push = 1'b1;
                pop = 1'b1;
                next = MIN1;
              end

              default: begin  // s_valid=0, m_ready=0: hold state
                push = 1'b0;
                pop = 1'b0;
                next = MIN1;
              end
            endcase
          end  // HAS1

          FULL: begin  // FIFO Full
            s_ready_i = 1'b0;
            push = 1'b0;
            shift = 1'b0;
            if (m_ready) begin
              pop = 1'b1;
              next = MIN1;
            end else begin
              pop = 1'b0;
              next = FULL;
            end
          end  // FULL

          default: begin  // Same as RESET
            s_ready_i = 1'b0;
            push = 1'b0;
            pop = 1'b0;
            shift = 1'b0;
            next = EMPTY;
          end  // default
        endcase
      end

      always @(posedge aclk) begin
        if (areset) begin
          state <= RESET;
        end else begin
          if (aclken) begin
            state <= next;
          end
        end
      end

    end // if (C_REG_CONFIG == 1)
    else if (2 == 2) begin : gen_pipelined  // Fully pipelined

      localparam S_READY_0   = 1'b0;
      localparam S_READY_1   = 1'b1;
      localparam M_VALID_0   = 1'b0;
      localparam M_VALID_1   = 1'b1;
      localparam SRL_VALID_0 = 1'b0;
      localparam SRL_VALID_1 = 1'b1;
      localparam S_VALID_0   = 1'b0;
      localparam S_VALID_1   = 1'b1;
      localparam M_READY_0   = 1'b0;
      localparam M_READY_1   = 1'b1;

      localparam [2:0] K_RESET   = {S_READY_0,M_VALID_0,SRL_VALID_0};
      localparam [2:0] K_EMPTY   = {S_READY_1,M_VALID_0,SRL_VALID_0};
      localparam [2:0] K_HAS1    = {S_READY_1,M_VALID_1,SRL_VALID_0};
      localparam [2:0] K_MIN2    = {S_READY_1,M_VALID_1,SRL_VALID_1};
      localparam [2:0] K_FULL    = {S_READY_0,M_VALID_1,SRL_VALID_1};

      typedef enum bit [2:0] {
        RESET = K_RESET,
        EMPTY = K_EMPTY,
        HAS1  = K_HAS1 ,
        MIN2  = K_MIN2 ,
        FULL  = K_FULL }
        t_state;

      typedef struct packed {
        logic             s_ready_i;
        logic             m_valid_i;
        logic             srl_valid_i;  // SRL FIFO contains valid data
      } t_state_out;

      t_state state = RESET;  // State vector register
      t_state next;           // Next state value
      t_state_out state_out;  // Values to be sampled directly from state vector

      reg  load_mesg;  // Load output register
      reg  srl2mesg;   // Output reg loads from SRL (else from s_mesg)
      reg  [8-1:0] mesg_reg;  // No initial state

      assign state_out = state;  // Superimpose enum state value onto n-bit state_out struct
      assign s_ready = state_out.s_ready_i;  // Drive s_ready from state vector
      assign m_valid = state_out.m_valid_i;  // Drive m_valid from state vector
      assign m_mesg  = mesg_reg;
      assign shift_qual = shift & aclken;

      always @ * begin
        next = state;  // Default: hold state unless re-assigned
        load_mesg = 1'b1;
        srl2mesg = 1'b0;
        push = 1'b0;
        pop = 1'b0;
        case (state)
          RESET: begin  // De-assert all handshakes
            next = EMPTY;
            load_mesg = 1'b1;  // Inconsequential
            srl2mesg = 1'b0;  // Inconsequential
            push = 1'b0;
            pop = 1'b0;
            shift = 1'b0;
          end  // RESET

          EMPTY: begin  // FIFO Empty; pre-assert s_ready
            load_mesg = 1'b1;  // Inconsequential (ok to load output reg even when no handshake)
            srl2mesg = 1'b0;
            push = 1'b0;
            pop = 1'b0;
            shift = 1'b0;
            if (s_valid) begin
              next = HAS1;
            end
          end  // EMPTY

          HAS1: begin  // FIFO contains 1 item in the output register (SRL empty)
            srl2mesg = 1'b0;
            pop = 1'b0;
            shift = 1'b1;  // nothing to lose
            casex ({s_valid,m_ready})
              {S_VALID_1,M_READY_0}: begin  // Receive a 2nd item, push into SRL
                next = MIN2;
                load_mesg = 1'b0;
                push = 1'b1;
              end

              {S_VALID_0,M_READY_1}: begin  // Pop to empty
                next = EMPTY;
                load_mesg = 1'b1;  // Inconsequential
                push = 1'b0;
              end

              {S_VALID_1,M_READY_1}: begin  // Push a new item while popping; replace contents of output reg
                next = HAS1;
                load_mesg = 1'b1;
                push = 1'b0;
              end

              default: begin  // s_valid=0, m_ready=0: hold state
                next = HAS1;
                load_mesg = 1'b0;
                push = 1'b0;
              end
            endcase
          end  // HAS1

          MIN2: begin  // FIFO contains >1 item, some in SRL
            srl2mesg = 1'b1;
            shift = s_valid;

            casex ({s_valid,m_ready})
              {S_VALID_1,M_READY_0}: begin  // Receive a new item, push into SRL
                next = (fifoaddr_afull) ? FULL : MIN2;
                load_mesg = 1'b0;
                push = 1'b1;
                pop = 1'b0;
              end

              {S_VALID_0,M_READY_1}: begin  // Pop SRL to replace output reg
                next = (fifoaddr == P_ALMOSTEMPTY) ? HAS1 : MIN2;
                load_mesg = 1'b1;
                push = 1'b0;
                pop = 1'b1;
              end

              {S_VALID_1,M_READY_1}: begin  // Push a new item while popping
                next = MIN2;
                load_mesg = 1'b1;
                push = 1'b1;
                pop = 1'b1;
              end

              default: begin  // s_valid=0, m_ready=0: hold state
                next = MIN2;
                load_mesg = 1'b0;
                push = 1'b0;
                pop = 1'b0;
              end
            endcase
          end  // MIN2

          FULL: begin  // FIFO Full
            srl2mesg = 1'b1;
            push = 1'b0;
            shift = 1'b0;
            if (m_ready) begin
              next = MIN2;
              load_mesg = 1'b1;
              pop = 1'b1;
            end else begin
              next = FULL;
              load_mesg = 1'b0;
              pop = 1'b0;
            end
          end  // FULL

          default: begin  // Same as RESET
            next = EMPTY;
            load_mesg = 1'b1;  // Inconsequential
            srl2mesg = 1'b0;  // Inconsequential
            push = 1'b0;
            pop = 1'b0;
            shift = 1'b0;
          end  // default
        endcase
      end

      always @(posedge aclk) begin
        if (areset) begin
          state <= RESET;
        end else begin
          if (aclken) begin
            state <= next;
          end
        end
      end

      always @(posedge aclk) begin  // Payload reg needs no reset
        if (aclken) begin
          if (load_mesg) begin
            mesg_reg <= srl2mesg ? srl_reg : s_mesg;
          end
        end
      end

    end // if (C_REG_CONFIG == 2)

    // SRL FIFO address pointer
    always @(posedge aclk) begin
      if (areset) begin
        fifoaddr <= P_EMPTY;
      end else begin
        if (aclken) begin
          if (push & ~pop) begin
            fifoaddr <= fifoaddr + 1;
          end else if (~push & pop) begin
            fifoaddr <= fifoaddr - 1;
          end
        end
      end
    end

    always @(posedge aclk) begin
      if (areset) begin
        fifoaddr_afull <= 1'b0;
      end else begin
        if (aclken) begin
          if (push & ~pop & (fifoaddr == P_ALMOSTFULL_EARLY)) begin
            fifoaddr_afull <= 1'b1;
          end else if (~push & pop & (fifoaddr == P_ALMOSTFULL)) begin
            fifoaddr_afull <= 1'b0;
          end
        end
      end
    end
    assign s_afull = fifoaddr_afull;
    //---------------------------------------------------------------------------
    // Instantiate SRLs
    //---------------------------------------------------------------------------
    for (i=0;i<8;i=i+1) begin : gen_srls
      axi_switch_0_ref_example_example_reg_srl_fifo_0_rtl 
      srl_nx1
        (
         .clk (aclk),
         .a   (fifoaddr),
         .ce  (shift_qual),
         .d   (s_mesg[i]),
         .q   (srl_reg[i])
        );
    end
  endgenerate

endmodule

`default_nettype wire

