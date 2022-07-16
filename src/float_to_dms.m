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
## @deftypefn {} {@var{dms_vec} =} float_to_dms (@var{coordinate})
## @var{dms_vec} - vector representing coordinate in DMS format [degrees, minutes, seconds]
## Returns vector representing given floating point @var{coordinate} in DMS
## [degrees minutes seconds] format
## @seealso{}
## @end deftypefn

## Author: Bartosz Czaja
## Created: 2022-07-15

function dms_vec = float_to_dms (coordinate)
  degrees = floor(coordinate);
  float_rest = coordinate - degrees;
  minutes = floor(float_rest * 60);
  float_rest = (float_rest * 60) - minutes;
  seconds = floor(float_rest * 60);
  dms_vec = [degrees, minutes, seconds];
endfunction
