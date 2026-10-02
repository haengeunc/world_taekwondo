view: fact_athlete_monthly_rankings {
  sql_table_name: `opm-looker-core-demo-instance.world_taekwondo.fact_athlete_monthly_rankings` ;;

  # ---------------------------------------------------------------------------
  # Primary Key
  # ---------------------------------------------------------------------------
  dimension: ranking_id {
    primary_key: yes
    type: string
    description: "Unique ranking snapshot record identifier (e.g. RNK-000001)"
    sql: ${TABLE}.ranking_id ;;
  }

  # ---------------------------------------------------------------------------
  # Foreign Keys & Core Dimensions
  # ---------------------------------------------------------------------------
  dimension: athlete_id {
    type: string
    description: "Foreign key referencing dim_athletes"
    sql: ${TABLE}.athlete_id ;;
  }

  dimension_group: snapshot {
    type: time
    timeframes: [raw, date, month, quarter, year]
    convert_tz: no
    datatype: date
    description: "Official publication date of monthly World/Olympic rankings (1st of month)"
    sql: ${TABLE}.snapshot_date ;;
  }

  dimension: ranking_category {
    type: string
    description: "Ranking circuit classification: Olympic Kyorugi, World Kyorugi, World Poomsae, Para Kyorugi"
    sql: ${TABLE}.ranking_category ;;
  }

  dimension: division_name {
    type: string
    description: "Division classification, e.g. Olympic Senior Division"
    sql: ${TABLE}.division_name ;;
  }

  dimension: weight_or_form_class {
    type: string
    description: "Weight category or Poomsae discipline (e.g. M-58 kg, F-49 kg, Individual Recognized)"
    sql: ${TABLE}.weight_or_form_class ;;
  }

  dimension: current_rank {
    type: number
    description: "Current official standing in division (1 = World #1)"
    sql: ${TABLE}.current_rank ;;
  }

  dimension: rank_delta {
    type: number
    description: "Signed integer representing positions gained (+) or lost (-) since prior monthly snapshot"
    sql: ${TABLE}.rank_delta ;;
  }

  dimension: total_ranking_points {
    type: number
    description: "Total accumulated official World/Olympic ranking points"
    sql: ${TABLE}.total_ranking_points ;;
    value_format_name: decimal_2
  }

  # ---------------------------------------------------------------------------
  # Derived / Calculated Dimensions
  # ---------------------------------------------------------------------------
  dimension: rank_movement_status {
    type: string
    description: "Momentum tier: Fast Riser (delta >= +5), Stable (-2 to +2), Dropping (delta <= -3)"
    sql: CASE
      WHEN ${rank_delta} >= 5 THEN 'Fast Riser'
      WHEN ${rank_delta} <= -3 THEN 'Dropping'
      ELSE 'Stable'
    END ;;
  }

  dimension: olympic_cutoff_tier {
    type: string
    description: "Olympic qualification tier: Top 6 Automatic Cutoff vs. Outside Cutoff"
    sql: CASE
      WHEN ${current_rank} <= 6 THEN 'Top 6 Automatic Cutoff'
      ELSE 'Outside Cutoff'
    END ;;
  }

  dimension: rank_delta_symbol {
    type: string
    description: "Visual indicator for monthly rank momentum (e.g. ↑ 5, ↓ 3, -)"
    sql: CASE
      WHEN ${rank_delta} > 0 THEN CONCAT('↑ ', CAST(${rank_delta} AS STRING))
      WHEN ${rank_delta} < 0 THEN CONCAT('↓ ', CAST(ABS(${rank_delta}) AS STRING))
      ELSE '-'
    END ;;
  }

  dimension: is_top_ranked {
    type: yesno
    description: "True if athlete holds Rank 1 in their division"
    sql: ${current_rank} = 1 ;;
  }

  # ---------------------------------------------------------------------------
  # Measures
  # ---------------------------------------------------------------------------
  measure: count {
    type: count
    description: "Total monthly ranking snapshot records"
    drill_fields: [ranking_id, athlete_id, snapshot_date, weight_or_form_class, current_rank, rank_delta, total_ranking_points]
  }

  measure: total_points {
    type: sum
    description: "Sum of global ranking points"
    sql: ${total_ranking_points} ;;
    value_format_name: decimal_2
  }

  measure: average_points_per_athlete {
    type: average
    description: "Average ranking points per athlete"
    sql: ${total_ranking_points} ;;
    value_format_name: decimal_2
  }

  measure: max_rank_gain {
    type: max
    description: "Maximum positions gained in ranking cycle (highest positive rank delta)"
    sql: ${rank_delta} ;;
  }

  measure: biggest_drop {
    type: min
    description: "Maximum positions dropped in ranking cycle (most negative rank delta)"
    sql: ${rank_delta} ;;
  }

  measure: count_ranked_athletes {
    type: count_distinct
    description: "Count of unique ranked athletes"
    sql: ${athlete_id} ;;
  }

  measure: count_fast_risers {
    type: count_distinct
    description: "Count of athletes gaining 5 or more spots in the cycle"
    sql: ${athlete_id} ;;
    filters: [rank_movement_status: "Fast Riser"]
  }

  measure: count_droppers {
    type: count_distinct
    description: "Count of athletes dropping 3 or more spots in the cycle"
    sql: ${athlete_id} ;;
    filters: [rank_movement_status: "Dropping"]
  }

  measure: count_stable {
    type: count_distinct
    description: "Count of athletes maintaining rank stability (-2 to +2)"
    sql: ${athlete_id} ;;
    filters: [rank_movement_status: "Stable"]
  }

  measure: count_automatic_qualifiers {
    type: count_distinct
    description: "Count of athletes situated within the Top 6 Olympic qualification cutoff"
    sql: ${athlete_id} ;;
    filters: [olympic_cutoff_tier: "Top 6 Automatic Cutoff"]
  }
}
