
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

entity cross_clk_bus is
generic 
(
   C_NUM_SYNC_REGS : integer := 3;
   C_DATA_WIDTH    : integer := 32
);
port 
(
   in_clk      : in std_logic;
   out_clk     : in std_logic;
   data_in     : in std_logic_vector(C_DATA_WIDTH-1 downto 0);
   data_out    : out std_logic_vector(C_DATA_WIDTH-1 downto 0)
);
end;

architecture rtl of cross_clk_bus is

attribute DowngradeIPIdentifiedWarnings: string;
attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

attribute ASYNC_REG : string;
attribute SHIFT_EXTRACT : string;
--------------------------------------------------------------
signal req_sync : std_logic_vector(C_NUM_SYNC_REGS-1 downto 0) := (others => '0');
signal ack_sync : std_logic_vector(C_NUM_SYNC_REGS-1 downto 0) := (others => '0');
attribute ASYNC_REG of req_sync : signal is "TRUE";
attribute SHIFT_EXTRACT of req_sync : signal is "NO";
attribute ASYNC_REG of ack_sync : signal is "TRUE";
attribute SHIFT_EXTRACT of ack_sync : signal is "NO";

signal data_int : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
signal in_clk_enable : std_logic;
signal ack_in_clk : std_logic;
signal ack_in_clk_d1 : std_logic := '0';
signal req : std_logic;
signal out_clk_enable : std_logic;
signal req_out_clk : std_logic;
signal req_out_clk_d1 : std_logic := '0';
signal ack : std_logic;

begin

--------------------------------------------------------------------
-- in clock domain
--------------------------------------------------------------------
in_clk_enable <= ack_in_clk_d1 xor ack_in_clk;
req <= not(ack_in_clk_d1);
process(in_clk)
begin
   if (rising_edge(in_clk)) then
      if in_clk_enable = '1' then
         data_int <= data_in;
      end if;
      ack_sync <= ack_sync(ack_sync'high-1 downto 0) & ack;
      ack_in_clk_d1 <= ack_in_clk;
   end if;  
end process;
ack_in_clk <= ack_sync(ack_sync'high);
--------------------------------------------------------------------
-- out clock domain
--------------------------------------------------------------------
out_clk_enable <= req_out_clk_d1 xor req_out_clk;
ack <= req_out_clk_d1;
process(out_clk)
begin
   if (rising_edge(out_clk)) then
      if out_clk_enable = '1' then
         data_out <= data_int;
      end if;   
      req_sync <= req_sync(req_sync'high-1 downto 0) & req;
      req_out_clk_d1 <= req_out_clk;
  end if;
end process;
req_out_clk <= req_sync(req_sync'high);

end rtl;