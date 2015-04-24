require 'ivy/serializers'

RSpec.describe Ivy::Serializers::Formats::JSONAPI do
  let(:format) { described_class.new(document) }

  describe '#as_json' do
    let(:registry) { Ivy::Serializers::Registry.new }
    let(:document) { Ivy::Serializers::Documents.create(registry, :post, post) }

    subject { format.as_json }

    context 'with default mapping' do
      let(:post_class) { double('Post', :name => 'Post') }
      let(:post) { double('post', :class => post_class, :id => 1) }

      it { should eq(:post => {:id => '1', :links => {}, :type => 'post'}) }
    end

    context 'with an attribute' do
      let(:post_class) { double('Post', :name => 'Post') }
      let(:post) { double('post', :class => post_class, :id => 1, :title => 'title') }

      context 'with default options' do
        before do
          registry.map post_class do
            attribute :title
          end
        end

        it { should eq(:post => {:id => '1', :links => {}, :title => 'title', :type => 'post'}) }
      end

      context 'with the :as option' do
        before do
          registry.map post_class do
            attribute :title, :as => :headline
          end
        end

        it { should eq(:post => {:id => '1', :headline => 'title', :links => {}, :type => 'post'}) }
      end
    end

    context 'with a belongs_to relationship' do
      let(:author_class) { double('Author', :name => 'Author') }
      let(:author) { double('author', :class => author_class, :id => 1) }
      let(:post_class) { double('Post', :name => 'Post') }
      let(:post) { double('post', :author => author, :class => post_class, :id => 1) }

      context 'with default options' do
        before do
          registry.map post_class do
            belongs_to :author
          end
        end

        it { should eq(:post => {:id => '1', :links => {:author => '1'}, :type => 'post'}) }
      end

      context 'with the :embed_in_root option' do
        before do
          registry.map post_class do
            belongs_to :author, :embed_in_root => true
          end
        end

        it { should eq(
          :linked => {:authors => [{:id => '1', :links => {}, :type => 'author'}]},
          :post => {:id => '1', :links => {:author => '1'}, :type => 'post'}
        ) }
      end
    end

    context 'with a has_many relationship' do
      let(:comment_class) { double('Comment', :name => 'Comment') }
      let(:comment) { double('comment', :class => comment_class, :id => 1) }
      let(:post_class) { double('Post', :name => 'Post') }
      let(:post) { double('post', :class => post_class, :comments => [comment], :id => 1) }

      context 'with default options' do
        before do
          registry.map post_class do
            has_many :comments
          end
        end

        it { should eq(:post => {:id => '1', :links => {:comments => ['1']}, :type => 'post'}) }
      end

      context 'with the :embed_in_root option' do
        before do
          registry.map post_class do
            has_many :comments, :embed_in_root => true
          end
        end

        it { should eq(
          :post => {:id => '1', :links => {:comments => ['1']}, :type => 'post'},
          :linked => {:comments => [{:id => '1', :links => {}, :type => 'comment'}]}
        ) }
      end

      context 'with the :polymorphic option' do
        before do
          registry.map post_class do
            has_many :comments, :polymorphic => true
          end
        end

        it { should eq(:post => {:id => '1', :links => {:comments => ['1']}, :type => 'post'}) }
      end
    end
  end
end
