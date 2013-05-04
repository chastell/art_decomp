require 'erb'
require 'delegate'

module ArtDecomp class CircuitPresenter < SimpleDelegator
  def self.vhdl_for_circuit circuit, name
    new(circuit).vhdl name
  end

  def puts
    [:is, :os, :ps, :qs]
  end

  def vhdl name
    template = File.read 'lib/art_decomp/circuit_presenter.vhdl.erb'
    ERB.new(template, nil, '%').result binding
  end

  private

  Pin = Struct.new :object, :group, :index, :label

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
    Hash[wires.flat_map do |wire|
      dst = wirings_pin_for wire.dst
      src = wirings_pin_for wire.src
      wirings_for dst, src
    end]
  end

  def wirings_for dst, src
    Array.new dst.object.widths(dst.group)[dst.index] do |n|
      dst_bin = dst.object.widths(dst.group)[0...dst.index].reduce(0, :+) + n
      src_bin = src.object.widths(src.group)[0...src.index].reduce(0, :+) + n
      [
        "#{dst.label}_#{dst.group}(#{dst_bin})",
        "#{src.label}_#{src.group}(#{src_bin})",
      ]
    end
  end

  def wirings_label_for object
    case
    when self == object             then 'fsm'
    when functions.include?(object) then "f#{functions.index object}"
    when recoders.include?(object)  then "r#{recoders.index  object}"
    end
  end

  def wirings_meta_for put
    wirings_object_groups.each do |object, groups|
      groups.each do |group|
        object.send(group).each_index do |index|
          return [object, group, index] if object.send(group)[index].equal? put
        end
      end
    end
  end

  def wirings_object_groups
    @wirings_object_groups ||= {}.tap do |wog|
      wog[self] = [:is, :os, :ps, :qs]
      (functions + recoders).each { |object| wog[object] = [:is, :os] }
    end
  end

  def wirings_pin_for put
    Pin.new.tap do |pin|
      pin.object, pin.group, pin.index = wirings_meta_for put
      pin.label = wirings_label_for pin.object
    end
  end
end end
