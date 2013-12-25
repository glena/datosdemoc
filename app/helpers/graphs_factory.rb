class GraphsFactory
  include Singleton

  def initialize
    @graphs = {
        'comparativa-inflacion'=>GraphInflacion
    }
  end

  def get name
    return @graphs[name].new if @graphs.has_key? name
    return nil
  end
end