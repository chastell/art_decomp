require_relative '../spec_helper'

module ArtDecomp describe FunctionPresenter do
  let(:is) {[
    { :'0' => B[0, 1, 3, 4, 6, 7, 8, 9], :'1' => B[1, 2, 3, 4, 5, 7, 8, 9] },
    { :'0' => B[0, 1, 3, 4, 5, 6, 8, 9], :'1' => B[0, 2, 3, 4, 6, 7, 8, 9] },
    { :'0' => B[0, 1, 2, 3, 5, 6, 7, 8], :'1' => B[0, 1, 2, 4, 5, 6, 7, 9] },
    { :HG => B[0, 1, 2], :HY => B[3, 4], :FG => B[5, 6, 7], :FY => B[8, 9] },
  ]}
  let(:os) {[
    { :'0' => B[0, 1, 3, 5, 8], :'1' => B[2, 4, 6, 7, 9] },
    { :'0' => B[0, 1, 2, 3, 4], :'1' => B[5, 6, 7, 8, 9] },
    { :'0' => B[0, 1, 2, 5, 6, 7, 8, 9], :'1' => B[3, 4] },
    { :'0' => B[5, 6, 7, 8, 9], :'1' => B[0, 1, 2, 3, 4] },
    { :'0' => B[0, 1, 2, 3, 4, 5, 6, 7], :'1' => B[8, 9] },
    { :HG => B[0, 1, 9], :HY => B[2, 3], :FG => B[4, 5], :FY => B[6, 7, 8] },
  ]}
  let(:function_presenter) { FunctionPresenter.new Function.new(is, os) }

  describe '#rows' do
    it 'returns binary-encoded row representation of the function' do
      function_presenter.rows.must_equal [
        ['0--10', '0001010'],
        ['-0-10', '0001010'],
        ['11-10', '1001011'],
        ['--011', '0011011'],
        ['--111', '1011000'],
        ['10-00', '0100000'],
        ['0--00', '1100001'],
        ['-1-00', '1100001'],
        ['--001', '0100101'],
        ['--101', '1100110'],
      ]
    end
  end

  describe '#widths' do
    it 'returns the Function widths' do
      function_presenter.widths(:is).must_equal [1, 1, 1, 2]
      function_presenter.widths(:os).must_equal [1, 1, 1, 1, 1, 2]
    end
  end
end end
