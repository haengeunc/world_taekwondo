- dashboard: world_taekwondo_analytics
  title: World Taekwondo Global Analytics & Olympic Momentum
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Official World Taekwondo intelligence dashboard covering Olympic qualification cutoff races, monthly ranking movers (Simply Compete), match performance archives (TaekwondoData), and Kyorugi vs. Poomsae discipline dynamics."

  filters:
    - name: snapshot_date
      title: "Snapshot Month"
      type: field_filter
      default_value: "2026-09-01"
      allow_multiple_values: false
      required: true
      model: world_taekwondo
      explore: athlete_rankings
      field: athlete_rankings.snapshot_date

    - name: country
      title: "Nation / Federation"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      model: world_taekwondo
      explore: athlete_rankings
      field: dim_athletes.country_code

    - name: discipline
      title: "Discipline"
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      model: world_taekwondo
      explore: tournament_performance
      field: dim_tournaments.discipline

    - name: is_active
      title: "Active Athletes Only"
      type: field_filter
      default_value: "Yes"
      allow_multiple_values: false
      required: false
      model: world_taekwondo
      explore: athlete_rankings
      field: dim_athletes.is_active_athlete

  tabs:
    - name: tab_1_executive_kpi
      label: "Executive KPI & Nation Leaderboard"
    - name: tab_2_ranking_dynamics
      label: "Monthly Ranking Dynamics & Movers"
    - name: tab_3_olympic_race
      label: "Olympic & World Championship Race"
    - name: tab_4_discipline_deep_dive
      label: "Poomsae vs. Kyorugi Deep Dive"

  elements:
    # =========================================================================
    # TAB 1: EXECUTIVE KPI & NATION LEADERBOARD
    # =========================================================================
    - name: tab1_banner
      tab: tab_1_executive_kpi
      type: text
      title_text: "🥋 Global Executive Overview & National Federation Power Rankings"
      subtitle_text: "High-level summary of active ranked competitors, tournament footprint, and country-level dominance across World Taekwondo events."
      row: 0
      col: 0
      width: 24
      height: 2

    - name: kpi_active_athletes
      tab: tab_1_executive_kpi
      title: "Active Ranked Athletes"
      model: world_taekwondo
      explore: athlete_rankings
      type: single_value
      fields: [dim_athletes.active_athlete_count]
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 2
      col: 0
      width: 6
      height: 4

    - name: kpi_g_tournaments
      tab: tab_1_executive_kpi
      title: "Total G-Level Tournaments"
      model: world_taekwondo
      explore: tournament_performance
      type: single_value
      fields: [dim_tournaments.count_g_level_tournaments]
      listen:
        discipline: dim_tournaments.discipline
      row: 2
      col: 6
      width: 6
      height: 4

    - name: kpi_average_points
      tab: tab_1_executive_kpi
      title: "Average Global Points"
      model: world_taekwondo
      explore: athlete_rankings
      type: single_value
      fields: [athlete_rankings.average_points_per_athlete]
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 2
      col: 12
      width: 6
      height: 4

    - name: kpi_nations_represented
      tab: tab_1_executive_kpi
      title: "Total Nations Represented"
      model: world_taekwondo
      explore: athlete_rankings
      type: single_value
      fields: [dim_athletes.count_distinct_nations]
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 2
      col: 18
      width: 6
      height: 4

    - name: world_map_nations
      tab: tab_1_executive_kpi
      title: "Global Distribution of Ranking Points by Nation"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_geo_choropleth
      fields: [dim_athletes.country_code, athlete_rankings.total_points]
      map: auto
      map_projection: ''
      quantize_colors: false
      colors: ["#e8f0fe", "#1a73e8", "#174ea6"]
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 6
      col: 0
      width: 13
      height: 9

    - name: top_nations_bar_chart
      tab: tab_1_executive_kpi
      title: "Top 15 Nations by Accumulated Ranking Points"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_bar
      fields: [dim_athletes.country_code, athlete_rankings.total_points]
      sorts: [athlete_rankings.total_points desc]
      limit: 15
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
      show_x_axis_label: true
      x_axis_label: "Country Code (ISO-3)"
      show_x_axis_ticks: true
      show_value_labels: true
      series_colors:
        athlete_rankings.total_points: "#1a73e8"
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 6
      col: 13
      width: 11
      height: 9

    # =========================================================================
    # TAB 2: MONTHLY RANKING DYNAMICS & MOVERS
    # =========================================================================
    - name: tab2_banner
      tab: tab_2_ranking_dynamics
      type: text
      title_text: "📈 Official Monthly Ranking Dynamics & Athlete Momentum (Simply Compete Insights)"
      subtitle_text: "Month-over-month rank swings, Fast Risers surging into contention, Steepest Droppers, and MoM point accumulation trends."
      row: 15
      col: 0
      width: 24
      height: 2

    - name: kpi_tab2_fast_risers
      tab: tab_2_ranking_dynamics
      title: "Fast Risers (Delta ≥ +5)"
      model: world_taekwondo
      explore: athlete_rankings
      type: single_value
      fields: [athlete_rankings.count_fast_risers]
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 17
      col: 0
      width: 6
      height: 4

    - name: kpi_tab2_droppers
      tab: tab_2_ranking_dynamics
      title: "Rank Droppers (Delta ≤ -3)"
      model: world_taekwondo
      explore: athlete_rankings
      type: single_value
      fields: [athlete_rankings.count_droppers]
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 17
      col: 6
      width: 6
      height: 4

    - name: kpi_tab2_max_gain
      tab: tab_2_ranking_dynamics
      title: "Peak Monthly Climb (MoM)"
      model: world_taekwondo
      explore: athlete_rankings
      type: single_value
      fields: [athlete_rankings.max_rank_gain]
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 17
      col: 12
      width: 6
      height: 4

    - name: kpi_tab2_biggest_drop
      tab: tab_2_ranking_dynamics
      title: "Steepest Monthly Slide (MoM)"
      model: world_taekwondo
      explore: athlete_rankings
      type: single_value
      fields: [athlete_rankings.biggest_drop]
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 17
      col: 18
      width: 6
      height: 4

    - name: top_fast_risers_chart
      tab: tab_2_ranking_dynamics
      title: "Top 10 Fast Risers (Largest Positive Monthly Rank Delta)"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_column
      fields: [dim_athletes.full_name, dim_athletes.country_code, athlete_rankings.weight_or_form_class, athlete_rankings.rank_delta]
      filters:
        athlete_rankings.rank_movement_status: "Fast Riser"
      sorts: [athlete_rankings.rank_delta desc]
      limit: 10
      show_view_names: false
      show_value_labels: true
      series_colors:
        athlete_rankings.rank_delta: "#1e8e3e"
      show_y_axis_labels: true
      y_axis_label: "Positions Gained (↑)"
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 21
      col: 0
      width: 12
      height: 8

    - name: top_droppers_chart
      tab: tab_2_ranking_dynamics
      title: "Top 10 Steepest Droppers (Largest Negative Monthly Rank Delta)"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_column
      fields: [dim_athletes.full_name, dim_athletes.country_code, athlete_rankings.weight_or_form_class, athlete_rankings.rank_delta]
      filters:
        athlete_rankings.rank_movement_status: "Dropping"
      sorts: [athlete_rankings.rank_delta asc]
      limit: 10
      show_view_names: false
      show_value_labels: true
      series_colors:
        athlete_rankings.rank_delta: "#d93025"
      show_y_axis_labels: true
      y_axis_label: "Positions Dropped (↓)"
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 21
      col: 12
      width: 12
      height: 8

    - name: mom_point_accumulation_trends
      tab: tab_2_ranking_dynamics
      title: "MoM Point Accumulation Trends (Top Ranked Athletes)"
      model: world_taekwondo
      explore: athlete_rankings
      type: looker_line
      fields: [athlete_rankings.snapshot_month, dim_athletes.full_name, athlete_rankings.total_points]
      pivots: [dim_athletes.full_name]
      filters:
        athlete_rankings.current_rank: "<= 3"
      sorts: [athlete_rankings.snapshot_month asc]
      limit: 500
      show_view_names: false
      show_x_axis_label: true
      x_axis_label: "Snapshot Month"
      show_y_axis_labels: true
      y_axis_label: "Ranking Points"
      listen:
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 29
      col: 0
      width: 24
      height: 8

    - name: official_monthly_ranking_table
      tab: tab_2_ranking_dynamics
      title: "Official World Taekwondo Monthly Standings Table (Simply Compete View)"
      model: world_taekwondo
      explore: athlete_rankings
      type: table
      fields: [
        athlete_rankings.current_rank,
        athlete_rankings.rank_delta_symbol,
        dim_athletes.wt_member_license,
        dim_athletes.first_name,
        dim_athletes.last_name,
        dim_athletes.full_name,
        dim_athletes.country_code,
        athlete_rankings.weight_or_form_class,
        athlete_rankings.total_points,
        athlete_rankings.rank_movement_status,
        athlete_rankings.olympic_cutoff_tier,
        dim_athletes.athlete_status
      ]
      sorts: [athlete_rankings.weight_or_form_class asc, athlete_rankings.current_rank asc]
      limit: 100
      show_view_names: false
      show_row_numbers: false
      truncate_column_names: false
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 37
      col: 0
      width: 24
      height: 10

    # =========================================================================
    # TAB 3: OLYMPIC & WORLD CHAMPIONSHIP RACE
    # =========================================================================
    - name: tab3_banner
      tab: tab_3_olympic_race
      type: text
      title_text: "🥇 Olympic Qualification Race & Participation vs. Performance Correlation"
      subtitle_text: "Real-time tracking of the prestigious Top 6 Automatic Olympic Cutoff across all 8 Olympic Kyorugi weight categories, paired with tournament volume ROI."
      row: 47
      col: 0
      width: 24
      height: 2

    - name: top_6_olympic_cutoff_grid
      tab: tab_3_olympic_race
      title: "Top 6 Automatic Olympic Qualification Cutoff Tracker"
      model: world_taekwondo
      explore: athlete_rankings
      type: table
      fields: [
        athlete_rankings.weight_or_form_class,
        athlete_rankings.current_rank,
        dim_athletes.wt_member_license,
        dim_athletes.full_name,
        dim_athletes.country_code,
        athlete_rankings.total_points,
        athlete_rankings.olympic_cutoff_tier
      ]
      filters:
        athlete_rankings.current_rank: "<= 6"
        athlete_rankings.ranking_category: "Olympic Kyorugi"
      sorts: [athlete_rankings.weight_or_form_class asc, athlete_rankings.current_rank asc]
      limit: 100
      show_view_names: false
      show_row_numbers: false
      listen:
        snapshot_date: athlete_rankings.snapshot_date
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 49
      col: 0
      width: 14
      height: 10

    - name: participation_vs_points_scatter
      tab: tab_3_olympic_race
      title: "Tournament Participation Frequency vs. Accumulated Ranking Points"
      model: world_taekwondo
      explore: tournament_performance
      type: looker_scatter
      fields: [tournament_performance.tournaments_entered, tournament_performance.total_tournament_points, dim_athletes.full_name]
      show_view_names: false
      show_x_axis_label: true
      x_axis_label: "Tournaments Entered"
      show_y_axis_labels: true
      y_axis_label: "Total Accumulated Ranking Points"
      series_colors:
        tournament_performance.total_tournament_points: "#e37400"
      listen:
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 49
      col: 14
      width: 10
      height: 10

    # =========================================================================
    # TAB 4: POOMSAE VS. KYORUGI DISCIPLINE DEEP DIVE
    # =========================================================================
    - name: tab4_banner
      tab: tab_4_discipline_deep_dive
      type: text
      title_text: "🥋 Poomsae vs. Kyorugi Discipline Deep Dive & Cross-Discipline Analysis"
      subtitle_text: "Comparative demographic curves, gender distributions, and athlete profiles crossing over between full-contact Sparring and Recognized/Freestyle Forms."
      row: 59
      col: 0
      width: 24
      height: 2

    - name: gender_split_kyorugi_donut
      tab: tab_4_discipline_deep_dive
      title: "Gender Distribution: Kyorugi (Sparring)"
      model: world_taekwondo
      explore: tournament_performance
      type: looker_pie
      fields: [dim_athletes.gender, dim_athletes.count]
      filters:
        dim_tournaments.discipline: "Kyorugi"
      inner_radius: 50
      colors: ["#1a73e8", "#e52592"]
      show_view_names: false
      listen:
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 61
      col: 0
      width: 6
      height: 7

    - name: gender_split_poomsae_donut
      tab: tab_4_discipline_deep_dive
      title: "Gender Distribution: Poomsae (Forms)"
      model: world_taekwondo
      explore: tournament_performance
      type: looker_pie
      fields: [dim_athletes.gender, dim_athletes.count]
      filters:
        dim_tournaments.discipline: "Poomsae"
      inner_radius: 50
      colors: ["#12b5cb", "#f29900"]
      show_view_names: false
      listen:
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 61
      col: 6
      width: 6
      height: 7

    - name: age_distribution_curves
      tab: tab_4_discipline_deep_dive
      title: "Athlete Age Curves: Kyorugi vs. Poomsae"
      model: world_taekwondo
      explore: tournament_performance
      type: looker_column
      fields: [dim_athletes.age_group_tier, dim_athletes.primary_discipline, dim_athletes.count]
      pivots: [dim_athletes.primary_discipline]
      sorts: [dim_athletes.age_group_tier asc]
      show_view_names: false
      show_value_labels: true
      stacking: normal
      x_axis_label: "Age Group Tier"
      y_axis_label: "Number of Competitors"
      series_colors:
        Kyorugi - dim_athletes.count: "#1a73e8"
        Poomsae - dim_athletes.count: "#12b5cb"
        Both - dim_athletes.count: "#f29900"
      listen:
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 61
      col: 12
      width: 12
      height: 7

    - name: cross_discipline_athletes_table
      tab: tab_4_discipline_deep_dive
      title: "Dual-Discipline Competitors (Active in Both Kyorugi & Poomsae)"
      model: world_taekwondo
      explore: tournament_performance
      type: table
      fields: [
        dim_athletes.wt_member_license,
        dim_athletes.full_name,
        dim_athletes.country_code,
        dim_athletes.athlete_age,
        dim_athletes.primary_discipline,
        tournament_performance.tournaments_entered,
        tournament_performance.total_medals,
        tournament_performance.total_tournament_points
      ]
      filters:
        dim_athletes.primary_discipline: "Both"
      sorts: [tournament_performance.total_tournament_points desc]
      limit: 25
      show_view_names: false
      show_row_numbers: false
      listen:
        country: dim_athletes.country_code
        is_active: dim_athletes.is_active_athlete
      row: 68
      col: 0
      width: 24
      height: 8
