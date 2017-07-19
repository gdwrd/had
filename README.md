# Had

Had is Hanami Api Documentation. Gem generates API documentation from your integration tests written with `rspec` for [Hanami](https://hanamirb.org).

This is fork of [`reqres_rspec`](https://github.com/reqres-api/reqres_rspec) gem and worked implemantation for Hanami.

## Installation

### 1) Gem

Just add this gem to `Gemfile` of your API Application

    gem 'had', group: :test

And then execute:

    $ bundle install

If necessary, add `require "had"` to your `spec/spec_helper.rb` file

## Usage

Before start you need to setup environment.
`export APP_ROOT=/path/to/your/application` 

By default `had` is not active (this may be configured!). To activate it, run `rspec` with

`HAD_RUN=1 bundle exec rspec --order=defined`

Documentation will be put into your application's `/doc` folder

### Sample controller action

```ruby
  # @description creates Category from given parameters
  # description text may be multiline
  # @param category[title] required String Category title
  # @param category[weight] in which order Category will be shown
  # param text may also be multiline
  def call(params)
    # action code
  end
```

Description param text is started with `@description` and may be multiline.
Each param text is started with `@param` and first word will be param name, then optionally `required`, then optionally type (`Integer`, `String` etc), and finally param description, which may be multiline as well.

### Sample rspec test

```ruby
  it 'validates params', :skip_had do
    ...
  end

  context 'With valid params' do
    it 'bakes pie' do
      ...
    end
  end

  context 'With invalid params', :skip_had do
    it 'returns errors' do
      ...
    end
  end
```

 By default all examples will be added to docs. A context of examples (`context` and `describe` blocks) or any particular examples may be excluded from docs with option `:skip_had`

 Doc will use full example description, as a title for each separate spec

If you want to group examples in another way, you can do something like:

```ruby
describe 'Something', had_section: 'Foo' do
  context 'valid params', had_title: 'Bakes Pie' do
    it 'works' do
      ...
    end

    it 'tires baker', had_title: 'Tires baker' do
      ...
    end
  end
end
```

## Configuration

```ruby
Had.configure do |c|
  c.templates_path = './spec/support/reqres/templates' # Path to custom templates
  c.output_path = 'some path' # by default it will use doc/reqres
  c.formatters = %w(MyCustomFormatter) # List of custom formatters, these can be inherited from Had::Formatters::HTML
  c.title = 'My API Documentation' # Title for your documentation
end
```

## Custom Formatter example

```ruby
class CustomAPIDoc < Had::Formatters::HTML
  private
  def write
    # Copy assets
    %w(styles images components scripts).each do |folder|
      FileUtils.cp_r(path(folder), output_path)
    end

    # Generate general pages
    @pages = {
      'index.html'          => 'Introduction',
      'authentication.html' => 'Authentication',
      'filtering.html'      => 'Filtering, Sorting and Pagination',
      'locations.html'      => 'Locations',
      'files.html'          => 'Files',
      'external-ids.html'   => 'External IDs',
    }

    @pages.each do |filename, _|
      @current_page = filename
      save filename, render("pages/#{filename}")
    end

    # Generate API pages
    @records.each do |record|
      @record       = record
      @current_page = @record[:filename]
      save "#{record[:filename]}.html", render('spec.html.erb')
    end
  end
end
```

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
