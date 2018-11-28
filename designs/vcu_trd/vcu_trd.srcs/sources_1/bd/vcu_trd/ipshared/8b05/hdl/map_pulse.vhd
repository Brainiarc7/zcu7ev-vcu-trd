-- VHDL Entity Interfaces.map_pulse.symbol
--
-- Created:
--          by - xue_ch.UNKNOWN (SGA250765)
--          at - 06:53:46 06-Jun-14
--
-- Generated by Mentor Graphics' HDL Designer(TM) 2010.2 (Build 21)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY map_pulse IS
   generic ( 
       C_NUM_SYNC_REGS : integer := 3 
		);
   PORT( 
      clk_i    : IN     std_logic;
      clk_o   : IN     std_logic;
      pls_i    : IN     std_logic;
      pls_o   : OUT    std_logic
   );

-- Declarations

END map_pulse ;

ARCHITECTURE struct OF map_pulse IS

component cross_clk_reg is
generic 
(
   C_NUM_SYNC_REGS : integer := 2;
   C_DATA_WIDTH    : integer := 32;
   C_REGISTER_INPUT : integer := 1
);
port 
(
   in_clk      : in std_logic;
   out_clk      : in std_logic;
   data_in  : in std_logic_vector(C_DATA_WIDTH-1 downto 0);
   data_out : out std_logic_vector(C_DATA_WIDTH-1 downto 0)
);
end component;

   signal pls_i_d1   : std_logic := '0';
   signal pls_i_rise : std_logic := '0';
   SIGNAL req         : std_logic := '0';
   SIGNAL req_synced  : std_logic := '0';
   SIGNAL req_synced_d1  : std_logic := '0';

BEGIN

   pls_i_rise <= pls_i and (not pls_i_d1);

   --convert pls_i to level toggling
   proc0: PROCESS (clk_i)BEGIN
      IF (clk_i'EVENT AND clk_i='1') THEN
			--delay 
			pls_i_d1 <= pls_i;
			--use rise edge to toggle req
			IF (pls_i_rise = '1') THEN
               req <= not req;
			end if;
      END IF;
   END PROCESS proc0;

   --sync req to clk_o domain
   req_sync_to_out_clk : cross_clk_reg
   generic map
   (  C_NUM_SYNC_REGS => C_NUM_SYNC_REGS,
      C_DATA_WIDTH    => 1,
      C_REGISTER_INPUT => 0
   ) port map (
      in_clk         => clk_i,
      out_clk         => clk_o,
      data_in(0)  => req,
      data_out(0) => req_synced);

   --re-generate the pulse in clk_o domain: single cycle pulse
   proc1: PROCESS (clk_o)BEGIN
      IF (clk_o'EVENT AND clk_o='1') THEN
			--delay
            req_synced_d1 <= req_synced;
      END IF;
   END PROCESS proc1;

   pls_o <= req_synced XOR req_synced_d1;

END struct;