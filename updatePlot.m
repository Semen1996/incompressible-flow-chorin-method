function updatePlot(hPlot, u, v, t)
% UPDATEPLOT Обновление heatmap модуля скорости
%
% updatePlot(hPlot, u, v, t)
%
% hPlot - дескрипторы из initPlot
% u     - скорость по x на вертикальных гранях, размер (ny+2, nx+1)
% v     - скорость по y на горизонтальных гранях, размер (ny+1, nx+2)
% t     - текущее время, [с]

    % Интерполяция скоростей с граней в центры ячеек
    uCenter = (u(2:end-1, 1:end-1) + u(2:end-1, 2:end)) / 2;
    vCenter = (v(1:end-1, 2:end-1) + v(2:end, 2:end-1)) / 2;

    set(hPlot.image, 'CData', sqrt(uCenter.^2 + vCenter.^2));
    set(hPlot.title, 'String', sprintf('Модуль скорости, t = %g с', t));
    drawnow;
end
