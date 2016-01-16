library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity mc is
  port(
        reset: in  std_logic;
        clock: in  std_logic;
        circ_src: in  std_logic_vector(0 to 4);
        circ_dst: out std_logic_vector(0 to 6)
      );
end mc;

architecture behaviour of mc is
  signal f0_dst: std_logic_vector(0 to 4);
  signal f0_src: std_logic_vector(0 to 6);

begin
  f0_dst(0) <= circ_src(0);
  f0_dst(1) <= circ_src(1);
  f0_dst(2) <= circ_src(2);
  f0_dst(3) <= circ_src(3);
  f0_dst(4) <= circ_src(4);
  circ_dst(0) <= f0_src(0);
  circ_dst(1) <= f0_src(1);
  circ_dst(2) <= f0_src(2);
  circ_dst(3) <= f0_src(3);
  circ_dst(4) <= f0_src(4);
  circ_dst(5) <= f0_src(5);
  circ_dst(6) <= f0_src(6);

  f0: process(f0_dst) begin
    f0_src <= (others => '-');
    if std_match(f0_dst, "0--10") then f0_src <= "0001010";
    elsif std_match(f0_dst, "-0-10") then f0_src <= "0001010";
    elsif std_match(f0_dst, "11-10") then f0_src <= "1001011";
    elsif std_match(f0_dst, "--011") then f0_src <= "0011011";
    elsif std_match(f0_dst, "--111") then f0_src <= "1011000";
    elsif std_match(f0_dst, "10-00") then f0_src <= "0100000";
    elsif std_match(f0_dst, "0--00") then f0_src <= "1100001";
    elsif std_match(f0_dst, "-1-00") then f0_src <= "1100001";
    elsif std_match(f0_dst, "--001") then f0_src <= "0100101";
    elsif std_match(f0_dst, "--101") then f0_src <= "1100110";
    end if;
  end process;
end behaviour;
