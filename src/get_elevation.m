## Copyright (C) 2022 Bartosz Czaja
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{terrain_height} =} get_elevation (@var{latitude}, @var{longitude}, @var{tile})
## @var{latitude} - floating point latitude coordinate
## @var{longitude} - floating point longitude coordinate
## @var{tile} - tile we want terrain elevation from
## Returns terrain height in meters for the point described with @var{latitude}
## and @var{longitude} coordinates. If @var{tile} does not contain given point
## the height is 0 and ERROR is thrown.
## @seealso{}
## @end deftypefn

## Author: Bartosz Czaja
## Created: 2022-07-15

function terrain_height = get_elevation (latitude, longitude, tile)
  lat_dms = float_to_dms(latitude); % [deg min sec]
  lon_dms = float_to_dms(longitude); % [deg min sec]

  % lower left point of terrain elevation matrix is always the origin point
  % matrix dimensions on hemishpheres on top right element example:
  % NE: top right element - (origin_lat + 1, origin_lon + 1)
  % SE: top right element - (origin_lat - 1, origin_lon + 1)
  % NW: top right element - (origin_lat + 1, origin_lon - 1)
  % SW: top right element _ (origin_lat - 1, origin_lon - 1)

  %check if the point is in given tile
  in_tile_flag = false;
  lat_edge_flag = false;
  lon_edge_flag = false;
  if (tile.origin_lon_hemisphere == "E")
    if (tile.origin_lat_hemisphere == "N")
      if (tile.origin_lat(1) <= latitude && tile.origin_lat(1) + 1 >= latitude)
        if (tile.origin_lon(1) <= longitude && tile.origin_lon(1) + 1 >= longitude)
          in_tile_flag = true;    % in NE inside tile
          if (latitude == tile.origin_lat(1) + 1)
            lat_edge_flag = true;
          endif
          if (longitude == tile.origin_lon(1) + 1)
            lon_edge_flag = true;
          endif
        endif
      endif
    elseif (tile.origin_lat_hemisphere == "S")
      if (tile.origin_lat(1) >= latitude && tile.origin_lat(1) - 1 <= latitude)
        if (tile.origin_lon(1) <= longitude && tile.origin_lon(1) + 1 >= longitude)
          in_tile_flag = true;    % in SE inside tile
          if (latitude == tile.origin_lat(1) - 1)
            lat_edge_flag = true;
          endif
          if (longitude == tile.origin_lon(1) + 1)
            lon_edge_flag = true;
          endif
        endif
      endif
    endif
  elseif (tile.origin_lon_hemisphere == "W")
    if (tile.origin_lat(end) == "N")
      if (tile.origin_lat(1) <= floor(latitude) && tile.origin_lat(1) + 1 >= floor(latitude))
        if (tile.origin_lon(1) >= longitude && tile.origin_lon(1) - 1 <= longitude)
          in_tile_flag = true;    % in NW inside tile
          if (latitude == tile.origin_lat(1) + 1)
            lat_edge_flag = true;
          endif
          if (longitude == tile.origin_lon(1) - 1)
            lon_edge_flag = true;
          endif
        endif
      endif
    elseif (tile.origin_lat_hemisphere == "S")
      if (tile.origin_lat(1) >= latitude && tile.origin_lat(1) - 1 <= latitude)
        if (tile.origin_lon(1) >= longitude && tile.origin_lon(1) - 1 <= longitude)
          in_tile_flag = true;   % in SW inside tile
          if (latitude == tile.origin_lat(1) - 1)
            lat_edge_flag = true;
          endif
          if (longitude == tile.origin_lon(1) - 1)
            lon_edge_flag = true;
          endif
        endif
      endif
    endif
  endif

  if (in_tile_flag == false)
    terrain_height = 0;
    error("ERROR, the given tile does not consist the point %d, %d \n", latitude, longitude);
    return
  endif

  if (lat_edge_flag == true)
    row_index = 1;
  else
    row_index = lat_dms(2) * 60 + lat_dms(3);
    row_index = tile.lat_num - floor(row_index / tile.lat_step);
  endif

  if (lon_edge_flag == true)
    col_index = tile.lon_num;
  else
    col_index = lon_dms(2) * 60 + lon_dms(3);
    col_index = floor(col_index / tile.lon_step) + 1;
  endif

  terrain_height = tile.height_mat(row_index, col_index);
  return
endfunction
