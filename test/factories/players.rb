FactoryBot.define do
  factory :player do
    sequence(:name) { |n| "Player #{n}" }
    sequence(:searchable_name) { |n| "player#{n}" }
    sequence(:team) { |n| "TEAM#{n}" }
    espn_rank { 100 }
    cbs_rank { 100 }
    fantasy_pros_rank { 100 }
    claimed { false }

    trait :aaron_judge do
      name { "Aaron Judge" }
      searchable_name { "aaronjudge" }
      espn_rank { 1 }
      cbs_rank { 2 }
      fantasy_pros_rank { 1 }
      team { "NYY" }
      claimed { false }
    end

    trait :max_muncy_lad do
      name { "Max Muncy" }
      searchable_name { "maxmuncy" }
      espn_rank { 150 }
      cbs_rank { 145 }
      fantasy_pros_rank { 148 }
      team { "LAD" }
      claimed { false }
    end

    trait :mike_trout do
      name { "Mike Trout" }
      searchable_name { "mikemtrout" }
      espn_rank { 25 }
      cbs_rank { 30 }
      fantasy_pros_rank { 28 }
      team { "LAA" }
      claimed { false }
    end

    trait :claimed_player do
      sequence(:name) { |n| "Claimed Player#{n}" }
      sequence(:searchable_name) { |n| "claimedplayer#{n}" }
      espn_rank { 5 }
      cbs_rank { 6 }
      fantasy_pros_rank { 5 }
      team { "BOS" }
      claimed { true }
    end

    trait :no_rank_player do
      sequence(:name) { |n| "No Rank Player#{n}" }
      sequence(:searchable_name) { |n| "norankplayer#{n}" }
      espn_rank { nil }
      cbs_rank { 100 }
      fantasy_pros_rank { 95 }
      team { "CHC" }
      claimed { false }
    end

    trait :unclaimed do
      claimed { false }
    end

    trait :claimed do
      claimed { true }
    end

    trait :with_espn_rank do
      espn_rank { rand(1..200) }
    end

    trait :without_espn_rank do
      espn_rank { nil }
    end
  end
end
