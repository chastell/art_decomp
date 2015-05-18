library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity mc is
  port(
        reset: in  std_logic;
        clock: in  std_logic;
        circ_ins: in  std_logic_vector(0 to 2);
        circ_outs: out std_logic_vector(0 to 4)
      );
end mc;

architecture behaviour of mc is
  signal circ_states, circ_next_states: std_logic_vector(0 to 1);

  signal f0_ins: std_logic_vector(0 to 4);
  signal f0_outs: std_logic_vector(0 to 6);

begin
  f0_ins(0) <= circ_ins(0);
  f0_ins(1) <= circ_ins(1);
  f0_ins(2) <= circ_ins(2);
  f0_ins(3) <= circ_states(0);
  f0_ins(4) <= circ_states(1);
  circ_outs(0) <= f0_outs(0);
  circ_outs(1) <= f0_outs(1);
  circ_outs(2) <= f0_outs(2);
  circ_outs(3) <= f0_outs(3);
  circ_outs(4) <= f0_outs(4);
  circ_next_states(0) <= f0_outs(5);
  circ_next_states(1) <= f0_outs(6);

  process(reset, clock) begin
    if reset = '1' then circ_states <= "00";
    elsif rising_edge(clock) then circ_states <= circ_next_states;
    end if;
  end process;

  f0: process(f0_ins) begin
    f0_outs <= (others => '-');
    if std_match(f0_ins, "0--10") then f0_outs <= "0001010";
    elsif std_match(f0_ins, "-0-10") then f0_outs <= "0001010";
    elsif std_match(f0_ins, "11-10") then f0_outs <= "1001011";
    elsif std_match(f0_ins, "--011") then f0_outs <= "0011011";
    elsif std_match(f0_ins, "--111") then f0_outs <= "1011000";
    elsif std_match(f0_ins, "10-00") then f0_outs <= "0100000";
    elsif std_match(f0_ins, "0--00") then f0_outs <= "1100001";
    elsif std_match(f0_ins, "-1-00") then f0_outs <= "1100001";
    elsif std_match(f0_ins, "--001") then f0_outs <= "0100101";
    elsif std_match(f0_ins, "--101") then f0_outs <= "1100110";
    end if;
  end process;
end behaviour;
