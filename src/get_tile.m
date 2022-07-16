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
## @deftypefn {get_tile} {@var{tile} =} get_data (@var{file_name})
## @var{file_name) - path to the DTED file that is to be read
## Returns tile structure containing most important data
## from DTED file to which path is passed as argument @var{file_name}
## tile struct fields:
## -> origin_lon - origin point longitude coordinate in DMS format [degrees, minutes, seconds]
## -> origin_lat - origin point latitude coordinate in DMS format [degrees, minutes, seconds]
## -> origin_lon_hemisphere - hemisphere indicator for the longitude (W or E)
## -> origin_lat_hemisphere - hemisphere indicator for the latitude (N or S)
## -> lon_step - interval for the longitude in seconds
## -> lat_step - interval for the latitude in seconds
## -> mult_accuracy - multiple accuracy flag (0 - single accuracy; 1 - multiple accuracy)
## -> compile_date - file compilation date MM/YY
## -> lat_num - number of latitudes in file (it's equal to number of rows of terrain elevation matrix)
## -> lon_num - number of longitudes in file (it's equal to number of columns of terrain elevation matrix)
## -> height_mat - terrain elevation matrix
##
## @seealso{}
## @end deftypefn

## Author: Bartosz Czaja
## Created: 2022-07-15

## Script written using specification declared:
## https://www.dlr.de/eoc/Portaldata/60/Resources/dokumente/7_sat_miss/SRTM-XSAR-DEM-DTED-1.1.pdf

function tile = get_tile(file_name)
  bin_file = fopen(file_name);

  tile = struct();

  % reading tile parameters
  % 80 bytes of UHL (User Header Label) Record
  uhl_data = char(fread(bin_file, 80, "char"));
  deg = uhl_data(5:7);
  deg = str2num(strcat(deg(1), deg(2), deg(3)));
  min = uhl_data(8:9);
  min = str2num(strcat(min(1), min(2)));
  sec = uhl_data(10:11);
  sec = str2num(strcat(sec(1), sec(2)));
  hemisphere = uhl_data(12);
  tile.origin_lon = [deg, min, sec];     % origin longitude
  tile.origin_lon_hemisphere = hemisphere;
  deg = uhl_data(13:15);
  deg = str2num(strcat(deg(1), deg(2), deg(3)));
  min = uhl_data(16:17);
  min = str2num(strcat(min(1), min(2)));
  sec = uhl_data(18:19);
  sec = str2num(strcat(sec(1), sec(2)));
  hemisphere = uhl_data(20);
  tile.origin_lat = [deg, min, sec];     % origin latitude
  tile.origin_lat_hemisphere = hemisphere;
  tile.lon_step = str2num(strcat(uhl_data(21), uhl_data(22), uhl_data(23), ".", uhl_data(24)));     % longitude interval in seonds
  tile.lat_step = str2num(strcat(uhl_data(25), uhl_data(26), uhl_data(27), ".", uhl_data(28)));     % latitude interval in seconds
  tile.mult_accuracy = uhl_data(56);   % multiple accuracy 0-single 1-multiple

  % 648 bytes of DSI (Data Set Identification) Record
  dsi_data = char(fread(bin_file, 648, "char"));
  tile.compile_date = strcat(dsi_data(162), dsi_data(163), "/", dsi_data(160), dsi_data(161));  % compilation date MM/YY
  tile.lat_num = str2num(strcat(dsi_data(282), dsi_data(283), dsi_data(284), dsi_data(285)));  % number of latitude lines
  tile.lon_num = str2num(strcat(dsi_data(286), dsi_data(287), dsi_data(288), dsi_data(289)));  % number of longitude lines
  % 2700 bytes of ACC (Accuracy Description) Record
  acc_data = char(fread(bin_file, 2700, "char"));
  % -----

  % reading terrain elevation data
  % Data Record
  % every data record has 8 bytes of preamble, lat_num number of elevation data and 4 bytes of checksum
  terrain_data_vector = int16(fread(bin_file, (4 + tile.lat_num + 2) * tile.lon_num, "int16"));
  terrain_data_vector = swapbytes(terrain_data_vector);
  terrain_mat = reshape(terrain_data_vector, (4 + tile.lat_num + 2), tile.lon_num);
  terrain_mat = terrain_mat(5:end, :);     % delete preambles
  terrain_mat = terrain_mat(1:end-2, :);   % delete checksum
  if terrain_mat(terrain_mat < -12000),
    printf("WARNING! The loaded file contains void cells, they are being filled with value of 0\n");
    terrain_mat(terrain_mat < -12000) = 0;   % convert void data to 0
  endif

  terrain_mat =  flipud(terrain_mat);

  % lower left point of terrain elevation matrix is always the origin point
  % matrix dimensions on hemishpheres on top right element example:
  % NE: top right element - (origin_lat + 1, origin_lon + 1)
  % SE: top right element - (origin_lat - 1, origin_lon + 1)
  % NW: top right element - (origin_lat + 1, origin_lon - 1)
  % SW: top right element _ (origin_lat - 1, origin_lon - 1)
  tile.height_mat = terrain_mat;
  return
endfunction
