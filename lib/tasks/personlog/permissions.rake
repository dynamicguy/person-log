namespace :personlog do
  namespace :permissions do
    desc "setup permissions"
    task :setup => :environment do
      setup_models_db
    end

    def setup_models_db
      models = Dir.new("#{Rails.root}/app/models").entries
      models.each do |model|
        m = model.gsub(".rb", "").camelize
        puts m
      end
    end

    def setup_actions_controllers_db
      controllers = Dir.new("#{Rails.root}/app/controllers").entries
      controllers.each do |controller|
        if controller =~ /_controller/
          ctrl = controller.gsub("_controller.rb", "").singularize.camelize
        end
      end
    end


    def eval_cancan_action(action)
      case action.to_s
        when "index", "show", "search"
          cancan_action = "read"
          action_desc = I18n.t "helpers.links.read"
        when "create", "new"
          cancan_action = "create"
          action_desc = I18n.t "helpers.links.create"
        when "edit", "update"
          cancan_action = "update"
          action_desc = I18n.t "helpers.links.edit"
        when "delete", "destroy"
          cancan_action = "delete"
          action_desc = I18n.t "helpers.links.delete"
        else
          cancan_action = action.to_s
          action_desc = "Other: " << cancan_action
      end
      return action_desc, cancan_action
    end

    def write_permission(class_name, cancan_action, name, description, force_id_1 = false)
      #permission = Permission.find(:first, :conditions => ["subject_class = ? and action = ?", class_name, cancan_action])
      permission = Permission.find(:conditions => ["subject_class = ? and action = ?", class_name, cancan_action])
      if not permission
        permission = Permission.new
        permission.id = 1 unless not force_id_1
        permission.subject_class = class_name
        permission.action = cancan_action
        permission.name = name
        permission.description = description
        permission.save
      else
        permission.name = name
        permission.description = description
        permission.save
      end
    end
  end
end
