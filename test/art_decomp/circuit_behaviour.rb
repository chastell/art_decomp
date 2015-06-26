require_relative '../../lib/art_decomp/arch'
require_relative '../../lib/art_decomp/archs_sizer'
require_relative '../../lib/art_decomp/function'

module ArtDecomp
  module CircuitBehaviour
    def self.included(spec_class)
      spec_class.class_eval do
        describe '#adm_size' do
          it 'returns the admissible heuristic size of the Circuit' do
            stub(cs = fake(ArchsSizer, as: :class)).adm_size([]) { 7 }
            _(empty.adm_size(archs_sizer: cs)).must_equal 7
          end
        end

        describe '#functions' do
          it 'gets the functions' do
            functions = fake(Array)
            _(empty.update(functions: functions).functions).must_equal functions
          end
        end

        describe '#inspect' do
          it 'returns a readable representation' do
            f1 = fake(Function, arch: Arch[2,1])
            f2 = fake(Function, arch: Arch[4,3])
            inspect = empty.update(functions: [f1, f2]).inspect
            _(inspect).must_equal "#{empty.class}([ArtDecomp::Arch[2,1], " \
                                                  'ArtDecomp::Arch[4,3]])'
          end
        end

        describe '#largest_function' do
          it 'returns the largest Function (input- and output-wise)' do
            f23 = fake(Function, arch: Arch[2,3])
            f32 = fake(Function, arch: Arch[3,2])
            f33 = fake(Function, arch: Arch[3,3])
            functions = [f23, f32, f33]
            nonempty = empty.update(functions: functions)
            _(nonempty.largest_function).must_equal f33
          end
        end

        describe '#max_size' do
          it 'returns the maximum size of the Circuit' do
            stub(cs = fake(ArchsSizer, as: :class)).max_size([]) { 7 }
            _(empty.max_size(archs_sizer: cs)).must_equal 7
          end
        end

        describe '#min_size' do
          it 'returns the smallest possible size of the Circuit' do
            stub(cs = fake(ArchsSizer, as: :class)).min_size([]) { 7 }
            _(empty.min_size(archs_sizer: cs)).must_equal 7
          end
        end

        describe '#wires' do
          it 'gets the wires' do
            _(empty.update(wires: wires = fake(Array)).wires).must_equal wires
          end
        end
      end
    end
  end
end
