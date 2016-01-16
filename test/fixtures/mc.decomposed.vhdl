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
  signal f0_dst: std_logic_vector(0 to 2);
  signal f0_src: std_logic_vector(0 to 1);
  signal f1_dst: std_logic_vector(0 to 3);
  signal f1_src: std_logic_vector(0 to 6);
  signal f2_dst: std_logic_vector(0 to 1);
  signal f2_src: std_logic_vector(0 to 1);
  signal f3_dst: std_logic_vector(0 to 1);
  signal f3_src: std_logic_vector(0 to 1);

begin
  f0_dst(0) <= circ_src(0);
  f0_dst(1) <= circ_src(1);
  f2_dst(0) <= circ_src(3);
  f2_dst(1) <= circ_src(4);
  f0_dst(2) <= f2_src(1);
  f1_dst(0) <= circ_src(2);
  f1_dst(1) <= f0_src(0);
  f1_dst(2) <= f0_src(1);
  f1_dst(3) <= f2_src(0);
  circ_dst(5) <= f3_src(0);
  circ_dst(6) <= f3_src(1);
  f3_dst(0) <= f1_src(0);
  f3_dst(1) <= f1_src(1);
  circ_dst(0) <= f1_src(2);
  circ_dst(1) <= f1_src(3);
  circ_dst(2) <= f1_src(4);
  circ_dst(3) <= f1_src(5);
  circ_dst(4) <= f1_src(6);

  f0: process(f0_dst) begin
    f0_src <= (others => '-');
    if std_match(f0_dst, "000") then f0_src <= "10";
    elsif std_match(f0_dst, "001") then f0_src <= "01";
    elsif std_match(f0_dst, "010") then f0_src <= "10";
    elsif std_match(f0_dst, "011") then f0_src <= "01";
    elsif std_match(f0_dst, "100") then f0_src <= "00";
    elsif std_match(f0_dst, "101") then f0_src <= "01";
    elsif std_match(f0_dst, "110") then f0_src <= "10";
    elsif std_match(f0_dst, "111") then f0_src <= "11";
    end if;
  end process;
  f1: process(f1_dst) begin
    f1_src <= (others => '-');
    if std_match(f1_dst, "-000") then f1_src <= "0001000";
    elsif std_match(f1_dst, "-010") then f1_src <= "0100010";
    elsif std_match(f1_dst, "-100") then f1_src <= "1011000";
    elsif std_match(f1_dst, "-110") then f1_src <= "1110010";
    elsif std_match(f1_dst, "0001") then f1_src <= "1001001";
    elsif std_match(f1_dst, "0011") then f1_src <= "1100110";
    elsif std_match(f1_dst, "0101") then f1_src <= "1001001";
    elsif std_match(f1_dst, "0111") then f1_src <= "1100110";
    elsif std_match(f1_dst, "1001") then f1_src <= "0111001";
    elsif std_match(f1_dst, "1011") then f1_src <= "0010110";
    elsif std_match(f1_dst, "1101") then f1_src <= "0111001";
    elsif std_match(f1_dst, "1111") then f1_src <= "0010110";
    end if;
  end process;
  f2: process(f2_dst) begin
    f2_src <= (others => '-');
    if std_match(f2_dst, "00") then f2_src <= "00";
    elsif std_match(f2_dst, "01") then f2_src <= "10";
    elsif std_match(f2_dst, "10") then f2_src <= "01";
    elsif std_match(f2_dst, "11") then f2_src <= "11";
    end if;
  end process;
  f3: process(f3_dst) begin
    f3_src <= (others => '-');
    if std_match(f3_dst, "00") then f3_src <= "00";
    elsif std_match(f3_dst, "10") then f3_src <= "01";
    elsif std_match(f3_dst, "01") then f3_src <= "10";
    elsif std_match(f3_dst, "11") then f3_src <= "11";
    end if;
  end process;
end behaviour;
