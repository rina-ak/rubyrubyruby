module ApplicationHelper
  def russian_plural(count, one, few, many)
    n = count % 100
    n1 = n % 10

    word = if n.between?(11, 14)
      many
    elsif n1 == 1
      one
    elsif n1.between?(2, 4)
      few
    else
      many
    end

    "#{count} #{word}"
  end
end

