module crc_test(

input en,

input [9:0] data_in,



input clk,

input rst_n,

output reg [4:0] crc_out, //最后的余数，将其附加至data_out末尾

output reg [14:0] data_out

);

wire [14:0] data_in_reg;

//reg[3:0] cnt;

reg [5:0] crc_out_r;

reg crc_start;

parameter gx_crc_8=6'h35;


reg crc_end;


//crc 时钟

reg clk_crc;

reg [3:0] cnt;

always @(posedge clk or negedge rst_n)

begin

if(!rst_n) begin

cnt<=0;

clk_crc<=0;

end

else if(cnt==4'd5) begin

cnt<=0;

clk_crc<=~clk_crc;

end

else

cnt<=cnt+1;

end

reg data_en1,data_en2;

wire data_en_pos;


always @(posedge clk or negedge rst_n)

begin

if(!rst_n) begin

data_en1<=1'b0;

data_en2<=1'b0;

end

else begin

data_en1<=en;

data_en2<=data_en1;

end

end

assign data_en_pos=(data_en1&(~data_en2)); //检测使能上升沿



always @(posedge clk or negedge rst_n)

begin

if(!rst_n) begin

crc_start<=1'b0;

end

else if(data_en_pos) begin

crc_start<=1'b1;

end

else if(crc_end)

crc_start<=1'b0;

end

assign data_in_reg={data_in,5'b00_000};

/*always @(posedge clk_crc or negedge rst_n)

begin

if(!rst_n)

data_in_reg<=16'b0;

else ?

data_in_reg<={data_in,5'b00_000};

end

*/









reg [3:0] i;

//data ?width >crc width crc_8

always @(posedge clk or negedge rst_n)

begin

if(!rst_n) begin

crc_out_r<=data_in_reg[14:9];

i<=4'd8;

crc_end<=1'b0;

data_out<=0;

crc_out<=0;

end

else if(crc_start) begin

if (i==0) begin

if(crc_out_r[5]) begin //decide shift or conduct xor operate

crc_out_r<=crc_out_r^gx_crc_8;

end

else begin

i<=4'd10;

crc_out_r<={crc_out_r[4:0],1'b0};

crc_end<=1'b1;

end

end


else if(i>0 &&i<=8) begin

if(crc_out_r[5]) //decide shift or conduct xor operate

crc_out_r<=crc_out_r^gx_crc_8;

else begin

crc_out_r<={crc_out_r[4:0],data_in_reg[i]}; 

i<=i-1; //shift

end

end

else if (i==10) begin

crc_out<=crc_out_r[5]?(crc_out_r[4:0]^gx_crc_8[4:0]):crc_out_r[4:0];

data_out<={data_in,crc_out};

end


end



else begin

i<=4'd8;

crc_end<=1'b0;

crc_out_r<=data_in_reg[14:9];

end

end

endmodule
