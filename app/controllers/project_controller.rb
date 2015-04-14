class ProjectController < ApplicationController
  before_action :set_project, only: [:show, :update, :delete, :report]
  skip_before_action :verify_authenticity_token

  def report
    subject = "TotalSim App Issue Report: #{App.find(1).app_hex_code}"
    body = "app: #{App.find(1).app_hex_code}\n" +
      "type: project\n" +
      "id: #{@project.id}\n" +
      "path: NULL\n" +
      "user: <user>\n" +
      "datetime: #{DateTime.now}"
    body += "\nmessage: #{params[:message]}" if params[:message]
    system "echo '#{body}' | mutt -s '#{subject}' #{App.find(1).email}"
    respond_to do |format|
      format.json { render json: { message: 'report sent' } }
    end
  end

  def index
    @projects = Project.all
    respond_to do |format|
      format.json
    end
  end

  def show
    respond_to do |format|
      format.json
    end
  end

  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        format.json { render "project/show.json" }
      else
        format.json { render json: { message: 'create failed' }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.json { render "project/show.json" }
      else
        format.json { render "project/show.json", status: :unprocessable_entity }
      end
    end
  end

  def delete
    respond_to do |format|
      if @project.destroy
        format.json { render json: { status: "delete success" } }
      else
        format.json { render "project/show.json", status: :unprocessable_entity }
      end
    end
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.permit(:name, :description)
    end
end
