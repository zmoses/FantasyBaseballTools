FactoryBot.define do
  factory :player do
    sequence(:name) { |n| "Player #{n}" }
    sequence(:searchable_name) { |n| "player#{n}" }
    sequence(:team) { |n| "TEAM#{n}" }
    espn_rank { 100 }
    cbs_rank { 100 }
    fantasy_pros_rank { 100 }

    trait :aaron_judge do
      name { "Aaron Judge" }
      searchable_name { "aaronjudge" }
      espn_rank { 1 }
      cbs_rank { 2 }
      fantasy_pros_rank { 1 }
      team { "NYY" }
    end

    trait :max_muncy_lad do
      name { "Max Muncy" }
      searchable_name { "maxmuncy" }
      espn_rank { 150 }
      cbs_rank { 145 }
      fantasy_pros_rank { 148 }
      team { "LAD" }
    end

    trait :mike_trout do
      name { "Mike Trout" }
      searchable_name { "mikemtrout" }
      espn_rank { 25 }
      cbs_rank { 30 }
      fantasy_pros_rank { 28 }
      team { "LAA" }
    end

    trait :claimed_player do
      sequence(:name) { |n| "Claimed Player#{n}" }
      sequence(:searchable_name) { |n| "claimedplayer#{n}" }
      espn_rank { 5 }
      cbs_rank { 6 }
      fantasy_pros_rank { 5 }
      team { "BOS" }

      after(:create) do |player|
        create(:player_tracking, :claimed, player: player)
      end
    end

    trait :no_rank_player do
      sequence(:name) { |n| "No Rank Player#{n}" }
      sequence(:searchable_name) { |n| "norankplayer#{n}" }
      espn_rank { nil }
      cbs_rank { 100 }
      fantasy_pros_rank { 95 }
      team { "CHC" }
    end

    trait :claimed do
      after(:create) do |player|
        create(:player_tracking, :claimed, player: player)
      end
    end

    trait :with_notes do
      transient do
        notes_content { "Some notes about this player" }
      end

      after(:create) do |player, evaluator|
        create(:player_tracking, player: player, notes: evaluator.notes_content)
      end
    end

    trait :with_espn_rank do
      espn_rank { rand(1..200) }
    end

    trait :without_espn_rank do
      espn_rank { nil }
    end
  end
end
