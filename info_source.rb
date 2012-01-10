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
  def initialize
  end

  def data
    res = RestClient.get "https://api.github.com/users/#{settings.github_user}"
    res_json = JSON.parse(res)
    fields = ['login', 'avatar_url', 'html_url', 'public_repos', 'public_gists', 'followers', 'following', 'created_at']
    data = res_json.select{ |e| fields.include? e}
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
        <th>
          <img width=\"20\" height=\"20\" id=\"avatar_url\" src=\"\">
          <a id=\"html_url\" href=\"\"><span id=\"login\"></span></a>
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
  def render_header
    super{"LinkedIn"}
  end
end
class WwrInfo < InfoSource
  def render_header
    super{"Working with Rails"}
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
