module slave_switch #( // connect M masters and output 3 request channels to arbitrated channel buses and receive 2 response channels from arbitrated channel buses
    parameter N = 2,           // Number of slave ports connected to masters
    parameter M = 2,           // Number of master ports connected to slaves
    parameter WIDTH = 32,      // Data width
    parameter ID_WIDTH = 4,    // ID width
    parameter ADDR_WIDTH = 32,  // Address width
    parameter LOG_N = (N > 1) ? $clog2(N) : 1, // Width of the master index
    parameter LOG_M = (M > 1) ? $clog2(M) : 1  // Width of the slave index
) (
    // Clock and reset
    input  logic                    clk,
    input  logic                    rstn,

    // Master module interface (N masters) - Standard AXI4 signals
    input  logic [N-1:0]            s_axi_arvalid,      // Read address valid from masters
    output logic [N-1:0]            s_axi_arready,      // Read address ready to masters
    input  [ID_WIDTH-1:0]           s_axi_arid[N],      // Read address ID from masters
    input  [ADDR_WIDTH-1:0]         s_axi_araddr[N],     // Read address from masters
    input  [7:0]                    s_axi_arlen[N],      // Read address burst length from masters
    input  [2:0]                    s_axi_arsize[N],     // Read address burst size from masters
    input  [1:0]                    s_axi_arburst[N],    // Read address burst type from masters

    input  logic [N-1:0]            s_axi_awvalid,      // Write address valid from masters
    output logic [N-1:0]            s_axi_awready,      // Write address ready to masters
    input  [ID_WIDTH-1:0]           s_axi_awid[N],       // Write address ID from masters
    input  [ADDR_WIDTH-1:0]         s_axi_awaddr[N],     // Write address from masters
    input  [7:0]                    s_axi_awlen[N],      // Write address burst length from masters
    input  [2:0]                    s_axi_awsize[N],     // Write address burst size from masters
    input  [1:0]                    s_axi_awburst[N],    // Write address burst type from masters

    input  logic [N-1:0]            s_axi_wvalid,       // Write data valid from masters
    output logic [N-1:0]            s_axi_wready,       // Write data ready to masters
    input  [WIDTH-1:0]              s_axi_wdata[N],      // Write data from masters
    input  [WIDTH/8-1:0]            s_axi_wstrb[N],      // Write data strobe from masters
    input  logic                    s_axi_wlast[N],      // Write data last from masters

    // Read data channel signals (R) - from switch to masters
    output logic [N-1:0]            s_axi_rvalid,       // Read data valid to masters
    input  logic [N-1:0]            s_axi_rready,       // Read data ready from masters
    output [ID_WIDTH-1:0]           s_axi_rid[N],       // Read ID to masters
    output [WIDTH-1:0]              s_axi_rdata[N],      // Read data to masters
    output [1:0]                    s_axi_rresp[N],      // Read response to masters
    output logic                    s_axi_rlast[N],      // Read last to masters

    // Write response channel signals (B) - from switch to masters
    output logic [N-1:0]            s_axi_bvalid,       // Write response valid to masters
    input  logic [N-1:0]            s_axi_bready,       // Write response ready from masters
    output [ID_WIDTH-1:0]           s_axi_bid[N],        // Write response ID to masters
    output [1:0]                    s_axi_bresp[N],      // Write response to masters

    // 5 arbitrated channel buses
    // AR (Read Address) arbitrated channel bus
    output logic [N-1:0]            busARVld_o,         // Read arbitrated valid to slaves
    input  logic [M-1:0]            busARRdy_i,         // Read address ready from slaves
    output [ADDR_WIDTH-1:0]         busARAddr_o,        // Read address to slaves
    output [ID_WIDTH-1:0]           busARId_o,          // Read address ID to slaves
    output [7:0]                    busARLen_o,         // Read address burst length to slaves
    output [2:0]                    busARSz_o,          // Read address burst size to slaves
    output [1:0]                    busARBurst_o,       // Read address burst type to slaves
    output [LOG_N-1:0]              busARSrc_o,         // Source master index for read address

    // AW (Write Address) arbitrated channel bus
    output logic [N-1:0]            busAWVld_o,         // Write address valid to slaves
    input  logic [M-1:0]            busAWRdy_i,         // Write address ready from slaves
    output [ADDR_WIDTH-1:0]         busAWAddr_o,        // Write address to slaves
    output [ID_WIDTH-1:0]           busAWId_o,          // Write address ID to slaves
    output [7:0]                    busAWLen_o,         // Write address burst length to slaves
    output [2:0]                    busAWSz_o,          // Write address burst size to slaves
    output [1:0]                    busAWBurst_o,       // Write address burst type to slaves
    output [LOG_N-1:0]              busAWSrc_o,         // Source master index for write address

    // W (Write Data) arbitrated channel bus
    output logic [N-1:0]            busWVld_o,          // Write data valid to slaves
    input  logic [M-1:0]            busWRdy_i,          // Write data ready from slaves
    output [WIDTH-1:0]              busWData_o,         // Write data to slaves
    output [WIDTH/8-1:0]            busWStrb_o,         // Write data strobe to slaves
    output logic                    busWLast_o,         // Write data last to slaves
    output [LOG_N-1:0]              busWSrc_o,          // Source master index for write data

    // R (Read Data) arbitrated channel bus
    input  logic [M-1:0]            busRVld_i,          // Read data valid from slaves
    output logic [N-1:0]            busRRdy_o,          // Read data ready to slaves
    input  [WIDTH-1:0]              busRData_i,         // Read data from slaves
    input  [ID_WIDTH-1:0]           busRId_i,           // Read data ID from slaves
    input  [1:0]                    busRResp_i,         // Read data response from slaves
    input  logic                    busRLast_i,         // Read data last from slaves

    // B (Write Response) arbitrated channel bus
    input  logic [M-1:0]            busBVld_i,          // Write response valid from slaves
    output logic [N-1:0]            busBRdy_o,          // Write response ready to slaves
    input  [ID_WIDTH-1:0]           busBId_i,           // Write response ID from slaves
    input  [1:0]                    busBResp_i          // Write response from slaves
);

    // Internal signals for channel data packing
    logic [ADDR_WIDTH+ID_WIDTH+8+3+2-1:0] ar_packed_data[N];
    logic [ADDR_WIDTH+ID_WIDTH+8+3+2-1:0] aw_packed_data[N];
    logic [WIDTH+WIDTH/8+1-1:0] w_packed_data[N];
    logic [LOG_M-1:0] ar_target[N];
    logic [LOG_M-1:0] aw_target[N];
    logic [LOG_M-1:0] w_target[N];

    // Calculate target slave from address MSBs
    generate
        for (genvar i = 0; i < N; i++) begin : target_calc
            assign ar_target[i] = s_axi_araddr[i][ADDR_WIDTH-1:ADDR_WIDTH-LOG_M];
            assign aw_target[i] = s_axi_awaddr[i][ADDR_WIDTH-1:ADDR_WIDTH-LOG_M];
            // W channel uses same target as AW
            assign w_target[i] = s_axi_awaddr[i][ADDR_WIDTH-1:ADDR_WIDTH-LOG_M];

            // Pack AR channel data
            assign ar_packed_data[i] = {s_axi_araddr[i], s_axi_arid[i], s_axi_arlen[i], s_axi_arsize[i], s_axi_arburst[i]};

            // Pack AW channel data
            assign aw_packed_data[i] = {s_axi_awaddr[i], s_axi_awid[i], s_axi_awlen[i], s_axi_awsize[i], s_axi_awburst[i]};

            // Pack W channel data
            assign w_packed_data[i] = {s_axi_wdata[i], s_axi_wstrb[i], s_axi_wlast[i]};
        end
    endgenerate

    // Unpacked data for output channels
    wire [ADDR_WIDTH+ID_WIDTH+8+3+2-1:0] ar_unpacked_data;
    wire [ADDR_WIDTH+ID_WIDTH+8+3+2-1:0] aw_unpacked_data;
    wire [WIDTH+WIDTH/8+1-1:0] w_unpacked_data;

    // Connect packed data to outputs
    assign {busARAddr_o, busARId_o, busARLen_o, busARSz_o, busARBurst_o} = ar_unpacked_data;
    assign {busAWAddr_o, busAWId_o, busAWLen_o, busAWSz_o, busAWBurst_o} = aw_unpacked_data;
    assign {busWData_o, busWStrb_o, busWLast_o} = w_unpacked_data;

    // instantiate 3 channel arbiters for AR, AW, W channels
    channel_arbiter #(
        .S      (N),
        .D      (M),
        .WIDTH  (ADDR_WIDTH + ID_WIDTH + 8 + 3 + 2), // AR/AW channel width
        .LOG_D  (LOG_M),
        .LOG_S  (LOG_N)
    ) ar_arbiter (
        .clk            (clk),
        .rstn           (rstn),
        .srcVld_i       (s_axi_arvalid),
        .srcTarget_i    (ar_target),
        .srcDat_i       (ar_packed_data),
        .grantRdy_o     (s_axi_arready),
        .dstRdy_i       (busARRdy_i),
        .dstVld_o       (busARVld_o),
        .dstDat_o       (ar_unpacked_data),
        .dstSrc_o       (busARSrc_o)
    );

    channel_arbiter #(
        .S      (N),
        .D      (M),
        .WIDTH  (ADDR_WIDTH + ID_WIDTH + 8 + 3 + 2), // AR/AW channel width
        .LOG_D  (LOG_M),
        .LOG_S  (LOG_N)
    ) aw_arbiter (
        .clk            (clk),
        .rstn           (rstn),
        .srcVld_i       (s_axi_awvalid),
        .srcTarget_i    (aw_target),
        .srcDat_i       (aw_packed_data),
        .grantRdy_o     (s_axi_awready),
        .dstRdy_i       (busAWRdy_i),
        .dstVld_o       (busAWVld_o),
        .dstDat_o       (aw_unpacked_data),
        .dstSrc_o       (busAWSrc_o)
    );

    channel_arbiter #(
        .S          (N),
        .D          (M),
        .WIDTH      (WIDTH + WIDTH/8 + 1), // W channel width
        .LOG_D      (LOG_M),
        .LOG_S      (LOG_N)
    ) w_arbiter (
        .clk            (clk),
        .rstn           (rstn),
        .srcVld_i       (s_axi_wvalid),
        .srcTarget_i    (w_target),
        .srcDat_i       (w_packed_data),
        .grantRdy_o     (s_axi_wready),
        .dstRdy_i       (busWRdy_i),
        .dstVld_o       (busWVld_o),
        .dstDat_o       (w_unpacked_data),
        .dstSrc_o       (busWSrc_o)
    );

    // Connect read-data and write-ack bus with the master module ports

    // R channel - Connect slave responses to masters
    assign busRRdy_o = s_axi_rready;  // Forward master ready signals to bus

    // Broadcast incoming read data to all masters
    // Only the master with matching ID will actually use the data
    genvar r_idx;
    generate
        for (r_idx = 0; r_idx < N; r_idx++) begin : r_broadcast
            assign s_axi_rvalid[r_idx] = busRVld_i[r_idx];  // Valid to specific master
            assign s_axi_rdata[r_idx] = busRData_i;         // Broadcast data to all masters
            assign s_axi_rid[r_idx] = busRId_i;           // Broadcast ID to all masters
            assign s_axi_rresp[r_idx] = busRResp_i;        // Broadcast response to all masters
            assign s_axi_rlast[r_idx] = busRLast_i;        // Broadcast last to all masters
        end
    endgenerate

    // B channel - Connect slave write responses to masters
    assign busBRdy_o = s_axi_bready;  // Forward master ready signals to bus

    // Broadcast incoming write responses to all masters
    // Only the master with matching ID will actually use the response
    genvar b_idx;
    generate
        for (b_idx = 0; b_idx < N; b_idx++) begin : b_broadcast
            assign s_axi_bvalid[b_idx] = busBVld_i[b_idx];  // Valid to specific master
            assign s_axi_bid[b_idx] = busBId_i;             // Broadcast ID to all masters
            assign s_axi_bresp[b_idx] = busBResp_i;         // Broadcast response to all masters
        end
    endgenerate
endmodule
