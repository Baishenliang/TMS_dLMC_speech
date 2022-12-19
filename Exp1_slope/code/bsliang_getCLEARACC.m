function score=bsliang_getCLEARACC(m,isdim2)

    if isdim2==1
        % 这是第二个维度也清晰的算法（就没有第二维度的干扰，但是trial数很少）
        dim1=logical(double(m(:,1)==1)+double(m(:,1)==5));
        dim2=logical(double(m(:,4)==1)+double(m(:,4)==5));
        dim=logical(dim1.*dim2);
    elseif isdim2==2
    % 这是只关注第一维度清晰的算法（就trial数较多，有第二维度的干扰）
        dim=logical(double(m(:,1)==1)+double(m(:,1)==5));
    end
    
    k=m(dim,:);
    score=0;
    for row=1:size(k,1)
        if k(row,1)==5 && k(row,2)==0
            score=score+1;
        elseif k(row,1)==1 && k(row,2)==1
            score=score+1;
        end
    end
    score=score/size(k,1);
end