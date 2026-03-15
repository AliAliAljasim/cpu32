vlib work
vlog ../rtl/*.v
vlog cpu32_tb.v

vsim cpu32_tb

delete wave *

add wave -radix binary /cpu32_tb/clk
add wave -radix binary /cpu32_tb/reset

add wave -radix unsigned /cpu32_tb/uut/cpu_datapath/pc_value
add wave -radix hex /cpu32_tb/uut/instruction

add wave -radix binary /cpu32_tb/uut/reg_write
add wave -radix binary /cpu32_tb/uut/alu_src
add wave -radix binary /cpu32_tb/uut/branch
add wave -radix binary /cpu32_tb/uut/mem_read
add wave -radix binary /cpu32_tb/uut/mem_write
add wave -radix binary /cpu32_tb/uut/alu_op

add wave -radix decimal /cpu32_tb/uut/cpu_datapath/reg_data1
add wave -radix decimal /cpu32_tb/uut/cpu_datapath/reg_data2
add wave -radix decimal /cpu32_tb/uut/cpu_datapath/imm
add wave -radix decimal /cpu32_tb/uut/cpu_datapath/alu_input_b

add wave -radix decimal /cpu32_tb/uut/cpu_datapath/alu_result
add wave -radix decimal /cpu32_tb/uut/cpu_datapath/mem_data
add wave -radix decimal /cpu32_tb/uut/cpu_datapath/writeback_data

add wave -radix decimal /cpu32_tb/uut/cpu_datapath/registers/registers(1)
add wave -radix decimal /cpu32_tb/uut/cpu_datapath/registers/registers(2)

run 130ns
wave zoom full