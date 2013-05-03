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

  Pin = Struct.new :object, :group, :index, :label

  def wirings
    Hash[wires.flat_map do |wire|
      dst = wirings_pin_for wire.dst
      src = wirings_pin_for wire.src

      Array.new dst.object.widths(dst.group)[dst.index] do |n|
        dst_bindex = dst.object.widths(dst.group)[0...dst.index].reduce(0, :+) + n
        src_bindex = src.object.widths(src.group)[0...src.index].reduce(0, :+) + n
        ["#{dst.label}_#{dst.group}(#{dst_bindex})", "#{src.label}_#{src.group}(#{src_bindex})"]
      end
    end]
  end

  def wirings_label_for object
    case
    when self == object             then 'fsm'
    when functions.include?(object) then "f#{functions.index object}"
    when recoders.include?(object)  then "r#{recoders.index  object}"
    end
  end

  def wirings_meta_for put
    object_groups = { self => [:is, :os, :ps, :qs] }
    functions.each { |fun| object_groups[fun] = [:is, :os] }
    recoders.each  { |rec| object_groups[rec] = [:is, :os] }
    object_groups.each do |obj, groups|
      groups.each do |grp|
        obj.send(grp).each_index do |idx|
          return [obj, grp, idx] if obj.send(grp)[idx].equal? put
        end
      end
    end
  end

  def wirings_pin_for put
    pin = Pin.new
    pin.object, pin.group, pin.index = wirings_meta_for put
    pin.label = wirings_label_for pin.object
    pin
  end
end end
