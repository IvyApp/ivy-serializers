# ivy-serializers

[![Build Status](https://travis-ci.org/IvyApp/ivy-serializers.svg?branch=master)](https://travis-ci.org/IvyApp/ivy-serializers)

JSON serialization for client-side apps, with multiple output formats. Ships with [ActiveModel::Serializers](https://github.com/rails-api/active_model_serializers) and [JSON-API](http://jsonapi.org/) 1.0 support out of the box.

If you're building a Rails project, take a look at [ivy-serializers-rails](https://github.com/IvyApp/ivy-serializers-rails) instead.

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

### Defining a Serializer

Assuming we have `Post` and `Comment` models:

```ruby
class Post < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
end
```

Define a serializer in `app/serializers/my_serializer.rb`:

```ruby
class MySerializer < Ivy::Serializers::Serializer
  map Post do
    attributes :title
    has_many :comments
  end

  map Comment do
    attributes :body
    belongs_to :post
  end
end
```

**NOTE**: An `id` attribute is automatically defined for you. This is a consequence of supporting JSON-API, which requires all resources to have IDs.

### Sideloading

The `#belongs_to` and `#has_many` methods support an optional `:embed_in_root` option, which will load the associated record into the root of the payload. For instance, if we wanted the list of comments to be included when fetching a post, we could define the `has_many` relationship like so:

```ruby
map Post do
  has_many :comments, :embed_in_root => true
end
```

The same thing also works with `belongs_to`, so if we wanted to ensure the post was included when fetching a comment:

```ruby
map Comment do
  belongs_to :post, :embed_in_root => true
end
```

### Polymorphic Associations

There is also support for polymorphic associations. To use it, pass the `:polymorphic => true` option to the `#belongs_to` or `#has_many` methods:

```ruby
map Post do
  has_many :replies, :polymorphic => true
end

map Comment do
  belongs_to :commentable, :polymorphic => true
end
```

### Customizing Attributes

By default, attributes are mapped directly to methods on the record being serialized. So defining:

```ruby
map Post do
  attributes :title
end
```

will read `title` from the post and write it into the hash under the `:title` key. If you want to customize the value, you can use the `#attribute` method instead, and pass it a block:

```ruby
map Post do
  attribute(:title) { |post| post.headline }
end
```

In the above example, we read the `headline` attribute from the post and write it into the payload under the `:title` key.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ivy-serializers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
