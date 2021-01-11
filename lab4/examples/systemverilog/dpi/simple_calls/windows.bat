vlib work

vlog simple_calls.sv -dpiheader cimports.h cimports.c
vopt +acc simple_calls -o opt_simple_calls
vsim -i opt_simple_calls -do "add wave light; view source"
