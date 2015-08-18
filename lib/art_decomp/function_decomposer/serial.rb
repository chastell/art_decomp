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
          each_uv do |u_ins, v_ins|
            dec = Decomposition.new(function: function,
                                    u_ins: u_ins, v_ins: v_ins)
            yielder << dec.circuit if dec.sensible?
          end
        end
      end

      private

      alias_method :function, :__getobj__

      def each_uv                              # rubocop:disable Metrics/AbcSize
        sorted = ins.sort_by { |put| (outs.seps & put.seps).count }
        [3, 2].each do |g_width|
          sorted.puts.combination(g_width).each do |v_ins|
            yield Puts.new(ins.puts - v_ins), Puts.new(v_ins)
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
                                     size:     function.size)
        end

        def h
          @h ||= Function.new(ins: u_ins + g_outs, outs: function.outs)
        end

        def g_h_array
          g_outs.map { |put| [[g, :outs, g.outs, put], [h, :ins, h.ins, put]] }
        end

        def wires                              # rubocop:disable Metrics/AbcSize
          Wires.from_array(g_h_array) +
            Wirer.wires(g, ins: function.ins, outs: function.outs) +
            Wirer.wires(h, ins: function.ins, outs: function.outs)
        end
      end
    end
  end
end
