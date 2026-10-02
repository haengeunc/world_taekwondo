view: fact_tournament_results {
  sql_table_name: `opm-looker-core-demo-instance.world_taekwondo.fact_tournament_results` ;;

  dimension: result_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.result_id ;;
    hidden: yes
  }

  dimension: tournament_id {
    type: string
    sql: ${TABLE}.tournament_id ;;
    hidden: yes
  }

  dimension: athlete_id {
    type: string
    sql: ${TABLE}.athlete_id ;;
    hidden: yes
  }

  dimension: division_category {
    label: "Division Category"
    type: string
    sql: ${TABLE}.division_category ;;
  }

  dimension: weight_or_form_class {
    label: "Weight / Form Class"
    type: string
    sql: ${TABLE}.weight_or_form_class ;;
  }

  dimension: rank_achieved {
    label: "Placement / Rank"
    type: number
    sql: ${TABLE}.rank_achieved ;;
  }

  dimension: medal_color {
    label: "Medal Color"
    type: string
    sql: ${TABLE}.medal_color ;;
  }

  dimension: is_podium_finish {
    label: "Is Podium Finish"
    type: yesno
    sql: ${medal_color} IN ('Gold', 'Silver', 'Bronze') ;;
  }

  dimension: points_awarded {
    label: "Points Awarded (Base)"
    type: number
    sql: ${TABLE}.points_awarded ;;
    hidden: yes
  }

  measure: count_entries {
    label: "Tournaments Entered"
    type: count
  }

  measure: total_tournament_points {
    label: "Total Tournament Points"
    type: sum
    sql: ${points_awarded} ;;
    value_format_name: decimal_2
  }

  measure: count_gold_medals {
    label: "Gold Medals"
    type: count
    filters: [medal_color: "Gold"]
  }

  measure: count_silver_medals {
    label: "Silver Medals"
    type: count
    filters: [medal_color: "Silver"]
  }

  measure: count_bronze_medals {
    label: "Bronze Medals"
    type: count
    filters: [medal_color: "Bronze"]
  }

  measure: count_total_medals {
    label: "Total Medals"
    type: count
    filters: [medal_color: "Gold, Silver, Bronze"]
  }

  measure: gold_medal_rate {
    label: "Gold Medal Win Rate"
    type: number
    sql: 1.0 * ${count_gold_medals} / NULLIF(${count_entries}, 0) ;;
    value_format_name: percent_1
  }

  measure: podium_finish_rate {
    label: "Podium Finish Rate"
    type: number
    sql: 1.0 * ${count_total_medals} / NULLIF(${count_entries}, 0) ;;
    value_format_name: percent_1
  }
}
