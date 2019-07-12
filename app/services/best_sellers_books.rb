class BestSellersBooks
  def self.call
    new.call
  end

  def call
    Category.all.select { |category| category.books.count.positive? }.map do |category|
      category.books.max { |book| book.reviews.count }
    end[0...4]
  end
end
