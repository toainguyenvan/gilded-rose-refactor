class GildedRose
  def initialize(items)
    @items = items
  end
  attr_accessor :items

  def update_quality
    @items.each do |item|
      update_item(item) unless is_sulfuras?(item)
    end
  end

  def update_item(item)
    is_normal?(item) ? decrease_quality(item) : increace_others_quality(item)
    decrease_sell_in(item)
    check_whether_sell_in_passed(item)
  end

  def increace_others_quality(item)
    increace_quality(item)
    increace_back_stage_quality(item) if is_backstage?(item)
  end

  def check_whether_sell_in_passed(item)
    if item.sell_in < 0
      is_normal?(item) ? decrease_quality(item) : sell_in_passed_non_legendary(item)
    end
  end

  def decrease_quality(item)
    item.quality -= 1 if item.quality > 0
    item.quality -= 1 if is_conjured?(item)
  end

  def increace_back_stage_quality(item)
    increace_quality(item) if item.sell_in < 11
    increace_quality(item) if item.sell_in < 6
  end

  def decrease_sell_in(item)
    item.sell_in -= 1
  end

  def drop_zero(item)
    item.quality = 0
  end

  def sell_in_passed_non_legendary(item)
    !is_aged_brie?(item) ? drop_zero(item) : increace_quality(item)
  end

  def increace_quality(item)
    item.quality += 1 if (item.quality < 50)
  end

  def is_normal? (item)
    !is_aged_brie?(item) && !is_backstage?(item)
  end

  def is_aged_brie? (item)
    item.name == 'Aged Brie'
  end

  def is_backstage? (item)
    item.name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def is_sulfuras? (item)
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  def is_conjured? (item)
    item.name == 'Conjured'
  end
end

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
