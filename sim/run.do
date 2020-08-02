quit			-sim
.main			clear
vlib			work
vlog			./tb_crc3.v
vlog			./../design/crc3.v
vsim			-voptargs=+acc	work.tb_crc3
add		wave	/tb_crc3/crc3_inst/*
run		5ms