function ORDERnum=bsliang_gainORDERnum(PARnum)
% 原本安排的是48个被试，因此被试实验顺序的平衡也是按着这个来的。
%但是事实上被试可能或多或少，因此真正实验的时候每个被试都有一个自己的被试编号
%（跟第一次实验一样），同时有一个ORDER编号用来确定被试做实验的block顺序。ORDER编号是可以重复的。

% tranMAT=[1:47;2:48]';
 tranMAT=[1,1;... % 这是BSLiang本人，不纳入平衡序列和数据
          116,3;...
          103,4;...
          98,9;...
          85,10;...
          101,15;...
          108,16;...
          33,21;...
          % 以上，2020年10月26日做第一次
%           102,1;... % 因为结构像有问题，废了
          156,2;...
          115,5;...
          66,6;...
          % 以上，2020年10月27日做第一次
%           61,25;... %右脑 因为机器原因，废了
%           125,7;... % 因为拷贝数据原因，废了
          56,26;... %右脑
          44,8;...
          9,27;... %右脑
          141,28;... %右脑
          % 以上，2020年10月28日做第一次
          136,11;...
          14,12;...
          % 以上，2020年10月29日做第一次
%           17, 29;...%右脑 因为机器炸了，还没做
%           50, 30;...%右脑 因为机器炸了，还没做
          121, 31;...%右脑
          3, 13;...
          % 以上，2020年10月30日做第一次
          93,32;... %右脑
          96,33;... %右脑
          107,34;... %右脑
          132,35;... %右脑
          129,14;...
          % 以上，2020年10月31日
          75,36;... %右脑
          133,37;... %右脑
          112,38;... %右脑
          5,39;... %右脑
          23,40;... %右脑
          153,41;... %右脑
          %95,17;...
          %61,42
          % 以上，2020年11月1日 （注释掉的是没做）
          61,25;...%右脑;
          110,17;...
          % 以上，2020年11月2日做第一次
          102,1;...
          140,18;...
          114,19;...
          % 以上，2020年11月3日做第一次
          17, 29;...%右脑
          50, 30;...%右脑
          125, 7;...
          58,20;...
          119,22;...
          % 以上，2020年11月4日做第一次
          160,42;... %右脑
          149,43;... %右脑
          162,23;
          % 以上，2020年11月5日第一次
          159,24;...
          45,46;...
          138,44;... %右脑
          88,45;...%右脑
          % 以上，2020年11月6日第一次
%           90,47;... %右脑
          151,48;... %右脑
          150, 47;... %右脑
          124, 25;... %右脑
          % 以上，2020年11月7日第一次
          105, 26;...%右脑
          % 以上，2020年11月8日第一次
          158, 1;... 
          144, 27;...%右脑
          161,2;...
          122,28;...%右脑
          % 以下2021年1月13日开始的新实验
          174,3;... % 年后做完，左脑
          172,4;... % 年前做完，左脑 **
          165,5;... % 年前做完，左脑 **
          187,6;... % 年后做完，左脑
          188,7;... % 年前做完，左脑 **
          185,29;...% 年前做完，右脑
          186,30;...% 年前做完，右脑
          192,31;...% 年前做完，右脑
          189,8;... % 年前做完，左脑 **
          190,9;... % 年前做完，左脑 **
          194,10;...% 年前做完，左脑 **
          196,11;...% 年前做完，左脑 **
          197,12;...% 年前做完，左脑 **
          193,32]; % 年前做完，右脑
      
%第一列为被试自己的编号，第二列为被试的ORDER编号。

ORDERnum=tranMAT(tranMAT(:,1)==PARnum,2);