view: fact_athlete_monthly_rankings {
  sql_table_name: `opm-looker-core-demo-instance.world_taekwondo.fact_athlete_monthly_rankings` ;;

  dimension: ranking_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ranking_id ;;
    hidden: yes
  }

  dimension: athlete_id {
    type: string
    sql: ${TABLE}.athlete_id ;;
    hidden: yes
  }

  dimension_group: snapshot {
    type: time
    timeframes: [raw, date, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.snapshot_date ;;
  }

  dimension: ranking_category {
    label: "Ranking Category"
    type: string
    sql: ${TABLE}.ranking_category ;;
  }

  dimension: division_name {
    label: "Division Name"
    type: string
    sql: ${TABLE}.division_name ;;
  }

  dimension: weight_or_form_class {
    label: "Weight / Form Class"
    type: string
    sql: ${TABLE}.weight_or_form_class ;;
  }

  dimension: current_rank {
    label: "Current Rank"
    type: number
    sql: ${TABLE}.current_rank ;;
  }

  dimension: rank_delta {
    label: "Rank Delta (Prior MoM)"
    type: number
    sql: ${TABLE}.rank_delta ;;
  }

  dimension: rank_movement_status {
    label: "Rank Movement Status"
    description: "Fast Riser (>= +5), Stable (-2 to +2), Dropping (<= -3)"
    type: string
    sql: CASE
           WHEN ${rank_delta} >= 5 THEN 'Fast Riser'
           WHEN ${rank_delta} <= -3 THEN 'Dropping'
           ELSE 'Stable'
         END ;;
  }

  dimension: olympic_cutoff_tier {
    label: "Olympic Cutoff Tier"
    description: "Tags top 6 automatic Olympic qualification quota positions"
    type: string
    sql: CASE
           WHEN ${current_rank} <= 6 THEN 'Top 6 (Olympic Quota Spot)'
           WHEN ${current_rank} <= 10 THEN 'Challenger (Rank 7-10)'
           ELSE 'Field (Rank 11+)'
         END ;;
  }

  dimension: ranking_points {
    label: "Ranking Points (Base)"
    type: number
    sql: ${TABLE}.total_ranking_points ;;
    hidden: yes
  }

  measure: total_points {
    label: "Total Accumulated Points"
    type: sum
    sql: ${ranking_points} ;;
    value_format_name: decimal_2
  }

  measure: average_points_per_athlete {
    label: "Average Global Points"
    type: average
    sql: ${ranking_points} ;;
    value_format_name: decimal_2
  }

  measure: max_rank_gain {
    label: "Max Rank Gain"
    type: max
    sql: ${rank_delta} ;;
  }

  measure: biggest_drop {
    label: "Biggest Rank Drop"
    type: min
    sql: ${rank_delta} ;;
  }
}
