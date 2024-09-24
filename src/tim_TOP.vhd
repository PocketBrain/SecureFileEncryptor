
LIBRARY IEEE;--! standard library IEEE (Institute of Electrical and Electronics Engineers)
USE IEEE.std_logic_1164.ALL;--! standard unresolved logic UX01ZWLH-
USE IEEE.numeric_std.ALL;--! for the signed, unsigned types and arithmetic ops

entity tim_TOP is
PORT (
  refclk : IN STD_LOGIC;--! reference clock expect 250Mhz
  rst    : IN STD_LOGIC--! sync active high reset. sync -> refclk
);
end entity tim_TOP;
architecture rtl of tim_TOP is
begin
end architecture rtl;
