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
  signal f0_dst: std_logic_vector(0 to 2);
  signal f0_src: std_logic_vector(0 to 0);
  signal f1_dst: std_logic_vector(0 to 3);
  signal f1_src: std_logic_vector(0 to 0);

begin
  f0_dst(0) <= circ_src(2);
  f0_dst(1) <= circ_src(3);
  f0_dst(2) <= circ_src(4);
  f1_dst(0) <= circ_src(0);
  f1_dst(1) <= circ_src(1);
  f1_dst(2) <= circ_src(5);
  f1_dst(3) <= f0_src(0);
  circ_dst(0) <= f1_src(0);

  f0: process(f0_dst) begin
    f0_src <= (others => '-');
    if std_match(f0_dst, "01-") then f0_src <= "0";
    elsif std_match(f0_dst, "0-0") then f0_src <= "0";
    elsif std_match(f0_dst, "000") then f0_src <= "0";
    elsif std_match(f0_dst, "011") then f0_src <= "0";
    elsif std_match(f0_dst, "11-") then f0_src <= "0";
    elsif std_match(f0_dst, "110") then f0_src <= "0";
    elsif std_match(f0_dst, "001") then f0_src <= "1";
    elsif std_match(f0_dst, "10-") then f0_src <= "1";
    end if;
  end process;
  f1: process(f1_dst) begin
    f1_src <= (others => '-');
    if std_match(f1_dst, "0100") then f1_src <= "0";
    elsif std_match(f1_dst, "0100") then f1_src <= "0";
    elsif std_match(f1_dst, "-1-0") then f1_src <= "0";
    elsif std_match(f1_dst, "01-0") then f1_src <= "0";
    elsif std_match(f1_dst, "001-") then f1_src <= "0";
    elsif std_match(f1_dst, "--10") then f1_src <= "0";
    elsif std_match(f1_dst, "1--0") then f1_src <= "0";
    elsif std_match(f1_dst, "000-") then f1_src <= "1";
    elsif std_match(f1_dst, "-1-1") then f1_src <= "1";
    elsif std_match(f1_dst, "1--1") then f1_src <= "1";
    end if;
  end process;
end behaviour;
