---
layout: post
title:  "Dry-web-roda and Sprockets"
tags: ruby dry-web-roda
---

If you are migrating a Rails app to Dry-web-roda it is possible that you have your assets managed by sprockets. And, If you want to reduce the impact of the changes you will want to use sprockets in your new dry-web-roda app. Thankfully is really simple to do that.

<!--more-->
The code was taken from my app called `Focus` then you want to replace it with the name of the yours.

These are the steps to make it work:

#### Add to your Gemfile the dependencies that you need

```ruby
gem 'sprockets'
gem 'coffee-script' # only if you need to compile coffee-script
gem 'sass'          # for sass and scss files processing
gem 'uglifier'      # for js compression
```

#### Boot in your system the sprockets processor

Add the file `apps/main/system/boot/sprockets.rb`

```ruby
Focus::Main::Container.boot :sprockets do |system|
  # "system" is the Main::Container here
  start do
    require 'sprockets'
    require 'slim'

    # system.root is "apps/main/"
    sprockets = Sprockets::Environment.new(system.root) do |env|
      env.logger = system['core.logger']
    end
    # Add the paths where the assets will be found
    sprockets.append_path(File.join(system.root, 'assets', 'javascripts'))
    sprockets.append_path(File.join(system.root, 'assets', 'stylesheets'))
    sprockets.append_path(File.join(system.root, 'assets', 'images'))

    # This will be used by the rake task that precompiles your assets
    if ENV['RACK_ENV'] == 'production'
      sprockets.js_compressor  = :uglify
      sprockets.css_compressor = :sass
    end

    # Here I added the path for assets loaded by bower
    project_root = system.root.parent.parent
    sprockets.append_path(
      File.join(project_root, 'vendor', 'assets', 'bower_components')
    )

    # This allows find the asset inside of your scss/sass file
    sprockets.context_class.class_eval do
      def asset_path(path, _options = {})
        path
      end
    end

    # I need this for slim templates used by my angular app
    sprockets.register_engine '.slim', Slim::Template, mime_type: 'text/slim',
      silence_deprecation: true

    # Register the configured sprockets into the dry-container
    register 'sprockets', sprockets
  end
end
```

#### Ask the context of the assets' reference

Add to the view context an `asset` method that returns the asset's reference. You can add this to the `Main` app or globally in the `lib`. In my case `lib/focus/view/context.rb`:

```ruby
module Focus
  module View
    class Context
      ...
      def asset(name)
        if ENV['RACK_ENV'] == 'production'
          manifest["#{asset_prefix}__#{name}"]
        else
          "/#{asset_prefix}/assets/#{name}"
        end
      end

      private

      # In production the manifest file will map with the compiled
      # file name (idea stolen from https://github.com/icelab/berg)
      def manifest
        @manifest ||= YAML.load_file(
          "#{Focus::Container.config.root}/public/manifest.yml"
        )
      end

      def asset_prefix
        Inflecto.underscore self.class.to_s.split('::')[1]
      end
      ...
    end
  end
end
```

Then in your template you can use:

```slim
doctype html
html
  head
    link rel="stylesheet" href=asset("application.css")
    script rel="javascript" type="text/javascript" src=asset("application.js")
  body
    == yield
```

#### Serve the assets through sprockets

In development or test environment, delegate to `sprockets` the task of serving the assets.

```ruby
module Focus
  module Main
    class Web < Dry::Web::Roda::Application
      route do |r|
        r.on 'main/assets' do
          r.run self.class['sprockets']
        end
        ...
      end
    end
  end
end
```

## Moving to production

We need a rake task for precompile the assets in production. The following code has my customized needs for assets compilation (images in application assets path, bootstrap fonts from vendor file, and adding a digest to css and js files). But I'm sure that you will get the idea. Also, you can precompile your assets in development.

Then this are the changes added to my `Rakefile` for assets processing:

```ruby
# Load sub-apps containers
app_paths = Pathname(__FILE__).dirname.join('./apps').realpath.join('*')
Dir[app_paths].each do |f|
  require "#{f}/system/focus/#{f.split('/').last}/container"
end

# These are the sub-apps that use sprockets
def sub_apps_containers
  [
    Focus::Main::Container,
    Focus::Spa::Container,
  ]
end

namespace :assets do
  desc 'compile assets'
  task :precompile do

    filenames = {}
    sub_apps_containers.each do |container|
      # Start the container to make sprockets accessible
      container.start :sprockets
      # Determine the sub-app directory (e.g.: 'main')
      sub_app_dir = container.config.default_namespace.split('.').last
      # Generate the destination directory
      outpath = File.join(Focus::Container.config.root, "public/#{sub_app_dir}/assets")
      FileUtils.mkdir_p outpath

      # obtain the images names
      assets = Dir[container.root.join('assets/images/*')].map do |img|
        img.split('/').last
      end
      # standard sprockets manifest
      assets << 'application.js'
      assets << 'application.css'

      # Bootstrap fonts, I'm including fonts in my sass file with:
      # $icon-font-path: "bootstrap-sass/assets/fonts/bootstrap/"
      # then I take the last 5 elements
      fonts = Dir[Focus::Container.root.join(
        'vendor/assets/bower_components/bootstrap-sass/assets/fonts/bootstrap/*'
      )].map do |font|
        font.split('/').last(5).join('/')
      end

      (assets + fonts).each do |filename|
        asset = container['sprockets'][filename]
        path = filename =~ /\.(js|css)$/ ? asset.digest_path : filename
        outfile = Pathname.new(outpath).join(path)

        asset.write_to(outfile)

        puts "successfully compiled #{filename} assets for #{container}"

        filenames["#{sub_app_dir}__#{filename}"] =
          "/public/#{sub_app_dir}/assets/#{asset.digest_path}"
      end
    end

    # Write the manifest file
    File.open('public/manifest.yml', 'w') do |file|
      file.write(YAML.dump(filenames))
    end
  end

  desc 'clean assets'
  task :clean do
    system('rm -rf public/*')
  end
end
```

Now you can precompile your assets with:

```
$ RACK_ENV=production rake assets:precompile
```

#### The last step use Rack::Static to serve compiled assets in production

Add to your `config.ru`

```ruby
use Rack::Static, urls: ['/public']

require_relative 'system/boot'
run Focus::Web.freeze.app
```

And that's all.
