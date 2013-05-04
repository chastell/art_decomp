require_relative '../spec_helper'

module ArtDecomp describe FunctionPresenter do
  let(:is) {[
    Put[:'0' => B[0, 1, 3, 4, 6, 7, 8, 9], :'1' => B[1, 2, 3, 4, 5, 7, 8, 9]],
    Put[:'0' => B[0, 1, 3, 4, 5, 6, 8, 9], :'1' => B[0, 2, 3, 4, 6, 7, 8, 9]],
    Put[:'0' => B[0, 1, 2, 3, 5, 6, 7, 8], :'1' => B[0, 1, 2, 4, 5, 6, 7, 9]],
    Put[:HG => B[0, 1, 2], :HY => B[3, 4], :FG => B[5, 6, 7], :FY => B[8, 9]],
  ]}
  let(:os) {[
    Put[:'0' => B[0, 1, 3, 5, 8], :'1' => B[2, 4, 6, 7, 9]],
    Put[:'0' => B[0, 1, 2, 3, 4], :'1' => B[5, 6, 7, 8, 9]],
    Put[:'0' => B[0, 1, 2, 5, 6, 7, 8, 9], :'1' => B[3, 4]],
    Put[:'0' => B[5, 6, 7, 8, 9], :'1' => B[0, 1, 2, 3, 4]],
    Put[:'0' => B[0, 1, 2, 3, 4, 5, 6, 7], :'1' => B[8, 9]],
    Put[:HG => B[0, 1, 9], :HY => B[2, 3], :FG => B[4, 5], :FY => B[6, 7, 8]],
  ]}
  let(:function_presenter) { FunctionPresenter.new Function.new(is, os) }

  describe '#binwidths' do
    it 'returns the Function binary widths' do
      function_presenter.binwidths(:is).must_equal [1, 1, 1, 2]
      function_presenter.binwidths(:os).must_equal [1, 1, 1, 1, 1, 2]
    end
  end

  describe '#puts' do
    it 'returns the types of Put groups it responds to' do
      FunctionPresenter.new(Function.new).puts.must_equal [:is, :os]
    end
  end

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
end end
