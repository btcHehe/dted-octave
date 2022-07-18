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
## @deftypefn {} {@var{cutout_mat} =} terrain_cutout (@var{bottom_left}, @var{top_right})
## @var{bottom_left} - vector of coordinates [latitude, longitude] of bottom left corner of ROI rectangle
## @var{top_right} - vector of coordinates [latitude, longitude] of top right corner of ROI rectangle
## @var{tile} - tile structure object from which the cutout will be taken
## @var{cutout_mat} - submatrix containing ROI rectangle
## Function for cutting out the ROI rectangle from given @var{tile}.
## @seealso{}
## @end deftypefn

## Author: Bartosz Czaja
## Created: 2022-07-18

function cutout_mat = terrain_cutout (bottom_left, top_right, tile)
  bl_lat_dms = float_to_dms(bottom_left(1));
  bl_lon_dms = float_to_dms(bottom_left(2));

  tr_lat_dms = float_to_dms(top_right(1));
  tr_lon_dms = float_to_dms(top_right(2));

  if (tile.origin_lon_hemisphere == "W")
	  x = floor((tr_lon_dms(2)*60 + tr_lon_dms(3))/tile.lon_step) : 1 : floor((bl_lon_dms(2)*60 + bl_lon_dms(3))/tile.lon_step);
  elseif (tile.origin_lon_hemisphere == "E")
	  x = floor((bl_lon_dms(2)*60 + bl_lon_dms(3))/tile.lon_step) : 1 : floor((tr_lon_dms(2)*60 + tr_lon_dms(3))/tile.lon_step);
  endif

  if (tile.origin_lat_hemisphere == "N")
	  y = floor((bl_lat_dms(2)*60 + bl_lat_dms(3))/tile.lat_step) : 1 : floor((tr_lat_dms(2)*60 + tr_lat_dms(3))/tile.lat_step);
  elseif (tile.origin_lat_hemisphere == "S")
    y = floor((tr_lat_dms(2)*60 + tr_lat_dms(3))/tile.lat_step) : 1 : floor((bl_lat_dms(2)*60 + bl_lat_dms(3))/tile.lat_step);
  endif

  cutout_mat = tile.height_mat(y(1): y(end), x(1): x(end));

  return
endfunction
