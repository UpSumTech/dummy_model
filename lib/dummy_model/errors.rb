module DummyModel
  class DummyModelError < StandardError
  end

  class RecordInvalid < DummyModelError
    def initialize(object)
      super(object.errors.full_messages.to_sentence)
    end
  end
end
