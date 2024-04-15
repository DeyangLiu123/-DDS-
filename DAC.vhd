-- DAC_A and DAC_B output the same sawtooth wave
-- 一次16位的数据传输需要16个输出时钟+1个片选信号（维持一个输出时钟的高电平，其余时刻为低电平）
-- 对应了一次数据传输需要32+2个系统时钟，也就是说数据传输的周期为34个系统时钟周期
-- 但同时，data_a与data_b交替输出，那么DDS_DA需要2*34=68个系统时钟周期输出一次dataA和dataB
-- 那么控制DDS_DA的时钟需要进行系统时钟的68分频。
-- 如果要求输出波形的基频>200HZ，那么就要求dds的时钟频率>200*512=102400HZ，那么就要求系统时钟的频率>68*102400hz=6963200HZ=6.9632Mhz，很明显应该选50MHZ的原始时钟。

-- 引入必要的IEEE标准库
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity DAC is
    port (
        clk_i : in std_logic;     -- 时钟输入
        reset_i : in std_logic;   -- 复位输入
		  dataa : in std_logic_vector(11 downto 0);
		  datab : in std_logic_vector(11 downto 0);

        cs_o : out std_logic;     -- 选择信号输出
        data_o : out std_logic;   -- 数据输出信号
        dclock_o : out std_logic  -- 数据时钟输出
    );
end DAC;



architecture DAC_arch of DAC is
    
	 signal channel : integer range 0 to 1 ;--用于切换ab，0输出b
	 
    component tlv5638 is
        port (
            cs_o : out std_logic;         -- 选择信号输出
            data_o : out std_logic;       -- 数据输出信号
            dclock_o : out std_logic;     -- 数据时钟输出
            
            reset_i : in std_logic;       -- 复位输入
            clk_i : in std_logic;         -- 时钟输入
                
            start_i : in std_logic;       -- 启动输入
            eoc_o : out std_logic;        -- 转换结束输出
            data_i : in std_logic_vector(15 downto 0)   -- 16位输入数据
        );
    end component;
    
    -- 信号声明
    signal start_da : STD_LOGIC;
    signal eoc_da : STD_LOGIC;
    signal data, data_a, data_b : std_logic_vector(15 downto 0);
    
    signal timer0 : std_logic;
    --signal channel : integer range 0 to 1;
    signal state : integer range 0 to 2;
    signal waveform_val : std_logic_vector(7 downto 0);
    signal cnt : integer range 0 to 3;
    signal delay : integer range 0 to 63;
    
begin
    -- 实例化tlv5638组件并进行端口映射
    u1: tlv5638 PORT MAP(cs_o => cs_o, data_o => data_o, reset_i => reset_i, clk_i => clk_i, dclock_o => dclock_o, start_i => start_da, eoc_o => eoc_da, data_i => data);
    
    -- 进程处理，用于在设备初始化期间等待一段时间
    process(clk_i, reset_i)
    begin
        if reset_i = '1' then
            delay <= 0;
            timer0 <= '0';
				elsif clk_i'event and clk_i = '1' then --每次高电平delay+1，复位之后等待输入时钟64个周期--再等待2个输入时钟周期（初始化状态）
            if (delay = 63) then
                timer0 <= '1';
            else
                delay <= delay + 1;
            end if;
        end if;
    end process;

    -- 另一个进程处理，用于初始化和控制DAC
    process(reset_i, clk_i)
    begin
        if reset_i = '1' then
            state <= 0;
            channel <= 0;
        elsif clk_i'event and clk_i = '0' then --时钟下降沿触发
            case state is 
                when 0 =>    -- 等待设备初始化的一段时间
                    if (timer0 = '1') then
                        state <= 1;
                    end if;
                when 1 =>
                    data <= "1101000000000010";    -- 设置参考电压为2.048 V
                    start_da <= '1';
                    state <= 2;
                when 2 =>  --开始工作
                    if (eoc_da = '1') then --每次结束channel翻转一次，对应ab输出翻转一次
                        data_b <=  "0001" & datab;    -- 写入 DAC B 的数据到缓冲区
                        data_a <=  "1000" & dataa;    -- 同时写入新的 DAC A 值并更新 DAC A 和 B
                  
               
                        if (channel = 0) then
                            data <= data_b; --相当于t=0
                        else
                            data <= data_a; --相当于t=1
                        end if;
                        if (channel < 1) then
                            channel <= channel + 1;
                        else
                            channel <= 0;
                        end if;
                        start_da <= '1';
                        
                    else
                        start_da <= '0';  --如果还没结束，那么开始符号一直为低电平          
                    end if;
                when others => null;
            end case;
        end if;
    end process;

end;
