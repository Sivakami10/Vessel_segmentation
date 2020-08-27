%%%%%%%%%%%% This script calls the Adaptive Frangi filter pipeline %%%%%%%%
% Note: This code works well for in-plane resolution close to 0.5 x 0.5
% If the input image is widely different from this, it is helpful to resample
% the image

clear all; close all; clc
addpath(genpath('Add_your_path_here/Ves_seg_protected'))
load sample.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Variables  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
type = 1; % type = 1 for MRA, 0 for SWI
alpha = 300; % Adjust according to noise level. Increase value for noisy image
% Reduce threshold if many vessels are missed
erode_size = 17; % No. of pixels to erode brain boundary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Applying on 3D data
[Auto, Ves_rad] = AdaptiveFrangi_pipeline3(tof, type, alpha, erode_size);
map = mycolormap();
for i = 1:size(tof,3)
    f1 = figure(1);
    set( f1, 'position', [50, 750, 700, 350] );
    subplot(121)
    imagesc(tof(:,:,i)); colormap gray; axis off; title(['Original TOF- Slice ' num2str(i)])

    subplot(122)
    imagesc(Auto(:,:,i)); colormap gray; axis off; title('Adaptive Frangi')

    f2 = figure(2);
    set( f2, 'position', [750, 750, 700, 350] );
    Ves_rad_sl = Ves_rad(:,:,i);
    subplot(121)
    imagesc(Ves_rad_sl);title('Vessel Radii Map');colormap(map); colorbar; axis off
    
    subplot(122)
    bins = round(max(Ves_rad_sl(:))/ 0.11); % Each bin=0.11 mm
    [counts edges] = histcounts(Ves_rad_sl, bins);
    bar(edges(2:end-1), counts(2:end))
    title('Vessel radii distribution'); xlabel('Number of pixels thick'); ylabel('Counts')
    disp('Press any key to continue')
    pause;
end

%% Applying on 2D Maximum Intensity Projection
tof_mip = max(tof,[],3);
[Auto_mip, Ves_rad_mip] = AdaptiveFrangi_pipeline2(tof_mip, type, alpha);
map = mycolormap();

f3 = figure(3);
set( f3, 'position', [50, 50, 700, 350] );
subplot(121)
imagesc(tof_mip);colormap gray; axis off; title('Original TOF-MIP')

subplot(122)
imagesc(Auto_mip); colormap gray; axis off; title('Adaptive Frangi-MIP')

f4 = figure(4);
set( f4, 'position', [750, 50, 700, 350] );
subplot(121)
imagesc(Ves_rad_mip); title('Vessel Radii Map-MIP'); colormap(map); colorbar; axis off

subplot(122)
bins = round(max(Ves_rad_mip(:))/ 0.11); % Each bin=0.11 mm
[counts edges] = histcounts(Ves_rad_mip, bins);
bar(edges(2:end-1), counts(2:end))
title('Vessel radii distribution'); xlabel('Number of pixels thick'); ylabel('Counts')


