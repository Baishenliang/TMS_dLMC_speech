function [htest,P,rank] = bsliang_permutationtest(Morgi,Mi,alpha,tail)
% do permutation test
Mi_Morgi=[Mi,Morgi];
nBOOT=length(Mi);
if isequal(tail,'both')
    if Morgi<mean(Mi,'omitnan')
        Mi_Morgi=sort(Mi_Morgi);
        rank=find(Mi_Morgi==Morgi,1);
        P=(rank+1)/(nBOOT+1);
    elseif Morgi>mean(Mi,'omitnan')
        Mi_Morgi=sort(Mi_Morgi,'descend');
        rank=find(Mi_Morgi==Morgi,1);
        P=(rank+1)/(nBOOT+1);
    end
    P=P*2;
elseif isequal(tail,'left')
    Mi_Morgi=sort(Mi_Morgi);
    rank=find(Mi_Morgi==Morgi,1);
    P=(rank+1)/(nBOOT+1);
elseif isequal(tail,'right')
    Mi_Morgi=sort(Mi_Morgi,'descend');
    rank=find(Mi_Morgi==Morgi,1);
    P=(rank+1)/(nBOOT+1);
end
if P < alpha; htest=1;else htest=0; end