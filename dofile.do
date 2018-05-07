
# Compile of Branching_Unit.vhd was successful.
# Compile of Buffer.vhd was successful.
# Compile of Data_Memory.vhd was successful.
# Compile of Decode_Stage.vhd was successful.
# Compile of DECODER.vhd was successful.
# Compile of DFF.vhd was successful.
# Compile of EXC_ALU.vhd was successful.
# Compile of Execution_Stage.vhd was successful.
# Compile of Fetch_Stage.vhd was successful.
# Compile of Forwarding_Unit.vhd was successful.
# Compile of Full_Adder.vhd was successful.
# Compile of Instruction_Memory.vhd was successful.
# Compile of Main.vhd was successful.
# Compile of Memory_Stage.vhd was successful.
# Compile of NBit_Adder.vhd was successful.
# Compile of PC_Adder.vhd was successful.
# Compile of REGISTER.vhd was successful.
# Compile of Register_File.vhd was successful.
# Compile of WriteBack_Stage.vhd was successful.
# 19 compiles, 0 failed with no errors.
vsim work.main
# vsim work.main 
# Start time: 13:31:51 on May 07,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.main(main_arch)
# Loading ieee.numeric_std(body)
# Loading work.fetch_stage(fetch_stage_arch)
# Loading work.instruction_memory(instruction_memory_arch)
# Loading work.pc_adder(pc_adder_arch)
# Loading work.internal_buffer(internal_buffer_arch)
# Loading work.dff(dff_arch)
# Loading work.decode_stage(decode_stage_arch)
# Loading work.branching_unit(branching_unit_arch)
# Loading work.decoder(data_arch)
# Loading work.execution_stage(execution_stage_arch)
# Loading work.forwarding_unit(forwarding_unit_arch)
# Loading work.exc_alu(exc_alu_arch)
# Loading work.nbitadder(nbitadder_arch)
# Loading work.fulladder(data_flow)
# Loading work.memory_stage(memory_stage_arch)
# Loading work.data_memory(data_memory_arch)
# Loading work.write_back_stage(write_back_stage_arch)
# Loading work.register_file(register_file_arch)
# Loading work.reg(reg_arch)
mem load -i {/home/sobeih/eclipse-workspace/Assembler/instr.mem} /main/f/u/ram
add wave -r /*
force -freeze sim:/main/mem_clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/main/clk 1 10, 0 {60 ps} -r 100
force -freeze sim:/main/reset 1 0
force -freeze sim:/main/intr 0 0
force -freeze sim:/main/input_port x\"0000\" 0
run 70 ps
force -freeze sim:/main/reset 0 0
run 30 ps

