# lib/model.rb
module Model
  def self.included(base)
    base.extend(ClassMethods)
    base.instance_variable_set(:@attributes_definitions, {})
  end

  module ClassMethods
    # Метод для определения атрибутов
    def attribute(name, options = {})
      @attributes_definitions[name] = options

      # Геттер
      define_method(name) do
        value = instance_variable_get("@#{name}")
        if value.nil? && options.key?(:default)
          default = options[:default]
          value = default.is_a?(Proc) ? instance_eval(&default) : default
          send("#{name}=", value)
        end
        value
      end

      # Сеттер
      define_method("#{name}=") do |val|
        if options[:type] && !val.nil?
          val = convert_type(val, options[:type])
        end
        instance_variable_set("@#{name}", val)
      end
    end

    # Классовый метод для получения определений атрибутов
    def attributes_definitions
      @attributes_definitions
    end
  end

  # Конструктор класса
  def initialize(attrs = {})
    # Преобразуем ключи хэша в символы для согласованности
    attrs = attrs.transform_keys(&:to_sym)
    self.class.attributes_definitions.each do |name, options|
      if attrs.key?(name)
        send("#{name}=", attrs[name])
      else
        if options.key?(:default)
          default = options[:default]
          value = default.is_a?(Proc) ? instance_eval(&default) : default
          send("#{name}=", value)
        else
          send("#{name}=", nil)
        end
      end
    end
  end

  # Экземплярный метод для получения текущих атрибутов
  def attributes
    self.class.attributes_definitions.keys.each_with_object({}) do |name, hash|
      hash[name] = send(name)
    end
  end

  private

  # Метод для преобразования типов
  def convert_type(value, type)
    case type
    when :integer
      Integer(value)
    when :datetime
      DateTime.strptime(value, "%d/%m/%Y")
    when :boolean
      !!value
    else
      value
    end
  end
end