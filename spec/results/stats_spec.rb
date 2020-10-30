# frozen_string_literal: true

RSpec.describe Results::Stats do
  subject(:results_stats) { described_class.new results }

  let(:results) do
    [
      *3.times.map do
        Result.new(
          person: Person.new(birth_on: "#{rand(1930..2002)}-#{rand(1..12)}-#{rand(1..28)}"),
          infected: true
        )
      end,
      *7.times.map do
        Result.new(
          person: Person.new(birth_on: "#{rand(1930..2002)}-#{rand(1..12)}-#{rand(1..28)}"),
          infected: false
        )
      end
    ].shuffle
  end

  describe "#positives" do
    subject(:positives) { results_stats.positives }

    it { is_expected.to be_an_instance_of Array }

    it "returns only positive results" do
      expect(positives).to all have_attributes infected?: true
    end

    it "contains all positive results" do
      expect(positives.size).to eql 3
    end
  end

  describe "#negatives" do
    subject(:negatives) { results_stats.negatives }

    it { is_expected.to be_an_instance_of Array }

    it "returns only negative results" do
      expect(negatives).to all have_attributes infected?: false
    end

    it "contains all negative results" do
      expect(negatives.size).to eql 7
    end
  end

  describe "#stats" do
    subject(:stats) { results_stats.stats }

    it { is_expected.to be_an_instance_of Hash }

    it "returns a hash with positives and negatives keys" do
      expect(stats.keys).to contain_exactly :positive, :negative
    end

    it "counts the positive tests" do
      expect(stats[:positive]).to eql 3
    end

    it "counts the negative tests" do
      expect(stats[:negative]).to eql 7
    end
  end
end
