function TDATA=bsliang_Trandata(DATA)
    % 读取和转换数据到处理数据的格式
    % ================================
    % DATA structure:
    
    %  turn：
    %   stimSITE   NUMBER
    %   Left iTBS    1
    %   Left cTBS    2
    %   Right iTBS   3
    %   Right cTBS   4
    %   Sham         5 
    
    % block：
    %   BLOCK	NAME        NUMBER
    %   A       T_CLEAR_ID      1
    %   B       P_CLEAR_ID      2
    %   C       T_NOISE_ID      3
    %   D       P_NOISE_ID      4
    
    % ===============================
    % 数据缺省情况
    % （1）不存在该被试，DATA(subj).Id_Di为空；
    % （2）存在该被试，但是完全没做正式实验，DATA(subj).Id_Di不为空，但DATA(subj).Id_Di不存在data字段
    % （3）存在该被试，但是没做第五个turn(Sham)，存在DATA(subj).Id_Di.data，但data(:,:,5)不存在
    % （4）存在该被试，但是没做第四五个turn(Sham)，存在DATA(subj).Id_Di.data，但data(:,:,4)、data(:,:,5)不存在
    % （5）存在该被试，但是没做第三四五个turn(Sham)，存在DATA(subj).Id_Di.data，但data(:,:,3)、data(:,:,4)、data(:,:,5)不存在
    % （6）存在该被试，但是没做第二三四五个turn(Sham)，存在DATA(subj).Id_Di.data，但data(:,:,3)、但data(:,:,3)、data(:,:,4)、data(:,:,5)不存在
    % （7）以上都不符合，但是某个block没做完或者没做（数据只有做完了才会存下来），DATA(subj).Id_Di.data(1,block,turn)中的每一项均为空（处理方式跟处理不空数据是一样的）
    % 无论是哪一种缺省，最终TDATA体现出来的都是block里面出现下面EMPTY这样的格式
    EMPTY.rawdata=[];
    EMPTY.half_threshold=[];
    EMPTY.threshold_boundaries=[];
    
    TDATA=cell(4,5,size(DATA,2));
    % TDATA dims: block, turn, subj
    for subj=1:size(DATA,2) 
        for turn=1:size(TDATA,2) %  Left iTBS Left cTBS Right iTBS Right cTBS Sham
            for block=1:size(TDATA,1) % IDTC IDPC IDTN IDPN
                if isempty(DATA(subj).Id_Di)
                    % 缺省情况1
                    TDATA{block,turn,subj}=EMPTY;
                elseif ~isfield(DATA(subj).Id_Di,'data')
                    % 缺省情况2
                    TDATA{block,turn,subj}=EMPTY;
                elseif size(DATA(subj).Id_Di.data,3)==4 && turn>4
                    % 缺省情况3
                    TDATA{block,turn,subj}=EMPTY;
                elseif size(DATA(subj).Id_Di.data,3)==3 && turn>3
                    % 缺省情况4
                    TDATA{block,turn,subj}=EMPTY;
                elseif size(DATA(subj).Id_Di.data,3)==2 && turn>2
                    % 缺省情况5
                    TDATA{block,turn,subj}=EMPTY;   
                elseif size(DATA(subj).Id_Di.data,3)==1 && turn>1
                    % 缺省情况6
                    TDATA{block,turn,subj}=EMPTY;
                else
                    % 缺省情况7或非缺省情况
                    TDATA{block,turn,subj}=DATA(subj).Id_Di.data(1,block,turn);
                    disp(subj)
                end
            end
        end
    end
end
