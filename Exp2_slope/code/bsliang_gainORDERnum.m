function ORDERnum=bsliang_gainORDERnum(PARnum)

% tranMAT=[1:47;2:48]';
 tranMAT=[1,1;... % ����BSLiang���ˣ�������ƽ�����к�����; 
          142,2;...% Larynx Ů
          202,1;...% Larynx Ů
          201,3;...% Larynx Ů
          55,4;...% Larynx ��
          104,5;...% Larynx Ů
          206,6;...% Larynx Ů
          229,7;...% Larynx ��
          203,8;...% Larynx ��
          210,9;...% Larynx Ů
          216,10;...% Larynx Ů
          234,11;...% Larynx Ů
          212,12;...% Larynx Ů
          211,13;...% Larynx Ů
          123,14;...% Larynx ��
          217,15;...% Larynx Ů
          209,16;...% Larynx ��
          205,17;...% Larynx ��
          218,18;...% Larynx ��
          139,19;...% Larynx ��
          231,20;...% Larynx ��
          240,21;...% Larynx Ů
          225,22;...% Larynx ��
          226,23;...% Larynx Ů
          232,24;...% Larynx ��
          247,1;... % Larynx ��
          253,2] % Larynx Ů
      
%��һ��Ϊ�����Լ��ı�ţ��ڶ���Ϊ���Ե�ORDER��š�

ORDERnum=tranMAT(tranMAT(:,1)==PARnum,2);