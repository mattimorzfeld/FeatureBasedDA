function p = fire(m)
%FIRE   Blue-Purple Hot colormap
% 
% FIRE(M) returns an M-by-3 matrix containing a "fire" colormap.
% FIRE, by itself, is the same length as the current figure's
% colormap. If no figure exists, MATLAB creates one.
%
% To add this colormap as a default map, use 'addpath' with the 
% directory containing 'fire.m'.
%
% To reset the colormap of the current figure use 'colormap(fire)'.
%
% see also:  HSV, GRAY, HOT, COOL, BONE, COPPER, FLAG, PINK, COLORMAP,
% RGBPLOT.
%
% To create any custom colormap, see the directions on line 23 of this
% m-file.

if nargin < 1
    m = size(get(gcf,'colormap'),1); 
end

%You can replace this M x 3 matrix with any matrix whose values range
%between 0 and 1 to create a new colormap file.  Use copy / paste to create
%a matrix like the one below, you do not have to add these values
%manually.  To create a new colormap, change 'cmap_mat' to the desired
%matrix, rename the function *and* the m-file from 'fire' to your desired
%colormap name.

cmap_mat=[
 [0;150;250]'/255;
 1 1 1
 1 130/255 0
 [200;50;0]'/255;
    ];

%interpolate values
xin=linspace(0,1,m)';
xorg=linspace(0,1,size(cmap_mat,1));

p(:,1)=interp1(xorg,cmap_mat(:,1),xin,'linear');
p(:,2)=interp1(xorg,cmap_mat(:,2),xin,'linear');
p(:,3)=interp1(xorg,cmap_mat(:,3),xin,'linear');
find(p<=0)