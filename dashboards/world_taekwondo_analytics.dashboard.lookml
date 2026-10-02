- dashboard: world_taekwondo_analytics
  title: "World Taekwondo Global Analytics & Olympic Momentum"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive analytics covering Olympic qualification races, monthly ranking momentum, nation leaderboards, and Kyorugi vs. Poomsae discipline comparisons."

  filters:
    - name: snapshot_month
      title: "Snapshot Month"
      type: field_filter
      default_value: "2026-09"
      model: world_taekwondo
      explore: athlete_rankings
      field: athlete_rankings.snapshot_month

    - name: country
      title: "Nation"
      type: field_filter
      default_value: ""
      model: world_taekwondo
      explore: athlete_rankings
      field: dim_athletes.country_code

    - name: discipline
      title: "Discipline"
      type: field_filter
      default_value: ""
      model: world_taekwondo
      explore: athlete_rankings
      field: dim_athletes.primary_discipline

    - name: is_active
      title: "Active Status Only"
      type: field_filter
      default_value: "Yes"
      model: world_taekwondo
      explore: athlete_rankings
      field: dim_athletes.is_active_athlete

  elements:
    # -------------------------------------------------------------
    # TAB 1: EXECUTIVE KPI & NATION LEADERBOARD
    # -------------------------------------------------------------
    - name: tab1_header
      type: text
      title_text: "🥋 Global Executive Overview & National Leaderboard"
      subtitle_text: High-level summary of active ranked competitors, tournament footprint, and country-level dominance across World Taekwondo events.
      row: 0
      col: 0
      width: 24
      height: 2

    - name: kpi_active_athletes
      title: "Active Ranked Athletes"
      model: world_taekwondo
      explore: athlete_rankings
      type: single_value
      fields: [dim_athletes.count_active_athletes]
      row: 2
      col: 0
      width: 6
      height: 4

    - name: kpi_total_tournaments
      title: "Total G-Level Tournaments"
      model: world_taekwondo
      explore: tournament_performance
      type: single_value
      fields: [dim_tournaments.count_g_level_tournaments]
      row: 2
      col: 6
      width: 6
      height: 4

    - name: kpi_avg_points
      title: "Average Global Points"
      model: world_taekwondo
      explore: athlete_rankings
      type: single_value
      fields: [athlete_rankings.average_points_per_athlete]
      row: 2
      col: 12
      width: 6
      height: 4

    - name: kpi_total_nations
      title: "Total Nations Represented"
      model: world_taekwondo
      explore: athlete_rankings
      type: single_value
      fields: [dim_athletes.count_nations]
      row: 2
      col: 18
      width: 6
      height: 4

    - name: nation_world_map
      title: "World Map: Ranking Points by Nation"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_geo_choropleth
      fields: [dim_athletes.country_code, athlete_rankings.total_points]
      row: 6
      col: 0
      width: 12
      height: 10

    - name: top_15_nations_points
      title: "Top 15 Nations by Accumulated Ranking Points"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_bar
      fields: [dim_athletes.country_code, athlete_rankings.total_points]
      sorts: [athlete_rankings.total_points desc]
      limit: 15
      row: 6
      col: 12
      width: 12
      height: 10

    # -------------------------------------------------------------
    # TAB 2: MONTHLY RANKING DYNAMICS & MOVERS
    # -------------------------------------------------------------
    - name: tab2_header
      type: text
      title_text: "## Tab 2: Monthly Ranking Dynamics & Movers (Simply Compete Insights)"
      row: 16
      col: 0
      width: 24
      height: 2

    - name: top_10_fast_risers
      title: "Top 10 Fast Risers (Positions Gained MoM)"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_column
      fields: [dim_athletes.full_name, dim_athletes.country_code, athlete_rankings.max_rank_gain]
      filters:
        athlete_rankings.rank_movement_status: "Fast Riser"
      sorts: [athlete_rankings.max_rank_gain desc]
      limit: 10
      row: 18
      col: 0
      width: 10
      height: 10

    - name: official_monthly_ranking_table
      title: "Official Monthly WT Ranking Table"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_grid
      fields: [
        athlete_rankings.current_rank,
        athlete_rankings.rank_delta,
        dim_athletes.wt_member_license,
        dim_athletes.first_name,
        dim_athletes.last_name,
        dim_athletes.full_name,
        dim_athletes.country_code,
        athlete_rankings.total_points,
        dim_athletes.athlete_status
      ]
      sorts: [athlete_rankings.current_rank asc]
      limit: 50
      row: 18
      col: 10
      width: 14
      height: 10

    - name: mom_point_accumulation_trend
      title: "MoM Point Accumulation Trends: Top Ranked Athletes"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_line
      fields: [athlete_rankings.snapshot_month, dim_athletes.full_name, athlete_rankings.total_points]
      pivots: [dim_athletes.full_name]
      sorts: [athlete_rankings.snapshot_month asc]
      row: 28
      col: 0
      width: 24
      height: 10

    # -------------------------------------------------------------
    # TAB 3: OLYMPIC & WORLD CHAMPIONSHIP RACE
    # -------------------------------------------------------------
    - name: tab3_header
      type: text
      title_text: "## Tab 3: Olympic & World Championship Race"
      row: 38
      col: 0
      width: 24
      height: 2

    - name: top_6_automatic_olympic_cutoff
      title: "Top 6 Automatic Olympic Cutoff Tracker"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_grid
      fields: [
        athlete_rankings.weight_or_form_class,
        athlete_rankings.current_rank,
        dim_athletes.full_name,
        dim_athletes.country_code,
        athlete_rankings.total_points,
        athlete_rankings.olympic_cutoff_tier
      ]
      filters:
        athlete_rankings.current_rank: "<= 6"
        athlete_rankings.ranking_category: "Olympic Kyorugi"
      sorts: [athlete_rankings.weight_or_form_class asc, athlete_rankings.current_rank asc]
      row: 40
      col: 0
      width: 14
      height: 12

    - name: participation_vs_ranking_points
      title: "Tournament Participation Frequency vs. Global Ranking Points"
      model: world_taekwondo
      explore: tournament_performance
      type: looker_scatter
      fields: [tournament_performance.count_entries, tournament_performance.total_tournament_points, dim_athletes.full_name]
      row: 40
      col: 14
      width: 10
      height: 12

    # -------------------------------------------------------------
    # TAB 4: POOMSAE VS. KYORUGI DISCIPLINE DEEP DIVE
    # -------------------------------------------------------------
    - name: tab4_header
      type: text
      title_text: "## Tab 4: Poomsae vs. Kyorugi Discipline Deep Dive"
      row: 52
      col: 0
      width: 24
      height: 2

    - name: gender_split_by_discipline
      title: "Gender Split: Kyorugi vs. Poomsae"
      model: world_taekwondo
      explore: tournament_performance
      type: looker_donut_multiples
      fields: [dim_tournaments.discipline, dim_athletes.gender, dim_athletes.count]
      pivots: [dim_athletes.gender]
      row: 54
      col: 0
      width: 8
      height: 10

    - name: age_distribution_by_discipline
      title: "Athlete Age Tier Distribution: Sparring vs. Forms"
      model: world_taekwondo
      explore: tournament_performance
      type: looker_column
      fields: [dim_athletes.age_tier, dim_tournaments.discipline, dim_athletes.count]
      pivots: [dim_tournaments.discipline]
      sorts: [dim_athletes.age_tier asc]
      row: 54
      col: 8
      width: 8
      height: 10

    - name: cross_discipline_athletes
      title: "Cross-Discipline Competitors (Kyorugi & Poomsae)"
      model: world_taekwondo
      explore: tournament_performance
      type: looker_grid
      fields: [dim_athletes.wt_member_license, dim_athletes.full_name, dim_athletes.country_code, dim_athletes.primary_discipline, tournament_performance.count_entries]
      filters:
        dim_athletes.primary_discipline: "Both"
      sorts: [tournament_performance.count_entries desc]
      row: 54
      col: 16
      width: 8
      height: 10
