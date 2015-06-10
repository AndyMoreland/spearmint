require 'set'

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

  def ambiguous_name?(repos, repo)
    names = repos.map(&:name)
    names.select { |n| n == repo.name }.size > 1
  end

  def disambiguated_name(repos, repo)
    ambiguous_name?(repos, repo) ? repo.full_name : repo.name
  end
end
