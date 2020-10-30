# frozen_string_literal: true

require_relative "../../app/models/result"
require_relative "../../app/models/person"

RSpec.describe Result do
  let(:person) { double Person }

  context "with truthy values" do
    [true, "true", "1", 1].each do |infected_value|
      it "evaluates infected? to true" do
        result = Result.new(person: person, infected: infected_value)

        expect(result.infected?).to be true
      end
    end
  end

  it "is not infected when passed a falsey infected status" do
    result = Result.new(person: person, infected: false)

    expect(result.infected?).to be false
  end
end
