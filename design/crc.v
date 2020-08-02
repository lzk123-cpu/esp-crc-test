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
//�������ݵķ�ת
/*
			1.����һ��8λ��data
			2.��data_in ��ת��ֵ��data
			3.��always @(*)�����е�data_in�滻Ϊdata
*/
wire [7:0]data;
assign data = {data_in[0],data_in[1],data_in[2],data_in[3],data_in[4],data_in[5],data_in[6],data_in[7]};
		
		
//������ݵķ�ת
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

//У���ʼ��
/*
��always @(posedge clk, posedge rst) �е� lfsr_q  <= {8{1'b1}}��Ϊ lfsr_q  <= {8{1'b0}}.
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
