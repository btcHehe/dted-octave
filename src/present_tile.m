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
## @deftypefn {} {@var{retval} =} present_tile (@var{tile})
## Prints out metadana of the tile to console.
## @seealso{}
## @end deftypefn

## Author: Bartosz Czaja
## Created: 2022-07-18

function retval = present_tile (tile)
  printf("Origin latitude (DMS): %d %s\n", tile.origin_lat(1), tile.origin_lat_hemisphere);
  printf("Origin longitude (DMS): %d %s\n", tile.origin_lon(1), tile.origin_lon_hemisphere);
  printf("Latitude interval [seconds]: %d\n", tile.lat_step);
  printf("Longitude interval [seconds]: %d\n", tile.lon_step);
  printf("Multiple accuracy (0-false / 1-true): %s\n", tile.mult_accuracy);
  printf("Compilation date (MM/YY): %s\n", tile.compile_date);
  return
endfunction
