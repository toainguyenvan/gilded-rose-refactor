require_relative '../lib/gilded_rose_refactor'

RSpec.describe GildedRoseRefactor do
    context "APPROACH 1" do
        context "Normal Items" do
            it "Not change the item name" do
                item = Item.new('name', 1, 10)
                gilded_rose = described_class.new([item])
                gilded_rose.update_quality
                expect(item.name).to eq 'name'
            end

            it "Lower the quality by day, BEFORE sell date passed" do
                quality = 10
                item = Item.new('name', 10, quality)
                gilded_rose = described_class.new([item])
                5.times do |i|
                gilded_rose.update_quality
                expect(item.quality).to eq (quality -  (i + 1))
                end
            end

            it "Lower the quality by day, WHEN sell date passed" do
                quality = 10
                item = Item.new('name', 0, quality)
                gilded_rose = described_class.new([item])
                gilded_rose.update_quality
                expect(item.quality).to eq 8
            end

            it "Quality not negative" do
                item = Item.new('name', 0, 0)
                gilded_rose = described_class.new([item])
                gilded_rose.update_quality
                expect(item.quality).to be >= 0
            end

            it "Check quality when sell date passed" do
                item = Item.new('name', 0, 2)
                gilded_rose = described_class.new([item])
                gilded_rose.update_quality
                expect(item.quality).to eq 0
            end
        end

        context "Aged Brie Items" do
            item = Item.new('Aged Brie', 1, 0)
            gilded_rose = described_class.new([item])
            
            it "Increase quality by older it gets" do
                gilded_rose.update_quality
                expect(item.quality).to eq 1
            end
        
            it "When sell date passed, quality increase twice" do
                gilded_rose.update_quality
                expect(item.quality).to eq 3
                gilded_rose.update_quality
                expect(item.quality).to eq 5
            end
        
            it "Quality never greater than 50" do
                item = Item.new('Aged Brie', 0, 49)
                gilded_rose = described_class.new([item])
                3.times {
                    gilded_rose.update_quality
                    expect(item.quality).to be <= 50
                }
            end
        end

        context "Backstage passes Items" do
            context "When sell date not passed" do
                it "sell_in > 10. Increase 1 by older it gets" do
                    quality = 1
                    item = Item.new('Backstage passes to a TAFKAL80ETC concert', 20, quality)
                    gilded_rose = described_class.new([item])
                    5.times do |i|
                        gilded_rose.update_quality
                        expect(item.quality).to eq (quality + (i + 1))
                    end 
                end
                
                it "When 5 < sell_in <= 10, quality increase by 2" do
                    quality = 1
                    item = Item.new('Backstage passes to a TAFKAL80ETC concert', 10, quality)
                    gilded_rose = described_class.new([item])
                    3.times do |i|
                        gilded_rose.update_quality
                        expect(item.quality).to eq (quality + 2 * (i + 1))
                    end
                end
            
                it "When sell_in <= 5, quality increase by 3" do
                    quality = 1
                    item = Item.new('Backstage passes to a TAFKAL80ETC concert', 5, quality)
                    gilded_rose = described_class.new([item])
                    3.times do |i|
                        gilded_rose.update_quality
                        expect(item.quality).to eq (quality + 3 * (i + 1))
                    end
                end
            end

            context "When sell_in passed" do
                it "Drop to 0" do
                    item = Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 10)
                    gilded_rose = described_class.new([item])
                    3.times {
                        gilded_rose.update_quality
                        expect(item.quality).to eq 0
                    }
                end
            end
        end

        context "Sulfuras Items" do
            item = Item.new('Sulfuras, Hand of Ragnaros', 0, 0)
            it "Not changes anything" do
            gilded_rose = described_class.new([item])
            5.times {
                gilded_rose.update_quality
                expect(item.sell_in).to eq 0
                expect(item.quality).to eq 0
            }
            end
        end

        context "Conjured Items" do
            it "Degrade quality twice than normal, BEFORE sell date passed" do
            item = Item.new('Conjured', 5, 10)
            gilded_rose = described_class.new([item])
            gilded_rose.update_quality
            expect(item.quality).to eq 8
            end
            it "Degrade quality twice than normal, AFTER sell date passed" do
            item = Item.new('Conjured', 0, 8)
            gilded_rose = described_class.new([item])
            gilded_rose.update_quality
            expect(item.quality).to eq 4
            gilded_rose.update_quality
            expect(item.quality).to eq 0
            end
        end
    end
end