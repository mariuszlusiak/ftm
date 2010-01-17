module PlayersHelper

  def render_player_div(player)
    result = %{
      <div class='index-div player'>
        <span class='headline'>
          <span class='name'>#{h player.full_name}</span>
        </span>
    }
    if player.team
      result += %{
        <span class='info'>#{h player.team.name}</span>
      }
    end
    if player.avatar
      result += %{ 
        <div class='avatar'>
          #{image_tag(player.avatar.public_filename(:thumb))}
        </div>
      }
    end
    result += %{
      </div>
    }
    result
  end

	def show_avatar(player, size = :small)
		res = ''
		if player.avatar
			res += link_to(image_tag(player.avatar.public_filename(size)),
				player_path(player))
		else
			size_string = size == :small ? '50x50' : '100x100'
			res += link_to(image_tag('/avatars/default.jpg', :size => size_string),
				player_path(player))
		end
		res
	end

	def show_short_player_info(player)
		res = link_to_player_team(player)
		if res.length > 0 and player.date_of_birth
			res += ', '
		end
		res += player_year_of_birth(player)
		res
	end

	def link_to_player(player)
		link_to player.full_name, player_path(player)
	end

	def link_to_player_team(player)
		res = ''
		if player.team
			res += link_to player.team.name, team_path(player.team)
		end
		res
	end

	def player_year_of_birth(player)
		res = ''
		if player.date_of_birth
				res += player.date_of_birth.year.to_s
		end
		res
	end

end
