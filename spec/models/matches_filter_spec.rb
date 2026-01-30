require 'rails_helper'

RSpec.describe MatchesFilter do
  let(:matches_filter) { described_class.new(played_from: 6.month.ago, played_to: Time.zone.today) }
  let(:filtered_matches) { matches_filter.filter(Match.all) }

  before do
    travel_to Time.zone.parse("2024-02-01 00:00:00")
    freeze_time
  end

  context "when battle_type_id is present" do
    before do
      matches_filter.battle_type_id = 1
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), battle_type_id: 1)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), battle_type_id: 2)
    end

    it "filter by battle_type_id" do
      expect(filtered_matches).to have_attributes(count: 2)
        .and all(have_attributes(battle_type_id: 1))
    end
  end

  context "when played_from is present" do
    before do
      matches_filter.played_from = "2024-01-10"
      create(:battle, played_at: Time.zone.parse("2024-01-09 12:30:00"))
      create(:battle, played_at: Time.zone.parse("2024-01-09 23:59:59"))
      create(:battle, played_at: Time.zone.parse("2024-01-10 12:30:00"))
      create(:battle, played_at: Time.zone.parse("2024-01-10 12:30:01"))
      create(:battle, played_at: Time.zone.parse("2024-01-11 12:30:00"))
    end

    it "filter by played_at >= played_from" do
      expect(filtered_matches).to have_attributes(count: 6)
        .and all(have_attributes(played_at: a_value >= Time.zone.parse("2024-01-10")))
    end
  end

  context "when played_to is present" do
    before do
      matches_filter.played_to = "2024-01-09"
      create(:battle, played_at: Time.zone.parse("2024-01-09 12:30:00"))
      create(:battle, played_at: Time.zone.parse("2024-01-09 23:59:59"))
      create(:battle, played_at: Time.zone.parse("2024-01-10 12:30:00"))
      create(:battle, played_at: Time.zone.parse("2024-01-10 12:30:01"))
      create(:battle, played_at: Time.zone.parse("2024-01-11 12:30:00"))
    end

    it "filter by played_at <= played_to" do
      expect(filtered_matches).to have_attributes(count: 4)
        .and all(have_attributes(played_at: a_value < Time.zone.parse("2024-01-10")))
    end
  end

  context "when home_fighter_id is present" do
    before do
      matches_filter.home_fighter_id = 111_111_111
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_fighter_id: 111_111_111, p2_fighter_id: 222_222_222)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_fighter_id: 222_222_222, p2_fighter_id: 111_111_111)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_fighter_id: 222_222_222, p2_fighter_id: 333_333_333)
    end

    it "filter by home_fighter_id" do
      expect(filtered_matches).to have_attributes(count: 2)
        .and all(have_attributes(home_fighter_id: 111_111_111))
    end
  end

  context "when home_character_id is present" do
    before do
      matches_filter.home_character_id = 1
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_character_id: 1, p2_character_id: 2)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_character_id: 2, p2_character_id: 1)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_character_id: 2, p2_character_id: 2)
    end

    it "filter by home_character_id" do
      expect(filtered_matches).to have_attributes(count: 2)
        .and all(have_attributes(home_character_id: 1))
    end
  end

  context "when home_input_type_id is present" do
    before do
      matches_filter.home_input_type_id = 1
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_input_type_id: 1, p2_input_type_id: 2)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_input_type_id: 2, p2_input_type_id: 1)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_input_type_id: 2, p2_input_type_id: 2)
    end

    it "filter by home_input_type_id" do
      expect(filtered_matches).to have_attributes(count: 2)
        .and all(have_attributes(home_input_type_id: 1))
    end
  end

  context "when away_fighter_id is present" do
    before do
      matches_filter.away_fighter_id = 111_111_111
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_fighter_id: 111_111_111, p2_fighter_id: 222_222_222)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_fighter_id: 222_222_222, p2_fighter_id: 111_111_111)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_fighter_id: 222_222_222, p2_fighter_id: 333_333_333)
    end

    it "filter by away_fighter_id" do
      expect(filtered_matches).to have_attributes(count: 2)
        .and all(have_attributes(away_fighter_id: 111_111_111))
    end
  end

  context "when away_character_id is present" do
    before do
      matches_filter.away_character_id = 1
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_character_id: 1, p2_character_id: 2)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_character_id: 2, p2_character_id: 1)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_character_id: 2, p2_character_id: 2)
    end

    it "filter by away_character_id" do
      expect(filtered_matches).to have_attributes(count: 2)
        .and all(have_attributes(away_character_id: 1))
    end
  end

  context "when away_input_type_id is present" do
    before do
      matches_filter.away_input_type_id = 1
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_input_type_id: 1, p2_input_type_id: 2)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_input_type_id: 2, p2_input_type_id: 1)
      create(:battle, played_at: Time.zone.parse("2024-01-01 00:00:00"), p1_input_type_id: 2, p2_input_type_id: 2)
    end

    it "filter by away_input_type_id" do
      expect(filtered_matches).to have_attributes(count: 2)
        .and all(have_attributes(away_input_type_id: 1))
    end
  end
end
