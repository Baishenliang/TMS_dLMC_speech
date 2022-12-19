% 从数据里获取steps：
% load DATA
% steps=sort(DATA(5).Id_Di.data(1,1,1).rawdata(:,1))';
steps=[1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5];
ls=length(steps);
sim_n=10000;
curves=nan(5,sim_n);
slopes=nan(1,sim_n);
parfor subj=1:sim_n
    disp(subj);
    raw_subj=nan(1,ls);
    curve_subj=nan(1,5);
    for trial=1:ls
        % 随机数生成：
        % https://www.mathworks.com/help/stats/random-number-generation.html
        % 二项分布：
        % https://www.mathworks.com/help/stats/binornd.html
        raw_subj(trial)=binornd(1,0.5);
    end
    paras = lsqcurvefit(@(paras,X) 0+1./(1+exp(-1*paras(1)*(X-paras(2)))),[0 3],steps,raw_subj);
    for step=1:5
        curve_subj(step)=mean(raw_subj(steps==step));
    end
    curves(:,subj)=curve_subj;
    slopes(subj)=paras(1);
end

slopes(slopes<=0)=nan;
rtms=log(slopes);
sham=log(slopes(randperm(length(slopes))));
NORM_tms=(rtms-sham)./abs(sham);