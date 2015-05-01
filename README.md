# Ivy::Serializers

[![Build Status](https://travis-ci.org/IvyApp/ivy-serializers.svg?branch=master)](https://travis-ci.org/IvyApp/ivy-serializers)

JSON serialization for client-side apps, with multiple output formats. Ships
with [ActiveModel::Serializers][ams] and [JSON-API][jsonapi] RC3 support
out of the box.

[ams]: https://github.com/rails-api/active_model_serializers
[jsonapi]: http://jsonapi.org/

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

Define a serializer in `app/serializers/serializer.rb`:

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

Then set up your controllers to use the serializer:

```ruby
class ApplicationController < ActionController::Base
  self.serializer = Serializer
end
```

Note that you're not limited to a single serializer. If you have multiple
serialization formats, such as one for admin and one for public-facing, you can
define alternate serializers in `app/serializers` and use them as well.

### Sideloading

The `#belongs_to` and `#has_many` methods support an optional `:embed_in_root`
option, which will load the associated record into the root of the payload. For
instance, if we wanted the list of comments to be included when fetching
a post, we could define the `has_many` relationship like so:

```ruby
map Post do
  has_many :comments, :embed_in_root => true
end
```

The same thing also works with `belongs_to`, so if we wanted to ensure the post
was included when fetching a comment:

```ruby
map Comment do
  belongs_to :post, :embed_in_root => true
end
```

### Polymorphic Associations

There is also support for polymorphic associations. To use it, pass the
`:polymorphic => true` option to the `#belongs_to` or `#has_many` methods:

```ruby
map Post do
  has_many :replies, :polymorphic => true
end

map Comment do
  belongs_to :commentable, :polymorphic => true
end
```

### Customizing Attributes

By default, attributes are mapped directly to methods on the record being
serialized. So defining:

```ruby
map Post do
  attributes :id, :title
end
```

will read `id` and `title` from the post and write it into the hash under the
`:id` and `:title` keys. If you want to customize the value, you can use the
`#attribute` method instead, and pass it a block:

```ruby
map Post do
  attribute(:title) { |post| post.headline }
end
```

In the above example, we read the `headline` attribute from the post and write
it into the payload under the `:title` key.

### Alternate Output Formats

By default the ActiveModel::Serializers output format is used. If you'd rather
use JSON-API (or a custom format), you can do so by setting
`serialization_format` in your controller. For instance, to use JSON-API:

```ruby
class ApplicationController < ActionController::Base
  self.serialization_format = Ivy::Serializers::Formats::JSONAPI
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ivy-serializers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
