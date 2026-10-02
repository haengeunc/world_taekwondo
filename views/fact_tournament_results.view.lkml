view: fact_tournament_results {
  sql_table_name: `opm-looker-core-demo-instance.world_taekwondo.fact_tournament_results` ;;

  # ---------------------------------------------------------------------------
  # Primary Key
  # ---------------------------------------------------------------------------
  dimension: result_id {
    primary_key: yes
    type: string
    description: "Unique result record identifier (e.g. RES-00001)"
    sql: ${TABLE}.result_id ;;
  }

  # ---------------------------------------------------------------------------
  # Foreign Keys & Core Dimensions
  # ---------------------------------------------------------------------------
  dimension: tournament_id {
    type: string
    description: "Foreign key referencing dim_tournaments"
    sql: ${TABLE}.tournament_id ;;
  }

  dimension: athlete_id {
    type: string
    description: "Foreign key referencing dim_athletes"
    sql: ${TABLE}.athlete_id ;;
  }

  dimension: discipline {
    type: string
    description: "Competition discipline: Kyorugi or Poomsae"
    sql: ${TABLE}.discipline ;;
  }

  dimension: division_category {
    type: string
    description: "Competition age division: Senior, Junior, Cadet, Under 30, Under 40"
    sql: ${TABLE}.division_category ;;
  }

  dimension: weight_or_form_class {
    type: string
    description: "Weight category or recognized/freestyle form class (e.g. M-58 kg, F-49 kg, Individual Recognized)"
    sql: ${TABLE}.weight_or_form_class ;;
  }

  dimension: rank_achieved {
    type: number
    description: "Final tournament placement (1=Gold, 2=Silver, 3=Bronze, 5=Quarterfinals, etc.)"
    sql: ${TABLE}.rank_achieved ;;
  }

  dimension: medal_color {
    type: string
    description: "Official medal classification: Gold, Silver, Bronze, or None"
    sql: ${TABLE}.medal_color ;;
  }

  dimension: points_awarded {
    type: number
    description: "World/Olympic ranking points earned from the event"
    sql: ${TABLE}.points_awarded ;;
    value_format_name: decimal_2
  }

  # ---------------------------------------------------------------------------
  # Derived Dimensions
  # ---------------------------------------------------------------------------
  dimension: is_gold_medal {
    type: yesno
    description: "True if competitor won 1st place Gold medal"
    sql: ${medal_color} = 'Gold' ;;
  }

  dimension: is_podium_finish {
    type: yesno
    description: "True if competitor earned any medal (Gold, Silver, or Bronze)"
    sql: ${medal_color} IN ('Gold', 'Silver', 'Bronze') ;;
  }

  # ---------------------------------------------------------------------------
  # Measures
  # ---------------------------------------------------------------------------
  measure: count {
    type: count
    description: "Total result entries (tournaments entered by athletes)"
    drill_fields: [result_id, tournament_id, athlete_id, division_category, weight_or_form_class, rank_achieved, medal_color, points_awarded]
  }

  measure: tournaments_entered {
    type: count
    description: "Total individual tournament participations across athletes"
    drill_fields: [tournament_id, athlete_id, medal_color]
  }

  measure: total_tournament_points {
    type: sum
    description: "Total ranking points accumulated across tournament results"
    sql: ${points_awarded} ;;
    value_format_name: decimal_2
  }

  measure: gold_medal_count {
    type: count
    description: "Total Gold medals awarded"
    filters: [medal_color: "Gold"]
    drill_fields: [athlete_id, tournament_id, weight_or_form_class]
  }

  measure: silver_medal_count {
    type: count
    description: "Total Silver medals awarded"
    filters: [medal_color: "Silver"]
    drill_fields: [athlete_id, tournament_id, weight_or_form_class]
  }

  measure: bronze_medal_count {
    type: count
    description: "Total Bronze medals awarded"
    filters: [medal_color: "Bronze"]
    drill_fields: [athlete_id, tournament_id, weight_or_form_class]
  }

  measure: total_medals {
    type: count
    description: "Total podium finishes (Gold, Silver, and Bronze)"
    filters: [medal_color: "Gold, Silver, Bronze"]
    drill_fields: [athlete_id, tournament_id, medal_color, weight_or_form_class]
  }

  measure: gold_medal_rate {
    type: number
    description: "Gold medal conversion rate: count(gold medals) / count(tournaments entered)"
    sql: SAFE_DIVIDE(${gold_medal_count}, NULLIF(${tournaments_entered}, 0)) ;;
    value_format_name: percent_1
  }

  measure: podium_finish_rate {
    type: number
    description: "Podium conversion rate: count(medals) / count(tournaments entered)"
    sql: SAFE_DIVIDE(${total_medals}, NULLIF(${tournaments_entered}, 0)) ;;
    value_format_name: percent_1
  }

  measure: average_points_per_athlete {
    type: number
    description: "Average tournament ranking points awarded per participating athlete"
    sql: SAFE_DIVIDE(${total_tournament_points}, NULLIF(COUNT(DISTINCT ${athlete_id}), 0)) ;;
    value_format_name: decimal_2
  }

  measure: count_participating_athletes {
    type: count_distinct
    description: "Count of unique athletes who participated in tournaments"
    sql: ${athlete_id} ;;
  }
}
