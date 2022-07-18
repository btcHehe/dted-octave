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
## @deftypefn {} {@var{coord_float} =} dms_to_float (@var{coord_dms})
## @var{coord_dms} - coordinate in DMS format (Degrees, Minutes, Seconds)
## @var{coord_float} - coordinate translated to floating point format
## Returns coordinate given as vector of values in DMS format translated to floating point number format 
## @seealso{}
## @end deftypefn

## Author: Bartosz Czaja
## Created: 2022-07-18

function coord_float = dms_to_float (coord_dms)
  coord_float = coord_dms(1) + (coord_dms(2) / 60) + (coord_dms(3) / 3600);
  return
endfunction
