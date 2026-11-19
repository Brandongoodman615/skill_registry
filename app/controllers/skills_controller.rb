class SkillsController < ApplicationController
  before_action :set_skill, only: %i[show edit update destroy]

  def index
    @skills = Skill.all.order(:category, :name)
    @skills = @skills.where(category: params[:category]) if params[:category].present?
    @skills = @skills.where(status: params[:status]) if params[:status].present?
    @conflict_count = Skill.all_conflicts.length
  end

  def show
    @conflicts = @skill.conflicts
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      redirect_to @skill, notice: "Skill created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @skill.update(skill_params)
      redirect_to @skill, notice: "Skill updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @skill.destroy
    redirect_to skills_path, notice: "Skill deleted."
  end

  def conflicts
    @conflict_pairs = Skill.all_conflicts
  end

  private

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(:name, :description, :trigger_keywords, :category, :file_path, :status)
  end
end
