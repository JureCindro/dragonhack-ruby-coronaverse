# frozen_string_literal: true

module Results
  class Stats
    attr_reader :results

    def initialize(results = [])
      @results = results
    end

    def positives
      partition.first
    end

    def negatives
      partition.last
    end

    def stats
      results.map(&:infected_status).tally
    end

    private

    def partition
      @partition ||= results.partition(&:infected?)
    end
  end
end
