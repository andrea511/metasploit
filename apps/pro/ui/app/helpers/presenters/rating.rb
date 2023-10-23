module Presenters::Rating
  def rating(rank)
    [(rank - 100), 0].max / 100
  end
end