class FakeStorage

  def received
    @received ||= []
  end

  def save(resource)
    received << resource
  end

end