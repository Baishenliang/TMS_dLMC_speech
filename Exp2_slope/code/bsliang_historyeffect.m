function HistEffect=bsliang_historyeffect(resp_var)
% 灵感来源于Zhong et al., 2019. Nat. Neurosci., fig. 6c，
% 计算一个trial的范畴判断受前一个trial的影响的程度
resp_pre=resp_var(1:end-1);
resp_post=resp_var(2:end);
sameind=resp_pre==resp_post;
diffind=resp_pre~=resp_post;
HistEffect=(sum(sameind)-sum(diffind))/length(resp_var);