view: dim_athletes {
  sql_table_name: `opm-looker-core-demo-instance.world_taekwondo.dim_athletes` ;;

  dimension: athlete_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.athlete_id ;;
    hidden: yes
  }

  dimension: wt_member_license {
    label: "WT Member ID"
    description: "Official World Taekwondo Global License (e.g. KOR-10704, ITA-2116)"
    type: string
    sql: ${TABLE}.wt_member_license ;;
  }

  dimension: first_name {
    label: "First Name"
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    label: "Last Name"
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    label: "Athlete Name"
    type: string
    sql: ${TABLE}.full_name ;;
  }

  dimension: gender {
    label: "Gender"
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: country_code {
    label: "Nation (ISO-3)"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country_code ;;
  }

  dimension: birth_year {
    label: "Birth Year"
    type: number
    sql: ${TABLE}.birth_year ;;
    value_format_name: id
  }

  dimension: current_age {
    label: "Current Age"
    type: number
    sql: 2026 - ${birth_year} ;;
  }

  dimension: age_tier {
    label: "Age Tier"
    type: tier
    tiers: [18, 24, 30, 36, 45]
    style: integer
    sql: ${current_age} ;;
  }

  dimension: athlete_status {
    label: "Athlete Status"
    type: string
    sql: ${TABLE}.athlete_status ;;
  }

  dimension: is_active_athlete {
    label: "Is Active Athlete"
    type: yesno
    sql: ${athlete_status} = 'Active' ;;
  }

  dimension: primary_discipline {
    label: "Primary Discipline"
    type: string
    sql: ${TABLE}.primary_discipline ;;
  }

  measure: count {
    label: "Total Athletes"
    type: count
    drill_fields: [wt_member_license, full_name, country_code, primary_discipline, athlete_status]
  }

  measure: count_active_athletes {
    label: "Active Athletes Count"
    type: count
    filters: [athlete_status: "Active"]
  }

  measure: count_nations {
    label: "Total Nations Represented"
    type: count_distinct
    sql: ${country_code} ;;
  }
}
