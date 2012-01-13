require 'json'

class InfoSource
  attr :title
  def data
    {}.to_json
  end
  def render
    render_header + render_body
  end
  def render_header
    res = "<div class=\"info_box_header\">"
    if block_given?
      res += yield
    end
    res += "</div>"
  end
  def render_body
    res = "<div class=\"info_box_body\">"
    if block_given?
      res += yield
    end
    res += "</div>"
  end
end

class GithubInfo < InfoSource
  require 'rest_client'
  def initialize
  end

  def data
    res = RestClient.get "https://api.github.com/users/#{settings.github_conf[:user]}"
    res_json = JSON.parse(res)
    fields = ['login', 'avatar_url', 'html_url', 'public_repos', 'public_gists', 'followers', 'following', 'created_at']
    data = res_json.delete_if{ |k, v| !fields.include? k }
    data['created_at'] = Time.parse(data['created_at']).to_s
    data.to_json
  end

  def render_header
    super{"Github"}
  end

  def render_body
    super do
    "<table>
      <tr>
        <th colspan=\"2\">
          <img width=\"20\" height=\"20\" id=\"avatar_url\" src=\"\">
          <a id=\"html_url\" href=\"\"><span>agnessa</span></a>
        </th>
      </tr>
      <tr>
        <th>public repos</th>
        <td id=\"public_repos\"></td>
      </tr>
      <tr>
        <th>public gists</th>
        <td id=\"public_gists\"></td>
      </tr>
      <tr>
        <th>followers</th>
        <td id=\"followers\"></td>
      </tr>
      <tr>
        <th>following</th>
        <td id=\"following\"</td>
      </tr>
      <tr>
        <th>member since</th>
        <td id=\"created_at\"</td>
      </tr>
    </table>"
    end
  end
end

class LinkedinInfo < InfoSource
  require 'linkedin'

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

  def render_header
    super{"LinkedIn"}
  end

  def render_body
    super do
    "<table>
      <tr>
        <th colspan=\"2\">
          <img width=\"20\" height=\"20\" id=\"picture_url\" src=\"\">
          <a id=\"public_profile_url\" href=\"\"><span>Agnieszka Figiel</span></a>
        </th>
      </tr>
      <tr>
        <th>headline</th>
        <td id=\"headline\"></td>
      </tr>
      <tr>
        <th>position</th>
        <td id=\"position\"</td>
      </tr>
      <tr>
        <th>skills</th>
        <td id=\"skills\"</td>
      </tr>
    </table>"
    end
  end

end
class WwrInfo < InfoSource
  require 'open-uri'
  require 'nokogiri'
  def data
    doc = Nokogiri::HTML(open("http://workingwithrails.com/person/5003-agnieszka-figiel"))
    data = {}
    sidebar = doc.search("#Side")
    data[:authority_items] = sidebar.search("ul.authority/li").map(&:inner_html).join("\n")
    doc.css("#Side > div").each_with_index do |div, i|
      case i
      when 1
        data[:authority] = div.search("div:nth-child(2)").inner_text.chomp
      when 2
        data[:popularity] = div.search("div:nth-child(2)").inner_text.chomp
      when 3
        data[:ranking] = div.inner_text.chomp
      end
    end
    data[:experience] = doc.css("#Side > p").first.inner_text.chomp
    data.to_json
  end
  def render_header
    super{"Working with Rails"}
  end
  def render_body
    super do
    "<table>
      <tr>
        <th colspan=\"2\">
          <a href=\"#{settings.wwr_conf[:profile_url]}\"><span>Agnieszka Figiel</span></a>
        </th>
      </tr>
      <tr>
        <th>authority</th>
        <td id=\"authority\"></td>
      </tr>
      <tr>
        <th></th>
        <td id=\"authority_items\"></td>
      </tr>
      <tr>
        <th>popularity</th>
        <td id=\"popularity\"</td>
      </tr>
      <tr>
        <th>ranking</th>
        <td id=\"ranking\"</td>
      </tr>
      <tr>
        <th>experience</th>
        <td id=\"experience\"</td>
      </tr>
    </table>"
    end
  end

end
class GildInfo < InfoSource
  def render_header
    super{"Gild"}
  end
end
class BioInfo < InfoSource
  def render_header
    super{"Bio"}
  end
end
