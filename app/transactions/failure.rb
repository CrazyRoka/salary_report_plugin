class Failure
  def initialize(str = '')
    @str = str
  end

  def success?
    false
  end

  def failure
    @str
  end
end
