module ColorfulExceptions
  def backtrace
    value = super
    if value
      green  = "\e[#{32}m"
      cyan   = "\e[#{36}m"
      clear = "\e[0m"
      value.map do |msg|
        case msg
        when %r[\A(.*?):(\d+):in `(.*)'\z]
          "#{green}#{$1}#{clear}:#{green}#{$2}#{clear}: in `#{cyan}#{$3}#{clear}'"
        # Never seen them, but documentation insists they exist
        when %r[\A(.*?):(\d+)]
          "#{green}#{$1}#{clear}:#{green}#{$2}#{clear}"
        else
          "#{green}#{msg}#{clear}"
        end
      end
    else
      value
    end
  end
end

class Exception
  prepend ColorfulExceptions
end
