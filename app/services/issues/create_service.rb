module Issues
  class CreateService < BaseService
    def execute
      issue = project.issues.new(params)
      issue.author = current_user

      if issue.save
        notification_service.new_issue(issue, current_user)
        event_service.open_issue(issue, current_user)
        issue.create_cross_references!(issue.project, current_user)
        execute_hooks(issue)
      end

      issue
    end

    private

    def execute_hooks(issue)
      issue.project.execute_hooks(issue.to_hook_data, :issue_hooks)
    end
  end
end
