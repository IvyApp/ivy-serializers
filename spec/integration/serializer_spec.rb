require 'ivy/serializers'

RSpec.describe Ivy::Serializers::Serializer do
  describe '#resource' do
    let(:serializer) { serializer_class.new }
    let(:generator) { Ivy::Serializers::Formats::ActiveModelSerializers.new(document) }
    let(:document) { Ivy::Serializers::Documents.create(serializer, :post, post) }
    let(:post_class) { double('Post') }
    let(:post) { double('post', :class => post_class, :id => 1, :title => 'title') }

    context 'with an attribute' do
      subject { generator.as_json }

      context 'with default options' do
        let(:serializer_class) {
          post_klass = post_class

          Class.new(described_class) do
            map post_klass do
              attribute :title
            end
          end
        }

        it { should eq(:post => {:id => 1, :title => 'title'}) }
      end

      context 'with a block provided' do
        let(:serializer_class) {
          post_klass = post_class

          Class.new(described_class) do
            map post_klass do
              attribute(:title) { title }

              def title
                'custom_title'
              end
            end
          end
        }

        it { should eq(:post => {:id => 1, :title => 'custom_title'}) }
      end
    end
  end
end
