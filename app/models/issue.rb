class Issue < ActiveRecord::Base

  def self.define_with_default_fatal(klass, default)
    Issue.const_set(klass.to_s.titleize, Class.new(Issue) {
                      define_method :initialize do
                        super()
                        self.fatal = default
                      end
                    })
  end

  def self.def_fatal(k) define_with_default_fatal(k, true) end
  def self.def_info(k) define_with_default_fatal(k, false) end

  private_class_method :define_with_default_fatal, :def_fatal, :def_info

  
  belongs_to :build
  
  def_fatal :Abort
  def_fatal :Error
  def_info :Warning
  def_info :Convention
  def_info :Refactor

  ObjectSpace.each_object(Issue.singleton_class).reject { |k| k == Issue }.each do |klass|
    klass.define_singleton_method(klass.name.demodulize.pluralize.to_sym) do
      where(type: klass)
    end
  end
end


