module LanguageDetective
  class Detector
    def self.filename_to_language(filename)
      ending = filename.split('.').last

      case ending
      when 'rb' then :ruby
      when 'js' then :javascript
      when 'py' then :python
      when 'c' then :c
      when 'cpp' then :cpp
      when 'h' then :c
      when 'java' then :java
      when 'html' then :html
      else :unknown_language end
    end
  end
end
