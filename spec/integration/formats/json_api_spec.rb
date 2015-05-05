require 'ivy/serializers'

RSpec.describe Ivy::Serializers::Formats::JSONAPI do
  let(:format) { described_class.new(document) }

  describe '#as_json' do
    let(:registry) { Ivy::Serializers::Registry.new }
    let(:document) { Ivy::Serializers::Documents.create(registry, :posts, resource) }

    subject { format.as_json }

    context 'with default mapping' do
      let(:post_class) { double('Post', :name => 'Post') }
      let(:post) { double('post', :class => post_class, :id => 1) }

      context 'for an individual resource' do
        let(:resource) { post }

        it { should eq({
          :data => {
            :type => 'post',
            :id => '1',
            :links => {}
          }
        }) }
      end

      context 'for a resource collection' do
        let(:resource) { [post] }

        it { should eq({
          :data => [{
            :type => 'post',
            :id => '1',
            :links => {}
          }]
        }) }
      end
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

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq({
            :data => {
              :type => 'post',
              :id => '1',
              :title => 'title',
              :links => {}
            }
          }) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq({
            :data => [{
              :type => 'post',
              :id => '1',
              :title => 'title',
              :links => {}
            }]
          }) }
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

          it { should eq({
            :data => {
              :type => 'post',
              :id => '1',
              :headline => 'title',
              :links => {}
            }
          }) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq({
            :data => [{
              :type => 'post',
              :id => '1',
              :headline => 'title',
              :links => {}
            }]
          }) }
        end
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

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq({
            :data => {
              :type => 'post',
              :id => '1',
              :links => {
                :author => {
                  :linkage => {:id => '1', :type => 'author'}
                }
              }
            }
          }) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq({
            :data => [{
              :type => 'post',
              :id => '1',
              :links => {
                :author => {
                  :linkage => {:id => '1', :type => 'author'}
                }
              }
            }]
          }) }
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

          it { should eq({
            :data => {
              :type => 'post',
              :id => '1',
              :links => {
                :user => {
                  :linkage => {:id => '1', :type => 'author'}
                }
              }
            }
          }) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq({
            :data => [{
              :type => 'post',
              :id => '1',
              :links => {
                :user => {
                  :linkage => {:id => '1', :type => 'author'}
                }
              }
            }]
          }) }
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

          it { should eq({
            :data => {
              :type => 'post',
              :id => '1',
              :links => {
                :author => {
                  :linkage => {:id => '1', :type => 'author'}
                }
              }
            },

            :included => {
              :authors => [{
                :id => '1',
                :links => {},
                :type => 'author'
              }]
            }
          }) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq({
            :data => [{
              :type => 'post',
              :id => '1',
              :links => {
                :author => {
                  :linkage => {:id => '1', :type => 'author'}
                }
              }
            }],

            :included => {
              :authors => [{
                :id => '1',
                :links => {},
                :type => 'author'
              }]
            }
          }) }
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

          it { should eq({
            :data => {
              :type => 'post',
              :id => '1',
              :links => {
                :author => {
                  :linkage => {:id => '1', :type => 'author'}
                }
              }
            }
          }) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq({
            :data => [{
              :type => 'post',
              :id => '1',
              :links => {
                :author => {
                  :linkage => {:id => '1', :type => 'author'}
                }
              }
            }]
          }) }
        end
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

        context 'for an individual resource' do
          let(:resource) { post }

          it { should eq({
            :data => {
              :type => 'post',
              :id => '1',
              :links => {
                :comments => {
                  :linkage => [{:id => '1', :type => 'comment'}]
                }
              }
            }
          }) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq({
            :data => [{
              :type => 'post',
              :id => '1',
              :links => {
                :comments => {
                  :linkage => [{:id => '1', :type => 'comment'}]
                }
              }
            }]
          }) }
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

          it { should eq({
            :data => {
              :type => 'post',
              :id => '1',
              :links => {
                :replies => {
                  :linkage => [{:id => '1', :type => 'comment'}]
                }
              }
            }
          }) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq({
            :data => [{
              :type => 'post',
              :id => '1',
              :links => {
                :replies => {
                  :linkage => [{:id => '1', :type => 'comment'}]
                }
              }
            }]
          }) }
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

          it { should eq({
            :data => {
              :type => 'post',
              :id => '1',
              :links => {
                :comments => {
                  :linkage => [{:id => '1', :type => 'comment'}]
                }
              }
            },

            :included => {
              :comments => [{
                :type => 'comment',
                :id => '1',
                :links => {}
              }]
            }
          }) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq({
            :data => [{
              :type => 'post',
              :id => '1',
              :links => {
                :comments => {
                  :linkage => [{:id => '1', :type => 'comment'}]
                }
              }
            }],

            :included => {
              :comments => [{
                :type => 'comment',
                :id => '1',
                :links => {}
              }]
            }
          }) }
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

          it { should eq({
            :data => {
              :type => 'post',
              :id => '1',
              :links => {
                :comments => {
                  :linkage => [{:id => '1', :type => 'comment'}]
                }
              }
            }
          }) }
        end

        context 'for a resource collection' do
          let(:resource) { [post] }

          it { should eq({
            :data => [{
              :type => 'post',
              :id => '1',
              :links => {
                :comments => {
                  :linkage => [{:id => '1', :type => 'comment'}]
                }
              }
            }]
          }) }
        end
      end
    end
  end
end
