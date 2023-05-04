FolAuthor: 111064523 張柏彥 通訊所碩一

Date: January, 10, 2023


Description
-------------------------
DSPIC Final Project: Digital FIR filter design

Design a low-pass digital FIR filter, using Matlab tool functions to calculate the filter coefficients and C/C++ program for Fixed-point simulation. Design the circuit using Verilog HDL and synthesize using Synopsys Design Compiler.


File Hierarchy
-------------------------
111064523_final_project.zip
|
|--111064523_final_project
	|
	|--report.pdf
	|
	|--Folded_FIR
              |
              |--sw
              |   |--input_8bits.txt
              |   |--input_24bits.txt
              |   |--coeff.txt
              |   |--Equi_23.fda
              |   |--data_gen.m
              |   |--positive_fft.m
              |   |--plot_snr_curve.m
              |   |--main.cpp
              |   |--conv.cpp
              |   |--fixed_conv.cpp
              |   |--gFix.cpp
              |   |--gFix.h
              |
              |--hdl
	          |--sim
	          |    |--input_hex.txt
	          |    |--output_hex.txt
	          |
	          |--src
	          |    |--define.vh
	          |    |--DW02_mult_2_stage_inst.v
	          |    |--FIR.v
	          |    |--FIR_tb.v
	          |
	          |--syn
	              |--dc_syn.tcl
	              |--FIR_syn_tb.v
	              |--FIR.sdc
	              |--synopsys_dc.setup
	              |--.synopsys_dc.setup


Compilation Guide
-------------------------
Digital Folded FIR filter
1. Enter "cd 111064523_HW4/FIR/sw".
2. Run main.cpp to generate SNR.txt file.
3. Run plot_snr_curve.m to generate output SNR versus input signal word-length graph.
4. Enter "cd ../hdl/src".
5. Enter "vcs FIR_tb.v FIR.v -y /usr/cad/synopsis/synthesis/cur/dw/sim_ver+libext+.v -full64 -R -debug_access+all +v2k +neg_tchk" for pre-sim.
6. Enter "cd ../syn".
7. Add "tsmc13_neg.v" to syn directory.
8. Enter "dc_shell -f *.tcl | tee FIR_syn.log" for circuit synthesis with Synopsys Design Compiler.
9. Enter "vcs FIR_syn_tb.v FIR_syn.v -v tsmc13_neg.v -full64 -R -debug_access+all -timescale=1ns/10ps +v2k +neg_tchk -l compile.log" for gate level netlist simulation.
10. Check area.log, timing.log, power.log for detailed hardware specification.







