tic
names = [""];
images=[]; num_imgs = zeros(size(names)); pixelsize = num_imgs;
maxsize = [0,0];
avgsize = maxsize;
wnum = 1;  wname = 'db3';
for i = 1:1
    Dw{i} = [];
    Dp{i} = [];
    directory = char('images/');
    Files = dir(fullfile(directory));
    Files(1:2) = [];
    Files(329) = [];
    Files(540) = [];
    num_imgs(i) = length(Files);
    fprintf(1, 'Now reading %s\n', directory);
    for j = 1:num_imgs(i)
        baseFileName = Files(j).name;
        fullFileName = fullfile(directory, baseFileName);
        image{i}{j} = imread(fullFileName);
        image{i}{j} = image{i}{j}(:,:,1);
%         imwrite(image,['covid_image',num2str(i),'_',num2str(j),'.png'])
        mysize = size(image{i}{j});
%         if numel(mysize) < 3; mysize(1,3) = 0; end
%         maxsize = max(maxsize,mysize);
%         avgsize = avgsize + mysize;
        image_resized{i}{j} = imresize(image{i}{j}(:,:,:),[mysize(1)/mysize(2)*80 80]);
        myrsize = size(image_resized{i}{j});
        maxsize = max(maxsize,myrsize);
        if myrsize(1) > 120
            image_resized{i}{j}(121:end,:) = [];
        elseif myrsize(1) < 120
            image_resized{i}{j}(120,end) = 0;
        end
%       imshow(image_resized{i}{j});  drawnow;
%       img_flat = reshape(image_resized,[],numel(image_resized));
%       pixelsize(i) = max(pixelsize(i),length(img_flat));
%       images{i}{j} = img_flat;
%         Y(m,:) = [i,j,k];
        [C,S] = wavedec2(image_resized{i}{j}(:,:,1),wnum,wname);
        Dw{i}(j,:) = C(:);
        x = image_resized{i}{j}(:,:,1);
        Dp{i}(j,:) = double(x(:));
    end
%     Dw{i} = single(Dw{i});
    toc
end

avgsize/sum(num_imgs)
maxsize
%%
figure, imagesc(Dp{1})
figure, imagesc(Dw{1})
%%
rank(Dw{1})
rank(Dp{1})
%%
[~,~,p_qr] = qr(Dw{1},'vector');
X = Dw{1}(:,p_qr(1:800));
% X = Dw{1};
%%
p_lap = fsulaplacian(Dw{1});
%%
X = Dw{1};
X = Dw{1}(:,p_lap(1:5000));
%%
[U,S,V] = svd(Dw{1});
%%
Sc = cosineSimilarity(X);
figure, imagesc(Sc), axis equal tight
%%
myS = Sc;
myS = myS - diag(diag(myS));
m = mean(Sc);
[~,idx] = sort(m);
figure, imagesc(myS(idx,idx)), axis equal tight
%%
for i = 340:345
    figure, imshow(image{1}{i}), axis equal tight
end
%%
myS = pdist(X,'cosine');
% myS = pdist(X,@distfun);
myS = squareform(myS);
myS = exp(-myS.^2/std(myS(:)));
issymmetric(myS)
mean(myS(:))
figure, plot((real(eig(myS))))
%%
nc = 15;
% idx = spectralcluster(Sc,3,'Distance','precomputed');
idc = spectralcluster(myS,nc,'Distance','precomputed',...
    'LaplacianNormalization','randomwalk','ClusterMethod','kmedoids',...
    'KNNGraphType','complete');
idx = [];
for i = 1:nc
    idx = [idx;find(idc==i)];
end
figure, imagesc(myS), axis equal tight, colorbar
ax = gca;
exportgraphics(ax,['similarity_bare.jpg'])
figure, imagesc(myS(idx,idx)), axis equal tight, colorbar
ax = gca;
exportgraphics(ax,['similarity',num2str(nc),'c.jpg'])
%%
e = flip(sort(real(eig(myS))));
figure, plot((e(1:40)),'LineWidth',2), pbaspect([3 1 1])
grid on, grid minor, ylabel('eigen values'), xlabel('eigen numbers')
% ylim([1 7])
ax = gca;
exportgraphics(ax,['eigs.jpg'])
%%
idx = find(idc==2);
for i = 1:12
    figure, imshow(image{1}{idx(i)}), axis equal tight
end

%%
function D2 = distfun(ZI,ZJ)
m = size(ZJ,1);
D2 = zeros(m,1);
for i = 1:m
    D2(i,1) = xcorr(ZI,ZJ(i,:),0,'coeff');
end

end