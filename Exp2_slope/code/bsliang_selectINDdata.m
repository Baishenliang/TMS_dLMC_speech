function DDATA=bsliang_selectINDdata(DATA,rej_ind,mode)
% �������ɾ����
    if isequal(mode,'rej')
        for ind=rej_ind
            DATA(ind).par_info=[];
            DATA(ind).def_range=[];
            DATA(ind).practice=[];
            DATA(ind).Id_Di=[];
        end
    elseif isequal(mode,'select')
        for ind=1:size(DATA,2)
            if isempty(find(rej_ind==ind,1))
                DATA(ind).par_info=[];
                DATA(ind).def_range=[];
                DATA(ind).practice=[];
                DATA(ind).Id_Di=[];
            end
        end
    end
    DDATA=DATA;
end
