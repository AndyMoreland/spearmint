module ProjectsHelper
  def link_to_revision(project, build)
    if build.pull_id
      link_to build.commit[0..7], "https://www.github.com/#{project.full_name}/pull/#{build.pull_id}"
    else
      link_to build.commit[0..7], "https://www.github.com/#{project.full_name}/commit/#{build.commit}"
    end
  end
end
