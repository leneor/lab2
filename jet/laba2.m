calib = load('2-experimentData/calib.dat');
calib_0 = load('2-experimentData/calibzero.dat');

y_cal = ones(size(calib(:, 2)))*68
y_cal_0 = zeros(size(calib(:, 2)))
y = [y_cal_0; y_cal];

cal = [calib_0(:, 2) calib(:, 2)];

c = polyfit(cal, y, 1);

cfigure = figure('Name','Калибровка', 'NumberTitle','off');
hold all;
grid on;

for i = 1:size(calib(:, 2))
    plot(calib(i, 2), y_cal,'r.', 'MarkerSize', 20);
end

for i = 1:size(calib(:, 2))
    plot(calib_0(i, 2), y_cal_0,'b.', 'MarkerSize', 20);
end
axis([400 1100 -10 70]);

plot(y, polyval(c, y));
x1 = [450:1:1100];
y1 = c(1)*x1+c(2);
plot(x1, y1);
grid on;
xlabel("Отсчеты АЦП");
ylabel("\DeltaP, Па");
title("Калибровка ");

mm01 = load('2-experimentData/01mm.dat');
mm11 = load('2-experimentData/11mm.dat');
mm21 = load('2-experimentData/21mm.dat');
mm31 = load('2-experimentData/31mm.dat');
mm41 = load('2-experimentData/41mm.dat');
mm51 = load('2-experimentData/51mm.dat');
mm61 = load('2-experimentData/61mm.dat');
mm71 = load('2-experimentData/71mm.dat');


dx = 0.25; %mm
x = mm01(:, 1)' * 0.25;

p01 =  polyval(c, mm01(:, 2));
p11 =  polyval(c, mm11(:, 2));
p21 =  polyval(c, mm21(:, 2));
p31 =  polyval(c, mm31(:, 2));
p41 =  polyval(c, mm41(:, 2));
p51 =  polyval(c, mm51(:, 2));
p61 =  polyval(c, mm61(:, 2));
p71 =  polyval(c, mm71(:, 2));

pressure = [p01, p11, p21, p31, p41, p51, p61, p71];
zNames = {'1 mm'; '11 mm'; '21 mm'; '31 mm'; '41 mm'; '51 mm'; '61 mm'; '71 mm'};
z = [1, 11, 21, 31, 41, 51, 61, 71];

f2 = figure();
hold on;
grid on;
title({'Сечения затопленной струи', 'на разном расстоянии от сопла'});
ylabel('DeltaP, Па');
xlabel('Расстояние вдоль струи, mm');

for i = 1:size(pressure, 2)
    plot(x, pressure(:, i), 'DisplayName', zNames{i});
end

legend('Location', 'NorthWest');

saveas(f2, 'pressure.png');

f3 = figure();
hold on;
grid on;
title({'Центрированые сечения затопленной струи', 'на разном расстоянии от сопла'});
ylabel('\DeltaP, Па');
xlabel({'Расстояние вдоль сечения струи', 'относительно её центра, mm'});

xCentered = zeros(size(pressure));
offset = 50;

for i = 1:size(pressure, 2)
    right = x(find(pressure(:, i) > offset, 1, 'last'));
    left = x(find(pressure(:, i) > offset, 1));
    
    center = left + (right - left)/2;
    xCentered(:, i) = x - center;
    
    plot(xCentered(:, i), pressure(:, i), 'DisplayName', zNames{i});
end

legend('Location', 'Northwest');

saveas(f3, 'centered.png');

speed = sqrt(abs(2*pressure));

f4 = figure();
surf(z, xCentered, speed);
title({'Центрированые сечения затопленной струи', 'на разном расстоянии от сопла'});
zlabel('Скорость потока, m/s');
ylabel('x, mm');
xlabel('z, mm');
colorbar;

saveas(f4, "surf.png");




q = zeros(8, 1);
for i = 1:8
    q(i,1) = 2*pi*1.1*0.00025 * (abs(xCentered(:, i)))' * speed(:, i);
end

q = 0.5 * q;

f5 = figure();
hold on;

plot(z, q, '-', 'LineWidth', 2.5);

grid on;
title({'Расход затопленной струи'});
xlabel('z,mm');
ylabel('Q, m^3 /s');

saveas(f5, "flow.png");




