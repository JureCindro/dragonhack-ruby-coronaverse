# frozen_string_literal: true

RSpec.describe Results::Repository do
  subject(:results_repository) { described_class.new(results) }

  let(:positive_results) do
    (3..4).to_a.sample.times.map do
      Result.new(
        person: Person.new(birth_on: "#{rand(1930..2002)}-#{rand(1..12)}-#{rand(1..28)}"),
        infected: true
      )
    end
  end
  let(:negative_results) do
    (6..7).to_a.sample.times.map do
      Result.new(
        person: Person.new(birth_on: "#{rand(1930..2002)}-#{rand(1..12)}-#{rand(1..28)}"),
        infected: false
      )
    end
  end
  let(:results) { [*positive_results, *negative_results].shuffle }

  describe "#positives" do
    subject(:positives) { results_repository.positives }

    it { is_expected.to be_an_instance_of Array }

    it "returns only positive results" do
      expect(positives).to all be_infected
    end

    it "contains all positive results" do
      expect(positives.size).to eql positive_results.count
    end
  end

  describe "#negatives" do
    subject(:negatives) { results_repository.negatives }

    it { is_expected.to be_an_instance_of Array }

    it "returns only negative results" do
      expect(negatives).not_to include be_infected
    end

    it "contains all negative results" do
      expect(negatives.size).to eql negative_results.count
    end
  end

  describe "#stats" do
    subject(:stats) { results_repository.stats }

    it { is_expected.to be_an_instance_of Hash }

    it "returns a hash with positives and negatives keys" do
      expect(stats.keys).to contain_exactly :positive, :negative
    end

    it "counts the positive tests" do
      expect(stats[:positive]).to be positive_results.count
    end

    it "counts the negative tests" do
      expect(stats[:negative]).to be negative_results.count
    end
  end

  describe "#random" do
    subject(:random_samples) { results_repository.random }

    it { is_expected.to be_an Array }

    it "returns 3 samples by default" do
      expect(random_samples.size).to be 3
    end

    it "can return more samples" do
      expect(results_repository.random(4).size).to be 4
    end

    it "returns unique samples" do
      sample_ids = random_samples.uniq

      expect(sample_ids.count).to be 3
    end

    it "second iteration returns different set of samples" do
      first_iteration_results = results_repository.random
      second_iteration_results = results_repository.random

      expect(first_iteration_results).not_to match second_iteration_results
    end
  end

  context "with filtering" do
    subject(:results_repository) { described_class.new(positive_results) }

    let(:ages) { [20, *[40, 60, 70, 80, 85, 90, 92].shuffle] }
    let(:positive_results) do
      ages.count.times.map.with_index { |i|
        Result.new(
          person: Person.new(
            birth_on: "#{Date.current.year - ages[i]}-#{rand(1..Date.current.month - 1)}-#{rand(1..28)}"
          ),
          infected: true
        )
      }
    end

    describe "#filter_critical" do
      subject(:filter_critical_results) { results_repository.filter_critical }

      it { is_expected.to be_an Array }

      it "returns all critical results" do
        expect(filter_critical_results.size).to be 4
      end

      it "returns ages over or equal to 80" do
        expect(filter_critical_results).to all satisfy { |result| result.person.age >= 80 }
      end
    end

    describe "#first_critical" do
      subject(:first_critical_result) { results_repository.first_critical }

      before do
        allow_any_instance_of(Result).to receive(:person).and_call_original
      end

      it { is_expected.to be_a Result }
      it { is_expected.to be_critical }

      it "returns the first critical result" do
        critical_result_index = positive_results.index first_critical_result

        expect(positive_results[0..critical_result_index - 1]).to all satisfy { |result| result.person.age < 80 }
      end

      context "with query optimization" do
        let(:first_person) { instance_double Person, age: 20 }
        let(:critical_person) { instance_double Person, age: 80 }
        let(:third_person) { instance_spy Person, age: 30 }
        let(:positive_results) do
          3.times.map { Result.new(person: Person.new(birth_on: double), infected: true) }
        end

        before do
          allow(Person).to receive(:new).and_return first_person, critical_person, third_person
        end

        it "returns early at the first critical result" do
          first_critical_result

          expect(third_person).not_to have_received :age
          expect(third_person).not_to have_received :birth_on
        end
      end
    end
  end
end
