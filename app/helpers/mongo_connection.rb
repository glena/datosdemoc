#http://api.mongodb.org/ruby/current/
#http://www.slideshare.net/emstolfo/mongodb-ruby-on-rails-and-mongoid

#https://github.com/mongodb/mongo-ruby-driver/wiki/Tutorial
#http://docs.mongodb.org/manual/tutorial/getting-started-with-the-mongo-shell/


#https://github.com/seyhunak/twitter-bootstrap-rails

require 'mongo'
include Mongo

class MongoConnection

  include Singleton

  def initialize

    @connection =  MongoClient.new("localhost", 27017)
    @data = @connection.db("datosdemocraticos");

  end

  def get_collection collection_name

    @data.collection collection_name

  end

end