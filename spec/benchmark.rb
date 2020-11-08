# frozen_string_literal: true

require "benchmark"
require "benchmark/memory"
require "benchmark/ips"

require_relative "../app/models/result"
require_relative "../app/models/person"
require_relative "../app/results/repository"
require_relative "../app/results/repository_anze"
require_relative "../app/results/repository_joosko"

results = 10_000.times.map do
  Result.new person: Person.new(birth_on: "#{rand(1930..2002)}-#{rand(1..12)}-#{rand(1..28)}"),
             infected: %i[f f f t f].sample
end

def runner(results, repository_class = Results::Repository)
  repo = repository_class.new(results)
  repo.positives
  repo.negatives
  repo.stats
  repo.filter_critical
  repo.first_critical
end

puts "-------- IPS ---------\n"
Benchmark.ips do |x|
  x.config(time: 5, warmup: 2)

  x.report("Repository") { runner results }
  x.report("RepositoryAnze") { runner results, Results::RepositoryAnze }
  x.report("RepositoryJoosko") { runner results, Results::RepositoryJoosko }

  x.compare!
end

puts "-------- CPU ---------\n"
Benchmark.bmbm do |x|
  x.report("Repository") { runner results }
  x.report("RepositoryAnze") { runner results, Results::RepositoryAnze }
  x.report("RepositoryJoosko") { runner results, Results::RepositoryJoosko }
end

puts "\n-------- MEM ---------\n"
Benchmark.memory do |x|
  x.report("Repository") { runner results }
  x.report("RepositoryAnze") { runner results, Results::RepositoryAnze }
  x.report("RepositoryJoosko") { runner results, Results::RepositoryJoosko }

  x.compare!
end
