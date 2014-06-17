require './lib/jobs'

SCHEDULER.every '10m', first_in: 0 do
  GoldenBoot.update
  PredictedWinner.update
  FirstOwnGoal.update
  Skimlinks.update
  # Bootstraps GoalsScored, FastestGoal and MostReds
  LoadFromWiki.update
end
