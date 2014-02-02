class Spinach::Features::PublicProjectsFeature < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedProject

  step 'I should see project "Community"' do
    page.should have_content "Community"
  end

  step 'I should not see project "Enterprise"' do
    page.should_not have_content "Enterprise"
  end

  step 'I should see project "Empty Public Project"' do
    page.should have_content "Empty Public Project"
  end

  step 'I should see public project details' do
    page.should have_content '32 branches'
    page.should have_content '16 tags'
  end

  step 'I should see project readme' do
    page.should have_content 'README.md'
  end

  step 'public project "Community"' do
    create :project, name: 'Community', visibility_level: Gitlab::VisibilityLevel::PUBLIC
  end

  step 'public empty project "Empty Public Project"' do
    create :empty_project, name: 'Empty Public Project', visibility_level: Gitlab::VisibilityLevel::PUBLIC
  end

  step 'I visit empty project page' do
    project = Project.find_by(name: 'Empty Public Project')
    visit project_path(project)
  end

  step 'I visit project "Community" page' do
    project = Project.find_by(name: 'Community')
    visit project_path(project)
  end

  step 'I should see empty public project details' do
    page.should have_content 'Git global setup'
  end

  step 'I should see empty public project details with http clone info' do
    project = Project.find_by(name: 'Empty Public Project')
    page.all(:css, '.git-empty .clone').each do |element|
      element.text.should include(project.http_url_to_repo)
    end
  end

  step 'I should see empty public project details with ssh clone info' do
    project = Project.find_by(name: 'Empty Public Project')
    page.all(:css, '.git-empty .clone').each do |element|
      element.text.should include(project.url_to_repo)
    end
  end

  step 'private project "Enterprise"' do
    create :project, name: 'Enterprise'
  end

  step 'I visit project "Enterprise" page' do
    project = Project.find_by(name: 'Enterprise')
    visit project_path(project)
  end

  step 'I should see project "Community" home page' do
    within '.project-home-title' do
      page.should have_content 'Community'
    end
  end

  step 'internal project "Internal"' do
    create :project, name: 'Internal', visibility_level: Gitlab::VisibilityLevel::INTERNAL
  end

  step 'I should see project "Internal"' do
    page.should have_content "Internal"
  end

  step 'I should not see project "Internal"' do
    page.should_not have_content "Internal"
  end

  step 'I visit project "Internal" page' do
    project = Project.find_by(name: 'Internal')
    visit project_path(project)
  end

  step 'I should see project "Internal" home page' do
    within '.project-home-title' do
      page.should have_content 'Internal'
    end
  end

  step 'I should see an http link to the repository' do
    project = Project.find_by(name: 'Community')
    page.should have_field('project_clone', with: project.http_url_to_repo)
  end

  step 'I should see an ssh link to the repository' do
    project = Project.find_by(name: 'Community')
    page.should have_field('project_clone', with: project.url_to_repo)
  end

  step 'I visit "Community" issues page' do
    project = Project.find_by(name: 'Community')
    create(:issue,
       title: "Bug",
       project: project
      )
    create(:issue,
       title: "New feature",
       project: project
      )
    visit project_issues_path(project)
  end


  step 'I should see list of issues for "Community" project' do
    project = Project.find_by(name: 'Community')

    page.should have_content "Bug"
    page.should have_content project.name
    page.should have_content "New feature"
  end

  step 'I visit "Internal" issues page' do
    project = Project.find_by(name: 'Internal')
    create(:issue,
       title: "Internal Bug",
       project: project
      )
    create(:issue,
       title: "New internal feature",
       project: project
      )
    visit project_issues_path(project)
  end


  step 'I should see list of issues for "Internal" project' do
    project = Project.find_by(name: 'Internal')

    page.should have_content "Internal Bug"
    page.should have_content project.name
    page.should have_content "New internal feature"
  end

  step 'I visit "Community" merge requests page' do
    project = Project.find_by(name: 'Community')
    create(:merge_request,
      title: "Bug fix",
      source_project: project,
      target_project: project,
      source_branch: 'stable',
      target_branch: 'master',
    )
    create(:merge_request,
      title: "Feature created",
      source_project: project,
      target_project: project,
      source_branch: 'stable',
      target_branch: 'master',
    )
    visit project_merge_requests_path(project)
  end

  step 'I should see list of merge requests for "Community" project' do
    project = Project.find_by(name: 'Community')

    page.should have_content "Bug fix"
    page.should have_content project.name
    page.should have_content "Feature created"
  end

  step 'I visit "Internal" merge requests page' do
    project = Project.find_by(name: 'Internal')
    create(:merge_request,
      title: "Bug fix internal",
      source_project: project,
      target_project: project,
      source_branch: 'stable',
      target_branch: 'master',
    )
    create(:merge_request,
      title: "Feature created for internal",
      source_project: project,
      target_project: project,
      source_branch: 'stable',
      target_branch: 'master',
    )
    visit project_merge_requests_path(project)
  end

  step 'I should see list of merge requests for "Internal" project' do
    project = Project.find_by(name: 'Internal')

    page.should have_content "Bug fix internal"
    page.should have_content project.name
    page.should have_content "Feature created for internal"
  end
end

