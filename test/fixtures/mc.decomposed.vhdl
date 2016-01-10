library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity mc is
  port(
        reset: in  std_logic;
        clock: in  std_logic;
        circ_ins: in  std_logic_vector(0 to 4);
        circ_outs: out std_logic_vector(0 to 6)
      );
end mc;

architecture behaviour of mc is
  signal f0_ins: std_logic_vector(0 to 2);
  signal f0_outs: std_logic_vector(0 to 1);
  signal f1_ins: std_logic_vector(0 to 3);
  signal f1_outs: std_logic_vector(0 to 6);
  signal f2_ins: std_logic_vector(0 to 1);
  signal f2_outs: std_logic_vector(0 to 1);
  signal f3_ins: std_logic_vector(0 to 1);
  signal f3_outs: std_logic_vector(0 to 1);

begin
  f0_ins(0) <= circ_ins(0);
  f0_ins(1) <= circ_ins(1);
  f2_ins(0) <= circ_ins(3);
  f2_ins(1) <= circ_ins(4);
  f0_ins(2) <= f2_outs(1);
  f1_ins(0) <= circ_ins(2);
  f1_ins(1) <= f0_outs(0);
  f1_ins(2) <= f0_outs(1);
  f1_ins(3) <= f2_outs(0);
  circ_outs(5) <= f3_outs(0);
  circ_outs(6) <= f3_outs(1);
  f3_ins(0) <= f1_outs(0);
  f3_ins(1) <= f1_outs(1);
  circ_outs(0) <= f1_outs(2);
  circ_outs(1) <= f1_outs(3);
  circ_outs(2) <= f1_outs(4);
  circ_outs(3) <= f1_outs(5);
  circ_outs(4) <= f1_outs(6);

  f0: process(f0_ins) begin
    f0_outs <= (others => '-');
    if std_match(f0_ins, "000") then f0_outs <= "10";
    elsif std_match(f0_ins, "001") then f0_outs <= "01";
    elsif std_match(f0_ins, "010") then f0_outs <= "10";
    elsif std_match(f0_ins, "011") then f0_outs <= "01";
    elsif std_match(f0_ins, "100") then f0_outs <= "00";
    elsif std_match(f0_ins, "101") then f0_outs <= "01";
    elsif std_match(f0_ins, "110") then f0_outs <= "10";
    elsif std_match(f0_ins, "111") then f0_outs <= "11";
    end if;
  end process;
  f1: process(f1_ins) begin
    f1_outs <= (others => '-');
    if std_match(f1_ins, "-000") then f1_outs <= "0001000";
    elsif std_match(f1_ins, "-010") then f1_outs <= "0100010";
    elsif std_match(f1_ins, "-100") then f1_outs <= "1011000";
    elsif std_match(f1_ins, "-110") then f1_outs <= "1110010";
    elsif std_match(f1_ins, "0001") then f1_outs <= "1001001";
    elsif std_match(f1_ins, "0011") then f1_outs <= "1100110";
    elsif std_match(f1_ins, "0101") then f1_outs <= "1001001";
    elsif std_match(f1_ins, "0111") then f1_outs <= "1100110";
    elsif std_match(f1_ins, "1001") then f1_outs <= "0111001";
    elsif std_match(f1_ins, "1011") then f1_outs <= "0010110";
    elsif std_match(f1_ins, "1101") then f1_outs <= "0111001";
    elsif std_match(f1_ins, "1111") then f1_outs <= "0010110";
    end if;
  end process;
  f2: process(f2_ins) begin
    f2_outs <= (others => '-');
    if std_match(f2_ins, "00") then f2_outs <= "00";
    elsif std_match(f2_ins, "01") then f2_outs <= "10";
    elsif std_match(f2_ins, "10") then f2_outs <= "01";
    elsif std_match(f2_ins, "11") then f2_outs <= "11";
    end if;
  end process;
  f3: process(f3_ins) begin
    f3_outs <= (others => '-');
    if std_match(f3_ins, "00") then f3_outs <= "00";
    elsif std_match(f3_ins, "10") then f3_outs <= "01";
    elsif std_match(f3_ins, "01") then f3_outs <= "10";
    elsif std_match(f3_ins, "11") then f3_outs <= "11";
    end if;
  end process;
end behaviour;
