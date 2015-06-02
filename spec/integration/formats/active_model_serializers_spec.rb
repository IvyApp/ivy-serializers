require 'ivy/serializers'

RSpec.describe Ivy::Serializers::Formats::ActiveModelSerializers do
  let(:format) { described_class.new(document) }

  describe '#as_json' do
    let(:registry) { Ivy::Serializers::Registry.new }
    let(:document) { Ivy::Serializers::Documents.create(registry, :posts, resource) }

    subject { format.as_json }

    context 'with default mapping' do
      let(:post) { double('post', :id => 1) }

      context 'for an individual resource' do
        let(:resource) { post }

        it { should eq(:post => {:id => 1}) }
      end

      context 'for a resource collection' do
        let(:resource) { [post] }

        it { should eq(:posts => [{:id => 1}]) }
      end
    end

    context 'with an attribute' do
      let(:post_class) { double('Post') }
      let(:post) { double('post', :class => post_class, :id => 1, :title => 'title') }

      context 'with default options' do
        before do
          registry.map post_class do
            attribute :title
          end
        end

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq(:post => {:id => 1, :title => 'title'}) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq(:posts => [{:id => 1, :title => 'title'}]) }
        end
      end

      context 'with a block provided' do
        before do
          registry.map post_class do
            attribute(:headline) { |post| post.title }
          end
        end

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq(:post => {:id => 1, :headline => 'title'}) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq(:posts => [{:id => 1, :headline => 'title'}]) }
        end
      end
    end

    context 'with a belongs_to relationship' do
      let(:author_class) { double('Author', :name => 'Author') }
      let(:author) { double('author', :class => author_class, :id => 1) }
      let(:post_class) { double('Post') }
      let(:post) { double('post', :author => author, :class => post_class, :id => 1) }

      context 'with default options' do
        before do
          registry.map post_class do
            belongs_to :author
          end
        end

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq(:post => {:author_id => 1, :id => 1}) }

          context 'with no related resource' do
            let(:author) { nil }

            it { should eq(:post => {:author_id => nil, :id => 1}) }
          end
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq(:posts => [{:author_id => 1, :id => 1}]) }
        end
      end

      context 'with a block provided' do
        before do
          registry.map post_class do
            belongs_to(:user) { |post| post.author }
          end
        end

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq(:post => {:id => 1, :user_id => 1}) }

          context 'with no related resource' do
            let(:author) { nil }

            it { should eq(:post => {:id => 1, :user_id => nil}) }
          end
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq(:posts => [{:id => 1, :user_id => 1}]) }
        end
      end

      context 'with the :embed_in_root option' do
        before do
          registry.map post_class do
            belongs_to :author, :embed_in_root => true
          end
        end

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq(
            :authors => [{:id => 1}],
            :post => {:author_id => 1, :id => 1}
          ) }

          context 'with no related resource' do
            let(:author) { nil }

            it { should eq(:post => {:author_id => nil, :id => 1}) }
          end
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq(
            :authors => [{:id => 1}],
            :posts => [{:author_id => 1, :id => 1}]
          ) }
        end
      end

      context 'with the :polymorphic option' do
        before do
          registry.map post_class do
            belongs_to :author, :polymorphic => true
          end
        end

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq(:post => {:author => {:id => 1, :type => 'author'}, :id => 1}) }

          context 'with no related resource' do
            let(:author) { nil }

            it { should eq(:post => {:author => nil, :id => 1}) }
          end
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq(:posts => [{:author => {:id => 1, :type => 'author'}, :id => 1}]) }
        end
      end
    end

    context 'with a has_many relationship' do
      let(:comment_class) { double('Comment', :name => 'Comment') }
      let(:comment) { double('comment', :class => comment_class, :id => 1) }
      let(:post_class) { double('Post') }
      let(:post) { double('post', :class => post_class, :comments => [comment], :id => 1) }

      context 'with default options' do
        before do
          registry.map post_class do
            has_many :comments
          end
        end

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq(:post => {:comment_ids => [1], :id => 1}) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq(:posts => [{:comment_ids => [1], :id => 1}]) }
        end
      end

      context 'with a block provided' do
        before do
          registry.map post_class do
            has_many(:replies) { |post| post.comments }
          end
        end

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq(:post => {:id => 1, :reply_ids => [1]}) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq(:posts => [{:id => 1, :reply_ids => [1]}]) }
        end
      end

      context 'with the :embed_in_root option' do
        before do
          registry.map post_class do
            has_many :comments, :embed_in_root => true
          end
        end

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq(
            :comments => [{:id => 1}],
            :post => {:comment_ids => [1], :id => 1}
          ) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq(
            :comments => [{:id => 1}],
            :posts => [{:comment_ids => [1], :id => 1}]
          ) }
        end
      end

      context 'with the :polymorphic option' do
        before do
          registry.map post_class do
            has_many :comments, :polymorphic => true
          end
        end

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq(:post => {:comments => [{:id => 1, :type => 'comment'}], :id => 1}) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq(:posts => [{:comments => [{:id => 1, :type => 'comment'}], :id => 1}]) }
        end
      end
    end
  end
end
