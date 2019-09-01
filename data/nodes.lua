-- Exercise 226: I'll slowly grow this tree in future commits. I just don't want to spend too much time getting stuck on design.

tree = {}
tree[1] = {x = 30, y = 90, stats = {}, links = {2, 3, 5, 4}, no_description = true, size = 3}
tree[2] = {x = 30, y = 30, stats = {'6% Increased HP', 'hp_multiplier', 0.04}, title = "HP", links = {}, cost = 1, size = 2}
tree[3] = {x = -30, y = 90, stats = {'10% Increased Attack Speed', 'aspd_multiplier', 0.10}, title = "ASPD", links = {}, cost = 1, size = 2}
tree[4] = {x = 90, y = 90, stats = {'10% Increased Luck', 'luck_multiplier', 0.10}, links = {}, title = "Luck", cost = 1, size = 2}
tree[5] = {x = 30, y = 150, stats = {'10% Increased Movement Speed', 'mvspd_multiplier', 0.10}, title = "MVSPD", links = {}, cost = 1, size = 2}