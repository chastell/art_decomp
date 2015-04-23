library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity mc is
  port(
        reset: in  std_logic;
        clock: in  std_logic;
        fsm_ins: in  std_logic_vector(0 to 2);
        fsm_outs: out std_logic_vector(0 to 4)
      );
end mc;

architecture behaviour of mc is
  signal fsm_states, fsm_next_states: std_logic_vector(0 to 1);

  signal f0_ins: std_logic_vector(0 to 2);
  signal f0_outs: std_logic_vector(0 to 1);
  signal f1_ins: std_logic_vector(0 to 3);
  signal f1_outs: std_logic_vector(0 to 6);
  signal r0_ins: std_logic_vector(0 to 1);
  signal r0_outs: std_logic_vector(0 to 1);
  signal r1_ins: std_logic_vector(0 to 1);
  signal r1_outs: std_logic_vector(0 to 1);

begin
  f0_ins(0) <= fsm_ins(0);
  f0_ins(1) <= fsm_ins(1);
  r0_ins(0) <= fsm_states(0);
  r0_ins(1) <= fsm_states(1);
  f0_ins(2) <= r0_outs(1);
  f1_ins(0) <= fsm_ins(2);
  f1_ins(1) <= f0_outs(0);
  f1_ins(2) <= f0_outs(1);
  f1_ins(3) <= r0_outs(0);
  fsm_next_states(0) <= r1_outs(0);
  fsm_next_states(1) <= r1_outs(1);
  r1_ins(0) <= f1_outs(0);
  r1_ins(1) <= f1_outs(1);
  fsm_outs(0) <= f1_outs(2);
  fsm_outs(1) <= f1_outs(3);
  fsm_outs(2) <= f1_outs(4);
  fsm_outs(3) <= f1_outs(5);
  fsm_outs(4) <= f1_outs(6);

  process(reset, clock) begin
    if reset = '1' then fsm_states <= "00";
    elsif rising_edge(clock) then fsm_states <= fsm_next_states;
    end if;
  end process;

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
end behaviour;
