require 'erb'

module ArtDecomp class CircuitPresenter
  def initialize circuit, opts = {}
    @circuit    = circuit
    @fp_factory = opts.fetch(:fp_factory) { FunctionPresenter }
  end

  def vhdl name
    template = File.read 'lib/art_decomp/circuit_presenter.vhdl.erb'
    ERB.new(template, nil, '%').result binding
  end

  attr_reader :circuit, :fp_factory
  private     :circuit, :fp_factory

  private

  def functions
    @functions ||= circuit.functions.map { |fun| fp_factory.new fun }
  end

  def fsm_i_width
    circuit.i_widths.inject 0, :+
  end

  def fsm_o_width
    circuit.o_widths.inject 0, :+
  end

  def fsm_q_width
    circuit.q_widths.inject 0, :+
  end

  def recoders
    circuit.recoders
  end

  def reset_bits
    '0' * fsm_q_width
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

      Array.new dst.object.send("#{dst.group}_widths")[dst.index] do |n|
        dst_index = dst.object.send("#{dst.group}_widths")[0...dst.index].inject(0, :+) + n
        src_index = src.object.send("#{src.group}_widths")[0...src.index].inject(0, :+) + n
        ["#{dst_label}_#{dst.group}(#{dst_index})", "#{src_label}_#{src.group}(#{src_index})"]
      end
    end]
  end
end end
