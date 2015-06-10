module ReportsHelper
    def source_to_full_name(source)
        case source
        when 'rubysadist'
            'Ruby Sadist'
        when 'jscomplexity'
            'JSComplexity'
        else
            nil
        end
    end
end
