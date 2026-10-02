view: dim_tournaments {
  sql_table_name: `opm-looker-core-demo-instance.world_taekwondo.dim_tournaments` ;;

  # ---------------------------------------------------------------------------
  # Primary Key
  # ---------------------------------------------------------------------------
  dimension: tournament_id {
    primary_key: yes
    type: string
    description: "Unique tournament event identifier (e.g. TOURN-01)"
    sql: ${TABLE}.tournament_id ;;
  }

  # ---------------------------------------------------------------------------
  # Core Dimensions
  # ---------------------------------------------------------------------------
  dimension: tournament_name {
    type: string
    description: "Official title of the championship or tournament"
    sql: ${TABLE}.tournament_name ;;
  }

  dimension: level {
    type: string
    description: "Sanctioning tier: G-1, G-2, Grand Prix, World Championship, Olympic Games"
    sql: ${TABLE}.level ;;
  }

  dimension: location_city {
    type: string
    description: "Host city"
    sql: ${TABLE}.location_city ;;
  }

  dimension: location_country {
    type: string
    description: "Host country ISO-3 code"
    sql: ${TABLE}.location_country ;;
  }

  dimension: year {
    type: number
    description: "Calendar year of the tournament event"
    sql: ${TABLE}.year ;;
  }

  dimension_group: start {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    description: "Tournament commencement date"
    sql: ${TABLE}.start_date ;;
  }

  dimension: discipline {
    type: string
    description: "Discipline contested at event: Kyorugi or Poomsae"
    sql: ${TABLE}.discipline ;;
  }

  # ---------------------------------------------------------------------------
  # Derived Dimensions
  # ---------------------------------------------------------------------------
  dimension: is_g_level {
    type: yesno
    description: "True if tournament carries official WT ranking points (G-Level or Major)"
    sql: ${level} IN ('G-1', 'G-2', 'Grand Prix', 'World Championship', 'Olympic Games') ;;
  }

  dimension: is_major_games {
    type: yesno
    description: "True for pinnacle events (Olympic Games or World Championships)"
    sql: ${level} IN ('Olympic Games', 'World Championship') ;;
  }

  dimension: location_full {
    type: string
    description: "City and Country combined"
    sql: CONCAT(${location_city}, ', ', ${location_country}) ;;
  }

  # ---------------------------------------------------------------------------
  # Measures
  # ---------------------------------------------------------------------------
  measure: count {
    type: count
    description: "Total count of tournament events"
    drill_fields: [tournament_id, tournament_name, level, location_city, location_country, start_date, discipline]
  }

  measure: count_g_level_tournaments {
    type: count
    description: "Count of official G-level and major ranking tournaments"
    filters: [level: "G-1, G-2, Grand Prix, World Championship, Olympic Games"]
    drill_fields: [tournament_id, tournament_name, level, location_city, start_date]
  }
}
