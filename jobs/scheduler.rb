require './lib/jobs'

SCHEDULER.every '5m', first_in: 0 do
  GoalsConceded.update
  GoalsScored.update
  GoldenBoot.update
  PredictedWinner.update
  MostReds.update
end
