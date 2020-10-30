# frozen_string_literal: true

require "date"
require "securerandom"
require "active_support/time"

class Person
  attr_reader :id, :birth_on

  def initialize(birth_on:)
    @id = SecureRandom.uuid
    @birth_on = Date.parse birth_on
  end

  def age
    age = Date.today.year - @birth_on.year
    age -= 1 if Date.today < birth_on + age.years
    age
  end
end
