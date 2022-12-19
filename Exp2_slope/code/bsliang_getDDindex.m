function outmat=bsliang_getDDindex(inmat)
% ����˫����ָ��������ķ�ʽΪ���ֱ��������������������
% DD=(TONE_TONGUE_��rTMS-TONE_LARYNX_��rTMS)+(PHONEME_LARYNX_��rTMS-PHONEME_TONGUE_��rTMS)
% (TT-LT)+(LP-TP)��ֵԽ��˫����Խ����

% inmat - block(TC PC TN PN)*turn(L T)*subj(197)
% outmat - block(C N)*subj(197)
outmat=nan(2,size(inmat,3));
for i=1:2
    outmat(i,:)=(inmat(2*i-1,2,:)-inmat(2*i-1,1,:))+(inmat(2*i,1,:)-inmat(2*i,2,:));
end

