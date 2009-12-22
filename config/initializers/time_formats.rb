Time::DATE_FORMATS[:month_format] = lambda {|time| time.strftime("%B %d, %Y")  }

Time::DATE_FORMATS[:long_format] = lambda { |time| time.strftime("%d.%m.%y %H:%M:%S") }
Time::DATE_FORMATS[:date_format] = lambda { |time| time.strftime("%d.%m.%Y") }