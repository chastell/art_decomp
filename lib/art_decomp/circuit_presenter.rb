require 'erb'
require 'delegate'

module ArtDecomp class CircuitPresenter < SimpleDelegator
  def self.vhdl_for_circuit circuit, name
    new(circuit).vhdl name
  end

  def vhdl name
    template = File.read 'lib/art_decomp/circuit_presenter.vhdl.erb'
    ERB.new(template, nil, '%').result binding
  end

  private

  def functions
    @functions ||= super.map { |fun| FunctionPresenter.new fun }
  end

  def fsm_is_width
    widths(:is).reduce 0, :+
  end

  def fsm_os_width
    widths(:os).reduce 0, :+
  end

  def fsm_qs_width
    widths(:qs).reduce 0, :+
  end

  def reset_bits
    '0' * fsm_qs_width
  end

  def wirings
    Hash[super.flat_map do |dst, src|
      dst_label = case
                  when self == dst.object             then 'fsm'
                  when functions.include?(dst.object) then "f#{functions.index dst.object}"
                  when recoders.include?(dst.object)  then "r#{recoders.index  dst.object}"
                  end

      src_label = case
                  when self == src.object             then 'fsm'
                  when functions.include?(src.object) then "f#{functions.index src.object}"
                  when recoders.include?(src.object)  then "r#{recoders.index  src.object}"
                  end

      Array.new dst.object.widths(dst.group)[dst.index] do |n|
        dst_index = dst.object.widths(dst.group)[0...dst.index].reduce(0, :+) + n
        src_index = src.object.widths(src.group)[0...src.index].reduce(0, :+) + n
        ["#{dst_label}_#{dst.group}(#{dst_index})", "#{src_label}_#{src.group}(#{src_index})"]
      end
    end]
  end
end end
