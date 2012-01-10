class InfoSource
  attr :title
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
    res = RestClient.get "https://api.github.com/users/#{settings.github_user}"
    res_json = JSON.parse(res)
    @login = res_json['login']
    @avatar_url = res_json['avatar_url']
    @html_url = res_json['html_url']
    @public_repos = res_json['public_repos']
    @public_gists = res_json['public_gists']
    @followers = res_json['followers']
    @following = res_json['following']
    @created_at = res_json['created_at']
  end

  def render_header
    super{"Github"}
  end

  def render_body
    super do
    "     
          <table>
          <tr>
          <th>
            <img width=\"20\" height=\"20\" src=\"#{@avatar_url}\">
            <a href=\"#{@html_url}\">#{@login}</a>
          </th>
          </tr>
          <tr>
          <th>public repos</th>
          <td>#{@public_repos}</td>
          </tr>
          <tr>
          <th>public gists</th>
          <td>#{@public_gists}</td>
          </tr>
          <tr>
          <th>followers</th>
          <td>#{@followers}</td>
          </tr>
          <tr>
          <th>following</th>
          <td>#{@following}</td>
          </tr>
          <tr>
          <th>member since</th>
          <td>#{@created_at}</td>
          </tr>
          </table>
        "
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
