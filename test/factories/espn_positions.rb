FactoryBot.define do
  factory :espn_position do
    position { "OF" }

    trait :first_base do
      position { "1B" }
    end

    trait :second_base do
      position { "2B" }
    end

    trait :third_base do
      position { "3B" }
    end

    trait :shortstop do
      position { "SS" }
    end

    trait :catcher do
      position { "C" }
    end

    trait :relief_pitcher do
      position { "RP" }
    end

    trait :starting_pitcher do
      position { "SP" }
    end

    trait :designated_hitter do
      position { "DH" }
    end

    trait :outfield do
      position { "OF" }
    end
  end
end
