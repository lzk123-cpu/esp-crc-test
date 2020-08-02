module CRC(
input CLK
);
//��ʱ�ӽ��з�Ƶ����������
reg [1:0]cnt = 2'd0;
reg CLK_DIV = 1'd0;
always@(posedge CLK)
	begin
		if(cnt == 2'd3)
			begin
				CLK_DIV <= ~CLK_DIV;
				cnt <= 2'd0;
			end
		else
			begin
				cnt <= cnt + 1'd1;
		end
	end
		
//����CRCģ��Ĳ���
reg [7:0]crc_data_test[3:0];
reg [7:0]crc_cnt = 8'd0;
	
reg [7:0]crc_data_in;
wire [7:0]crc_data_out;
reg crc_en;
reg crc_rst;
//crc-8ʵ����
crc(
       .data_in(crc_data_in),
       .crc_en(crc_en),
       .crc_out(crc_data_out),
       .rst(crc_rst),
       .clk(~CLK_DIV)
		  );
	
	//����״̬��
	always@(posedge CLK_DIV)
		begin
			case(crc_cnt)
				8'd0:
					begin
						//�������ݸ���ֵ
						crc_data_test[0] <= 8'h01;
						crc_data_test[1] <= 8'h02;
						crc_data_test[2] <= 8'h03;
						crc_data_test[3] <= 8'h04;
						//�ر�crc
						crc_en <= 1'd0;
						//��λcrc
						crc_rst <= 1'd1;
						//״̬��������1
						crc_cnt <= crc_cnt + 1'd1;
					end
				8'd1:
					begin
						//ʹ��crc
						crc_en <= 1'd1;
						//ֹͣ��λcrc
						crc_rst <= 1'd0;
						//�������ݳ�ֵ
						crc_data_in <= crc_data_test[0];
						//״̬��������1
						crc_cnt <= crc_cnt + 1'd1;
					end
				8'd2:
					begin
						//�������ݳ�ֵ
						crc_data_in <= crc_data_test[1];
						//״̬��������1
						crc_cnt <= crc_cnt + 1'd1;
					end
				8'd3:
					begin
						//�������ݳ�ֵ
						crc_data_in <= crc_data_test[2];
						//״̬��������1
						crc_cnt <= crc_cnt + 1'd1;
					end
				8'd4:
					begin
						//�������ݳ�ֵ
						crc_data_in <= crc_data_test[3];
						//״̬����������
						crc_cnt <= 8'd0;
					end
				default:
					begin
						crc_cnt <= 8'd0;
					end
			endcase
		end
endmodule
