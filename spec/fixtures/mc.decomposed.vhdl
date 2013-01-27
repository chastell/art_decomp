library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity mc is
  port(
        reset: in  std_logic;
        clock: in  std_logic;
        fsm_i: in  std_logic_vector(0 to 2);
        fsm_o: out std_logic_vector(0 to 4)
      );
end mc;

architecture behaviour of mc is
  signal fsm_q, fsm_p: std_logic_vector(0 to 1);

  signal f0_i: std_logic_vector(0 to 2);
  signal f0_o: std_logic_vector(0 to 1);
  signal f1_i: std_logic_vector(0 to 3);
  signal f1_o: std_logic_vector(0 to 6);
  signal r0_i: std_logic_vector(0 to 1);
  signal r0_o: std_logic_vector(0 to 1);
  signal r1_i: std_logic_vector(0 to 1);
  signal r1_o: std_logic_vector(0 to 1);

begin
  f0_i(0) <= fsm_i(0);
  f0_i(1) <= fsm_i(1);
  f0_i(2) <= r0_o(1);
  f1_i(0) <= fsm_i(2);
  f1_i(1) <= f0_o(0);
  f1_i(2) <= f0_o(1);
  f1_i(3) <= r0_o(0);
  fsm_p(0) <= r1_o(0);
  fsm_p(1) <= r1_o(1);
  fsm_o(0) <= f1_o(2);
  fsm_o(1) <= f1_o(3);
  fsm_o(2) <= f1_o(4);
  fsm_o(3) <= f1_o(5);
  fsm_o(4) <= f1_o(6);

  process(reset, clock) begin
    if reset = '1' then fsm_q <= "00";
    elsif rising_edge(clock) then fsm_q <= fsm_p;
    end if;
  end process;

  f0: process(f0_i) begin
    f0_o <= (others => '-');
    if std_match(f0_i, "000") then f0_o <= "10";
    elsif std_match(f0_i, "001") then f0_o <= "01";
    elsif std_match(f0_i, "010") then f0_o <= "10";
    elsif std_match(f0_i, "011") then f0_o <= "01";
    elsif std_match(f0_i, "100") then f0_o <= "00";
    elsif std_match(f0_i, "101") then f0_o <= "01";
    elsif std_match(f0_i, "110") then f0_o <= "10";
    elsif std_match(f0_i, "111") then f0_o <= "11";
    end if;
  end process;
  f1: process(f1_i) begin
    f1_o <= (others => '-');
    if std_match(f1_i, "-000") then f1_o <= "0001000";
    elsif std_match(f1_i, "-010") then f1_o <= "0100010";
    elsif std_match(f1_i, "-100") then f1_o <= "1011000";
    elsif std_match(f1_i, "-110") then f1_o <= "1110010";
    elsif std_match(f1_i, "0001") then f1_o <= "1001001";
    elsif std_match(f1_i, "0011") then f1_o <= "1100110";
    elsif std_match(f1_i, "0101") then f1_o <= "1001001";
    elsif std_match(f1_i, "0111") then f1_o <= "1100110";
    elsif std_match(f1_i, "1001") then f1_o <= "0111001";
    elsif std_match(f1_i, "1011") then f1_o <= "0010110";
    elsif std_match(f1_i, "1101") then f1_o <= "0111001";
    elsif std_match(f1_i, "1111") then f1_o <= "0010110";
    end if;
  end process;
end behaviour;
