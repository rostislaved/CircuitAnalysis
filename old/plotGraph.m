clear
fullScr = struct('units','normalized','outerposition',[0 0.017 1 0.983]);
% close all
clf
clc

r = 50;
c = 100;

x = [];
y = [];

for i = r:-1:1
    for j = 1:c
        x = [x j];
        y = [y i];        
    end
end
h = figure('Visible','off');
plot(x,y,'.','MarkerSize',16)
border = 2;
xlim([min(x)-border  max(x)+border ])
ylim([min(y)-border  max(y)+border ])
cropImg

tx = string(1:r*c);
c1 = -1;
for i = 1:r*c
    text(x(i)-0.15, y(i) + (c1)^i*0.2, tx(i),'FontSize',4)
end
set(h, 'PaperPosition', [0 0 80 40])    % can be bigger than screen 
print(h, 'MyFigure.png', '-dpng', '-r300' );   %save file as PNG w/ 300dpi
close all
!MyFigure.png