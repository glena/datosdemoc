class MongoDataInserter

  def initialize collection_name
    @mongo_collection = MongoConnection.instance.get_collection collection_name
    @data = []
  end

  def clear
    @mongo_collection.drop
  end

  def add item
    @data.push item
    if @data.length == 1000
       self.insert
    end
  end

  def insert
    if @data.length > 0
      @mongo_collection.insert @data
      @data.clear
    end
  end

end