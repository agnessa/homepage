require 'json'

class InfoSource
  attr :title
  def data
    {}.to_json
  end
  def profile_link
    "<a href=#{profile_url}>view profile</a>"
  end
end

class GithubInfo < InfoSource
  require 'rest_client'
  def initialize
    @title = "Github"
  end

  def data
    res = RestClient.get "https://api.github.com/users/#{settings.github_conf[:user]}"
    res_json = JSON.parse(res)
    fields = ['login', 'avatar_url', 'html_url', 'public_repos', 'public_gists', 'followers', 'following', 'created_at']
    data = res_json.delete_if{ |k, v| !fields.include? k }
    data['created_at'] = Time.parse(data['created_at']).to_s
    data.to_json
  end

  def profile_url
    "https://github.com/#{settings.github_conf[:user]}"
  end
end

class LinkedinInfo < InfoSource
  require 'linkedin'

  def initialize
    @title="LinkedIn"
  end

  def data
    client = LinkedIn::Client.new(settings.linkedin_conf[:api_key], settings.linkedin_conf[:secret])
    client.authorize_from_access(settings.linkedin_conf[:access_key1], settings.linkedin_conf[:access_key2])
    user = client.profile(:fields => %w(picture-url public-profile-url headline skills positions))
    current_position = user.positions.all[0]
    current_position = "#{current_position.title} at #{current_position.company.name}"
    skills = user.skills.all.map{|s| s.skill.name}.join(', ')
    user_fields = {
      :skills => skills,
      :position => current_position
    }
    [:headline, :picture_url, :public_profile_url].each do |field|
      user_fields[field] = user.send(field)
    end
    user_fields.to_json
  end

  def profile_url
    "http://www.linkedin.com/in/#{settings.github_conf[:user]}"
  end
end
class WwrInfo < InfoSource
  require 'open-uri'
  require 'nokogiri'
  def initialize
    @title = "Working With Rails"
  end
  def data
    doc = Nokogiri::HTML(open(profile_url))
    data = {}
    sidebar = doc.search("#Side")
    data[:authority_items] = sidebar.search("ul.authority/li").map(&:inner_html).join("\n")
    doc.css("#Side > div").each_with_index do |div, i|
      case i
      when 1
        node = div.search("div:nth-child(2)")
        data[:authority] = node && node.inner_text.chomp
        #TODO as percentage
      when 2
        node = div.search("div:nth-child(2)")
        data[:popularity] = node && node.inner_text.chomp
        #TODO as percentage
      when 3
        data[:ranking] = div && div.inner_text.chomp.sub(/^Ranking:\s/,'')
      end
    end
    node = sidebar.search("p").first
    data[:experience] = node && node.inner_text.chomp
    data.to_json
  end
  def profile_url
    "http://workingwithrails.com/person/#{settings.wwr_conf[:user]}"
  end
end
class GildInfo < InfoSource
  require 'open-uri'
  require 'nokogiri'
  def initialize
    @title="Gild"
  end
  def data
    doc = Nokogiri::HTML(open(profile_url))
    data = {:gild_skills => []}
    skills = doc.search("#profile_user_skills_content")
    skills.search("ul.users_skills/li").each_with_index do |li, i|
      name = li.search(".profile_user_skill_name")
      score = li.search("span.current_score")
      data[:gild_skills] << [name.inner_text, score.inner_text]
      #TODO as percentage
    end
    data.to_json
  end
  def profile_url
    "http://www.gild.com/#{settings.gild_conf[:user]}"
  end
end
class BioInfo < InfoSource
  def initialize
    @title="Bio"
  end
  def profile_url
    nil
  end
end
