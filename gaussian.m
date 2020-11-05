%% setup
maskFiles = dir('train_images/masks/*.bmp');
imgFiles = dir('train_images/*.jpg');

muR = 0;  
muG = 0;
muB = 0;
n = 0;

for i=1:length(maskFiles)-3
    img = imread('train_images/' + string(imgFiles(i).name));
    mask = imread('train_images/masks/' + string(maskFiles(i).name));


    [rows, cols, colorChannels] = size(img);
    r = img(:,:,1);   %% Red Channel
    g = img(:,:,2);   %% Green Channel
    b = img(:,:,3);   %% Blue Channel
    %mask = double(roipoly(img));

    %% show mask
    %figure();
    %imshow(mask);

    %% finding mu
    

    for row=1:rows
        for col=1:cols
            if (mask(row,col) == 255)
                muR = muR + double(r(row,col));
                muG = muG + double(g(row,col));
                muB = muB + double(b(row,col));
                n = n + 1;
            end
        end
    end
end
mu = [muR/n; muG/n; muB/n]

%% finding sigma
sigma = 0;
%n = 0;

for i=1:length(maskFiles)-3
    for row=1:rows
        for col=1:cols
            if (mask(row,col) == 255)
                x = double(img(row,col,:));
                q = reshape(x,1,[]);
                x = q.';
                y = x - mu;
                if (sigma == 0)
                    sigma = y*transpose(y);
                else
                    sigma = sigma + (y)*transpose(y);
                end
                %n = n+1;
            end
        end
    end
end
sigma = sigma/n
detSigma = det(sigma)

%% finding likelihood
p = @(x) (1/sqrt(((2*pi)^3)*detSigma))*exp((-1/2)*((x-mu).')*inv(sigma)*(x-mu));
thresh = .0000005;

%% testing pixels with posterior
w = 0;
for i=length(maskFiles)-2:length(maskFiles)
    w = w + 1;
    testImg = imread('train_images/' + string(imgFiles(i).name));
    final = zeros(rows,cols);
    for row=1:rows
        for col=1:cols
            x = double(testImg(row,col,:));
            q = reshape(x,1,[]);
            x = q.';
            if (.5*p(x) >= thresh)
                final(row,col) = 1;
            else
                final(row,col) = 0;
                testImg(row,col,:) = 0;
            end
        end
    end

    %% show final
    %figure();
    %imshow(final);
    fprintf('Image: %s Figure %d', imgFiles(i).name, w);
    figure();
    imshow(testImg);
end