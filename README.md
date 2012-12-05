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

    gem 'two_faced', :git => "git://github.com/krhorst/two_faced.git"

And then execute:

    $ bundle


After you install Two Faced and add it to your Gemfile, you need to run the generator:

    $ rails generate two_faced:install
    $ rake db:migrate

## Configuring Models

Add the following line into any model you want to be overrideable:

    acts_as_overrideable

## Adding overrides with Active Admin

Add the nested attributes to the form for the resource, like so:

       form do |f|
         f.inputs
         f.has_many :overrides do |o|
           o.input :context_name
           o.input :field_name, :as => :select, :collection => f.object.attribute_names
           o.input :field_value
         end
         f.buttons
       end

## Adding overrides using the nested_form gem

Add the nested fields for overrides.

    <%= nested_form_for(@yourrecord) do |f| %>

        ## Your existing Fields

        <%= f.fields_for :overrides do |o|  %>
            <div class="field">
              <%= f.label :context_name %><br />
              <%=  o.text_field :context_name %><br/>
            </div>
            <div class="field">
              <%= f.label :field_name %><br />
              <%= o.select :field_name, f.object.attribute_names.map{ |value| [value, value]}  %>
              </div>
            <div class="field">
              <%= f.label :field_value %><br />
                <%= o.text_field :field_value %>
            </div>
        <% end  %>

        <%= f.link_to_add 'Add Override', :overrides %>

      <div class="actions">
        <%= f.submit %>
      </div>
    <% end %>

## Adding overrides programatically

    @yourrecord.overrides.create(:field_name => "name", :field_value => "New Name", :context_name => "mobile")

## Usage

You can now load up a version of your model with all overrides merged in. By default, two_faced will not overwrite the property, but will create a new method that will return the overridden property or the original property (if no override exists).

    @example = ModelName.for_context("facebook").first
    @example.name # Will be the original name
    @example.overridden_name # Will be the overridden name

If the overwrite parameter is passed, both the original property and the overridden property will be set to the new value

    @example = ModelName.for_context("facebook", :overwrite => true).first
    @example.name # Will be the overridden name
    @example.overridden_name # Will be the overridden name

If overwrite is set to true, it will also mark any records as read-only (to prevent saving this context-specific value back to the database). So this will give you an error:

    @example = ModelName.for_context("facebook", :overwrite => true).first
    @example.save #  ActiveRecord::ReadOnlyRecord exception

You can also pass a custom prefix which will be used in place of "overridden". An underscore will be appended to this, and then the property name

    @example = ModelName.for_context("facebook", :overwrite => true, :attribute_prefix = "custom").first
    @example.name # Will be the overridden name
    @example.custom_name # Will be the overridden name


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
