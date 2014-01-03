Habit Squares
------
Habit Squares is a web-based habit tracker that gathers data from third-party APIs to help you build and maintain regular habits. Think of it as an automated version of Jerry Seinfeld's famous ["don't break the chain" calendar](http://lifehacker.com/281626/jerry-seinfelds-productivity-secret).

Its interface is inspired by [continuous integration](http://en.wikipedia.org/wiki/Continuous_integration) monitors used in Extreme Programming and other forms of Agile software development. It features a status board containing up to 8 squares, each representing a single, actionable goal you want to accomplish each day. At the beginning of each day, every square is red; when you complete a goal, its square turns from green to red. At the bottom of each square is a rolling 7-day history of its red/green status.

The squares are driven by a modular system that uses third-party APIs to automatically determine when you've accomplished a goal without manual intervention, much as a CI board automatically turns green or red as a build passes or fails.

For more information about the goals and underlying design philosophy of this project, I'd recommend reading the [blog post]() introducing it.


Installation
============
Clone this repo:
`git clone https://github.com/lazerwalker/habit-squares.git`

### Configuration
There are two YAML files you will need to configure before you can use Habit Squares. Examples for each exist at `config/enabled.yml.example` and `config/externals.yml.example`.

#### Enabled.yml
This should contain a list of every service you want to use. The names should match the filenames in the `app/models` directory.

#### Externals.yml
For services requiring third-party credentials (most of them), you'll need to enter them here. A gentle reminder: if you have a public fork of this repository on GitHub, you DO NOT want to check this file into that public repository.

### Run a local server
```shell
bundle
rake db:migrate
rails s
```

You should have an instance up and running at `http://localhost:3000`.

### Deploy to Heroku
The recommended way of setting up a Habit Squares instance is to deploy it to Heroku. It should be ready out-of-the-box to deploy as a standard Heroku application. If you're not familiar with that process, check their documentation.

Similarly, it should be very easy to set up alternate deployment if Heroku isn't an acceptable option for you. It is a bog-standard Rails stack. Although it's currently configured to use postgres as a database, it should theoretically work with any ActiveRecord-compatible database.


Usage
=====
Habit Squares contains a number of built-in services, any of which can be enabled by adding them to your `enabled.yml` after entering the appropriate credentials in `externals.yml`. The correct key to use is the snake_cased filename of the `.rb` file in `app/models`. For example, to add the Remember the Milk service, you would add an entry in `externals.yml` that reads `- remember_the_milk`. Some of the built-in services include:

* Fitbit (distance walked, hours slept, and weight)
* Gmail (inbox count)
* Instapaper (number of articles in inbox)
* Remember The Milk (number of uncompleted tasks in a given list)
* 750 Words (whether an entry exists for today)
* Dropbox (whether a file matching a given name pattern exists)
* Buxfer (whether you are over or under your monthly budget given the current day of the month)

However, these are all services that I built and used because at one point in time I felt that tracking them was personally meaningful for me. The core philosophy behind this software is that you should only be quantifying things that have a measurable impact on your day-to-day happiness, health, and productivity. If you want to get the most out it, you will likely want to consider building your own custom services that help you track what is meaningful to you.


Defining Custom Services
========================
It is easy to create your own service that integrates with a third-party API. Simply create a new Ruby model within the `app/models` folder that is a subclass of `DataSource`. You will need to use standard Rails filename conventions: make the filename the snake_cased version of the class name (e.g. `FooBarBaz` should be defined in `foo_bar_baz.rb`). Once you've created your custom service, you should be able to add it to `enabled.yml` as normal.

There are a number of class instance variables you can configure in your subclass, as well as a number of methods you likely want to override.

`@description`: The text to show in each cell. Generally, this should be a yes-or-no question that asks about the current day (e.g. "Have I written in my journal today?").

`@show_count`: If true, the `count` value (determined by `updated_count`) will be shown on the square. Defaults to false.

`@unit`: The unit of measure, if any, to be displayed along with the count value (e.g. `mi` for distance walked)

`is_green?`: A method that should return true if the square should be green and false if it should be red. This will be called every time new data is fetched. If your subclass implements the `updated_count` method (see below), you can access the count value using the `count` accessor.

`updated_count`: A method that should return a value that represents the data you're trying to quantify. You'll likely use this in your ``is_green?` method, and is also displayed on-screen if `@show_count` is set to true.


### Tappable data sources
There are some things you'd like to track, but can't easily do so using third-party APIs or other automated data sources.

For these, there is an alternate approach. By subclassing `TappableDataSource` instead of `DataSource`, tapping or clicking on the corresponding cell will cause it to toggle between green and red for the current day. You can see an example of this in `creative.rb`; typically, all you will need to implement for tappable data sources is the `@description` parameter.


Contributing
============
Please do. Even if you've just added in a new third-party service, I'd love to merge it in.


License
=======
(c) 2013 Michael Walker
Habit Squares is licensed under the MIT license. See the LICENSE file for more info.
