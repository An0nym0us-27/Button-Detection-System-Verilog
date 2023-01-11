`timescale 1ns / 1ps

module db_tester(
    input logic clk,
    input logic btnR, //counter button
    input logic btnC, //reset button
    output logic [3:0] an,
    output logic [7:0] seg
    );
    
    logic [7:0] b_reg, d_reg;
    logic [7:0] b_next, d_next;
    logic btn_reg, db_reg;
    logic db_level, db_tick, btn_tick, clr;
    logic sw_en, db_en;
    
    disp_hex_mux disp_unit(.clk(clk), .reset(btnC), .hex3(b_reg[7:4]), .hex2(b_reg[3:0]), .hex1(d_reg[7:4]), .hex0(d_reg[3:0]), .dp_in(4'b1011), .an(an), .sseg(seg));
    rising_edge_detector red1(.clk(clk), .reset(btnC), .level(btnR), .tick(sw_en));
    rising_edge_detector red2(.clk(clk), .reset(btnC), .level(db_tick), .tick(db_en));
    db db_unit(.clk(clk), .reset(btnC), .sw(btnR), .db(db_level));
    
    //edge detection circuits
    always_ff@(posedge clk)
        begin
            btn_reg <= btnR;
            db_reg <= db_level;
        end
    assign btn_tick = ~btn_reg & btnR;
    assign db_tick = ~db_reg & db_level;
    
    //two counters
    assign clr = btnC;
    always_ff@(posedge clk)
        begin
            b_reg <= b_next;
            d_reg <= d_next;
        end
    assign b_next = (clr) ? 8'b0:
                    (btn_tick) ? b_reg + 1 : b_reg;
    assign d_next = (clr) ? 8'b0:
                    (db_tick) ? d_reg + 1 : d_reg;
endmodule
