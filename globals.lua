default_color = {222 / 255, 222 / 255, 222 / 255}
background_color = {16 / 255, 16 / 255, 16 / 255}
ammo_color = {123 / 255, 200 / 255, 164 / 255}
boost_color = {76 / 255, 195 / 255, 217 / 255}
hp_color = {241 / 255, 103 / 255, 69 / 255}
skill_point_color = {255 / 255, 198 / 255, 93 / 255}

default_colors = {default_color, hp_color, ammo_color, boost_color, skill_point_color}
negative_colors = {
    {1-default_color[1], 1-default_color[2], 1-default_color[3]}, 
    {1-hp_color[1], 1-hp_color[2], 1-hp_color[3]}, 
    {1-ammo_color[1], 1-ammo_color[2], 1-ammo_color[3]}, 
    {1-boost_color[1], 1-boost_color[2], 1-boost_color[3]}, 
    {1-skill_point_color[1], 1-skill_point_color[2], 1-skill_point_color[3]}
}
all_colors = M.append(default_colors, negative_colors)

enemies = {'Rock', 'Shooter', 'BigRock', 'Waver', 'Seeker', 'Orbitter'}

-- Skill tree colors
white = {222/255, 222/255, 222/255}
dark = {96/255, 96/255, 96/255}
gray = {160/255, 160/255, 160/255}
red = {222/255, 32/255, 32/255}
green = {32/255, 222/255, 32/255}
blue = {32/255, 32/255, 222/255}
pink = {222/255, 32/255, 222/255}
brown = {192/255, 96/255, 32/255}
yellow = {222/255, 222/255, 32/255}
orange = {222/255, 128/255, 32/255}
bluegreen = {32/255, 222/255, 222/255}
purple = {128/255, 32/255, 128/255}

main_volume = 5
sfx_volume = 5
music_volume = 5
muted = false