# frozen_string_literal: true

require "active_support/testing/time_helpers"
require_relative "../../app/models/person"

RSpec.describe Person do
  include ActiveSupport::Testing::TimeHelpers

  subject(:person) { Person.new(birth_on: "1978-2-28") }

  it { is_expected.to have_attributes id: match(/[[:alnum:]]*/), birth_on: DateTime.new(1978, 2, 28) }

  it "calculates the person's age" do
    travel_to Date.new(2020, 10, 30) do
      expect(person.age).to eql 42
    end
  end

  it "knows if the person did not have his birthday yet" do
    travel_to Date.new(2020, 2, 27) do
      expect(person.age).to eql 41
    end
  end
end
