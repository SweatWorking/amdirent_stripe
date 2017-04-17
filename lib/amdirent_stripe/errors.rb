class NoCardError < Exception
  def message
    "No card present!"
  end
end

class NoCustomerError < Exception
  def message
    "No stripe customer present!"
  end
end

class NoSuchCardError < Exception
  def message
    "Not a valid card token!"
  end
end

class NoSuchCustomerError < Exception
  def message
    "No such stripe customer!"
  end
end

class NoSuchSubscriptionError < Exception
  def message
    "No such stripe subscription!"
  end
end