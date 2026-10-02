view: dim_athletes {
  sql_table_name: `opm-looker-core-demo-instance.world_taekwondo.dim_athletes` ;;

  # ---------------------------------------------------------------------------
  # Primary Key
  # ---------------------------------------------------------------------------
  dimension: athlete_id {
    primary_key: yes
    type: string
    description: "Unique alphanumeric athlete identifier (e.g. ATH-001)"
    sql: ${TABLE}.athlete_id ;;
  }

  # ---------------------------------------------------------------------------
  # Core Dimensions
  # ---------------------------------------------------------------------------
  dimension: wt_member_license {
    type: string
    description: "Official World Taekwondo Global License ID (e.g. KOR-10704, ITA-2116)"
    sql: ${TABLE}.wt_member_license ;;
  }

  dimension: first_name {
    type: string
    description: "Given name / first name of the athlete"
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    description: "Family name / last name of the athlete"
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    type: string
    description: "Full registered competitor name"
    sql: ${TABLE}.full_name ;;
  }

  dimension: gender {
    type: string
    description: "Competitor gender: M (Male) or F (Female)"
    sql: ${TABLE}.gender ;;
  }

  dimension: country_code {
    type: string
    description: "3-letter ISO country code representing national member federation"
    sql: ${TABLE}.country_code ;;
    map_layer_name: countries
  }

  dimension: birth_year {
    type: number
    description: "Year of birth"
    sql: ${TABLE}.birth_year ;;
  }

  dimension: athlete_status {
    type: string
    description: "Current federation registration status: Active, Suspended, or Retired"
    sql: ${TABLE}.athlete_status ;;
  }

  dimension: primary_discipline {
    type: string
    description: "Discipline profile: Kyorugi (Sparring), Poomsae (Forms), or Both"
    sql: ${TABLE}.primary_discipline ;;
  }

  # ---------------------------------------------------------------------------
  # Derived / Calculated Dimensions
  # ---------------------------------------------------------------------------
  dimension: is_active_athlete {
    type: yesno
    description: "Boolean flag confirming active competition eligibility status"
    sql: ${athlete_status} = 'Active' ;;
  }

  dimension: athlete_age {
    type: number
    description: "Calculated competitor age in years"
    sql: 2026 - ${birth_year} ;;
  }

  dimension: age_group_tier {
    type: string
    description: "Age classification tier for demographic and discipline curves"
    sql: CASE
      WHEN (2026 - ${birth_year}) < 20 THEN 'Under 20 (Junior/Cadet)'
      WHEN (2026 - ${birth_year}) BETWEEN 20 AND 24 THEN '20 - 24 (Prime Senior)'
      WHEN (2026 - ${birth_year}) BETWEEN 25 AND 29 THEN '25 - 29 (Peak Senior)'
      WHEN (2026 - ${birth_year}) BETWEEN 30 AND 34 THEN '30 - 34 (Veteran Senior / Master)'
      ELSE '35+ (Master Division)'
    END ;;
  }

  dimension: is_cross_discipline {
    type: yesno
    description: "Indicates competitor participates across both Kyorugi and Poomsae"
    sql: ${primary_discipline} = 'Both' ;;
  }

  # ---------------------------------------------------------------------------
  # Measures
  # ---------------------------------------------------------------------------
  measure: count {
    type: count
    description: "Total count of registered athletes"
    drill_fields: [athlete_id, full_name, wt_member_license, country_code, primary_discipline, athlete_status]
  }

  measure: active_athlete_count {
    type: count
    description: "Count of active registered athletes"
    filters: [athlete_status: "Active"]
    drill_fields: [athlete_id, full_name, wt_member_license, country_code, primary_discipline]
  }

  measure: count_distinct_nations {
    type: count_distinct
    description: "Total distinct national federations represented"
    sql: ${country_code} ;;
    drill_fields: [country_code]
  }

  measure: average_age {
    type: average
    description: "Average athlete age"
    sql: 2026 - ${birth_year} ;;
    value_format_name: decimal_1
  }
}
