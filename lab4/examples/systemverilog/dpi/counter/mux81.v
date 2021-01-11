//
// Copyright 1991-2015 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
// PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
// LICENSE TERMS.
//
// Simple SystemVerilog DPI Example - Verilog test module for 8-to-1 MUX
//
`timescale 1ns / 1ns

module top;

    parameter CLK_PD = 100;               // system clock period

    logic [4:0] data;                     // DUT input signals
    bit clock = 0;                        // testbench clock
    logic [4:0] results [0:28];          // array to hold golden test values
    int e_cnt = 0;                        // counter for DATA MISMATCHES
    int v_cnt = 0;                        // verification counter

    
    
    CNT25 DUT ( 
        .clk(clock),
        .out(data)  
        ); 

    // clock generator
    always
        #(CLK_PD/2) clock = ~clock;

    // simulation control
    initial begin
        //////////////////////////////////////////////////////////////////////
        // load results array
        //////////////////////////////////////////////////////////////////////
        $readmemh("mux81.dat", top.results);
        //////////////////////////////////////////////////////////////////////
        // stimulus
        //////////////////////////////////////////////////////////////////////
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        @(negedge clock) vdata;
        
        //////////////////////////////////////////////////////////////////////
        // finish simulation
        //////////////////////////////////////////////////////////////////////
        $display("\n# Simulation finished: DATA MISMATCHES = %0d\n", e_cnt);
        // $stop;
        $finish;
    end

    // verify results and maintain error count
    task vdata;
        if (data !== results[v_cnt]) begin
            ++e_cnt;
            $display("# ERROR: %d != %d", data, results[v_cnt]);
        end
        ++v_cnt;
    endtask

endmodule

module CNT25 ( 
    input   clk,   
    output  reg [4:0] out); 

    import "DPI-C" context function int counter25 (input int curr);

    always @ (posedge clk) begin  
        out <= counter25(out);
    end 
endmodule  