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
  signal f0_ins: std_logic_vector(0 to 5);
  signal f0_outs: std_logic_vector(0 to 0);

begin
  f0_ins(0) <= fsm_ins(0);
  f0_ins(1) <= fsm_ins(1);
  f0_ins(2) <= fsm_ins(2);
  f0_ins(3) <= fsm_ins(3);
  f0_ins(4) <= fsm_ins(4);
  f0_ins(5) <= fsm_ins(5);
  fsm_outs(0) <= f0_outs(0);

  f0: process(f0_ins) begin
    f0_outs <= (others => '-');
    if std_match(f0_ins, "0101-0") then f0_outs <= "0";
    elsif std_match(f0_ins, "010-00") then f0_outs <= "0";
    elsif std_match(f0_ins, "-1000-") then f0_outs <= "0";
    elsif std_match(f0_ins, "01011-") then f0_outs <= "0";
    elsif std_match(f0_ins, "001--1") then f0_outs <= "0";
    elsif std_match(f0_ins, "--11-1") then f0_outs <= "0";
    elsif std_match(f0_ins, "1-110-") then f0_outs <= "0";
    elsif std_match(f0_ins, "00---0") then f0_outs <= "1";
    elsif std_match(f0_ins, "-1001-") then f0_outs <= "1";
    elsif std_match(f0_ins, "1-10--") then f0_outs <= "1";
    end if;
  end process;
end behaviour;
