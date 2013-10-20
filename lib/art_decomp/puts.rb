module ArtDecomp class Puts
  def initialize ss
    @ss = ss
  end

  def method_missing name
    ss[name] or super
  end

  def respond_to_missing? name, include_all
    ss.key? name or super
  end

  attr_accessor :ss
  private       :ss
end end
