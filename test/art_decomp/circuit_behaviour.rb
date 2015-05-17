require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/circuit_sizer'
require_relative '../../lib/art_decomp/function'

module ArtDecomp
  module CircuitBehaviour
    def self.included(spec_class)
      spec_class.class_eval do
        describe '#adm_size' do
          it 'returns the admissible heuristic size of the Circuit' do
            stub(cs = fake(CircuitSizer)).adm_size { 7 }
            empty.adm_size(circuit_sizer: cs).must_equal 7
          end
        end

        describe '#functions' do
          it 'gets the functions' do
            functions = fake(Array)
            empty.update(functions: functions).functions.must_equal functions
          end
        end

        describe '#function_archs' do
          it 'returns the Archs of its Functions' do
            f1 = fake(Function, arch: Arch[2,1])
            f2 = fake(Function, arch: Arch[4,3])
            empty.update(functions: [f1, f2]).function_archs
              .must_equal [Arch[2,1], Arch[4,3]]
          end
        end

        describe '#ins, #outs' do
          it 'returns the Circuit’s Put groups' do
            %i(ins outs).each do |type|
              puts = Puts.new([stub(:put)])
              empty.update(type => puts).send(type).must_equal puts
            end
          end
        end

        describe '#inspect' do
          it 'returns a readable representation' do
            f1 = fake(Function, arch: Arch[2,1])
            f2 = fake(Function, arch: Arch[4,3])
            circ = empty.update(functions: [f1, f2])
            circ.inspect.must_equal "#{empty.class}([ArtDecomp::Arch[2,1], " \
                                                    'ArtDecomp::Arch[4,3]])'
          end
        end

        describe '#largest_function' do
          it 'returns the largest Function (input- and output-wise)' do
            f23 = fake(Function, arch: Arch[2,3])
            f32 = fake(Function, arch: Arch[3,2])
            f33 = fake(Function, arch: Arch[3,3])
            functions = [f23, f32, f33]
            empty.update(functions: functions).largest_function.must_equal f33
          end
        end

        describe '#max_size' do
          it 'returns the maximum size of the Circuit' do
            stub(cs = fake(CircuitSizer)).max_size { 7 }
            empty.max_size(circuit_sizer: cs).must_equal 7
          end
        end

        describe '#min_size' do
          it 'returns the smallest possible size of the Circuit' do
            stub(cs = fake(CircuitSizer)).min_size { 7 }
            empty.min_size(circuit_sizer: cs).must_equal 7
          end
        end

        describe '#wires' do
          it 'gets the wires' do
            empty.update(wires: wires = fake(Array)).wires.must_equal wires
          end
        end
      end
    end
  end
end