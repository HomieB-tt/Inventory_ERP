MANUAL MERGE: Gemfile

Ruby unbundled several libraries from the default standard library
starting in 3.4, including csv, and you're on Ruby 4.0.5. Add this line
to your Gemfile (anywhere near the other gems is fine):

gem "csv"

Then run bundle install. Without this, `require "csv"` in
products_controller.rb will raise a LoadError when you try to export or
import.
