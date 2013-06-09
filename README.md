# DummyModel

A gem that makes your pure old ruby classes behave like Rails models.

## Build status

[![Build Status](https://travis-ci.org/sumanmukherjee03/dummy_model.png)](https://travis-ci.org/sumanmukherjee03/dummy_model)

## Installation

Add this line to your application's Gemfile:

    gem 'dummy_model'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dummy_model

## Usage
To make your pure old ruby class behave like a Rails model you must include the DummyModel module in your class.
You can define the attributes for your object using the class level attribute method.
The attribute method comes from the Virtus gem.
So, all operations defined in Virtus are supported.
You can also provide Rails like validations for your attributes / object.
```ruby
  class Article
    include DummyModel

    attribute :name, String

    validates :name, :presence => true
  end
```
There is a _save method which you can override to provide a custom save behavior for your class.
The ```Article#_save``` method must return a boolean value. For example:
```ruby
def _save
  file_name = "#{name}.txt"
  size = 0
  if File.exists?(file_name)
    file = File.open(file_name, 'w+')
    size = file.size
  else
    file = File.new(file_name, 'w')
  end
  file.puts "Name : #{name}"
  result = file.size > size
  file.close
  result
end
```
The _save method is called only if the object is valid.

Now you can initialize a new article like you initialize Rails models.
```ruby
article = Article.new(:name => 'foo')
```
You can also your article.
The ```Article#save``` method returns a boolean value.
```ruby
article.save # true
```
You can also call ```Article#save!``` method.
If the record is valid and it got saved this returns true.
This raises an exception if the article is not valid.
```ruby
Article.new(:name => 'foo').save! # true
Article.new.save! # raises DummyModel::RecordInvalid : Name can't be blank
```
You can call ```Article.create``` to create an Article.
It returns the article object.
```ruby
Article.create(:name => 'foo') # returns an Article object
```
You can also call ```Article.create!``` to create an Article.
It raises an error is the validations fail.
```ruby
Article.create!(:name => 'foo') # returns an Article object
Article.create! # raises DummyModel::RecordInvalid : Name can't be blank
```
Articles can be checked for equality.
The equality check checks for equality of attributes and not object_id
```ruby
article = Article.new(:name => 'foo')
article.save
article == Article.create(:name => 'foo') # true
```
Apart from this, you can define before_save and after_save callbacks.
The before_save/after_save callbacks run before/after before save and create.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2013 Suman Mukherjee

MIT License

For more information on license, please look at LICENSE.txt

