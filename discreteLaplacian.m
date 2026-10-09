function lapF = discreteLaplacian(f, j, i, dx, dy)
% DISCRETELAPLACIAN Пятиточечный лапласиан поля f в узлах (j, i)
%
% lapF = discreteLaplacian(f, j, i, dx, dy)
%
% j, i - векторы индексов строк (y) и столбцов (x); соседние узлы должны существовать

    lapF = (f(j, i+1) - 2 * f(j, i) + f(j, i-1)) / dx^2 ...
         + (f(j+1, i) - 2 * f(j, i) + f(j-1, i)) / dy^2;
end
