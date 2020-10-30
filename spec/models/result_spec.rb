# frozen_string_literal: true

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

  describe "#critical" do
    context "when person is infected" do
      subject { Result.new(person: person, infected: true) }

      context "when person is 80 or more" do
        let(:person) { Person.new(birth_on: 80.years.ago.to_s) }

        it { is_expected.to be_critical }
      end

      context "when person is less than 80" do
        let(:person) { Person.new(birth_on: 75.years.ago.to_s) }

        it { is_expected.not_to be_critical }
      end
    end

    context "when person is not infected" do
      subject { Result.new(person: person, infected: false) }

      context "when person is 80 or more" do
        let(:person) { Person.new(birth_on: 80.years.ago.to_s) }

        it { is_expected.not_to be_critical }
      end

      context "when person is less than 80" do
        let(:person) { Person.new(birth_on: 75.years.ago.to_s) }

        it { is_expected.not_to be_critical }
      end
    end
  end
end
