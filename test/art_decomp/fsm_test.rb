require_relative '../test_helper'
require_relative '../../lib/art_decomp/fsm'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/state_put'
require_relative 'circuit_behaviour'

module ArtDecomp
  describe FSM do
    include CircuitBehaviour

    let(:empty) do
      FSM.new(archs_sizer: archs_sizer, functions: [], lines: {},
              own: Function.new(ins: Puts.new, outs: Puts.new), recoders: [])
    end

    describe '.from_function' do
      it 'creates an FSM from Function' do
        ins      = Puts.new([Put[%i(0 1)], StatePut[%i(s1 s2 s3)]])
        outs     = Puts.new([Put[%i(1 0)], StatePut[%i(s3 s1 s2)]])
        function = Function.new(ins: ins, outs: outs)
        fsm      = FSM.from_function(function)
        _(fsm.functions).must_equal [function]
        _(fsm.lines).must_equal ins[0]  => ins[0],  ins[1]  => ins[1],
                                outs[0] => outs[0], outs[1] => outs[1]
        _(fsm.own).must_equal function
        _(fsm.recoders).must_be :empty?
      end
    end

    describe '#recoders' do
      it 'gets the Recorders' do
        _(empty.with(recoders: recs = fake(Array)).recoders).must_equal recs
      end
    end
  end
end
