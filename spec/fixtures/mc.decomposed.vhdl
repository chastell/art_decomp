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

  signal f0_is: std_logic_vector(0 to 2);
  signal f0_os: std_logic_vector(0 to 1);
  signal f1_is: std_logic_vector(0 to 3);
  signal f1_os: std_logic_vector(0 to 6);
  signal r0_is: std_logic_vector(0 to 1);
  signal r0_os: std_logic_vector(0 to 1);
  signal r1_is: std_logic_vector(0 to 1);
  signal r1_os: std_logic_vector(0 to 1);

begin
  f0_is(0) <= fsm_is(0);
  f0_is(1) <= fsm_is(1);
  f0_is(2) <= r0_os(1);
  f1_is(0) <= fsm_is(2);
  f1_is(1) <= f0_os(0);
  f1_is(2) <= f0_os(1);
  f1_is(3) <= r0_os(0);
  fsm_ps(0) <= r1_os(0);
  fsm_ps(1) <= r1_os(1);
  fsm_os(0) <= f1_os(2);
  fsm_os(1) <= f1_os(3);
  fsm_os(2) <= f1_os(4);
  fsm_os(3) <= f1_os(5);
  fsm_os(4) <= f1_os(6);

  process(reset, clock) begin
    if reset = '1' then fsm_qs <= "00";
    elsif rising_edge(clock) then fsm_qs <= fsm_ps;
    end if;
  end process;

  f0: process(f0_is) begin
    f0_os <= (others => '-');
    if std_match(f0_is, "000") then f0_os <= "10";
    elsif std_match(f0_is, "001") then f0_os <= "01";
    elsif std_match(f0_is, "010") then f0_os <= "10";
    elsif std_match(f0_is, "011") then f0_os <= "01";
    elsif std_match(f0_is, "100") then f0_os <= "00";
    elsif std_match(f0_is, "101") then f0_os <= "01";
    elsif std_match(f0_is, "110") then f0_os <= "10";
    elsif std_match(f0_is, "111") then f0_os <= "11";
    end if;
  end process;
  f1: process(f1_is) begin
    f1_os <= (others => '-');
    if std_match(f1_is, "-000") then f1_os <= "0001000";
    elsif std_match(f1_is, "-010") then f1_os <= "0100010";
    elsif std_match(f1_is, "-100") then f1_os <= "1011000";
    elsif std_match(f1_is, "-110") then f1_os <= "1110010";
    elsif std_match(f1_is, "0001") then f1_os <= "1001001";
    elsif std_match(f1_is, "0011") then f1_os <= "1100110";
    elsif std_match(f1_is, "0101") then f1_os <= "1001001";
    elsif std_match(f1_is, "0111") then f1_os <= "1100110";
    elsif std_match(f1_is, "1001") then f1_os <= "0111001";
    elsif std_match(f1_is, "1011") then f1_os <= "0010110";
    elsif std_match(f1_is, "1101") then f1_os <= "0111001";
    elsif std_match(f1_is, "1111") then f1_os <= "0010110";
    end if;
  end process;
end behaviour;
