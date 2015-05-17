library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity bin is
  port(
        reset: in  std_logic;
        clock: in  std_logic;
        fsm_ins: in  std_logic_vector(0 to 5);
        fsm_outs: out std_logic_vector(0 to 0)
      );
end bin;

architecture behaviour of bin is
  signal f0_ins: std_logic_vector(0 to 2);
  signal f0_outs: std_logic_vector(0 to 0);
  signal f1_ins: std_logic_vector(0 to 3);
  signal f1_outs: std_logic_vector(0 to 0);

begin
  f0_ins(0) <= fsm_ins(2);
  f0_ins(1) <= fsm_ins(3);
  f0_ins(2) <= fsm_ins(4);
  f1_ins(0) <= fsm_ins(0);
  f1_ins(1) <= fsm_ins(1);
  f1_ins(2) <= fsm_ins(5);
  f1_ins(3) <= f0_outs(0);
  fsm_outs(0) <= f1_outs(0);

  f0: process(f0_ins) begin
    f0_outs <= (others => '-');
    if std_match(f0_ins, "01-") then f0_outs <= "0";
    elsif std_match(f0_ins, "0-0") then f0_outs <= "0";
    elsif std_match(f0_ins, "000") then f0_outs <= "0";
    elsif std_match(f0_ins, "011") then f0_outs <= "0";
    elsif std_match(f0_ins, "11-") then f0_outs <= "0";
    elsif std_match(f0_ins, "110") then f0_outs <= "0";
    elsif std_match(f0_ins, "001") then f0_outs <= "1";
    elsif std_match(f0_ins, "10-") then f0_outs <= "1";
    end if;
  end process;
  f1: process(f1_ins) begin
    f1_outs <= (others => '-');
    if std_match(f1_ins, "0100") then f1_outs <= "0";
    elsif std_match(f1_ins, "0100") then f1_outs <= "0";
    elsif std_match(f1_ins, "-1-0") then f1_outs <= "0";
    elsif std_match(f1_ins, "01-0") then f1_outs <= "0";
    elsif std_match(f1_ins, "001-") then f1_outs <= "0";
    elsif std_match(f1_ins, "--10") then f1_outs <= "0";
    elsif std_match(f1_ins, "1--0") then f1_outs <= "0";
    elsif std_match(f1_ins, "000-") then f1_outs <= "1";
    elsif std_match(f1_ins, "-1-1") then f1_outs <= "1";
    elsif std_match(f1_ins, "1--1") then f1_outs <= "1";
    end if;
  end process;
end behaviour;
