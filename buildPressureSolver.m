function pSolver = buildPressureSolver(geom)
% BUILDPRESSURESOLVER LU-разложение дискретного лапласиана давления
%
% pSolver = buildPressureSolver(geom)
%
% Матрица собирается один раз для p(:) размера ny*nx (столбцы p подряд).
% Граничное условие dp/dn = 0 на всех стенках учтено в матрице.
% Задача Неймана вырождена (p определено с точностью до константы),
% поэтому первое уравнение заменено на p(1) = 0.

    Dxx = neumannSecondDiff(geom.nx) / geom.dx^2;
    Dyy = neumannSecondDiff(geom.ny) / geom.dy^2;

    A = kron(Dxx, speye(geom.ny)) + kron(speye(geom.nx), Dyy);

    % Фиксация уровня давления
    A(1, :) = 0;
    A(1, 1) = 1;

    [pSolver.L, pSolver.U, pSolver.P, pSolver.Q] = lu(A);
end


function D = neumannSecondDiff(n)
% NEUMANNSECONDDIFF Одномерная вторая разность с условием df/dn = 0 на концах

    e = ones(n, 1);
    D = spdiags([e, -2 * e, e], -1:1, n, n);
    D(1, 1) = -1;
    D(n, n) = -1;
end
