// CRC module for
//       data[7:0]
//       crc[7:0]=1+x^4+x^5+x^8;
//
module crc(
        input [7:0] data_in,
        input        crc_en,
        output [7:0] crc_out,
        input        rst,
        input        clk);

        reg [7:0] lfsr_q,
                   lfsr_c;
//输入数据的翻转
/*
			1.定义一个8位的data
			2.将data_in 翻转赋值给data
			3.将always @(*)语句块中的data_in替换为data
*/
wire [7:0]data;
assign data = {data_in[0],data_in[1],data_in[2],data_in[3],data_in[4],data_in[5],data_in[6],data_in[7]};
		
		
//输出数据的翻转
assign crc_out = {lfsr_q[0],lfsr_q[1],lfsr_q[2],lfsr_q[3],lfsr_q[4],lfsr_q[5],lfsr_q[6],lfsr_q[7]};
		 
		
always @(*) 
begin
 lfsr_c[0] = lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ data[0] ^ data[3] ^ data[4] ^ data[6];
 lfsr_c[1] = lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ data[1] ^ data[4] ^ data[5] ^ data[7];
 lfsr_c[2] = lfsr_q[2] ^ lfsr_q[5] ^ lfsr_q[6] ^ data[2] ^ data[5] ^ data[6];
 lfsr_c[3] = lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[7] ^ data[3] ^ data[6] ^ data[7];
 lfsr_c[4] = lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[7] ^ data[0] ^ data[3] ^ data[6] ^ data[7];
 lfsr_c[5] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[7] ^ data[0] ^ data[1] ^ data[3] ^ data[6] ^ data[7];
 lfsr_c[6] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[7] ^ data[1] ^ data[2] ^ data[4] ^ data[7];
 lfsr_c[7] = lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ data[2] ^ data[3] ^ data[5];


end // always

//校验初始化
/*
将always @(posedge clk, posedge rst) 中的 lfsr_q  <= {8{1'b1}}改为 lfsr_q  <= {8{1'b0}}.
*/
always @(posedge clk, posedge rst) begin
if(rst) 
  begin
    lfsr_q  <= {8{1'b0}};
  end
else begin
    lfsr_q  <= crc_en ? lfsr_c: lfsr_q;
  end
  end // always
endmodule // crc

