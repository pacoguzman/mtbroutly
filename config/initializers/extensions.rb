
class Hash
  def to_eschaton_center
    reverse_merge!({ :latitude => nil, :longitude => nil })
    replace_keys!({:lng => :longitude, :lat => :latitude})
    slice(:latitude, :longitude)
  end

  def replace_keys!(keys ={})
    keys.each do |k,v|
      replace_key!(k, v)
    end
  end

  def replace_key!(from, to)
    if include?(from)
      self[to] = self[from]
    end
    self
  end
end
