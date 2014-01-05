class DataTypeManagerBool
  def format str
    str.downcase!
    return true if str == 'true' || str == 't' || str == '1'
    return false
  end
end