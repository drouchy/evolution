alias Evolution.Genetic

problem = Evolution.Genetic.Problems.TravelingSalesman

cities = [
  %{lat: 35.6897, lng: 139.6922},
  %{lat: -6.2146, lng: 106.8451},
  %{lat: 28.6600, lng: 77.2300},
  %{lat: 18.9667, lng: 72.8333},
  %{lat: 14.5958, lng: 120.9772},
  %{lat: 31.1667, lng: 121.4667},
  %{lat: -23.5504, lng: -46.6339},
  %{lat: 37.5833, lng: 127.0000},
  %{lat: 19.4333, lng: -99.1333},
  %{lat: 23.1288, lng: 113.2590},
  %{lat: 39.9050, lng: 116.3914},
  %{lat: 30.0561, lng: 31.2394},
  %{lat: 40.6943, lng: -73.9249},
  %{lat: 22.5411, lng: 88.3378},
  %{lat: 55.7558, lng: 37.6178},
  %{lat: 13.7500, lng: 100.5167},
  %{lat: -34.5997, lng: -58.3819},
  %{lat: 22.5350, lng: 114.0540},
  %{lat: 23.7161, lng: 90.3961},
  %{lat: 6.4500, lng: 3.4000},
  %{lat: 41.0100, lng: 28.9603},
  %{lat: 34.6936, lng: 135.5019},
  %{lat: 24.8600, lng: 67.0100},
  %{lat: 12.9699, lng: 77.5980},
  %{lat: 35.7000, lng: 51.4167},
  %{lat: -4.3317, lng: 15.3139},
  %{lat: 10.8167, lng: 106.6333},
  %{lat: 34.1139, lng: -118.4068},
  %{lat: -22.9083, lng: -43.1964},
  %{lat: 32.9987, lng: 112.5292},
  %{lat: 13.0825, lng: 80.2750},
  %{lat: 30.6636, lng: 104.0667},
  %{lat: 31.5497, lng: 74.3436},
  %{lat: 48.8566, lng: 2.3522},
  %{lat: 51.5072, lng: -0.1275},
  %{lat: 35.0606, lng: 118.3425},
  %{lat: 39.1467, lng: 117.2056},
  %{lat: 38.0422, lng: 114.5086},
  %{lat: 38.8671, lng: 115.4845},
  %{lat: 33.6250, lng: 114.6418},
  %{lat: -12.0500, lng: -77.0333},
  %{lat: 17.3667, lng: 78.4667},
  %{lat: 4.6126, lng: -74.0705},
  %{lat: 36.7167, lng: 119.1000},
  %{lat: 35.1167, lng: 136.9333},
  %{lat: 30.5872, lng: 114.2881},
  %{lat: 35.2333, lng: 115.4333},
  %{lat: 25.8292, lng: 114.9336},
  %{lat: 34.2610, lng: 117.1859},
]

population = Genetic.initialise(problem,
  population_size: 100,
  problem_size: length(cities),
  mutation_rate: 0.1,
  survival_rate: 0,
  cities: cities
)

solution = Genetic.solve(problem, population,
  reporter: Evolution.Genetic.Reporters.LoggerReporter,
  cities: cities,
  max_iteration: 1_000
)

IO.inspect solution.champion
