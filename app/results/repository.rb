# frozen_string_literal: true

module Results
  class Repository
    attr_reader :results

    def initialize(results = [])
      @results = results
    end

    # We need a list of positive results to inform them of their infection status.
    # Implement a method #positives that returns results that have positive infected status from the results set.
    # To run specs exclusively, run `bundle exec rspec spec/results/repository_spec.rb:24`
    # @return [Array] Results that have positive infected status
    def positives

    end

    # We need a list of negative results that we can use at a later time to inform them they are not infected.
    # Implement a method #negatives that returns all results that have negative infected status from the results set.
    # To run specs exclusively, run `bundle exec rspec spec/results/repository_spec.rb:38`
    # @return [Array] Negative results
    def negatives

    end

    # We need counts of positive and negative results to display daily statistics of infected statuses.
    # Implement a method #stats that counts positive and negative results respectively.
    # To run specs exclusively, run `bundle exec rspec spec/results/repository_spec.rb:52`
    # @example Results::Repository.new(results).stats #=> { positive: 3, negative: 7 }
    # @return [Hash] A hash with positive and negative keys and number of results
    def stats

    end

    # Occasionally we will need to double check random samples of results to ensure good confidence? of the tests.
    # Implement a method #random that returns unique samples that can be used to double check the test results.
    # To run specs exclusively, run `bundle exec rspec spec/results/repository_spec.rb:70`
    # @param [Integer] count Number of samples returned
    # @return [Array] Array of random unique samples
    def random(count = 3)

    end

    # We will need to filter the result list to show us results of people that are considered to be critical if they are
    # infected, so we can more closely monitor their status or pre-emptively hospilatize them.
    # Implement a method #filter_critical that will return all results of people that are infected and equal or over the
    # age of 80.
    # To run specs exclusively, run `bundle exec rspec spec/results/repository_spec.rb:112`
    # @return [Array] Array of all critical results
    def filter_critical

    end

    # Since results are entered chronologically at the time of taking of the test, we assume that the results at the
    # start of the result array have been infected longer and are thus more critical to take care of immediately.
    # Implement a method that returns the first critical result it finds. Mind that you do not iterate over the whole
    # array of results, but return early as soon as you find the first critical result. Even though the test samples are
    # currently quite small, they will probably be a lot bigger and contain more data in the real world, so iterating
    # through them all might prove too costly
    # To run specs exclusively, run `bundle exec rspec spec/results/repository_spec.rb:126`
    # @return [Result] First critical result
    def first_critical

    end
  end
end
