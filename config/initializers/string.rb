class String

  def full_like
    "%#{self}%"
  end

  def right_like
    "%#{self}"
  end

  def left_like
    "#{self}%"
  end

end
