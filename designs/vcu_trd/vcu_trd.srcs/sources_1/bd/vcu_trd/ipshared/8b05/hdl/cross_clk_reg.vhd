-- (c) Copyright 2012 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity cross_clk_reg is
generic 
(
   C_NUM_SYNC_REGS : integer := 2;
   C_DATA_WIDTH    : integer := 32;
   C_REGISTER_INPUT : integer := 1 --1: register data_in by in_clk before register on data_out by out_clk. 0: in_clk is not used.
);
port 
(
   in_clk   : in std_logic;
   out_clk  : in std_logic;
   data_in  : in std_logic_vector(C_DATA_WIDTH-1 downto 0);
   data_out : out std_logic_vector(C_DATA_WIDTH-1 downto 0)
);

attribute shreg_extract : string;
attribute shreg_extract of cross_clk_reg : entity is "no"; -- do not use SLR16s

end;

architecture rtl of cross_clk_reg is

attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";  

signal data_in_reg  : std_logic_vector(C_DATA_WIDTH-1 downto 0);
signal data_in_int  : std_logic_vector(C_DATA_WIDTH-1 downto 0);

type slv_sync_array is array (natural range <>) of std_logic_vector(C_DATA_WIDTH-1 downto 0);
signal data_sync : slv_sync_array(C_NUM_SYNC_REGS-1 downto 0):=(others=>(others=>'0'));

attribute ASYNC_REG : string;
attribute SHIFT_EXTRACT : string;
--  attribute RLOC          : string;
attribute ASYNC_REG of data_sync : signal is "TRUE";
attribute SHIFT_EXTRACT of data_sync : signal is "NO";
--  attribute RLOC          of data_sync : signal is "X0Y0";
begin

gen_reg_input: if C_REGISTER_INPUT = 1 generate
   process(in_clk) is
   begin
      if (rising_edge(in_clk)) then
      	  data_in_reg <= data_in;
      end if;  
   end process;
   data_in_int <= data_in_reg;
end generate;

gen_not_reg_input: if C_REGISTER_INPUT = 0 generate
   data_in_int <= data_in;
end generate;


process(out_clk) is
begin
   if (rising_edge(out_clk)) then
      data_sync <= data_sync(data_sync'high-1 downto 0) & data_in_int;
   end if;  
end process;

data_out <= data_sync(data_sync'high);

end rtl;
