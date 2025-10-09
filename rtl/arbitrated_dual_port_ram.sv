// create a dual port RAM serving W writers and R readers
// - the module has only one internal read port and one internal write port
// - but it has N write request ports and M read request ports
// - if W>1, a round-robin write arbiter selects one of the write request ports to forward to the internal write port
// - if R>1, a round-robin read arbiter selects one of the read request ports to forward to the internal read port
// - the RAM has a depth of D and a width of WIDTH

module arbitrated_dual_port_ram #(
    parameter W = 2,           // Number of write ports
    parameter R = 2,           // Number of read ports
    parameter D = 16,          // Depth of the RAM
    parameter WIDTH = 32,      // Width of the RAM
    parameter LOG_D = (D > 1) ? $clog2(D) : 1, // Width of the address
    parameter LOG_W = (W > 1) ? $clog2(W) : 1, // Width of the write port index
    parameter LOG_R = (R > 1) ? $clog2(R) : 1  // Width of the read port index
) (
    // Clock and reset
    input  logic                    clk,
    input  logic                    rstn,

    // Write ports (W writers)
    input  logic [W-1:0]            we_i,            // Valid signals from writers
    output logic [W-1:0]            wrRdy_o,            // Ready signals to writers
    input  [LOG_D-1:0]              wadr_i[W],           // new id
    input  [WIDTH-1:0]              wdat_i[W],       // new target

    // Read ports (R readers)
    input  logic [R-1:0]            re_i,            // Valid signals from readers
    output logic [R-1:0]            rdRdy_o,            // Ready signals to readers
    input  [LOG_D-1:0]              radr_i[R],        // lookup id
    output logic [WIDTH-1:0]        rdat_o        // lookup target
);

    // Internal registers for dual port memory
    logic                   we, re;
    logic [LOG_D-1:0]       waddr, raddr;
    logic [WIDTH-1:0]       wdata;
    wire  [WIDTH-1:0]       rdata;
    reg   [WIDTH-1:0]       tableDat_r[D];
    wire  [LOG_W-1:0]       wrSel;
    wire  [LOG_R-1:0]       rdSel;
    // Wire declarations
    wire [W-1:0] wrGnt;
    wire [R-1:0] rdGnt;

    // Generate block to decide if write arbiter is required
    generate
        if (W > 1) begin: gen_write_arbiter
            // Write arbiter is needed
            rr_arbiter #(
                .N(W),
                .LOG_N(LOG_W)
            ) write_arbiter (
                .clk(clk),
                .rstn(rstn),
                .req_i(we_i),
                .gnt(wrGnt),
                .gnt_idx(wrSel)
            );
        end else begin: gen_write_direct
            // Direct connection for single writer
            assign wrGnt = we_i;
            assign wrSel = '0;
        end
    endgenerate

    // Generate block for read arbiter
    generate
        if (R > 1) begin: gen_read_arbiter
            // Read arbiter is needed
            rr_arbiter #(
                .N(R),
                .LOG_N(LOG_R)
            ) read_arbiter (
                .clk(clk),
                .rstn(rstn),
                .req_i(re_i),
                .gnt(rdGnt),
                .gnt_idx(rdSel)
            );
        end else begin: gen_read_direct
            // Direct connection for single reader
            assign rdGnt = re_i;
            assign rdSel = '0;
        end
    endgenerate

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            for (int i = 0; i < D; i++) begin
                tableDat_r[i] <= '0;
            end
        end else begin
            if (we) begin
                tableDat_r[waddr] <= wdata;
            end
        end
    end

    always_comb begin
    // Write logic
        we=|wrGnt;
        waddr=wadr_i[wrSel];
        wdata=wdat_i[wrSel];
        wrRdy_o=wrGnt;

    // Read logic
        re=|rdGnt;
        raddr=radr_i[rdSel];
        rdat_o=tableDat_r[raddr];
        rdRdy_o=rdGnt;
    end

endmodule

