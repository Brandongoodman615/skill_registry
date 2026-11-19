require "rails_helper"

RSpec.describe Skill, type: :model do
  describe "validations" do
    it "is valid with a name and valid status" do
      skill = Skill.new(name: "/commit", status: "active")
      expect(skill).to be_valid
    end

    it "is invalid without a name" do
      skill = Skill.new(status: "active")
      expect(skill).not_to be_valid
    end

    it "is invalid with an unrecognized status" do
      skill = Skill.new(name: "/commit", status: "unknown")
      expect(skill).not_to be_valid
    end
  end

  describe "#keyword_list" do
    it "returns a downcased, stripped array of keywords" do
      skill = Skill.new(trigger_keywords: "Commit, Git , SAVE")
      expect(skill.keyword_list).to eq(%w[commit git save])
    end

    it "returns an empty array when trigger_keywords is blank" do
      skill = Skill.new(trigger_keywords: nil)
      expect(skill.keyword_list).to eq([])
    end
  end

  describe "#conflicts" do
    it "returns skills that share at least one keyword" do
      skill_a = Skill.create!(name: "/commit", trigger_keywords: "commit, git, save", status: "active")
      skill_b = Skill.create!(name: "/git-save", trigger_keywords: "git, save, stage", status: "active")
      skill_c = Skill.create!(name: "/deploy", trigger_keywords: "deploy, ship", status: "active")

      expect(skill_a.conflicts).to include(skill_b)
      expect(skill_a.conflicts).not_to include(skill_c)
    end

    it "returns an empty array when the skill has no keywords" do
      skill = Skill.create!(name: "/commit", trigger_keywords: "", status: "draft")
      Skill.create!(name: "/other", trigger_keywords: "git", status: "active")
      expect(skill.conflicts).to eq([])
    end
  end

  describe "#shared_keywords_with" do
    it "returns the overlapping keywords between two skills" do
      skill_a = Skill.new(trigger_keywords: "commit, git, save")
      skill_b = Skill.new(trigger_keywords: "git, save, stage")
      expect(skill_a.shared_keywords_with(skill_b)).to match_array(%w[git save])
    end
  end

  describe ".all_conflicts" do
    it "returns all conflicting pairs with their shared keywords" do
      skill_a = Skill.create!(name: "/commit", trigger_keywords: "commit, git", status: "active")
      skill_b = Skill.create!(name: "/git-save", trigger_keywords: "git, save", status: "active")
      Skill.create!(name: "/deploy", trigger_keywords: "deploy, ship", status: "active")

      pairs = Skill.all_conflicts
      expect(pairs.length).to eq(1)
      expect(pairs.first[:skill]).to eq(skill_a)
      expect(pairs.first[:other]).to eq(skill_b)
      expect(pairs.first[:shared]).to eq(["git"])
    end

    it "returns an empty array when there are no conflicts" do
      Skill.create!(name: "/commit", trigger_keywords: "commit", status: "active")
      Skill.create!(name: "/deploy", trigger_keywords: "deploy", status: "active")
      expect(Skill.all_conflicts).to eq([])
    end
  end
end
