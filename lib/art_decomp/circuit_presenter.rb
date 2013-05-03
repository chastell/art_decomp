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
    Hash[wires.flat_map do |wire|
      dst_object, dst_group, dst_index = wirings_meta_for wire.dst
      src_object, src_group, src_index = wirings_meta_for wire.src

      dst_label = wirings_label_for dst_object
      src_label = wirings_label_for src_object

      Array.new dst_object.widths(dst_group)[dst_index] do |n|
        dst_bindex = dst_object.widths(dst_group)[0...dst_index].reduce(0, :+) + n
        src_bindex = src_object.widths(src_group)[0...src_index].reduce(0, :+) + n
        ["#{dst_label}_#{dst_group}(#{dst_bindex})", "#{src_label}_#{src_group}(#{src_bindex})"]
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
end end
