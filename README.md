# dted

## Description
Octave package for parsing DTED (.dt1/.dt2) files. It's base is tile structure which consists of such fields:
- origin_lon - origin point longitude coordinate in DMS format [degrees, minutes, seconds]
- origin_lat - origin point latitude coordinate in DMS format [degrees, minutes, seconds]
- origin_lon_hemisphere - hemisphere indicator for the longitude (W or E)
- origin_lat_hemisphere - hemisphere indicator for the latitude (N or S)
- lon_step - interval for the longitude in seconds
- lat_step - interval for the latitude in seconds
- mult_accuracy - multiple accuracy flag (0 - single accuracy; 1 - multiple accuracy)
- compile_date - file compilation date MM/YY
- lat_num - number of latitudes in file (it's equal to number of rows of terrain elevation matrix)
- lon_num - number of longitudes in file (it's equal to number of columns of terrain elevation matrix)
- height_mat - terrain elevation matrix

## DTED file format specification:
- [http://pancroma.com/downloads/MIL-PDF-89020B.pdf](http://pancroma.com/downloads/MIL-PDF-89020B.pdf)
- [https://www.dlr.de/eoc/Portaldata/60/Resources/dokumente/7_sat_miss/SRTM-XSAR-DEM-DTED-1.1.pdf](https://www.dlr.de/eoc/Portaldata/60/Resources/dokumente/7_sat_miss/SRTM-XSAR-DEM-DTED-1.1.pdf)

## Installation
Download dted.tar.gz file from releases, navigate in Octave to the directory where this file is stored and run command (in Octave Command Window):
```
pkg install dted.tar.gz
```
If installation didn't throw any error it mean that the package was installed successfully.

## Usage
In order to use the package, you need to load it. To do that you need to run this command (also in Octave Command Window):
```
pkg load dted
```

## Functionalities

### Present the tile metadata
```matlab
t = get_tile('s55_w069.dt2');
present_tile(t);
```

### Plot terrain elevation data as surface in 3D
```matlab
t = get_tile('s55_w069.dt2');
% highly recommended to cutout smaller portions of terrain for 3D plotting
% because the plot engine gets very laggy with that many points
top_right = [55.564234, 69.041133];
bot_left = [55.607654, 69.106438];	% in this example tile is in SW hemisphere so the bottom left corner looks like that
cut = terrain_cutout(bot_left, top_right, t);
x = 1:1:columns(cut);			% x axis in seconds
y = 1:1:rows(cut);			% y axis in seconds
[xm, ym] = meshgrid(x, y);
mesh(x, y, cut);
```

### Plot terrain elevation data as heatmap
```matlab
t = get_tile('s55_w069.dt2');
% heatmap for the entire tile could be a little bit laggy
z = t.height_mat;			% z axis in meters
x = 1:1:t.lon_num;			% x axis in seconds
y = 1:1:t.lat_num;			% y axis in seconds
colormap('jet');
colorbar();
imagesc(x, y, z);
```

### Get terrain elevation in given point
```matlab
t = get_tile('s55_w069.dt2');
LAT = 54.532421;
LON = 68.234432;
h = get_elevation(LAT, LON, t)
```

### Transform coordinates from floating point to DMS format and the other way
```matlab
LAT = 54.532421;
LON_DMS = [55, 24, 23];
LAT_DMS = float_to_dms(LAT);
LON = dms_to_float(LON_DMS);
```

### Check if the point on given coordinates is inside the tile
```matlab
t = get_tile('s55_w069.dt2');
LAT = 54.54234;
LON = 68.12343;
flag = is_in_tile(LAT, LON, t)
LAT = 55.54234;
LON = 69.12343;
flag = is_in_tile(LAT, LON, t)
```

