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
    drill_fields: [tournament_result_drill_detail*]
  }

  measure: tournaments_entered {
    type: count
    description: "Total individual tournament participations across athletes"
    drill_fields: [tournament_result_drill_detail*]
  }

  measure: total_tournament_points {
    label: "Total Tournament Ranking Points"
    type: sum
    description: "Total ranking points accumulated across tournament results. Used to evaluate 2026 WT High-Performance Grant (POL-WT-2026-HP08) tiers: Platinum (>= 200 pts, $30,000 USD with 20% Pair/Team Under 50 uplift), Gold (140-199.99 pts, $18,000 USD with uplift), and Silver (100-139.99 pts, $7,500 USD)."
    sql: ${points_awarded} ;;
    value_format_name: decimal_2
    drill_fields: [tournament_result_drill_detail*]

    link: {
      label: "📈 Open Monthly World Ranking Trajectory"
      url: "/explore/world_taekwondo/athlete_rankings?fields=athlete_rankings.snapshot_month,dim_athletes.full_name,dim_athletes.country_code,athlete_rankings.ranking_category,athlete_rankings.weight_or_form_class,athlete_rankings.current_rank,athlete_rankings.rank_delta_symbol,athlete_rankings.total_points,athlete_rankings.rank_movement_status{% if dim_athletes.full_name._in_query %}&f[dim_athletes.full_name]={{ _filters['dim_athletes.full_name'] | url_encode }}{% elsif dim_athletes.country_code._in_query %}&f[dim_athletes.country_code]={{ _filters['dim_athletes.country_code'] | url_encode }}{% endif %}&sorts=athlete_rankings.snapshot_month+desc&limit=24"
      icon_url: "https://www.google.com/s2/favicons?domain=looker.com&sz=64"
    }

    action: {
      label: "🏆 Approve 2026 WT High-Performance Grant (POL-WT-2026-HP08)"
      url: "https://httpbin.org/post"
      icon_url: "https://www.google.com/s2/favicons?domain=cloud.google.com&sz=64"
      param: {
        name: "policy_id"
        value: "POL-WT-2026-HP08"
      }
      param: {
        name: "verified_points"
        value: "{{ value }}"
      }
      form_param: {
        name: "athlete_recipient"
        label: "Eligible Athlete / Cohort"
        type: string
        required: yes
        default: "Selected WT Athlete / Cohort ({{ rendered_value }} pts)"
      }
      form_param: {
        name: "grant_tier"
        label: "Policy Stipend Tier & Retention Uplift"
        type: select
        required: yes
        default: "{% if value >= 200 %}platinum_uplift{% elsif value >= 140 %}gold_uplift{% elsif value >= 100 %}silver_standard{% else %}development_review{% endif %}"
        option: {
          name: "platinum_uplift"
          label: "Platinum + 20% Pair/Team Under 50 Uplift ($30,000 USD — ≥200 pts)"
        }
        option: {
          name: "gold_uplift"
          label: "Gold + 20% Pair/Team Under 50 Uplift ($18,000 USD — 140–199.99 pts)"
        }
        option: {
          name: "silver_standard"
          label: "Silver Stipend ($7,500 USD — 100–139.99 pts)"
        }
        option: {
          name: "development_review"
          label: "MNA Development Exception Review (<100 pts)"
        }
      }
      form_param: {
        name: "disbursement_channel"
        label: "Disbursement Channel"
        type: select
        required: yes
        default: "mna_high_performance"
        option: {
          name: "mna_high_performance"
          label: "Member National Association (MNA) High-Performance Account"
        }
        option: {
          name: "wt_athlete_escrow"
          label: "World Taekwondo Athlete Trust Escrow"
        }
      }
      form_param: {
        name: "approval_notes"
        label: "Commission Justification & Compliance Note"
        type: textarea
        required: yes
        default: "Approved under POL-WT-2026-HP08 based on {{ rendered_value }} verified Looker tournament points. WADA ADAMS & Knowledge Catalog athlete PII protections verified."
      }
    }

    action: {
      label: "⚡ Certify Points Ledger for Championship Seeding (1-Click)"
      url: "https://httpbin.org/post"
      icon_url: "https://www.google.com/s2/favicons?domain=olympics.com&sz=64"
      param: {
        name: "action_type"
        value: "certify_seeding_points"
      }
      param: {
        name: "certified_points"
        value: "{{ rendered_value }}"
      }
    }
  }

  measure: gold_medal_count {
    type: count
    description: "Total Gold medals awarded"
    filters: [medal_color: "Gold"]
    drill_fields: [tournament_result_drill_detail*]
  }

  measure: silver_medal_count {
    type: count
    description: "Total Silver medals awarded"
    filters: [medal_color: "Silver"]
    drill_fields: [tournament_result_drill_detail*]
  }

  measure: bronze_medal_count {
    type: count
    description: "Total Bronze medals awarded"
    filters: [medal_color: "Bronze"]
    drill_fields: [tournament_result_drill_detail*]
  }

  measure: total_medals {
    type: count
    description: "Total podium finishes (Gold, Silver, and Bronze)"
    filters: [medal_color: "Gold, Silver, Bronze"]
    drill_fields: [tournament_result_drill_detail*]
  }

  measure: gold_medal_rate {
    type: number
    description: "Gold medal conversion rate: count(gold medals) / count(tournaments entered)"
    sql: SAFE_DIVIDE(${gold_medal_count}, NULLIF(${tournaments_entered}, 0)) ;;
    value_format_name: percent_1
    drill_fields: [tournament_result_drill_detail*]
  }

  measure: podium_finish_rate {
    type: number
    description: "Podium conversion rate: count(medals) / count(tournaments entered)"
    sql: SAFE_DIVIDE(${total_medals}, NULLIF(${tournaments_entered}, 0)) ;;
    value_format_name: percent_1
    drill_fields: [tournament_result_drill_detail*]
  }

  measure: average_points_per_athlete {
    type: number
    description: "Average tournament ranking points awarded per participating athlete"
    sql: SAFE_DIVIDE(${total_tournament_points}, NULLIF(COUNT(DISTINCT ${athlete_id}), 0)) ;;
    value_format_name: decimal_2
    drill_fields: [tournament_result_drill_detail*]
  }

  measure: count_participating_athletes {
    type: count_distinct
    description: "Count of unique athletes who participated in tournaments"
    sql: ${athlete_id} ;;
    drill_fields: [dim_athletes.athlete_id, dim_athletes.full_name, dim_athletes.country_code, dim_athletes.athlete_age, dim_athletes.primary_discipline, dim_athletes.poomsae_recognized_pair_team_age_tier, dim_athletes.kyorugi_weight_tier, tournaments_entered, total_medals, total_tournament_points]
  }

  # ---------------------------------------------------------------------------
  # Drill Sets
  # ---------------------------------------------------------------------------
  set: tournament_result_drill_detail {
    fields: [
      dim_tournaments.start_date,
      dim_tournaments.tournament_name,
      dim_tournaments.level,
      dim_tournaments.location_full,
      dim_athletes.full_name,
      dim_athletes.country_code,
      dim_athletes.athlete_age,
      dim_athletes.poomsae_recognized_age_tier,
      discipline,
      division_category,
      weight_or_form_class,
      rank_achieved,
      medal_color,
      points_awarded
    ]
  }
}
