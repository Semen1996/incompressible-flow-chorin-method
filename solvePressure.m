function p = solvePressure(pSolver, uStar, vStar, geom, prm, dt)
% SOLVEPRESSURE Давление из уравнения Пуассона lap(p) = rho/dt * div(uStar)
%
% p = solvePressure(pSolver, uStar, vStar, geom, prm, dt)
%
% pSolver - разложение из buildPressureSolver
% p       - давление в центрах ячеек, размер (ny, nx), среднее равно нулю

    % Дивергенция промежуточной скорости в центрах ячеек
    divStar = diff(uStar(geom.jU, :), 1, 2) / geom.dx ...
            + diff(vStar(:, geom.iV), 1, 1) / geom.dy;

    rhs = prm.rho / dt * divStar(:);
    rhs(1) = 0;  % фиксация уровня давления, см. buildPressureSolver

    p = pSolver.Q * (pSolver.U \ (pSolver.L \ (pSolver.P * rhs)));
    p = reshape(p, geom.ny, geom.nx);
    p = p - mean(p, 'all');
end
