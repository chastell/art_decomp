library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity bin is
  port(
        reset: in  std_logic;
        clock: in  std_logic;
        circ_src: in  std_logic_vector(0 to 5);
        circ_dst: out std_logic_vector(0 to 0)
      );
end bin;

architecture behaviour of bin is
  signal f0_dst: std_logic_vector(0 to 5);
  signal f0_src: std_logic_vector(0 to 0);

begin
  f0_dst(0) <= circ_src(0);
  f0_dst(1) <= circ_src(1);
  f0_dst(2) <= circ_src(2);
  f0_dst(3) <= circ_src(3);
  f0_dst(4) <= circ_src(4);
  f0_dst(5) <= circ_src(5);
  circ_dst(0) <= f0_src(0);

  f0: process(f0_dst) begin
    f0_src <= (others => '-');
    if std_match(f0_dst, "0101-0") then f0_src <= "0";
    elsif std_match(f0_dst, "010-00") then f0_src <= "0";
    elsif std_match(f0_dst, "-1000-") then f0_src <= "0";
    elsif std_match(f0_dst, "01011-") then f0_src <= "0";
    elsif std_match(f0_dst, "001--1") then f0_src <= "0";
    elsif std_match(f0_dst, "--11-1") then f0_src <= "0";
    elsif std_match(f0_dst, "1-110-") then f0_src <= "0";
    elsif std_match(f0_dst, "00---0") then f0_src <= "1";
    elsif std_match(f0_dst, "-1001-") then f0_src <= "1";
    elsif std_match(f0_dst, "1-10--") then f0_src <= "1";
    end if;
  end process;
end behaviour;
