require_relative '../spec_helper'
require_relative '../../lib/art_decomp/b'
require_relative '../../lib/art_decomp/function'
require_relative '../../lib/art_decomp/function_presenter'
require_relative '../../lib/art_decomp/put'
require_relative '../../lib/art_decomp/puts'
require_relative '../../lib/art_decomp/puts_set'

module ArtDecomp
  describe FunctionPresenter do
    describe '#rows' do
      it 'returns binary-encoded row representation of the Function' do
        is = Puts.new([
          Put[:'0' => B[0,1,3,4,6,7,8,9], :'1' => B[1,2,3,4,5,7,8,9]],
          Put[:'0' => B[0,1,3,4,5,6,8,9], :'1' => B[0,2,3,4,6,7,8,9]],
          Put[:'0' => B[0,1,2,3,5,6,7,8], :'1' => B[0,1,2,4,5,6,7,9]],
          Put[HG: B[0,1,2], HY: B[3,4], FG: B[5,6,7], FY: B[8,9]],
        ])
        os = Puts.new([
          Put[:'0' => B[0,1,3,5,8], :'1' => B[2,4,6,7,9]],
          Put[:'0' => B[0,1,2,3,4], :'1' => B[5,6,7,8,9]],
          Put[:'0' => B[0,1,2,5,6,7,8,9], :'1' => B[3,4]],
          Put[:'0' => B[5,6,7,8,9], :'1' => B[0,1,2,3,4]],
          Put[:'0' => B[0,1,2,3,4,5,6,7], :'1' => B[8,9]],
          Put[HG: B[0,1,9], HY: B[2,3], FG: B[4,5], FY: B[6,7,8]],
        ])
        function = Function.new(PutsSet.new(is: is, os: os))
        function_presenter = FunctionPresenter.new(function)
        function_presenter.rows.must_equal [
          %w(0--10 0001010),
          %w(-0-10 0001010),
          %w(11-10 1001011),
          %w(--011 0011011),
          %w(--111 1011000),
          %w(10-00 0100000),
          %w(0--00 1100001),
          %w(-1-00 1100001),
          %w(--001 0100101),
          %w(--101 1100110),
        ]
      end
    end
  end
end
