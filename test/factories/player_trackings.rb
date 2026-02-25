FactoryBot.define do
  factory :player_tracking do
    player
    notes { nil }
    claimed { false }

    trait :claimed do
      claimed { true }
    end

    trait :with_notes do
      notes { "Some notes about this player" }
    end
  end
end
