module	crc1(
input								en,
input		[9:0]				data_in,
input								clk,
input								rst_n,
output	reg	[4:0]		crc_out,//模二除法后的余数
output	reg	[14:0]	data_out
);

wire		[14:0]			data_in_reg;//多项式为"X5+X4+X2+1 " ,位数为6位，在输入10位数据后加5位0，因此定义为15位寄存器；
reg			[5:0]				crc_out_r;
reg									crc_start;
reg									crc_end;
parameter		gx_crc_8=6'h35;//多项式“X5+X4+X2+1”,转化为二进制序列为110101，十六进制6'h35;


assign	data_in_reg={data_in,5'b00000};
//分频得到crc时钟
reg			clk_crc;
reg			[2:0]		cnt;

always	@(posedge clk or negedge rst_n)
	if(!rst_n)
		begin
			cnt<=3'd0;
			clk_crc<=0;
		end
	else	if(cnt==4'd5)
		begin
			cnt<=3'd0;
			clk_crc<=~clk_crc;
		end
	else
		cnt<=cnt+1'b1;
//data_en上升沿捕获		
reg		data_en1;
reg		data_en2; 
wire	pos_data_en;

always	@(posedge clk or negedge rst_n)
	if(!rst_n)
		begin
			data_en1<=1'b0;
			data_en2<=1'b0;
		end
	else
		begin
			data_en1<=en;
			data_en2<=data_en1;
		end
assign	pos_data_en=~data_en2 & data_en1;

//CRC算法启动标志信号产生
always	@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			crc_start<=1'b0;
		end
	else if(pos_data_en)
		crc_start<=1'b1;
	else if(crc_end)//如果CRC完成标志信号为高，将crc_start拉低
		crc_start<=1'b0;
end 

//模二除法运算data_in_reg/6'h35

reg		[3:0]		i;

always	@(posedge clk or negedge rst_n)
	if(!rst_n)
		begin
			crc_out_r<=data_in_reg[14:9];
			i<=4'd8;
			crc_end<=1'b0;
			data_out<=15'd0;
			crc_out<= 5'd0;
		end
	else if(crc_start)
		begin
			if(i==0)
				begin
					if(crc_out_r[5])
						begin
							//conduct xor operate
							crc_out_r<=crc_out_r ^ gx_crc_8;
						end
					else
						begin
							i<=4'd10;
							crc_out_r<={crc_out_r[4:0],1'b0};
							crc_end<=1'b1;
						end
				end
			else if(i>0 && i<=8)
				begin
					if(crc_out_r[5])
						//xor operate
						crc_out_r<=crc_out_r ^ gx_crc_8;
				//end
					else
						begin
							crc_out_r<={crc_out_r[4:0],data_in_reg[i]};
							i<=i-1;
						end
				end
			else if(i==10)
				begin
					crc_out<=crc_out_r[5]?(crc_out_r[4:0] ^ gx_crc_8[4:0]):crc_out_r[4:0];
					data_out<={data_in,crc_out};
				end 
		//end
	else
		begin
			i<=4'd8;
			crc_end<=1'b0;
			crc_out_r<=data_in_reg[14:9];
		end
	end
endmodule
				
					
					

		

