module ArtDecomp class PutPresenter < SimpleDelegator
  def mapping_for code
    codes.sort.index(code).to_s(2).rjust binwidth, '0'
  end
end end
