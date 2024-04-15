
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity tlv5638 is
    port (
		cs_o : out std_logic; --片选输出 --片选信号高到低转换，实现data_b到data_a的转变，一下输出16位，输出时钟高电平时输出数据有效。--而输出时钟为系统时钟的二分之一。--外部test控制ab转换
		data_o : out std_logic;
		dclock_o : out std_logic; --输出时钟
		
		reset_i : in std_logic;
		clk_i : in std_logic;
		
		start_i  : in std_logic; --启动输入
		eoc_o  : out std_logic; --结束输出
		data_i : in std_logic_vector( 15 downto 0) --16bit信号
    );
end tlv5638;

architecture tlv5638_arch of tlv5638 is
	signal start : std_logic;	--表示开始的电平
	type States is ( IDEL , BUSY );
	signal state : States; --表示状态的信号	
	signal eoc : std_logic; --表示结束
	signal reset_int : std_logic; 
	signal data_out : std_logic_vector( 15 downto 0);
	signal data_out_addr : integer range 0 to 15;

begin
	eoc_o <= eoc; --output输出结束
	process(clk_i , reset_i , eoc) --状态机一
	begin
		if ( reset_i = '1' or eoc = '1' ) then
		state <= IDEL; --高电平复位或者结束输出为1时，输出空闲状态

		elsif ( clk_i 'event and clk_i = '0' ) then --输入时钟下降沿时
			if ( start_i = '1' and state = IDEL ) then --当输入符号为高电平并且状态为空闲时
				state <=  BUSY; --转换为工作状态
				data_out <= data_i; --此时将16bit数据赋值给data_out
			end if;
		end if;
	end process;

	process( clk_i , reset_i )--状态机二
	begin
	if ( reset_i = '1' ) then --当复位时
	reset_int <= '0'; --reset_int表示复位标志赋值低电平
		elsif ( clk_i 'event and clk_i = '0' ) then --如果时钟下降
			if ( eoc = '1' ) then --如果结束
				reset_int <= '1'; --赋值1
			else
				reset_int <= '0'; --如果没有结束，每一个低电平就给他赋值为0
			end if;
		end if;
	end process;

	process( clk_i , reset_i , reset_int ) 
	variable cnt_wr : integer range 0 to 16; --传输计数器
	variable t : integer range 0 to 1; --整数01变量
	begin
		if ( reset_i = '1' or reset_int = '1' ) then --复位且空闲状态
			cs_o <= '1'; --片选高电平
			cnt_wr := 0; --重置计数器
			t := 0; --重置t
			dclock_o <= '0'; --输出时钟始终为低电平
			eoc <= '0'; --结束标志重置
			data_out_addr <= 15; --输出数据的索引地址变为15
			data_o <= '0'; --输出模拟量为0
		elsif ( clk_i 'event and clk_i = '1' ) then --输入时钟高电平
			if ( state = BUSY ) then	--如果工作
				if ( cnt_wr < 16 ) then --计数小于16
					eoc <= '0'; 
					cs_o <= '0';
					if ( t = 0 ) then
						data_o <= data_out(data_out_addr); --高电平赋值一次，高位向低位一位一位输出是由DAC的内部配置所决定的
						dclock_o <= '1'; --有模拟量输出时，输出时钟为1，正常的频率为输入时钟的二分之一
						if (  data_out_addr > 0 ) then
						    data_out_addr <= data_out_addr - 1; --高位向低位输出
						end if ;
					else
						dclock_o <= '0';
						cnt_wr := cnt_wr + 1;
					end if;
					if ( t < 1 ) then --一次高电平完成一次01反转
					    t := t + 1;
					else
					    t := 0 ;
					end if ;
				else
					cs_o <= '1'; --如果16位都传输完成
					eoc <= '1';	
				end if;					
			end if;
		end if;
	end process;

end tlv5638_arch;
