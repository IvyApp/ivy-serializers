# Ivy::Serializers

JSON serialization for client-side apps. Can output either
[ActiveModel::Serializers](https://github.com/rails-api/active_model_serializers)
or [JSON-API](http://jsonapi.org/) formats.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ivy-serializers'
```

And then execute:

```sh
bundle
```

Or install it yourself:

```sh
gem install ivy-serializers
```

## Usage

Given two models:

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  has_many :comments
end
```

```ruby
# app/models/comment.rb
class Comment < ActiveRecord::Base
  belongs_to :post
end
```

Define a serializer that extends from `Ivy::Serializers::Serializer`:

```ruby
class Serializer < Ivy::Serializers::Serializer
  map Post do
    attributes :id, :title
    has_many :comments
  end

  map Comment do
    attributes :id, :body
    belongs_to :post
  end
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ivy-serializers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
