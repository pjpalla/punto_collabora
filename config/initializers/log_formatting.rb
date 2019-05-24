class Log4r::Logger
  def formatter()
    outputters[0].formatter if outputters.any?
  end
end