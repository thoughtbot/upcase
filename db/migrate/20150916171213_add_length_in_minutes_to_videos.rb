class AddLengthInMinutesToVideos < ActiveRecord::Migration[4.2]
  def up
    add_column :videos, :length_in_minutes, :integer

    update_existing_episode_lengths
  end

  def down
    remove_column :videos, :length_in_minutes
  end

  def update_existing_episode_lengths
    video_times = {
      "Intro to Docker" => 35,
      "Live Refactoring with Joe" => 19,
      "Page Objects" => 20,
      "Heroku Tips and Tricks" => 20,
      "Building a Gem" => 20,
      "Turbolinks" => 16,
      "Active Support" => 17,
      "Enumerable & Comparable" => 18,
      "Speaking For Developers" => 22,
      "APIs, HTTP, & JSON" => 29,
      "Intro to Dotfiles" => 25,
      "The Story of a Feature: Flashcards" => 22,
      "Parsing Program Languages" => 13,
      "Regular Expressions" => 29,
      "Intro to React" => 19,
      "Git Workflow" => 18,
      "Internationalization" => 18,
      "Debugging For Fun and Profit" => 15,
      "Intro to Ember" => 16,
      "Managing Windows in Vim" => 7,
      "Getting Help in Vim" => 8,
      "Route, Controller, Action" => 8,
      "Surviving Your First Week in Vim (and beyond)" => 15,
      "The Second Feature is Easier" => 29,
      "The First Feature is the Hardest" => 22,
      "Serving Your Front-End" => 27,
      "Apprentice.io Experiences" => 24,
      "Ruby Science: Extract Class" => 19,
      "Ruby Science: Introduce Parameter Object" => 8,
      "Ruby Science: Move Method" => 10,
      "Ruby Science: Extract Method" => 9,
      "Haskell: Pattern Matching" => 14,
      "Haskell: Intro to Types" => 18,
      "Haskell: Intro to Functions" => 9,
      "Property-Based Testing in Swift" => 12,
      "You Got Your Objective-C In My Swift!" => 13,
      "Form Objects" => 20,
      "Stubs, Mocks, Spies, and Fakes" => 26,
      "Tightening the TDD Feedback Loop" => 12,
      "Functional Swift" => 12,
      "JavaScript MVC: Backbone, Angular" => 26,
      "Vim: To Config or Not to Config?" => 29,
      "Rubyisms In Swift" => 17,
      "Integration vs Unit Testing" => 23,
      "Intro to ClojureScript" => 18,
      "Isolated Unit Testing" => 14,
      "Testing Vanity Metrics" => 10,
      "Speedy Tests" => 21,
      "Outside-In Testing" => 24,
      "Improving Vim Speed" => 14,
      "Dependency Management in Rails" => 19,
      "Four Phases of Testing" => 10,
      "Functors Are More Fun Than Nil" => 12,
      "Sandi Metz's Rules" => 11,
      "Landing a Rails Job" => 8,
      "Unit Testing JavaScript" => 34,
      "Composition Over Inheritance" => 23,
      "Tips For Code Review" => 29,
      "Callbacks" => 12,
      "Demonstrate Class Design Via TDD" => 24,
      "Functional & Object Oriented Programming in Ruby" => 32,
      "Refactor First" => 9,
      "Swift First Impressions" => 21,
      "Ship A Feature: Supporting Markdown" => 9,
      "Contributing To Open Source, Step-By-Step" => 26,
      "Interactively Debugging Test Failures" => 22,
      "Ship a Feature" => 28,
      "Show Your Setup: Joe Ferris" => 12,
      "Invert Control" => 13,
      "Value Objects" => 11,
      "Dependency Inversion Principle" => 19,
      "Interface Segregation Principle" => 12,
      "Liskov Substitution Principle" => 14,
      "Open-Closed Principle" => 15,
      "Single Responsibility Principle " => 16,
      "RSpec Best Practices" => 16,
      "Live Coding Session: Replace Conditional With Null Object" => 16,
      "Ping-Pong, Paired Programing" => 41,
      "Noodling Around [part 2, Haskell]" => 20,
      "Noodling Around [part 1, Clojure]" => 16,
      "Law of Demeter" => 14,
      "Extract Class" => 12,
      "Inject: Ruby's Fold" => 14,
      "Tell, Don't Ask" => 14,
      "Refactoring Fast Order Line, with Joe Ferris" => 34,
      "Polymorphic Finder, with Joe Ferris" => 21,
      "Improving your Workflow, with Chris Toomey" => 17,
      "Coupling, with Joe Ferris" => 17,
      "Nil is Unfriendly, with Joe Ferris" => 35
    }

    video_times.each do |name, length|
      connection.update(<<-SQL)
        UPDATE videos
          SET length_in_minutes = #{length}
          WHERE name = #{connection.quote(name)}
      SQL
    end
  end
end
