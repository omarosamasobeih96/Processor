vsim work.main
mem load -i {/home/sobeih/eclipse-workspace/Assembler/instr.mem} /main/f/u/ram
mem load -i {/home/sobeih/eclipse-workspace/Assembler/data.mem} /main/m/u/ram
force -freeze sim:/main/mem_clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/main/clk 1 10, 0 {60 ps} -r 100
force -freeze sim:/main/reset 1 0
force -freeze sim:/main/intr 0 0
force -freeze sim:/main/input_port x\"0000\" 0
run 70 ps
force -freeze sim:/main/reset 0 0
run 30 ps
force -freeze sim:/main/input_port 0000000000000100 0

run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run

