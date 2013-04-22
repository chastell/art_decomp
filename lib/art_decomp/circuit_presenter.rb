require 'erb'

module ArtDecomp class CircuitPresenter
  def self.vhdl_for_circuit circuit, name
    new(circuit).vhdl name
  end

  def initialize circuit
    @circuit = circuit
  end

  def vhdl name
    template = File.read 'lib/art_decomp/circuit_presenter.vhdl.erb'
    ERB.new(template, nil, '%').result binding
  end

  attr_reader :circuit
  private     :circuit

  private

  def functions
    @functions ||= circuit.functions.map { |fun| FunctionPresenter.new fun }
  end

  def fsm_is_width
    circuit.widths(:is).reduce 0, :+
  end

  def fsm_os_width
    circuit.widths(:os).reduce 0, :+
  end

  def fsm_qs_width
    circuit.widths(:qs).reduce 0, :+
  end

  def recoders
    circuit.recoders
  end

  def reset_bits
    '0' * fsm_qs_width
  end

  def wirings
    Hash[circuit.wirings.flat_map do |dst, src|
      dst_label = case
                  when circuit == dst.object then 'fsm'
                  when circuit.functions.include?(dst.object) then "f#{circuit.functions.index dst.object}"
                  when circuit.recoders.include?(dst.object)  then "r#{circuit.recoders.index  dst.object}"
                  end

      src_label = case
                  when circuit == src.object then 'fsm'
                  when circuit.functions.include?(src.object) then "f#{circuit.functions.index src.object}"
                  when circuit.recoders.include?(src.object)  then "r#{circuit.recoders.index  src.object}"
                  end

      Array.new dst.object.widths(dst.group)[dst.index] do |n|
        dst_index = dst.object.widths(dst.group)[0...dst.index].reduce(0, :+) + n
        src_index = src.object.widths(src.group)[0...src.index].reduce(0, :+) + n
        ["#{dst_label}_#{dst.group}(#{dst_index})", "#{src_label}_#{src.group}(#{src_index})"]
      end
    end]
  end
end end
