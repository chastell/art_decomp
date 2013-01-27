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

  signal f0_i: std_logic_vector(0 to 4);
  signal f0_o: std_logic_vector(0 to 6);

begin
  f0_i(0) <= fsm_i(0);
  f0_i(1) <= fsm_i(1);
  f0_i(2) <= fsm_i(2);
  f0_i(3) <= fsm_q(0);
  f0_i(4) <= fsm_q(1);
  fsm_o(0) <= f0_o(0);
  fsm_o(1) <= f0_o(1);
  fsm_o(2) <= f0_o(2);
  fsm_o(3) <= f0_o(3);
  fsm_o(4) <= f0_o(4);
  fsm_p(0) <= f0_o(5);
  fsm_p(1) <= f0_o(6);

  process(reset, clock) begin
    if reset = '1' then fsm_q <= "00";
    elsif rising_edge(clock) then fsm_q <= fsm_p;
    end if;
  end process;

  f0: process(f0_i) begin
    f0_o <= (others => '-');
    if std_match(f0_i, "0--10") then f0_o <= "0001010";
    elsif std_match(f0_i, "-0-10") then f0_o <= "0001010";
    elsif std_match(f0_i, "11-10") then f0_o <= "1001011";
    elsif std_match(f0_i, "--011") then f0_o <= "0011011";
    elsif std_match(f0_i, "--111") then f0_o <= "1011000";
    elsif std_match(f0_i, "10-00") then f0_o <= "0100000";
    elsif std_match(f0_i, "0--00") then f0_o <= "1100001";
    elsif std_match(f0_i, "-1-00") then f0_o <= "1100001";
    elsif std_match(f0_i, "--001") then f0_o <= "0100101";
    elsif std_match(f0_i, "--101") then f0_o <= "1100110";
    end if;
  end process;
end behaviour;
