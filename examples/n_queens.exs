alias Evolution.Genetic

problem = Evolution.Genetic.Problems.NQueens

population = Genetic.initialise(problem,
  population_size: 100,
  problem_size: 13,
  mutation_rate: 0.1,
  survival_rate: 0
)

solution = Genetic.solve(problem, population,
  re_insertion: "pure",
  reporter: Evolution.Reporters.LoggerReporter
)

IO.inspect solution.champion
