require "rails_helper"

RSpec.describe "Skills", type: :request do
  let!(:skill) do
    Skill.create!(
      name: "/commit",
      description: "Commit staged changes",
      trigger_keywords: "commit, git, save",
      category: "git",
      status: "active"
    )
  end

  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "shows the conflict banner" do
      Skill.create!(name: "/git-save", trigger_keywords: "git, save", status: "active", category: "git")
      get root_path
      expect(response.body).to include("conflict")
    end

    it "filters by category" do
      Skill.create!(name: "/deploy", trigger_keywords: "deploy", category: "deploy", status: "active")
      get root_path, params: { category: "git" }
      expect(response.body).to include("/commit")
      expect(response.body).not_to include("/deploy")
    end

    it "filters by status" do
      Skill.create!(name: "/wip", trigger_keywords: "wip", category: "git", status: "draft")
      get root_path, params: { status: "draft" }
      expect(response.body).to include("/wip")
      expect(response.body).not_to include("/commit")
    end
  end

  describe "GET /skills/:id" do
    it "returns http success" do
      get skill_path(skill)
      expect(response).to have_http_status(:success)
    end

    it "shows conflict info when conflicts exist" do
      Skill.create!(name: "/git-save", trigger_keywords: "git, save", status: "active", category: "git")
      get skill_path(skill)
      expect(response.body).to include("/git-save")
    end
  end

  describe "GET /skills/new" do
    it "returns http success" do
      get new_skill_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /skills" do
    it "creates a skill and redirects" do
      expect {
        post skills_path, params: { skill: { name: "/review-pr", status: "active", category: "pr", trigger_keywords: "review, pr" } }
      }.to change(Skill, :count).by(1)
      expect(response).to redirect_to(skill_path(Skill.last))
    end

    it "renders new on invalid params" do
      post skills_path, params: { skill: { name: "", status: "active" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /skills/:id/edit" do
    it "returns http success" do
      get edit_skill_path(skill)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /skills/:id" do
    it "updates a skill and redirects" do
      patch skill_path(skill), params: { skill: { description: "Updated description" } }
      expect(response).to redirect_to(skill_path(skill))
      expect(skill.reload.description).to eq("Updated description")
    end

    it "renders edit on invalid params" do
      patch skill_path(skill), params: { skill: { name: "", status: "active" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /skills/:id" do
    it "destroys the skill and redirects" do
      expect {
        delete skill_path(skill)
      }.to change(Skill, :count).by(-1)
      expect(response).to redirect_to(skills_path)
    end
  end

  describe "GET /conflicts" do
    it "returns http success" do
      get conflicts_path
      expect(response).to have_http_status(:success)
    end

    it "lists conflicting pairs" do
      Skill.create!(name: "/git-save", trigger_keywords: "git, save", status: "active", category: "git")
      get conflicts_path
      expect(response.body).to include("/commit")
      expect(response.body).to include("/git-save")
    end

    it "shows all clear when no conflicts" do
      get conflicts_path
      expect(response.body).to include("All clear")
    end
  end
end
