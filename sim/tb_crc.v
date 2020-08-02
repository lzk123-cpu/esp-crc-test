module CRC(
input CLK
);
//对时钟进行分频，用于运算
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
		
//进行CRC模块的测试
reg [7:0]crc_data_test[3:0];
reg [7:0]crc_cnt = 8'd0;
	
reg [7:0]crc_data_in;
wire [7:0]crc_data_out;
reg crc_en;
reg crc_rst;
//crc-8实例化
crc(
       .data_in(crc_data_in),
       .crc_en(crc_en),
       .crc_out(crc_data_out),
       .rst(crc_rst),
       .clk(~CLK_DIV)
		  );
	
	//测试状态机
	always@(posedge CLK_DIV)
		begin
			case(crc_cnt)
				8'd0:
					begin
						//测试数据赋初值
						crc_data_test[0] <= 8'h01;
						crc_data_test[1] <= 8'h02;
						crc_data_test[2] <= 8'h03;
						crc_data_test[3] <= 8'h04;
						//关闭crc
						crc_en <= 1'd0;
						//复位crc
						crc_rst <= 1'd1;
						//状态计数器加1
						crc_cnt <= crc_cnt + 1'd1;
					end
				8'd1:
					begin
						//使能crc
						crc_en <= 1'd1;
						//停止复位crc
						crc_rst <= 1'd0;
						//输入数据初值
						crc_data_in <= crc_data_test[0];
						//状态计数器加1
						crc_cnt <= crc_cnt + 1'd1;
					end
				8'd2:
					begin
						//输入数据初值
						crc_data_in <= crc_data_test[1];
						//状态计数器加1
						crc_cnt <= crc_cnt + 1'd1;
					end
				8'd3:
					begin
						//输入数据初值
						crc_data_in <= crc_data_test[2];
						//状态计数器加1
						crc_cnt <= crc_cnt + 1'd1;
					end
				8'd4:
					begin
						//输入数据初值
						crc_data_in <= crc_data_test[3];
						//状态计数器清零
						crc_cnt <= 8'd0;
					end
				default:
					begin
						crc_cnt <= 8'd0;
					end
			endcase
		end
endmodule
