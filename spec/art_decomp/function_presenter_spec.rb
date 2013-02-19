require_relative '../spec_helper'

module ArtDecomp describe FunctionPresenter do
  let(:is) {[
    { :'0' => [0, 1, 3, 4, 6, 7, 8, 9], :'1' => [1, 2, 3, 4, 5, 7, 8, 9] },
    { :'0' => [0, 1, 3, 4, 5, 6, 8, 9], :'1' => [0, 2, 3, 4, 6, 7, 8, 9] },
    { :'0' => [0, 1, 2, 3, 5, 6, 7, 8], :'1' => [0, 1, 2, 4, 5, 6, 7, 9] },
    { :HG => [0, 1, 2], :HY => [3, 4], :FG => [5, 6, 7], :FY => [8, 9] },
  ]}
  let(:os) {[
    { :'0' => [0, 1, 3, 5, 8], :'1' => [2, 4, 6, 7, 9] },
    { :'0' => [0, 1, 2, 3, 4], :'1' => [5, 6, 7, 8, 9] },
    { :'0' => [0, 1, 2, 5, 6, 7, 8, 9], :'1' => [3, 4] },
    { :'0' => [5, 6, 7, 8, 9], :'1' => [0, 1, 2, 3, 4] },
    { :'0' => [0, 1, 2, 3, 4, 5, 6, 7], :'1' => [8, 9] },
    { :HG => [0, 1, 9], :HY => [2, 3], :FG => [4, 5], :FY => [6, 7, 8] },
  ]}
  let(:subject) { FunctionPresenter.new Function.new(is, os) }

  describe '#rows' do
    it 'returns binary-encoded row representation of the function' do
      subject.rows.must_equal [
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
      subject.widths(:i).must_equal [1, 1, 1, 2]
      subject.widths(:o).must_equal [1, 1, 1, 1, 1, 2]
    end
  end
end end
