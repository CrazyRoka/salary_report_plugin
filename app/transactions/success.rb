class Success
  def initialize(str = '')
    @str = str
  end

  def success?
    true
  end

  def result
    @str
  end
end
