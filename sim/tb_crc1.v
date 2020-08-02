`timescale			1ns/1ps
module tb_crc1();
// Inputs
reg data_en;
reg clk;
reg rst_n;
reg [9:0] data_in;
reg clk_crc;

// Outputs

wire [4:0] crc_out;
wire [14:0] data_out;

// Instantiate the Unit Under Test (UUT)

crc1 crc1_inst (

					.en					(data_en),
					
					.data_in		(data_in),
					
					.clk				(clk),
					
					.rst_n			(rst_n),
					
					.crc_out		(crc_out),
					
					.data_out		(data_out)
					
					);


initial begin
data_en = 0;
clk = 0;
clk_crc=0;
rst_n = 0;
data_in=10'b1010001101;
// Wait 100 ns for global reset to finish
#100;
rst_n =1;
#100;
data_en=1;
#100;
data_en=0;
data_in=10'b1011001101;
#300;
data_en=1;
#100;
data_en=0;
data_in=10'b1011011101;
#300;
fork
repeat (10) @(posedge clk_crc) data_en<=~data_en;
repeat (10) @(posedge clk_crc) data_in<=data_in+1;
join
end
/*initial
begin
clk = 0;
clk_crc=0;
rst_n = 0;
#10;
rst_n=1;
end

initial
begin
data_en=0;
data_in=10'b1010001101;
end

initial 
fork
data_en = 0;
data_in=10'b1010001101;
repeat (10) @(posedge clk_crc) data_en<=~data_en;
repeat (10) @(posedge clk_crc) data_in<=data_in+1;
join
*/
always #10 clk=~clk;
//always #100 clk_crc=~clk_crc;

endmodule
