module ProjectsHelper
  def link_to_revision(project, build)
    if build.pull_id
      link_to_pull_request(build.commit[0..7], project, build.pull_id)
    else
      link_to build.commit[0..7], "https://www.github.com/#{project.full_name}/commit/#{build.commit}"
    end
  end

  def link_to_pull_request_or_beranch(text, project, build)
    if build.pull_id
      link_to text, "https://www.github.com/#{project.full_name}/pull/#{build.pull_id}"
    else
      link_to text, "https://www.github.com/#{project.full_name}/tree/#{build.branch}"
    end
  end

  def link_to_github(text, project)
    link_to text, "https://www.github.com/#{project.full_name}"
  end
end
