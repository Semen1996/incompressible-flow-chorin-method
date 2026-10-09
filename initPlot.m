function hPlot = initPlot(geom, prm)
% INITPLOT Окно с heatmap модуля скорости
%
% hPlot = initPlot(geom, prm)
%
% hPlot - дескрипторы изображения и заголовка для updatePlot

    % Палитра: синий (|v| = 0) -> зеленый -> красный (|v| = uLid)
    cmap = interp1([0; 0.5; 1], [0 0 1; 0 1 0; 1 0 0], linspace(0, 1, 256)');

    figure;
    hPlot.image = imagesc(geom.x, geom.y, zeros(geom.ny, geom.nx));
    axis xy equal tight;
    colormap(cmap);
    caxis([0 prm.uLid]);  % фиксированная шкала, чтобы кадры были сопоставимы

    hColorbar = colorbar;
    ylabel(hColorbar, '|v|, [м/с]');
    xlabel('x, [м]');
    ylabel('y, [м]');

    hPlot.title = title('');
end
