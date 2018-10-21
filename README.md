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
Create the `GildedRose` instance:
```ruby
gilded_rose = GildedRose([item])
```
`item` can be a single object or the array of Struct `Item`

The `update_quality` function use to calculate quality of the list item

We seperate item into many types like these:

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

New reuirement, `Conjured` items, the behaviour is X2 than normal item, so:
- Lower the quality by 2 everyday
- Lower the quality by 4 when sell date passed
