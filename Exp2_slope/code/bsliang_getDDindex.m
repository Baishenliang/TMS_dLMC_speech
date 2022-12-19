function outmat=bsliang_getDDindex(inmat)
% 计算双分离指数，计算的方式为：分别对于清晰和噪声条件：
% DD=(TONE_TONGUE_ΔrTMS-TONE_LARYNX_ΔrTMS)+(PHONEME_LARYNX_ΔrTMS-PHONEME_TONGUE_ΔrTMS)
% (TT-LT)+(LP-TP)，值越大双分离越明显

% inmat - block(TC PC TN PN)*turn(L T)*subj(197)
% outmat - block(C N)*subj(197)
outmat=nan(2,size(inmat,3));
for i=1:2
    outmat(i,:)=(inmat(2*i-1,2,:)-inmat(2*i-1,1,:))+(inmat(2*i,1,:)-inmat(2*i,2,:));
end

