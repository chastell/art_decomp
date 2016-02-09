# frozen_string_literal: true

require 'anima'
require 'delegate'
require_relative '../circuit'
require_relative '../function'
require_relative '../puts_from_seps'
require_relative '../wires'

module ArtDecomp
  module FunctionDecomposer
    class Serial < SimpleDelegator
      def self.call(function)
        new(function).call
      end

      def call
        Enumerator.new do |yielder|
          each_uv do |u_ins, v_ins|
            dec = Decomposition.new(function: function,
                                    u_ins: u_ins, v_ins: v_ins)
            yielder << dec.circuit if dec.sensible?
          end
        end
      end

      private

      alias function __getobj__

      def each_uv
        sorted = ins.sort_by { |put| (outs.seps & put.seps).count }
        [3, 2].each do |g_width|
          sorted.combination(g_width).each { |v_ins| yield ins - v_ins, v_ins }
        end
      end

      # :reek:UncommunicativeVariableName
      class Decomposition
        include Anima.new(:function, :u_ins, :v_ins)

        def circuit
          gh = g_outs.map { |go| Wires.new(go => go) }.reduce(Wires.new, :+)
          wires = Wires.from_function(function) + gh
          Circuit.new(functions: [g, h], own: function, wires: wires)
        end

        def sensible?
          g.outs.binwidth < g.ins.binwidth
        end

        private

        # :reek:UncommunicativeMethodName
        def g
          @g ||= Function[v_ins, g_outs]
        end

        def g_outs
          @g_outs ||= begin
            PutsFromSeps.call(allowed:  v_ins.seps,
                              required: function.outs.seps - u_ins.seps,
                              size:     function.size)
          end
        end

        # :reek:UncommunicativeMethodName
        def h
          @h ||= Function[u_ins + g_outs, function.outs]
        end
      end
    end
  end
end
