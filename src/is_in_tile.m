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
## @deftypefn {} {@var{retval} =} is_in_tile (@var{latitude}, @var{longitude}, @var{tile})
## @var{latitude} - Latitude coordinate in floating point format
## @var{longitude} - Longitude coordinate in floating point format
## @var{tile} - Tile struct object that we want to check if it contains specified point
## @var{retval} - true or false value
## @seealso{}
## @end deftypefn

## Author: Bartosz Czaja
## Created: 2022-07-18

function retval = is_in_tile (latitude, longitude, tile)
  retval = false;
  if (tile.origin_lon_hemisphere == "E")
    if (tile.origin_lat_hemisphere == "N")
      if (tile.origin_lat(1) <= latitude && tile.origin_lat(1) + 1 >= latitude)
        if (tile.origin_lon(1) <= longitude && tile.origin_lon(1) + 1 >= longitude)
          retval = true;    % in NE inside tile
        endif
      endif
    elseif (tile.origin_lat_hemisphere == "S")
      if (tile.origin_lat(1) >= latitude && tile.origin_lat(1) - 1 <= latitude)
        if (tile.origin_lon(1) <= longitude && tile.origin_lon(1) + 1 >= longitude)
          retval = true;    % in SE inside tile
        endif
      endif
    endif
  elseif (tile.origin_lon_hemisphere == "W")
    if (tile.origin_lat(end) == "N")
      if (tile.origin_lat(1) <= floor(latitude) && tile.origin_lat(1) + 1 >= floor(latitude))
        if (tile.origin_lon(1) >= longitude && tile.origin_lon(1) - 1 <= longitude)
          retval = true;    % in NW inside tile
        endif
      endif
    elseif (tile.origin_lat_hemisphere == "S")
      if (tile.origin_lat(1) >= latitude && tile.origin_lat(1) - 1 <= latitude)
        if (tile.origin_lon(1) >= longitude && tile.origin_lon(1) - 1 <= longitude)
          retval = true;   % in SW inside tile
        endif
      endif
    endif
  endif
  return
endfunction
