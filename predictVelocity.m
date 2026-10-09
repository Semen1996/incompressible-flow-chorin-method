function [uStar, vStar] = predictVelocity(u, v, geom, prm, dt, gammaDC)
% PREDICTVELOCITY Предиктор схемы Чорина: скорость без учета давления
%
% [uStar, vStar] = predictVelocity(u, v, geom, prm, dt, gammaDC)
%
% uStar = u + dt * (nu * lap(u) - d(u^2)/dx - d(uv)/dy)
% vStar = v + dt * (nu * lap(v) - d(uv)/dx - d(v^2)/dy)
% Конвекция в консервативной форме, смесь центральной и donor-cell схем.
% На стенках uStar, vStar равны скорости стенки.

    iU = geom.iU;  jU = geom.jU;
    iV = geom.iV;  jV = geom.jV;
    dx = geom.dx;  dy = geom.dy;

    uStar = u;
    vStar = v;

    %% uStar
    % Переносящие скорости на гранях контрольного объема u
    uE = (u(jU, iU)     + u(jU, iU+1))   / 2;
    uW = (u(jU, iU-1)   + u(jU, iU))     / 2;
    vN = (v(jU, iU)     + v(jU, iU+1))   / 2;
    vS = (v(jU-1, iU)   + v(jU-1, iU+1)) / 2;

    du2dx = ( donorCellFlux(uE, u(jU, iU),   u(jU, iU+1), gammaDC) ...
            - donorCellFlux(uW, u(jU, iU-1), u(jU, iU),   gammaDC) ) / dx;
    duvdy = ( donorCellFlux(vN, u(jU, iU),   u(jU+1, iU), gammaDC) ...
            - donorCellFlux(vS, u(jU-1, iU), u(jU, iU),   gammaDC) ) / dy;

    lapU = discreteLaplacian(u, jU, iU, dx, dy);

    uStar(jU, iU) = u(jU, iU) + dt * (prm.nu * lapU - du2dx - duvdy);

    %% vStar
    % Переносящие скорости на гранях контрольного объема v
    uE = (u(jV, iV)     + u(jV+1, iV))   / 2;
    uW = (u(jV, iV-1)   + u(jV+1, iV-1)) / 2;
    vN = (v(jV, iV)     + v(jV+1, iV))   / 2;
    vS = (v(jV-1, iV)   + v(jV, iV))     / 2;

    duvdx = ( donorCellFlux(uE, v(jV, iV),   v(jV, iV+1), gammaDC) ...
            - donorCellFlux(uW, v(jV, iV-1), v(jV, iV),   gammaDC) ) / dx;
    dv2dy = ( donorCellFlux(vN, v(jV, iV),   v(jV+1, iV), gammaDC) ...
            - donorCellFlux(vS, v(jV-1, iV), v(jV, iV),   gammaDC) ) / dy;

    lapV = discreteLaplacian(v, jV, iV, dx, dy);

    vStar(jV, iV) = v(jV, iV) + dt * (prm.nu * lapV - duvdx - dv2dy);
end
