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
    synonyms: ["global license", "wt id", "federation license"]
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
    description: "Competitor gender: M (Men's / Male) or F (Women's / Female)"
    synonyms: ["sex", "mens or womens division"]
    sql: ${TABLE}.gender ;;
  }

  dimension: country_code {
    type: string
    description: "3-letter ISO country code representing national member federation"
    synonyms: ["nation", "federation", "country"]
    sql: ${TABLE}.country_code ;;
    map_layer_name: countries
  }

  dimension: birth_year {
    type: number
    description: "Year of birth used for World Taekwondo calendar-year age eligibility"
    sql: ${TABLE}.birth_year ;;
  }

  dimension: weight_kg {
    type: number
    description: "Official registered athlete weigh-in mass in kilograms (kg)"
    synonyms: ["body weight", "weigh in weight", "mass kg"]
    sql: ${TABLE}.weight_kg ;;
    value_format_name: decimal_1
  }

  dimension: height_cm {
    type: number
    description: "Official registered athlete standing height in centimeters (cm)"
    synonyms: ["stature", "athlete height"]
    sql: ${TABLE}.height_cm ;;
    value_format_name: decimal_1
  }

  dimension: athlete_status {
    type: string
    description: "Current federation registration status: Active, Suspended, or Retired"
    sql: ${TABLE}.athlete_status ;;
  }

  dimension: primary_discipline {
    type: string
    description: "Discipline profile: Kyorugi (Sparring), Poomsae (Forms), or Both"
    synonyms: ["sparring or forms", "taekwondo discipline"]
    sql: ${TABLE}.primary_discipline ;;
  }

  # ---------------------------------------------------------------------------
  # Derived / Calculated Dimensions — General & Eligibility
  # ---------------------------------------------------------------------------
  dimension: is_active_athlete {
    type: yesno
    description: "Boolean flag confirming active competition eligibility status"
    synonyms: ["eligible athlete", "currently active"]
    sql: ${athlete_status} = 'Active' ;;
  }

  dimension: athlete_age {
    type: number
    description: "Official World Taekwondo competition age calculated by license year (2026 - birth_year)"
    synonyms: ["competition age", "wt license age"]
    sql: 2026 - ${birth_year} ;;
  }

  dimension: is_cross_discipline {
    type: yesno
    description: "Indicates competitor participates across both Kyorugi and Poomsae"
    synonyms: ["dual discipline", "both sparring and poomsae"]
    sql: ${primary_discipline} = 'Both' ;;
  }

  dimension: age_group_tier_sort {
    type: number
    hidden: yes
    description: "Chronological sort key for unified World Taekwondo age group tier"
    sql: CASE
      WHEN ${athlete_age} <= 11 THEN 1
      WHEN ${athlete_age} BETWEEN 12 AND 14 THEN 2
      WHEN ${athlete_age} BETWEEN 15 AND 17 THEN 3
      WHEN ${athlete_age} BETWEEN 18 AND 30 THEN 4
      WHEN ${athlete_age} BETWEEN 31 AND 40 THEN 5
      WHEN ${athlete_age} BETWEEN 41 AND 50 THEN 6
      WHEN ${athlete_age} BETWEEN 51 AND 60 THEN 7
      WHEN ${athlete_age} BETWEEN 61 AND 65 THEN 8
      ELSE 9
    END ;;
  }

  dimension: age_group_tier {
    type: string
    description: "Unified World Taekwondo (WT) age classification tier across Youth, Senior, and Master brackets"
    synonyms: ["age tier", "age bracket", "age division", "demographic tier"]
    order_by_field: age_group_tier_sort
    sql: CASE
      WHEN ${athlete_age} <= 11 THEN 'Children (<=11 yrs)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 THEN 'Cadet (12-14 yrs)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 THEN 'Junior (15-17 yrs)'
      WHEN ${athlete_age} BETWEEN 18 AND 30 THEN 'Senior / Under 30 (18-30 yrs)'
      WHEN ${athlete_age} BETWEEN 31 AND 40 THEN 'Under 40 (31-40 yrs)'
      WHEN ${athlete_age} BETWEEN 41 AND 50 THEN 'Under 50 (41-50 yrs)'
      WHEN ${athlete_age} BETWEEN 51 AND 60 THEN 'Under 60 (51-60 yrs)'
      WHEN ${athlete_age} BETWEEN 61 AND 65 THEN 'Under 65 (61-65 yrs)'
      ELSE 'Over 65 (66+ yrs)'
    END ;;
  }

  # ---------------------------------------------------------------------------
  # Official WT Poomsae Age Divisions (Recognized & Freestyle)
  # ---------------------------------------------------------------------------
  dimension: poomsae_recognized_age_sort {
    type: number
    hidden: yes
    description: "Chronological sort order for WT Recognized Poomsae Individual divisions"
    sql: CASE
      WHEN ${athlete_age} < 12 THEN 0
      WHEN ${athlete_age} BETWEEN 12 AND 14 THEN 1
      WHEN ${athlete_age} BETWEEN 15 AND 17 THEN 2
      WHEN ${athlete_age} BETWEEN 18 AND 30 THEN 3
      WHEN ${athlete_age} BETWEEN 31 AND 40 THEN 4
      WHEN ${athlete_age} BETWEEN 41 AND 50 THEN 5
      WHEN ${athlete_age} BETWEEN 51 AND 60 THEN 6
      WHEN ${athlete_age} BETWEEN 61 AND 65 THEN 7
      ELSE 8
    END ;;
  }

  dimension: poomsae_recognized_age_tier {
    group_label: "WT Poomsae Divisions"
    label: "Recognized Poomsae Age Tier (Individual)"
    type: string
    description: "Official World Taekwondo Recognized Poomsae Individual age divisions: Cadet (12-14), Junior (15-17), Under 30 (18-30), Under 40 (31-40), Under 50 (41-50), Under 60 (51-60), Under 65 (61-65), and Over 65 (66+). Note: WT 'Under X' brackets include age X."
    synonyms: ["recognized poomsae division", "recognized poomsae age group", "individual poomsae age tier"]
    order_by_field: poomsae_recognized_age_sort
    sql: CASE
      WHEN ${athlete_age} < 12 THEN 'Children (<12 yrs)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 THEN 'Cadet (12-14 yrs)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 THEN 'Junior (15-17 yrs)'
      WHEN ${athlete_age} BETWEEN 18 AND 30 THEN 'Under 30 (18-30 yrs)'
      WHEN ${athlete_age} BETWEEN 31 AND 40 THEN 'Under 40 (31-40 yrs)'
      WHEN ${athlete_age} BETWEEN 41 AND 50 THEN 'Under 50 (41-50 yrs)'
      WHEN ${athlete_age} BETWEEN 51 AND 60 THEN 'Under 60 (51-60 yrs)'
      WHEN ${athlete_age} BETWEEN 61 AND 65 THEN 'Under 65 (61-65 yrs)'
      ELSE 'Over 65 (66+ yrs)'
    END ;;
  }

  dimension: poomsae_recognized_pair_team_sort {
    type: number
    hidden: yes
    description: "Chronological sort order for WT Recognized Poomsae Pair & Team divisions"
    sql: CASE
      WHEN ${athlete_age} < 12 THEN 0
      WHEN ${athlete_age} BETWEEN 12 AND 14 THEN 1
      WHEN ${athlete_age} BETWEEN 15 AND 17 THEN 2
      WHEN ${athlete_age} BETWEEN 18 AND 30 THEN 3
      WHEN ${athlete_age} BETWEEN 31 AND 50 THEN 4
      WHEN ${athlete_age} BETWEEN 51 AND 60 THEN 5
      ELSE 6
    END ;;
  }

  dimension: poomsae_recognized_pair_team_age_tier {
    group_label: "WT Poomsae Divisions"
    label: "Recognized Poomsae Age Tier (Pair & Team)"
    type: string
    description: "Official World Taekwondo Recognized Poomsae Pair (2 athletes) and Team (3 Male or 3 Female) age divisions: 12-14, 15-17, 18-30, 31-50 (combined Under 50), 51-60, and 61+ years old."
    synonyms: ["pair poomsae age tier", "team poomsae age division", "recognized pair and team age group"]
    order_by_field: poomsae_recognized_pair_team_sort
    sql: CASE
      WHEN ${athlete_age} < 12 THEN 'Children (<12 yrs)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 THEN 'Cadet (12-14 yrs)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 THEN 'Junior (15-17 yrs)'
      WHEN ${athlete_age} BETWEEN 18 AND 30 THEN 'Under 30 (18-30 yrs)'
      WHEN ${athlete_age} BETWEEN 31 AND 50 THEN 'Under 50 (31-50 yrs)'
      WHEN ${athlete_age} BETWEEN 51 AND 60 THEN 'Under 60 (51-60 yrs)'
      ELSE '61+ Years Old'
    END ;;
  }

  dimension: poomsae_freestyle_age_sort {
    type: number
    hidden: yes
    description: "Chronological sort order for WT Freestyle Poomsae divisions"
    sql: CASE
      WHEN ${athlete_age} < 12 THEN 0
      WHEN ${athlete_age} BETWEEN 12 AND 17 THEN 1
      ELSE 2
    END ;;
  }

  dimension: poomsae_freestyle_age_tier {
    group_label: "WT Poomsae Divisions"
    label: "Freestyle Poomsae Age Tier"
    type: string
    description: "Official World Taekwondo Freestyle Poomsae competition age divisions for Individual and Pair events: Under 17 (12-17 years old inclusive) and Over 17 (18 years old and over). Mixed Team requires 5 athletes (+1 substitute max) aged 12+."
    synonyms: ["freestyle poomsae division", "freestyle age group", "under 17 freestyle", "over 17 freestyle"]
    order_by_field: poomsae_freestyle_age_sort
    sql: CASE
      WHEN ${athlete_age} < 12 THEN 'Ineligible (<12 yrs)'
      WHEN ${athlete_age} BETWEEN 12 AND 17 THEN 'Under 17 (12-17 yrs)'
      ELSE 'Over 17 (18+ yrs)'
    END ;;
  }

  # ---------------------------------------------------------------------------
  # Official WT Kyorugi (Sparring) Age & Weight Group Tiers
  # ---------------------------------------------------------------------------
  dimension: kyorugi_age_division_sort {
    type: number
    hidden: yes
    description: "Chronological sort order for WT Kyorugi age divisions"
    sql: CASE
      WHEN ${athlete_age} <= 11 THEN 1
      WHEN ${athlete_age} BETWEEN 12 AND 14 THEN 2
      WHEN ${athlete_age} BETWEEN 15 AND 17 THEN 3
      ELSE 4
    END ;;
  }

  dimension: kyorugi_age_division {
    group_label: "WT Kyorugi (Sparring) Divisions"
    label: "Kyorugi Age Division"
    type: string
    description: "Official World Taekwondo Kyorugi (Sparring) age division: Children (<=11 yrs), Cadet (12-14 yrs), Junior (15-17 yrs), and Senior (18+ yrs)"
    synonyms: ["sparring age division", "kyorugi age tier", "cadet junior senior division"]
    order_by_field: kyorugi_age_division_sort
    sql: CASE
      WHEN ${athlete_age} <= 11 THEN 'Children Division (<=11 yrs)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 THEN 'Cadet Division (12-14 yrs)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 THEN 'Junior Division (15-17 yrs)'
      ELSE 'Senior Division (18+ yrs)'
    END ;;
  }

  dimension: kyorugi_weight_tier_sort {
    type: number
    hidden: yes
    description: "Lightest-to-heaviest sort key for WT Kyorugi weight categories and Children height groups"
    sql: CASE
      WHEN ${kyorugi_weight_tier} = 'Finweight' THEN 1
      WHEN ${kyorugi_weight_tier} = 'Flyweight' THEN 2
      WHEN ${kyorugi_weight_tier} = 'Bantamweight' THEN 3
      WHEN ${kyorugi_weight_tier} = 'Featherweight' THEN 4
      WHEN ${kyorugi_weight_tier} = 'Lightweight' THEN 5
      WHEN ${kyorugi_weight_tier} = 'Welterweight' THEN 6
      WHEN ${kyorugi_weight_tier} = 'Light Middleweight' THEN 7
      WHEN ${kyorugi_weight_tier} = 'Middleweight' THEN 8
      WHEN ${kyorugi_weight_tier} = 'Light Heavyweight' THEN 9
      WHEN ${kyorugi_weight_tier} = 'Heavyweight' THEN 10
      WHEN ${kyorugi_weight_tier} LIKE 'Group 0%' THEN 11
      WHEN ${kyorugi_weight_tier} LIKE 'Group 1%' THEN 12
      WHEN ${kyorugi_weight_tier} LIKE 'Group 2%' THEN 13
      WHEN ${kyorugi_weight_tier} LIKE 'Group 3%' THEN 14
      WHEN ${kyorugi_weight_tier} LIKE 'Group 4%' THEN 15
      WHEN ${kyorugi_weight_tier} LIKE 'Group 5%' THEN 16
      ELSE 99
    END ;;
  }

  dimension: kyorugi_weight_tier {
    group_label: "WT Kyorugi (Sparring) Divisions"
    label: "Kyorugi Weight Group Tier"
    type: string
    description: "Official World Taekwondo Kyorugi (Sparring) weight category (8 Senior Men/Women classes, 10 Junior Men/Women classes, 10 Cadet Men/Women classes) and Children height/age groups (Groups 0-5 for <=11 yrs) evaluated dynamically from athlete age, gender, weight (kg), and height (cm)."
    synonyms: ["weight group tier", "sparring weight class", "kyorugi weight division", "wt weight category", "finweight flyweight bantamweight featherweight"]
    order_by_field: kyorugi_weight_tier_sort
    sql: CASE
      -- 1. SENIOR DIVISION (18+ years old): 8 weight classes per gender
      WHEN ${athlete_age} >= 18 AND ${gender} = 'M' THEN
        CASE
          WHEN ${weight_kg} <= 54.0 THEN 'Finweight'
          WHEN ${weight_kg} <= 58.0 THEN 'Flyweight'
          WHEN ${weight_kg} <= 63.0 THEN 'Bantamweight'
          WHEN ${weight_kg} <= 68.0 THEN 'Featherweight'
          WHEN ${weight_kg} <= 74.0 THEN 'Lightweight'
          WHEN ${weight_kg} <= 80.0 THEN 'Welterweight'
          WHEN ${weight_kg} <= 87.0 THEN 'Middleweight'
          ELSE 'Heavyweight'
        END
      WHEN ${athlete_age} >= 18 AND ${gender} = 'F' THEN
        CASE
          WHEN ${weight_kg} <= 46.0 THEN 'Finweight'
          WHEN ${weight_kg} <= 49.0 THEN 'Flyweight'
          WHEN ${weight_kg} <= 53.0 THEN 'Bantamweight'
          WHEN ${weight_kg} <= 57.0 THEN 'Featherweight'
          WHEN ${weight_kg} <= 62.0 THEN 'Lightweight'
          WHEN ${weight_kg} <= 67.0 THEN 'Welterweight'
          WHEN ${weight_kg} <= 74.0 THEN 'Middleweight'
          ELSE 'Heavyweight'
        END

      -- 2. JUNIOR DIVISION (15-17 years old): 10 weight classes per gender
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' THEN
        CASE
          WHEN ${weight_kg} <= 45.0 THEN 'Finweight'
          WHEN ${weight_kg} <= 48.0 THEN 'Flyweight'
          WHEN ${weight_kg} <= 51.0 THEN 'Bantamweight'
          WHEN ${weight_kg} <= 55.0 THEN 'Featherweight'
          WHEN ${weight_kg} <= 59.0 THEN 'Lightweight'
          WHEN ${weight_kg} <= 63.0 THEN 'Welterweight'
          WHEN ${weight_kg} <= 68.0 THEN 'Light Middleweight'
          WHEN ${weight_kg} <= 73.0 THEN 'Middleweight'
          WHEN ${weight_kg} <= 78.0 THEN 'Light Heavyweight'
          ELSE 'Heavyweight'
        END
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' THEN
        CASE
          WHEN ${weight_kg} <= 42.0 THEN 'Finweight'
          WHEN ${weight_kg} <= 44.0 THEN 'Flyweight'
          WHEN ${weight_kg} <= 46.0 THEN 'Bantamweight'
          WHEN ${weight_kg} <= 49.0 THEN 'Featherweight'
          WHEN ${weight_kg} <= 52.0 THEN 'Lightweight'
          WHEN ${weight_kg} <= 55.0 THEN 'Welterweight'
          WHEN ${weight_kg} <= 59.0 THEN 'Light Middleweight'
          WHEN ${weight_kg} <= 63.0 THEN 'Middleweight'
          WHEN ${weight_kg} <= 68.0 THEN 'Light Heavyweight'
          ELSE 'Heavyweight'
        END

      -- 3. CADET DIVISION (12-14 years old): 10 weight classes per gender
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' THEN
        CASE
          WHEN ${weight_kg} <= 33.0 THEN 'Finweight'
          WHEN ${weight_kg} <= 37.0 THEN 'Flyweight'
          WHEN ${weight_kg} <= 41.0 THEN 'Bantamweight'
          WHEN ${weight_kg} <= 45.0 THEN 'Featherweight'
          WHEN ${weight_kg} <= 49.0 THEN 'Lightweight'
          WHEN ${weight_kg} <= 53.0 THEN 'Welterweight'
          WHEN ${weight_kg} <= 57.0 THEN 'Light Middleweight'
          WHEN ${weight_kg} <= 61.0 THEN 'Middleweight'
          WHEN ${weight_kg} <= 65.0 THEN 'Light Heavyweight'
          ELSE 'Heavyweight'
        END
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' THEN
        CASE
          WHEN ${weight_kg} <= 29.0 THEN 'Finweight'
          WHEN ${weight_kg} <= 33.0 THEN 'Flyweight'
          WHEN ${weight_kg} <= 37.0 THEN 'Bantamweight'
          WHEN ${weight_kg} <= 41.0 THEN 'Featherweight'
          WHEN ${weight_kg} <= 44.0 THEN 'Lightweight'
          WHEN ${weight_kg} <= 47.0 THEN 'Welterweight'
          WHEN ${weight_kg} <= 51.0 THEN 'Light Middleweight'
          WHEN ${weight_kg} <= 55.0 THEN 'Middleweight'
          WHEN ${weight_kg} <= 59.0 THEN 'Light Heavyweight'
          ELSE 'Heavyweight'
        END

      -- 4. CHILDREN'S DIVISION (11 years old and below): Height & age groups
      WHEN ${athlete_age} <= 11 THEN
        CASE
          WHEN ${height_cm} <= 120.0 AND ${athlete_age} <= 9 THEN 'Group 0: Below 120 cm (<=9 yrs)'
          WHEN ${height_cm} > 120.0 AND ${height_cm} <= 128.0 AND ${athlete_age} <= 10 THEN 'Group 1: Over 120 to 128 cm (<=10 yrs)'
          WHEN ${height_cm} > 128.0 AND ${height_cm} <= 136.0 THEN 'Group 2: Over 128 to 136 cm (<=11 yrs)'
          WHEN ${height_cm} > 136.0 AND ${height_cm} <= 144.0 THEN 'Group 3: Over 136 to 144 cm (<=11 yrs)'
          WHEN ${height_cm} > 144.0 AND ${height_cm} <= 152.0 THEN 'Group 4: Over 144 to 152 cm (<=11 yrs)'
          WHEN ${height_cm} > 152.0 THEN 'Group 5: Over 152 cm (<=11 yrs)'
          ELSE 'Children Age/Height Review Required'
        END
      ELSE 'Unclassified'
    END ;;
  }

  dimension: kyorugi_division_weight_bracket {
    group_label: "WT Kyorugi (Sparring) Divisions"
    label: "Kyorugi Full Division & Weight Bracket"
    type: string
    description: "Complete official World Taekwondo Kyorugi division, gender, weight category, and exact kg/cm threshold label (e.g., Senior Men's Featherweight (63.1-68.0 kg), Junior Women's Bantamweight (44.1-46.0 kg))."
    synonyms: ["full sparring weight bracket", "wt weight limit", "detailed kyorugi category"]
    sql: CASE
      -- SENIOR MEN (18+)
      WHEN ${athlete_age} >= 18 AND ${gender} = 'M' AND ${weight_kg} <= 54.0 THEN 'Senior Men - Finweight (<=54.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'M' AND ${weight_kg} <= 58.0 THEN 'Senior Men - Flyweight (54.1-58.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'M' AND ${weight_kg} <= 63.0 THEN 'Senior Men - Bantamweight (58.1-63.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'M' AND ${weight_kg} <= 68.0 THEN 'Senior Men - Featherweight (63.1-68.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'M' AND ${weight_kg} <= 74.0 THEN 'Senior Men - Lightweight (68.1-74.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'M' AND ${weight_kg} <= 80.0 THEN 'Senior Men - Welterweight (74.1-80.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'M' AND ${weight_kg} <= 87.0 THEN 'Senior Men - Middleweight (80.1-87.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'M' THEN 'Senior Men - Heavyweight (>87.0 kg)'
      -- SENIOR WOMEN (18+)
      WHEN ${athlete_age} >= 18 AND ${gender} = 'F' AND ${weight_kg} <= 46.0 THEN 'Senior Women - Finweight (<=46.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'F' AND ${weight_kg} <= 49.0 THEN 'Senior Women - Flyweight (46.1-49.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'F' AND ${weight_kg} <= 53.0 THEN 'Senior Women - Bantamweight (49.1-53.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'F' AND ${weight_kg} <= 57.0 THEN 'Senior Women - Featherweight (53.1-57.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'F' AND ${weight_kg} <= 62.0 THEN 'Senior Women - Lightweight (57.1-62.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'F' AND ${weight_kg} <= 67.0 THEN 'Senior Women - Welterweight (62.1-67.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'F' AND ${weight_kg} <= 74.0 THEN 'Senior Women - Middleweight (67.1-74.0 kg)'
      WHEN ${athlete_age} >= 18 AND ${gender} = 'F' THEN 'Senior Women - Heavyweight (>74.0 kg)'
      -- JUNIOR MEN (15-17)
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' AND ${weight_kg} <= 45.0 THEN 'Junior Men - Finweight (<=45.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' AND ${weight_kg} <= 48.0 THEN 'Junior Men - Flyweight (45.1-48.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' AND ${weight_kg} <= 51.0 THEN 'Junior Men - Bantamweight (48.1-51.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' AND ${weight_kg} <= 55.0 THEN 'Junior Men - Featherweight (51.1-55.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' AND ${weight_kg} <= 59.0 THEN 'Junior Men - Lightweight (55.1-59.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' AND ${weight_kg} <= 63.0 THEN 'Junior Men - Welterweight (59.1-63.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' AND ${weight_kg} <= 68.0 THEN 'Junior Men - Light Middleweight (63.1-68.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' AND ${weight_kg} <= 73.0 THEN 'Junior Men - Middleweight (68.1-73.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' AND ${weight_kg} <= 78.0 THEN 'Junior Men - Light Heavyweight (73.1-78.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'M' THEN 'Junior Men - Heavyweight (>78.0 kg)'
      -- JUNIOR WOMEN (15-17)
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' AND ${weight_kg} <= 42.0 THEN 'Junior Women - Finweight (<=42.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' AND ${weight_kg} <= 44.0 THEN 'Junior Women - Flyweight (42.1-44.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' AND ${weight_kg} <= 46.0 THEN 'Junior Women - Bantamweight (44.1-46.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' AND ${weight_kg} <= 49.0 THEN 'Junior Women - Featherweight (46.1-49.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' AND ${weight_kg} <= 52.0 THEN 'Junior Women - Lightweight (49.1-52.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' AND ${weight_kg} <= 55.0 THEN 'Junior Women - Welterweight (52.1-55.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' AND ${weight_kg} <= 59.0 THEN 'Junior Women - Light Middleweight (55.1-59.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' AND ${weight_kg} <= 63.0 THEN 'Junior Women - Middleweight (59.1-63.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' AND ${weight_kg} <= 68.0 THEN 'Junior Women - Light Heavyweight (63.1-68.0 kg)'
      WHEN ${athlete_age} BETWEEN 15 AND 17 AND ${gender} = 'F' THEN 'Junior Women - Heavyweight (>68.0 kg)'
      -- CADET MEN (12-14)
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' AND ${weight_kg} <= 33.0 THEN 'Cadet Men - Finweight (<=33.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' AND ${weight_kg} <= 37.0 THEN 'Cadet Men - Flyweight (33.1-37.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' AND ${weight_kg} <= 41.0 THEN 'Cadet Men - Bantamweight (37.1-41.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' AND ${weight_kg} <= 45.0 THEN 'Cadet Men - Featherweight (41.1-45.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' AND ${weight_kg} <= 49.0 THEN 'Cadet Men - Lightweight (45.1-49.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' AND ${weight_kg} <= 53.0 THEN 'Cadet Men - Welterweight (49.1-53.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' AND ${weight_kg} <= 57.0 THEN 'Cadet Men - Light Middleweight (53.1-57.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' AND ${weight_kg} <= 61.0 THEN 'Cadet Men - Middleweight (57.1-61.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' AND ${weight_kg} <= 65.0 THEN 'Cadet Men - Light Heavyweight (61.1-65.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'M' THEN 'Cadet Men - Heavyweight (>65.0 kg)'
      -- CADET WOMEN (12-14)
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' AND ${weight_kg} <= 29.0 THEN 'Cadet Women - Finweight (<=29.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' AND ${weight_kg} <= 33.0 THEN 'Cadet Women - Flyweight (29.1-33.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' AND ${weight_kg} <= 37.0 THEN 'Cadet Women - Bantamweight (33.1-37.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' AND ${weight_kg} <= 41.0 THEN 'Cadet Women - Featherweight (37.1-41.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' AND ${weight_kg} <= 44.0 THEN 'Cadet Women - Lightweight (41.1-44.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' AND ${weight_kg} <= 47.0 THEN 'Cadet Women - Welterweight (44.1-47.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' AND ${weight_kg} <= 51.0 THEN 'Cadet Women - Light Middleweight (47.1-51.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' AND ${weight_kg} <= 55.0 THEN 'Cadet Women - Middleweight (51.1-55.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' AND ${weight_kg} <= 59.0 THEN 'Cadet Women - Light Heavyweight (55.1-59.0 kg)'
      WHEN ${athlete_age} BETWEEN 12 AND 14 AND ${gender} = 'F' THEN 'Cadet Women - Heavyweight (>59.0 kg)'
      -- CHILDREN'S DIVISION (<=11)
      ELSE CONCAT('Children - ', ${kyorugi_weight_tier})
    END ;;
  }

  # ---------------------------------------------------------------------------
  # Measures
  # ---------------------------------------------------------------------------
  measure: count {
    type: count
    description: "Total count of registered athletes"
    drill_fields: [athlete_id, full_name, wt_member_license, country_code, primary_discipline, kyorugi_weight_tier, poomsae_recognized_age_tier, athlete_status]
  }

  measure: active_athlete_count {
    type: count
    description: "Count of active registered athletes eligible for sanctioned World Taekwondo competition"
    synonyms: ["eligible athletes", "active competitors"]
    filters: [athlete_status: "Active"]
    drill_fields: [athlete_id, full_name, wt_member_license, country_code, primary_discipline, kyorugi_weight_tier, poomsae_recognized_age_tier]
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

  measure: average_weight_kg {
    type: average
    description: "Average registered weigh-in mass across athletes in kilograms (kg)"
    sql: ${weight_kg} ;;
    value_format_name: decimal_1
  }
}
