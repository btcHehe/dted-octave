# dted

Octave package for parsing DTED (.dt1/.dt2) files. It's base is tile structure which consists of such fields:
-> origin_lon - origin point longitude coordinate in DMS format [degrees, minutes, seconds]
-> origin_lat - origin point latitude coordinate in DMS format [degrees, minutes, seconds]
-> origin_lon_hemisphere - hemisphere indicator for the longitude (W or E)
-> origin_lat_hemisphere - hemisphere indicator for the latitude (N or S)
-> lon_step - interval for the longitude in seconds
-> lat_step - interval for the latitude in seconds
-> mult_accuracy - multiple accuracy flag (0 - single accuracy; 1 - multiple accuracy)
-> compile_date - file compilation date MM/YY
-> lat_num - number of latitudes in file (it's equal to number of rows of terrain elevation matrix)
-> lon_num - number of longitudes in file (it's equal to number of columns of terrain elevation matrix)
-> height_mat - terrain elevation matrix

## Functionalities
### Extracting meta-information
```matlab
t = get_tile('s55_w069.dt2');
prinf(t.origin_lon);
printf(t.origin_lat);
printf(t.origin_lon_hemisphere);
printf(t.origin_lat_hemisphere);
printf(t.lon_step);
printf(t.lat_step);
printf(t.mult_accuracy);
printf(t.compile_date);
printf(t.lat_num);
printf(t.lon_num)
```

### Plot terrain elevation data as surface in 3D
```matlab
t = get_tile('s55_w069.dt2');
cutout = 100;   % for entire data surface in 3D is badly optimized and can crash octave
% highly recommended cutout smaller portions of terrain for 3D plotting
z = t.height_mat(1:cutout/t.lat_step, 1:cutout/t.lon_step);
x = 1:1:cutout/t.lon_step;
y = 1:1:cutout/t.lat_step;
```

### Plot terrain elevation data as heatmap
```matlab
t = get_tile('s55_w069.dt2');
% heatmap for entire terrain could be a little bit laggy but it shouldn't crash octave
z = t.height_mat;
% x and y axes are in seconds
x = 1:1:t.lon_num;
y = 1:1:t.lat_num;
```

### Get terrain elevation in given point
```matlab
t = get_tile('s55_w069.dt2');
LAT = 54.532421;
LON = 68.234432;
h = get_elevation(LAT, LON, t)
```
