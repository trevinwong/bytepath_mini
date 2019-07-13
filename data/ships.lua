Ships = {}

Ships["Fighter"] = {}
Ships["Fighter"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w, 0, -- 1
        w/2, -w/2, -- 2
        -w/2, -w/2, -- 3
        -w, 0, -- 4
        -w/2, w/2, -- 5
        w/2, w/2, -- 6
    }
    polygons[2] =  {
        w/2, -w/2, -- 7
        0, -w, -- 8
        -w - w/2, -w, -- 9
        -3*w/4, -w/4, -- 10
        -w/2, -w/2, -- 11
    }
    polygons[3] = {
        w/2, w/2, -- 12
        -w/2, w/2, -- 13
        -3*w/4, w/4, -- 14
        -w - w/2, w, -- 15
        0, w, -- 16
    }
    return polygons
end

Ships["Brick"] = {}
Ships["Brick"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w, -w/2, -- 1
        w, w/2, -- 2
        -w, w/2, -- 3
        -w, -w/2, -- 4
    }
    return polygons
end

Ships["Rocket"] = {}
Ships["Rocket"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w, 0, -- 1
        w/2, w/2, -- 2
        -w/2, w/2, -- 3
        -w/0.65, w, -- 4
        -w, w/2, -- 5
        -w, -w/2, -- 6
        -w/0.65, -w, -- 7
        -w/2, -w/2, -- 8
        w/2, -w/2, -- 9
    }
    return polygons
end

Ships["Night"] = {}
Ships["Night"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w, 0, -- 1
        -w/2, w, -- 2
        -w, w/1.5, -- 3
        -w/2, w/2, -- 4
        -w, 0, -- 5
        -w/2, -w/2, -- 6
        -w, -w/1.5, -- 7
        -w/2, -w --8
    }
    return polygons
end

Ships["Crystal"] = {}
Ships["Crystal"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w, 0, -- 1
        w/2, w/2, -- 2
        -w/2, w/2, -- 3
        -w, 0, -- 4
        -w/2, -w/2, -- 5
        w/2, -w/2 -- 6
    }
    return polygons
end

Ships["Robo"] = {}
Ships["Robo"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w/2, -w/2, -- 1
        w/2, w/2, -- 2
        -w, w/2, -- 3
        -w, -w/2, -- 4
    }
    polygons[2] = {
        w, -w, -- 5
        w, -w/1.5, -- 6
        -w/2, -w/1.5, -- 7
        -w/2, -w/2, -- 8
        -w, -w/2, -- 9
        -w, -w -- 10
    }
    polygons[3] = {
        w, w, -- 11
        w, w/1.5, -- 12
        -w/2, w/1.5, -- 13
        -w/2, w/2, -- 14
        -w, w/2, -- 15
        -w, w -- 16
    }
    return polygons
end

Ships["Freedom"] = {}
Ships["Freedom"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        w/1.5, -w/2, -- 1
        w/1.5, w/2, -- 2
        w/3, w/2, -- 3
        w/3, w, -- 4
        -w/3, w, -- 5
        -w/3, w/2, -- 6
        -w, w/2, -- 7
        -w, -w/2, -- 8
        -w/3, -w/2, -- 9
        -w/3, -w, -- 10
        w/3, -w, -- 11
        w/3, -w/2 -- 12
    }
    return polygons
end

Ships["Stabbinator"] = {}
Ships["Stabbinator"]["generatePolygons"] = function(w)
    local polygons = {}
    polygons[1] = {
        0, w, -- 1
        -w/2, w/3, -- 2
        0, 0, -- 3
        -w/2, -w/3, -- 4
        0, -w, -- 5
        w, 2*(-w/3),  -- 6
        w/2, -w/3,  -- 7
        w, 0,  -- 8
        w/2, w/3,  -- 9
        w, 2*(w/3),  -- 10
    }
    return polygons
end