# frozen_string_literal: true

require "date"

class Result
  attr_reader :created_at, :person, :infected_status

  def initialize(person:, infected:)
    @created_at = DateTime.now
    @person = person
    @infected_status = [true, "true", "1", 1].include?(infected) ? :positive : :negative
  end

  def infected?
    infected_status == :positive
  end
end
