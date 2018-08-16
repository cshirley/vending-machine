module Vending
  class Container

    def initialize(item_type:, items: nil)
      raise ArgumentError.new('item_type must not be nil') unless item_type
      @item_type = item_type
      @items = {}
      (items || []).each { |item| add(item) }
      self
    end

    def all
      items.values.flatten
    end

    def [](id)
      find_all(id).first || nil
    end

    def ids
      items.keys
    end

    def find_all(id)
      items.fetch(id.to_s, [])
    end

    def add(item)
      validate_item!(item)
      items[item.id] ||= []
      items[item.id] << item
      self
    end

    def remove(item)
      validate_item!(item)
      items.fetch(item.id, nil) ? items[item.id].pop : nil
    ensure
      if items && item &&
          item.is_a?(ContainerItem) &&
          items.fetch(item.id, []).length == 0
        items.delete(item.id)
      end
    end

    def add_items(new_items)
      new_items.each { |item| validate_item!(item) }
      new_items.each { |item| add(item) }
    end

    def remove_all
      removed_items = self.all
      @items = {}
      removed_items
    end

    def key_item_count
      items.inject({}) { |h, kv| h[kv.first] = kv.last.length; h; }
    end

    private

    attr_accessor :items, :item_type, :valid_item_keys

    def validate_item!(item)
      raise InvalidItemError.new("Invalid Type must be a #{item_type.name}") unless item && item.is_a?(ContainerItem)
      raise InvalidItemError.new("Invalid Type must be a #{item_type.name}") unless item && item.is_a?(item_type)
      validate_delegator(item)
    end

    def validate_delegator(item)
      validate(item) if respond_to?(:validate)
    end
  end
end
