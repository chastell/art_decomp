require 'anima'
require 'delegate'
require_relative '../circuit'
require_relative '../function'
require_relative '../puts'

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

      def each_uv
        sorted = ins.sort_by { |put| (outs.seps & put.seps).count }
        [3, 2].each do |g_width|
          sorted.combination(g_width).each { |v_ins| yield ins - v_ins, v_ins }
        end
      end

      class Decomposition
        include Anima.new(:function, :u_ins, :v_ins)

        def circuit
          in_wires  = function.ins.map  { |put| { put => put } }
          out_wires = function.outs.map { |put| { put => put } }
          gh_wires  = g_outs.map { |put| { put => put } }
          wires     = (in_wires + out_wires + gh_wires).reduce({}, :merge)
          Circuit.new(functions: [g, h], own: function, wires: wires)
        end

        def sensible?
          g.outs.binwidth < g.ins.binwidth
        end

        private

        # :reek:UncommunicativeMethodName
        def g
          @g ||= Function.new(ins: v_ins, outs: g_outs)
        end

        def g_outs
          @g_outs ||= Puts.from_seps(allowed:  v_ins.seps,
                                     required: function.outs.seps - u_ins.seps,
                                     size:     function.size)
        end

        # :reek:UncommunicativeMethodName
        def h
          @h ||= Function.new(ins: u_ins + g_outs, outs: function.outs)
        end
      end
    end
  end
end
