function bsliang_rawplot_conds(IDraw_G,LR_ind)
% LR_ind: 被试左右脑
% 根据条件画出raw曲线的图（均值和标准误），直观进行比较，同时也是为了验证模型拟合的结果
% IDraw_G
% step(5)*block(4)*turn(3)*subjs

% DATA structure:
% turn: L T S
% block: 
%   Id_Di	BLOCK	NAME        NUMBER
%   Id      A       T_CLEAR_ID      1
%   Id      B       P_CLEAR_ID      2
%   Id      C       T_NOISE_ID      3
%   Id      D       P_NOISE_ID      4
    

% 注意figure的subplot是横着来的

% LEFT CLEAR TONE
FigPAR(1).blocks=1;
FigPAR(1).turns=[1 2 3];
% LEFT CLEAR PHON
FigPAR(2).blocks=2;
FigPAR(2).turns=[1 2 3];
% RIGHT CLEAR TONE
FigPAR(3).blocks=1;
FigPAR(3).turns=[1 2 3];
% RIGHT CLEAR PHON
FigPAR(4).blocks=2;
FigPAR(4).turns=[1 2 3];
% LEFT CLEAR TONE
FigPAR(5).blocks=3;
FigPAR(5).turns=[1 2 3];
% LEFT CLEAR PHON
FigPAR(6).blocks=4;
FigPAR(6).turns=[1 2 3];
% RIGHT CLEAR TONE
FigPAR(7).blocks=3;
FigPAR(7).turns=[1 2 3];
% RIGHT CLEAR PHON
FigPAR(8).blocks=4;
FigPAR(8).turns=[1 2 3];

FigTIT={'LEFT CLEAR TONE','LEFT CLEAR PHON','RIGHT CLEAR TONE','RIGHT CLEAR PHON','LEFT NOISE TONE','LEFT NOISE PHON','RIGHT NOISE TONE','RIGHT NOISE PHON'};
LRs=[1 1 2 2 1 1 2 2]; % 区分左右脑，左=1，右=2

figure;
for p=1:8
    subplot(2,4,p)
    sub_IDraw_G=IDraw_G(:,FigPAR(p).blocks,FigPAR(p).turns,:);
    Larynx=squeeze(sub_IDraw_G(:,:,1,LR_ind==LRs(p)));
    Tongue=squeeze(sub_IDraw_G(:,:,2,LR_ind==LRs(p)));
    Sham=squeeze(sub_IDraw_G(:,:,3,LR_ind==LRs(p)));
    LarynxM=mean(Larynx,2,'omitnan');
    TongueM=mean(Tongue,2,'omitnan');
    ShamM=mean(Sham,2,'omitnan');
    LarynxE=std(Larynx,0,2,'omitnan')./sqrt(bsliang_nonemptycol(Larynx));
    TongueE=std(Tongue,0,2,'omitnan')./sqrt(bsliang_nonemptycol(Tongue));
    ShamE=std(Sham,0,2,'omitnan')./sqrt(bsliang_nonemptycol(Sham));
    errorbar(repmat(1:size(sub_IDraw_G,1),3,1)',[LarynxM,TongueM,ShamM],[LarynxE,TongueE,ShamE]);
    legend({'Larynx','Tongue','Sham'})
    title(FigTIT{p});
    box off
end