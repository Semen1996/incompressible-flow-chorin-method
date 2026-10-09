function [dt, gammaDC] = computeTimeStep(u, v, geom, prm, cfl)
% COMPUTETIMESTEP Шаг по времени и коэффициент противопоточной добавки
%
% [dt, gammaDC] = computeTimeStep(u, v, geom, prm, cfl)
%
% u, v    - скорости на гранях (с фиктивными слоями)
% geom    - сетка
% prm     - физические параметры (nu)
% cfl     - коэффициент запаса, < 1
%
% dt      - шаг по времени из условий диффузии и CFL
% gammaDC - вес схемы donor-cell, gammaDC >= max(|u| dt/dx, |v| dt/dy)

    % Фиктивные значения не участвуют в оценке
    uMax = max(abs(u(2:end-1, :)), [], 'all');
    vMax = max(abs(v(:, 2:end-1)), [], 'all');

    diffusionLimit  = 2 * prm.nu * (1 / geom.dx^2 + 1 / geom.dy^2);
    convectionLimit = uMax / geom.dx + vMax / geom.dy;
    dt = cfl / max(diffusionLimit, convectionLimit);

    gammaDC = min(1, max(uMax * dt / geom.dx, vMax * dt / geom.dy));
end
