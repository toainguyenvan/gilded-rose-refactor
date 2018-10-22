class GildedRoseRefactor
    def initialize(items)
        @items = items
    end
    attr_accessor :items

    def update_quality
        @items.map { |item|
            case item.name
            when 'Sulfuras, Hand of Ragnaros'
                sulfuras = Sulfuras.new(item)
                sulfuras.update_quality
            when 'Aged Brie'
                aged_brie = AgedBrie.new(item)
                aged_brie.update_quality
            when 'Backstage passes to a TAFKAL80ETC concert'
                backstage = BackStage.new(item)
                backstage.update_quality
            when 'Conjured'
                conjured = Conjured.new(item)
                conjured.update_quality
            else
                normal = BaseItem.new(item)
                normal.update_quality
            end
        }
    end
end

class Sulfuras
    def initialize(item)
        @item = item
    end
    attr_accessor :item

    def update_quality
        item
    end
end

class BaseItem < Sulfuras
    def initialize(item)
        super
    end

    def sell_date_passed?
        item.sell_in <= 0
    end

    def check_sell_date
        sell_date_passed? ? when_sell_date_passed : before_sell_date_passed
    end

    def when_sell_date_passed
        decrease_quality(2)
    end

    def before_sell_date_passed
        decrease_quality
    end

    def increase_quality(times = 1)
        item.quality += times if item.quality < 50
    end

    def decrease_quality(times = 1)
        item.quality -= times if item.quality > 0
    end

    def check_quality_conditions
        item.quality = 0 if item.quality < 0
        item.quality = 50 if item.quality > 50
    end

    def decrease_sell_in
        item.sell_in -= 1
    end

    def update_quality
        check_sell_date
        decrease_sell_in
        check_quality_conditions
    end
end

class AgedBrie < BaseItem
    def initialize(item)
        super
    end
    
    def before_sell_date_passed
        increase_quality
    end

    def when_sell_date_passed
        increase_quality(2)
    end
end

class BackStage < BaseItem
    def initialize(item)
        super
    end
    
    def before_sell_date_passed
        increase_quality
        increase_quality if item.sell_in < 11
        increase_quality if item.sell_in < 6
    end

    def when_sell_date_passed
        item.quality = 0
    end
end

class Conjured < BaseItem
    def initialize(item)
        super
    end

    def before_sell_date_passed
        decrease_quality(2)
    end

    def when_sell_date_passed
        decrease_quality(4)
    end
end

Item = Struct.new(:name, :sell_in, :quality)