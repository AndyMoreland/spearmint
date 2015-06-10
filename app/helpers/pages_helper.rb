module PagesHelper
  def tool_to_language(name)
    case name
    when 'Ruby Sadist', 'RuboCop'
      'Ruby'
    when 'JSLint', 'JSComplexity'
      'JavaScript'
    when 'Pylint'
      'Python'
    else
      name
    end
  end
end
