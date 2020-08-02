`timescale		1ns/1ps
module tb_crc3();// Inputsreg
reg			  clk;
reg [7:0] data;
reg rst_n;
wire [15:0] crc;

crc3	 crc3_inst (
.clk		(clk), 
.data		(data), 
.rst_n	(rst_n), 
.crc		(crc)
);


initial
begin
clk=0;
end

initial
begin
rst_n=0;
data=8'b0;
#1000;
data=8'b10110110;
rst_n=1;
#50;
rst_n=0;
#50;
rst_n=1;

#1000;
data=8'b11001100;
rst_n=1;
#50;
rst_n=0;
#50;
rst_n=1;

#1000;
data=8'b10110011;
rst_n=1;
#50;
rst_n=0;
#50;
rst_n=1;

#1000;
data=8'b10100101;
rst_n=1;
#50;
rst_n=0;
#50;
rst_n=1;
end



      always #10 clk=~clk;
endmodule

                                                                                                                                                                                                                               
                                                                                                                                                                                                                               