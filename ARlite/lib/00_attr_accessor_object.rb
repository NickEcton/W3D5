class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |attr|
      define_method(attr) do
        instance_variable_get("@#{attr}")
      end
      define_method("#{attr}=") do |value|
        instance_variable_set("@#{attr}", value)
      end
    end
  end
end
