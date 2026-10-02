view: dim_tournaments {
  sql_table_name: `opm-looker-core-demo-instance.world_taekwondo.dim_tournaments` ;;

  dimension: tournament_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.tournament_id ;;
    hidden: yes
  }

  dimension: tournament_name {
    label: "Tournament Name"
    type: string
    sql: ${TABLE}.tournament_name ;;
  }

  dimension: level {
    label: "Tournament Grade Level"
    description: "Olympic Games, World Championship, Grand Prix, G-2, G-1"
    type: string
    sql: ${TABLE}.level ;;
  }

  dimension: is_g_level_event {
    label: "Is G-Level Event"
    type: yesno
    sql: ${level} IN ('G-1', 'G-2', 'Grand Prix', 'World Championship', 'Olympic Games') ;;
  }

  dimension: location_city {
    label: "Host City"
    type: string
    sql: ${TABLE}.location_city ;;
  }

  dimension: location_country {
    label: "Host Country"
    type: string
    sql: ${TABLE}.location_country ;;
  }

  dimension_group: start {
    type: time
    timeframes: [raw, date, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.start_date ;;
  }

  dimension: discipline {
    label: "Tournament Discipline"
    type: string
    sql: ${TABLE}.discipline ;;
  }

  measure: count {
    label: "Total Tournaments"
    type: count
    drill_fields: [tournament_name, level, location_city, location_country, start_date]
  }

  measure: count_g_level_tournaments {
    label: "Total G-Level Tournaments"
    type: count
    filters: [level: "G-1, G-2, Grand Prix, World Championship, Olympic Games"]
  }
}
