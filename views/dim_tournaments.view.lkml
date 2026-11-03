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
    drill_fields: [level, location_full, start_date, discipline]

    link: {
      label: "🏅 View Full Tournament Leaderboard & Medalists"
      url: "/explore/world_taekwondo/tournament_performance?fields=tournament_performance.rank_achieved,tournament_performance.medal_color,dim_athletes.full_name,dim_athletes.country_code,tournament_performance.discipline,tournament_performance.weight_or_form_class,tournament_performance.points_awarded&f[dim_tournaments.tournament_name]={{ value | encode_uri }}&sorts=tournament_performance.points_awarded+desc,tournament_performance.rank_achieved+asc&limit=50"
      icon_url: "https://www.google.com/s2/favicons?domain=looker.com&sz=64"
    }

    action: {
      label: "🎥 Request Courtside Score Sheet & Video Replay"
      url: "https://httpbin.org/post"
      icon_url: "https://www.google.com/s2/favicons?domain=olympics.com&sz=64"
      param: {
        name: "tournament_name"
        value: "{{ value }}"
      }
      form_param: {
        name: "event_name"
        label: "Sanctioned Championship"
        type: string
        required: yes
        default: "{{ value }}"
      }
      form_param: {
        name: "artifact_type"
        label: "Requested Official Record"
        type: select
        required: yes
        default: "poomsae_judge_sheet"
        option: {
          name: "poomsae_judge_sheet"
          label: "Poomsae 5-Judge Accuracy & Presentation Score Sheet"
        }
        option: {
          name: "ivr_video_replay"
          label: "Instant Video Replay (IVR) Court Footage"
        }
        option: {
          name: "official_draw_bracket"
          label: "Certified Seeding & Draw Bracket PDF"
        }
      }
      form_param: {
        name: "notes"
        label: "Technical Delegate Request Note"
        type: textarea
        default: "Please share official court scoring logs for {{ value }} for high-performance review."
      }
    }
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
    convert_tz: no
    datatype: date
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
