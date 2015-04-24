require 'ivy/serializers'

class Model
  def initialize(attributes=nil)
    assign_attributes(attributes) if attributes
  end

  def assign_attributes(attributes)
    attributes.each_pair { |key, val| public_send("#{key}=", val) }
  end
end

class Message < Model
  attr_accessor :id
  attr_accessor :user
end

class Video < Message
end

class Post < Model
  attr_accessor :author
  attr_accessor :id
end

class User < Model
  attr_accessor :id
  attr_accessor :messages
  attr_accessor :posts
end

class Serializer < Ivy::Serializers::Serializer
  map Post do
    attributes :id
    belongs_to :author, :embed_in_root => true
  end

  map User do
    attributes :id
    has_many :messages, :embed_in_root => true, :polymorphic => true
    has_many :posts, :embed_in_root => true
  end
end
