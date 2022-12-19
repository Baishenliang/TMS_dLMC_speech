function bsling_plotrawdata(X_clear_sham,clear_sham_raw_mean,clear_sham_raw_se,Y_clear_sham,COL)
figure; 
plot(X_clear_sham,Y_clear_sham,'Color',COL,'LineWidth',2);
hold on
% errorbar(1:5,clear_sham_raw_mean,clear_sham_raw_se,'o','Color',COL,'MarkerFaceColor',COL,'LineWidth',1.5);
xlim([1 5])
set(gca,'XTick',1:5,'XTickLabels',{'1','2','3','4','5'},'FontName','Arial');
set(gca,'YTick',[0 0.2 0.5 0.8 1],'YTickLabels',{'0%','20%','50%','80%','100%'},'FontName','Arial');
grid on
set(gca,'GridLineStyle','--','GridColor','k')
set(gca,'LineWidth',0.8)
set(gcf,'unit','centimeter')
set(gcf,'Position',[0 0 7 5])