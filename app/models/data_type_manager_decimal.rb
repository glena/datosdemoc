class DataTypeManagerDecimal
  def format str
    str.to_f
  end
  def input_type
    'number'
  end
end