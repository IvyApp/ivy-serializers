require_relative '../models'

RSpec.describe Ivy::Serializers::Formats::ActiveModelSerializers do
  let(:message) { Message.new(:id => 1) }
  let(:post) { Post.new(:id => 1) }
  let(:user) { User.new(:id => 1) }
  let(:video) { Video.new(:id => 2) }

  subject(:format) { described_class.new(document) }

  before do
    post.author = user
    user.posts = [post]

    message.user = user
    video.user = user
    user.messages = [message, video]
  end

  describe '#as_json' do
    let(:document) { Ivy::Serializers::Documents.create(Serializer, resource_name, resource) }

    subject { format.as_json }

    context 'for an individual resource' do
      let(:resource_name) { :post }
      let(:resource) { post }

      it { is_expected.to match_schema('spec/schemas/active_model_serializers/post.json') }
    end

    context 'for a resource collection' do
      let(:resource_name) { :posts }
      let(:resource) { [post] }

      it { is_expected.to match_schema('spec/schemas/active_model_serializers/posts.json') }
    end
  end
end
