//
// Copyright 1991-2015 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
// PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
// LICENSE TERMS.
//
// Simple SystemVerilog DPI Example - Verilog test module for fibonacci seq.
//
`timescale 1ns / 1ns
`define EOF -1

module top
    (output [31:0] out,
    output SIGN,
    output [4:0] n,
    output int v_cnt1)
;

    parameter CLK_PD = 100;                 // system clock period
    parameter N = 10;                       // max number of sequences
    parameter TESTFILE = "./fibonacci.dat"; // test vectors

    logic [4:0] n_l;                        // DUT input
    logic signed [31:0] y_l;                // DUT output
    logic sign = 0;
    bit clock = 0;                          // testbench clock
    logic [31:0] results [0:10];            // array of golden test values
    int FD;                                 // input file handle
    int e_cnt = 0;                          // counter for DATA MISMATCHES
    int v_cnt = 0;                          // verification counter
    int l_cnt = 0;                          // counter - loading results array

    // Make C function visible to verilog code
    import "DPI-C" context function int factorial(input int N, input int unsigned sign);

    // clock generator
    always
        #(CLK_PD/2) clock = ~clock;

    // simulation control
    initial begin
        // Open input file - break simulation an error occurs
        FD = $fopen(TESTFILE, "r");
        if (FD == 0) begin
            $display("# ERROR: Failure opening \"%s\" for READING", TESTFILE);
            $finish;
        end

        // load results array
        while ($fscanf(FD, "%d", results[l_cnt]) != `EOF)
            ++l_cnt;

        // apply stimulus
        // n_l = 1;
        // sign = 1;
        // y_l = factorial(n_l, sign);
        // @(negedge clock) vdata;
        // repeat (N-1) begin
        //     n_l += 1;
        //     sign ^= 1;
        //     y_l = factorial(n_l, sign);
        //     @(negedge clock) vdata;
        // end

        n_l = 5'b10001;
        y_l = factorial(n_l[3:0], n_l[4]);
        @(negedge clock) vdata;
        repeat (N-1) begin
            n_l += 1;
            n_l[4] ^= 1;
            y_l = factorial(n_l[3:0], n_l[4]);
            @(negedge clock) vdata;
        end


        $display("\n# Simulation finished: DATA MISMATCHES = %0d\n", e_cnt);
        $fclose(FD);
        $finish;
    end

    // verify results & maintain error count
    task vdata;
        if (y_l !== results[v_cnt]) begin
            ++e_cnt;
            $display("# ERROR: %0d != %0d", y_l, results[v_cnt]);
        end
        if (n_l == N)
            v_cnt = 0;
        else
            ++v_cnt;
    endtask

    assign out = y_l;
    assign clock1 = clock;
    assign n = n_l[3:0];
    assign SIGN = n_l[4];

endmodule
