# frozen_string_literal: true

module Results
  class Repository
    attr_reader :results

    def initialize(results = [])
      @results = results
    end

    # @return [Array] Positive results
    def positives
      partition.first
    end

    # @return [Array] Negative results
    def negatives
      partition.last
    end

    # @return [Hash] Number of positive and negative results
    def stats
      results.map(&:infected_status).tally
    end

    # @param [Integer] count Number of samples returned
    # @return [Array] Random unique samples
    def random(count = 3)
      results.sample(count)
    end

    # @return [Array] Critical results
    def filter_critical(results = self.results)
      results.select(&:critical?)
    end

    # @return [Result] First critical result
    def first_critical
      filter_critical(results.lazy).first
    end

    private

    def partition
      @partition ||= results.partition(&:infected?)
    end
  end
end
