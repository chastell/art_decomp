require_relative 'decomposer'
require_relative 'fsm_kiss_parser'
require_relative 'fsm_presenter'
require_relative 'kiss_decomposer'

module ArtDecomp
  class FSMKISSDecomposer < KISSDecomposer
    def initialize(args, circuit_presenter: FSMPresenter,
                   decomposer: Decomposer, kiss_parser: FSMKISSParser)
      super
    end
  end
end
