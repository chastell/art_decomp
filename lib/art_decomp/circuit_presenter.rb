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
    object_groups = { self => [:is, :os, :ps, :qs] }
    functions.each { |fun| object_groups[fun] = [:is, :os] }
    recoders.each  { |rec| object_groups[rec] = [:is, :os] }
    Hash[wires.flat_map do |wire|
      dst_object, dst_group, dst_index = catch :found do
        object_groups.each do |obj, groups|
          groups.each do |grp|
            obj.send(grp).each_index do |idx|
              throw :found, [obj, grp, idx] if obj.send(grp)[idx].equal? wire.dst
            end
          end
        end
      end

      src_object, src_group, src_index = catch :found do
        object_groups.each do |obj, groups|
          groups.each do |grp|
            obj.send(grp).each_index do |idx|
              throw :found, [obj, grp, idx] if obj.send(grp)[idx].equal? wire.src
            end
          end
        end
      end

      dst_label = case
                  when self == dst_object             then 'fsm'
                  when functions.include?(dst_object) then "f#{functions.index dst_object}"
                  when recoders.include?(dst_object)  then "r#{recoders.index  dst_object}"
                  end

      src_label = case
                  when self == src_object             then 'fsm'
                  when functions.include?(src_object) then "f#{functions.index src_object}"
                  when recoders.include?(src_object)  then "r#{recoders.index  src_object}"
                  end

      Array.new dst_object.widths(dst_group)[dst_index] do |n|
        dst_bindex = dst_object.widths(dst_group)[0...dst_index].reduce(0, :+) + n
        src_bindex = src_object.widths(src_group)[0...src_index].reduce(0, :+) + n
        ["#{dst_label}_#{dst_group}(#{dst_bindex})", "#{src_label}_#{src_group}(#{src_bindex})"]
      end
    end]
  end
end end
