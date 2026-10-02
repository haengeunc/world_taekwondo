connection: "sample_bigquery_connection"

# Include views and dashboards
include: "/views/*.view.lkml"
include: "/dashboards/*.dashboard.lookml"

label: "World Taekwondo Analytics"

datagroup: world_taekwondo_default_datagroup {
  max_cache_age: "24 hours"
  sql_trigger: SELECT MAX(snapshot_date) FROM `opm-looker-core-demo-instance.world_taekwondo.fact_athlete_monthly_rankings` ;;
}

persist_with: world_taekwondo_default_datagroup

explore: tournament_performance {
  label: "Tournament Performance & Match Analytics"
  description: "Examines tournament placements, medal conversions, points awarded, and match participation across Kyorugi and Poomsae"
  from: fact_tournament_results
  view_name: tournament_performance

  join: dim_athletes {
    type: left_outer
    relationship: many_to_one
    sql_on: ${tournament_performance.athlete_id} = ${dim_athletes.athlete_id} ;;
  }

  join: dim_tournaments {
    type: left_outer
    relationship: many_to_one
    sql_on: ${tournament_performance.tournament_id} = ${dim_tournaments.tournament_id} ;;
  }
}

explore: athlete_rankings {
  label: "Monthly Athlete Rankings & Momentum"
  description: "Official World Taekwondo monthly ranking snapshots, rank deltas (Fast Risers, Stable, Dropping), and Olympic qualification cutoff trackers"
  from: fact_athlete_monthly_rankings
  view_name: athlete_rankings

  join: dim_athletes {
    type: left_outer
    relationship: many_to_one
    sql_on: ${athlete_rankings.athlete_id} = ${dim_athletes.athlete_id} ;;
  }
}
