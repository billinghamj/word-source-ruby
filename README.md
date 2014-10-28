# WordSource

WordSource processes streams of words, performing analytics on them as it goes.

[![Build Status](https://img.shields.io/travis/billinghamj/word-source-ruby.svg?style=flat)](//travis-ci.org/billinghamj/word-source-ruby)
[![Coverage Status](https://img.shields.io/coveralls/billinghamj/word-source-ruby.svg?style=flat)](//coveralls.io/r/billinghamj/word-source-ruby)

# Original Brief

## Background

A WordSource is a source of words. You can get words from it by calling the `next_word` method.

It keeps analytical information of each word that it has seen.

## Example

There are several potential sources for the words.
In this example we assume that the word source has been initialised with the following string: `"lorem,ipsum,ipsum"`

```ruby
   word_source = StringWordSource.new("lorem,ipsum,ipsum")
   word_source.next_word
     # => "lorem"
   word_source.next_word
     # => "ipsum"
   word_source.next_word
     # => "ipsum"
   word_source.top_5_words
     # => ["ipsum","lorem",nil,nil,nil]
   word_source.top_5_consonants
     # => ["m","p","s","l","r"]
   word_source.count
     # => 3 # total words seen
```

### Run method

```ruby
   word_source = StringWordSource.new("lorem,ipsum,ipusum")
   # This will run until there are no more words for the source implementation.
   word_source.run
     # => true
```

## Assignment

1. Implement FileWordSource that pulls in words from a file; include the methods
   described above. Use lorem_ipsum.txt to test.
2. Add callbacks on specific words e.g. every time "semper" is encountered, call those callbacks registered for "semper"
3. implement a WordSource that uses the Twitter API (instead of loading words from a file)
