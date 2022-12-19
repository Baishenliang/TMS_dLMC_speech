function ORDERnum=bsliang_gainORDERnum(PARnum)

% tranMAT=[1:47;2:48]';
 tranMAT=[1,1;... % 这是BSLiang本人，不纳入平衡序列和数据; 
          142,2;...% Larynx 女
          202,1;...% Larynx 女
          201,3;...% Larynx 女
          55,4;...% Larynx 男
          104,5;...% Larynx 女
          206,6;...% Larynx 女
          229,7;...% Larynx 男
          203,8;...% Larynx 男
          210,9;...% Larynx 女
          216,10;...% Larynx 女
          234,11;...% Larynx 女
          212,12;...% Larynx 女
          211,13;...% Larynx 女
          123,14;...% Larynx 男
          217,15;...% Larynx 女
          209,16;...% Larynx 男
          205,17;...% Larynx 男
          218,18;...% Larynx 男
          139,19;...% Larynx 男
          231,20;...% Larynx 男
          240,21;...% Larynx 女
          225,22;...% Larynx 男
          226,23;...% Larynx 女
          232,24;...% Larynx 男
          247,1;... % Larynx 男
          253,2] % Larynx 女
      
%第一列为被试自己的编号，第二列为被试的ORDER编号。

ORDERnum=tranMAT(tranMAT(:,1)==PARnum,2);