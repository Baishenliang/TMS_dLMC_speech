function HistEffect=bsliang_historyeffect(resp_var)
% �����Դ��Zhong et al., 2019. Nat. Neurosci., fig. 6c��
% ����һ��trial�ķ����ж���ǰһ��trial��Ӱ��ĳ̶�
resp_pre=resp_var(1:end-1);
resp_post=resp_var(2:end);
sameind=resp_pre==resp_post;
diffind=resp_pre~=resp_post;
HistEffect=(sum(sameind)-sum(diffind))/length(resp_var);