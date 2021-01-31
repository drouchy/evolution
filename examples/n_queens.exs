alias Evolution.Genetic

problem = Evolution.Genetic.Problems.NQueens

population = Genetic.initialise(problem,
  population_size: 100,
  problem_size: 16,
  mutation_rate: 0.1,
  survival_rate: 0
)

solution = Genetic.solve(problem, population,
  crossover: "order_one",
  re_insertion: "pure",
  reporter: Evolution.Genetic.Reporters.LoggerReporter
)

IO.inspect solution.champion
