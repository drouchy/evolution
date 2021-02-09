alias Evolution.Genetic

problem = Evolution.Problems.OneMax

population = Genetic.initialise(problem, population_size: 15, problem_size: 50, mutation_rate: 0.1, survival_rate: 0)
solution = Genetic.solve(problem, population, reporter: Evolution.Genetic.Reporters.LoggerReporter)

IO.inspect solution.champion
