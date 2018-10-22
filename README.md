## Ideas

I create `GildedRose` class like this:
```ruby
class GildedRose
  def initialize(items)
    @items = items
  end
  attr_accessor :items
  ...
end
```
Create the `gilded_rose` instance:
```ruby
gilded_rose = GildedRose.new([item])
```
`item` can be a single object or the array of Struct `Item`

The `update_quality` function use to calculate quality of the list item

## Next Steps

Implement the Test Cases to cover the logics:

Summary the requirements:

*Normal Items:*
- Lower the quality by 1 everyday
- Lower the quality by 2 when sell date passed (`sell_in = 0`)

*Aged Brie:*
- Increase the quality by 1 everyday
- Increase the quality by 2 when sell date passed

*Backstage passes:*
- Increase the quality by 1 every day
- Increase the quality by 2 when 5 < sell_in <= 10
- Increase the quality by 3 when 0 < sell_in <= 5
- Drop quality to 0 when sell date passed

## And...Conjured Items

New requirement, `Conjured` items, the behaviour is X2 than normal item, so:

Then, update the test case, add more context:
- Lower the quality by 2 everyday
- Lower the quality by 4 when sell date passed

## APPROACH 1 (gilded_rose_refactor.rb, gilded_rose_refactor_spec.rb)

Separate into many classes like these:

`Legendary` class for `Sulfuras`
```ruby
class Sulfuras
  def initialize(item)
    @item = item
  end
  attr_accessor :item

  def update_quality
    item
  end
end
```

Then, we inherit from that one:

`BaseItem`, for normal item
```ruby
class BaseItem < Sulfuras
  def initialize(item)
    super
  end
  ...
  def update_quality
    check_sell_date
    decrease_sell_in
    check_quality_conditions
  end
end
```

And, other classes inherit from `BaseItem`, like below:

```ruby
class AgedBrie < BaseItem
  def initialize(item)
    super
  end
  
  def before_sell_date_passed
    increase_quality
  end
  ...
end

class BackStage < BaseItem
  def initialize(item)
    super
  end
  ...
end

class Conjured < BaseItem
  def initialize(item)
    super
  end

  def before_sell_date_passed
    decrease_quality(2)
  end
  ...
end
```

*NOTE:*
Functions from `BaseItem` will be extended for difference purposes


## APPROACH 2 (gilded_rose.rb, gilded_rose_spec.rb)


Seperate item into many types like these:

*Aged Brie*
```ruby
def is_aged_brie?(item)
  item == 'Aged Brie'
end
```
*Back Stage passes*
```ruby
def is_aged_brie?(item)
  item == 'Backstage passes to a TAFKAL80ETC concert'
end
```
*Sulfuras (Legendary)*
```ruby
def is_sulfuras?(item)
  item == 'Sulfuras, Hand of Ragnaros'
end
```
And Normal:
```ruby
def is_normal? (item)
  !is_aged_brie?(item) && !is_backstage?(item)
end
```
## Test

How to test it?
```
rspec --format doc
```

The output should be:
```
GildedRose
  Normal Items
    Not change the item name
    Lower the quality by day, BEFORE sell date passed
    Lower the quality by day, WHEN sell date passed
    Quality not negative
    Check quality when sell date passed
  Sulfuras Items
    Not changes anything
  Aged Brie Items
    Increase quality by older it gets
    When sell_in passed, quality increase twice
    Quality never greater than 50
  Backstage passes Items
    When sell_in not passed
      sell_in > 10. Increase 1 by older it gets
      When 5 < sell_in <= 10, quality increase by 2
      When sell_in <= 5, quality increase by 3
    When sell_in passed
      Drop to 0
  Conjured Items
    Degrade quality twice than normal, BEFORE sell date passed
    Degrade quality twice than normal, AFTER sell date passed
```

Done.


