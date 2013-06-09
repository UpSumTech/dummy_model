require "dummy_model/version"
require "active_model"
require "virtus"

module DummyModel
  extend ActiveSupport::Concern

  included do
    include Virtus
    extend ActiveModel::Callbacks
    include ActiveModel::Validations

    define_model_callbacks :save, :only => [:before, :after]
  end

  module ClassMethods
    def create(attrs = {})
      self.new(attrs).tap {|element| element.save}
    end

    def create!(attrs = {})
      self.new(attrs).tap {|element| element.save!}
    end
  end

  def save
    result = false
    run_callbacks :save do
      result = self.valid? && _save
    end
    result
  end

  def save!
    saved = self.save
    raise RecordInvalid.new(self) unless saved
    saved
  end

  def ==(other)
    return false unless other.respond_to? :attributes
    return self.attributes == other.attributes
  end

  def to_s
    self.class.name + " : " + attributes.inspect
  end

  def _save
    true
  end

end

require "dummy_model/errors.rb"
