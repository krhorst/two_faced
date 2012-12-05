# TwoFaced

You've developed a site...and a mobile site...and facebook tab. Everything pulls in the same data and is working swimmingly, until you get a call from your boss/client --

"Hi, can we use a different photo for the Facebook version of this article? Also, the title of the Parmesan Crusted Chicken Cutlets is too long for mobile, can we just call them "Cheesy Cutlets" for mobile? "

At this point you have a few options:

1. Say no. They only get one image and one title and have to deal with it. Congratulations! You've just saved yourself a hassle.

2. Add new columns like "facebook_image" and "mobile_title" for these edge cases

3. Duplicate the records for each context and scope your queries accordingly. (Recipe.where(:context => "facebook").all ) This works, but the duplication can be a pain

4. Use TwoFaced to monkey-patch your data! Only override the attributes that are different.


## Installation

Add this line to your application's Gemfile:

    gem 'two_faced'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install two_faced

After you install Two Faced and add it to your Gemfile, you need to run the generator:

    $ rails generate two_faced:install

## Configuring Models



## Usage



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
