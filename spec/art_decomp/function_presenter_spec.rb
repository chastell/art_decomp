require_relative '../spec_helper'

module ArtDecomp describe FunctionPresenter do
  describe '#widths' do
    it 'returns the Function widths' do
      is = [
        { :'0' => [0, 1, 3, 4, 6, 7, 8, 9], :'1' => [1, 2, 3, 4, 5, 7, 8, 9] },
        { :'0' => [0, 1, 3, 4, 5, 6, 8, 9], :'1' => [0, 2, 3, 4, 6, 7, 8, 9] },
        { :'0' => [0, 1, 2, 3, 5, 6, 7, 8], :'1' => [0, 1, 2, 4, 5, 6, 7, 9] },
        { :HG => [0, 1, 2], :HY => [3, 4], :FG => [5, 6, 7], :FY => [8, 9] },
      ]
      os = [
        { :'0' => [0, 1, 3, 5, 8], :'1' => [2, 4, 6, 7, 9] },
        { :'0' => [0, 1, 2, 3, 4], :'1' => [5, 6, 7, 8, 9] },
        { :'0' => [0, 1, 2, 5, 6, 7, 8, 9], :'1' => [3, 4] },
        { :'0' => [5, 6, 7, 8, 9], :'1' => [0, 1, 2, 3, 4] },
        { :'0' => [0, 1, 2, 3, 4, 5, 6, 7], :'1' => [8, 9] },
        { :HG => [0, 1, 9], :HY => [2, 3], :FG => [4, 5], :FY => [6, 7, 8] },
      ]
      fp = FunctionPresenter.new Function.new(is, os)
      fp.widths(:i).must_equal [1, 1, 1, 2]
      fp.widths(:o).must_equal [1, 1, 1, 1, 1, 2]
    end
  end
end end
