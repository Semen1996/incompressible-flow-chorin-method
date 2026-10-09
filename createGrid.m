function geom = createGrid(prm, num)
% CREATEGRID Разнесенная (MAC) сетка с одним слоем фиктивных ячеек
%
% geom = createGrid(prm, num)
%
% prm - физические параметры (L, H)
% num - численные параметры (nx, ny)
%
% Индекс строки j - ось y (строка 1 - низ), индекс столбца i - ось x.
% u (ny+2, nx+1) - вертикальные грани: столбцы 1 и end лежат на стенках,
%                  строки 1 и end - фиктивные (дно и крышка)
% v (ny+1, nx+2) - горизонтальные грани: строки 1 и end лежат на стенках,
%                  столбцы 1 и end - фиктивные (левая и правая стенки)
% p (ny, nx)     - центры ячеек, без фиктивных ячеек

    geom.nx = num.nx;
    geom.ny = num.ny;

    geom.dx = prm.L / num.nx;
    geom.dy = prm.H / num.ny;

    % Неизвестные u
    geom.iU = 2 : num.nx;
    geom.jU = 2 : num.ny + 1;

    % Неизвестные v
    geom.iV = 2 : num.nx + 1;
    geom.jV = 2 : num.ny;

    % Центры ячеек
    geom.x = ((1 : num.nx) - 0.5) * geom.dx;
    geom.y = ((1 : num.ny) - 0.5) * geom.dy;
end
