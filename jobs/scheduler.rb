require './lib/jobs'

SCHEDULER.every '5m', first_in: 0 do
  GoldenBoot.update
  PredictedWinner.update

  # Bootstraps GoalsScored, FastestGoal and MostReds
  LoadFromWiki.update
end
