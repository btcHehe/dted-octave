# dted

Octave package for parsing DTED (.dt1/.dt2) files. 

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
