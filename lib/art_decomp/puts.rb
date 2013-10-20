module ArtDecomp class Puts
  def initialize ss
    @ss = ss
  end

  def == other
    ss == other.ss
  end

  def method_missing name
    ss.fetch(name) { super }
  end

  def respond_to? name
    ss.key? name or super
  end

  attr_accessor :ss
  protected     :ss
end end
