function bsliang_piledbar(values)
bsliang_bar(0.3125-1,values(1),0.1875,0.5,'k');
hold on
bsliang_bar(0.6875-1,values(2),0.1875,0.5,'k');
bsliang_bar(1.3125-1,values(3),0.1875,0.5,'k');
bsliang_bar(1.6875-1,values(4),0.1875,0.5,'k');
plot([-1 1],[0 0],'k--');

