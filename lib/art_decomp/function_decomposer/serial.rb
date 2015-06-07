require 'anima'
require 'delegate'
require_relative '../circuit'
require_relative '../function'
require_relative '../puts'
require_relative '../wirer'
require_relative '../wires'

module ArtDecomp
  module FunctionDecomposer
    class Serial < SimpleDelegator
      def self.decompose(function)
        new(function).decompositions
      end

      def decompositions
        Enumerator.new do |yielder|
          uv_ins.each do |u_ins, v_ins|
            dec = Decomposition.new(function: function,
                                    u_ins: u_ins, v_ins: v_ins)
            yielder << dec.circuit if dec.sensible?
          end
        end
      end

      private

      alias_method :function, :__getobj__

      def uv_ins
        f_seps = outs.seps
        sorted = ins.sort_by { |put| (f_seps - put.seps).count }
        Enumerator.new do |yielder|
          [3, 2].each do |g_width|
            sorted.combination(g_width).each do |v_ins|
              yielder << [Puts.new(ins.puts - v_ins), Puts.new(v_ins)]
            end
          end
        end
      end

      class Decomposition
        include Anima.new(:function, :u_ins, :v_ins)

        def circuit
          Circuit.new(functions: [g, h], wires: wires)
        end

        def sensible?
          g.outs.binwidth < g.ins.binwidth
        end

        private

        def g
          @g ||= Function.new(ins: v_ins, outs: g_outs)
        end

        def g_outs
          @g_outs ||= Puts.from_seps(allowed:  v_ins.seps,
                                     required: function.outs.seps - u_ins.seps,
                                     size:     function.ins.first.size)
        end

        def h
          @h ||= Function.new(ins: u_ins + g_outs, outs: function.outs)
        end

        def g_h_array
          g_outs.map.with_index do |put, i|
            g_offset = g_outs[0...i].binwidth
            h_offset = u_ins.binwidth + g_offset
            [[g, :outs, i,              put.binwidth, g_offset],
             [h, :ins,  u_ins.size + i, put.binwidth, h_offset]]
          end
        end

        def wires
          Wirer.new(g, ins: function.ins, outs: function.outs).wires +
            Wirer.new(h, ins: function.ins, outs: function.outs).wires +
            Wires.from_array(g_h_array)
        end
      end
    end
  end
end
