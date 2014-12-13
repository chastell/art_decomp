library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity mc is
  port(
        reset: in  std_logic;
        clock: in  std_logic;
        fsm_is: in  std_logic_vector(0 to 2);
        fsm_os: out std_logic_vector(0 to 4)
      );
end mc;

architecture behaviour of mc is
  signal fsm_qs, fsm_ps: std_logic_vector(0 to 1);

  signal f0_is: std_logic_vector(0 to 4);
  signal f0_os: std_logic_vector(0 to 6);

begin
  f0_is(0) <= fsm_is(0);
  f0_is(1) <= fsm_is(1);
  f0_is(2) <= fsm_is(2);
  f0_is(3) <= fsm_qs(0);
  f0_is(4) <= fsm_qs(1);
  fsm_os(0) <= f0_os(0);
  fsm_os(1) <= f0_os(1);
  fsm_os(2) <= f0_os(2);
  fsm_os(3) <= f0_os(3);
  fsm_os(4) <= f0_os(4);
  fsm_ps(0) <= f0_os(5);
  fsm_ps(1) <= f0_os(6);

  process(reset, clock) begin
    if reset = '1' then fsm_qs <= "00";
    elsif rising_edge(clock) then fsm_qs <= fsm_ps;
    end if;
  end process;

  f0: process(f0_is) begin
    f0_os <= (others => '-');
    if std_match(f0_is, "0--10") then f0_os <= "0001010";
    elsif std_match(f0_is, "-0-10") then f0_os <= "0001010";
    elsif std_match(f0_is, "11-10") then f0_os <= "1001011";
    elsif std_match(f0_is, "--011") then f0_os <= "0011011";
    elsif std_match(f0_is, "--111") then f0_os <= "1011000";
    elsif std_match(f0_is, "10-00") then f0_os <= "0100000";
    elsif std_match(f0_is, "0--00") then f0_os <= "1100001";
    elsif std_match(f0_is, "-1-00") then f0_os <= "1100001";
    elsif std_match(f0_is, "--001") then f0_os <= "0100101";
    elsif std_match(f0_is, "--101") then f0_os <= "1100110";
    end if;
  end process;
end behaviour;
