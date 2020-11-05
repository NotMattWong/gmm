%% setup

clc
clear all

thresh = .0000005;
k = 7;

%% training

image1 = imread('train_images/68.jpg');
image2 = imread('train_images/91.jpg');
image3 = imread('train_images/114.jpg');
image4 = imread('train_images/121.jpg');
image5 = imread('train_images/137.jpg');
[rows1, cols1, colorChannels1] = size(image1);
[rows2, cols2, colorChannels2] = size(image2);
[rows3, cols3, colorChannels3] = size(image3);
[rows4, cols4, colorChannels4] = size(image4);
[rows5, cols5, colorChannels5] = size(image5);
mask1 = imread('train_images/masks/68-mask.bmp');
mask2 = imread('train_images/masks/91-mask.bmp');
mask3 = imread('train_images/masks/114-mask.bmp');
mask4 = imread('train_images/masks/121-mask.bmp');
mask5 = imread('train_images/masks/137-mask.bmp');

orange = [];
curr = zeros(1,3);
for i=1:rows1
    for j=1:cols1
        if mask1(i,j) == 255
            curr(1,1) = image1(i,j,1);
            curr(1,2) = image1(i,j,2);
            curr(1,3) = image1(i,j,3);
            orange = vertcat(orange,double(curr));
        end
    end
end
for i=1:rows2
    for j=1:cols2
        if mask2(i,j) == 255
            curr(1,1) = image2(i,j,1);
            curr(1,2) = image2(i,j,2);
            curr(1,3) = image2(i,j,3);
            orange = vertcat(orange,double(curr));
        end
    end
end
for i=1:rows3
    for j=1:cols3
        if mask3(i,j) == 255
            curr(1,1) = image3(i,j,1);
            curr(1,2) = image3(i,j,2);
            curr(1,3) = image3(i,j,3);
            orange = vertcat(orange,double(curr));
        end
    end
end
for i=1:rows4
    for j=1:cols4
        if mask3(i,j) == 255
            curr(1,1) = image3(i,j,1);
            curr(1,2) = image3(i,j,2);
            curr(1,3) = image3(i,j,3);
            orange = vertcat(orange,double(curr));
        end
    end
end
for i=1:rows5
    for j=1:cols5
        if mask3(i,j) == 255
            curr(1,1) = image3(i,j,1);
            curr(1,2) = image3(i,j,2);
            curr(1,3) = image3(i,j,3);
            orange = vertcat(orange,double(curr));
        end
    end
end

x = orange;


[mu, sigma] = trainGMM(x, k);
plotGMM(mu, sigma, 1, x);

%% Testing

path = dir('test_images/*.jpg');
numFiles = length(path);

for i = 1:numFiles
    
    % Getting the file
    currImgPath = fullfile(path(i).folder, path(i).name);
    currImg = imread(currImgPath);
    x = currImg;
    
    cluster = testGMM(x, mu, sigma, thresh, k);
    
    % Measure Depth
    %d = measureDepth(cluster);
    
    figure();
    imshow(cluster);
    
    %disp('Distance of ball: ' + d);
    
end

