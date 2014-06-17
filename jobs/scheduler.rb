require './lib/jobs'

FirstOwnGoal.update
SCHEDULER.every '10m', first_in: 0 do
  GoldenBoot.update
  PredictedWinner.update

  # Bootstraps GoalsScored, FastestGoal and MostReds
  LoadFromWiki.update
end
