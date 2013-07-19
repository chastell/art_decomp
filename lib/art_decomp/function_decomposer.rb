module ArtDecomp class FunctionDecomposer
  def decompose function, parallel_function_decomposer: ParallelFunctionDecomposer.new, serial_function_decomposer: SerialFunctionDecomposer.new
    Enumerator.new do |yielder|
      parallel_function_decomposer.decompose(function).each { |c| yielder << c }
      serial_function_decomposer.decompose(function).each   { |c| yielder << c }
    end
  end
end end
