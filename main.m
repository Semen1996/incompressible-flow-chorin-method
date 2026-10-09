%% Течение в каверне с движущейся крышкой: схема Чорина на разнесенной (MAC) сетке
% Дискретизация по Грибелю (Griebel, Dornseifer, Neunhoeffer,
% "Numerical Simulation in Fluid Dynamics").


%% Физические параметры
prm.rho  = 880;     % плотность, [кг/м^3]
prm.nu   = 1.2e-3;  % кинематическая вязкость, [м^2/с]
prm.L    = 0.2;     % длина, [м]
prm.H    = 0.2;     % высота, [м]
prm.uLid = 6;       % скорость верхней крышки, [м/с]
prm.tEnd = 1;       % конец расчета, [с]

%% Численные параметры
num.nx        = 100;  % число ячеек по x
num.ny        = 100;  % число ячеек по y
num.cfl       = 0.9;  % коэффициент запаса по шагу времени
num.plotEvery = 200;   % отрисовка каждые plotEvery шагов


%% Сетка, начальные условия, решатель давления
geom = createGrid(prm, num);

% u (ny+2, nx+1), v (ny+1, nx+2) - скорости на гранях с фиктивными слоями,
% p (ny, nx) - давление в центрах ячеек
u = zeros(geom.ny + 2, geom.nx + 1);
v = zeros(geom.ny + 1, geom.nx + 2);
p = zeros(geom.ny, geom.nx);
[u, v] = applyVelocityBC(u, v, prm.uLid);

pSolver = buildPressureSolver(geom);

hPlot = initPlot(geom, prm);
updatePlot(hPlot, u, v, 0);


%% Расчет
t = 0;      % текущее время, [с]
iStep = 0;  % номер шага

while t < prm.tEnd
    [dt, gammaDC] = computeTimeStep(u, v, geom, prm, num.cfl);
    dt = min(dt, prm.tEnd - t);

    % 1 этап. Предиктор: скорость без учета давления
    [uStar, vStar] = predictVelocity(u, v, geom, prm, dt, gammaDC);

    % 2 этап. Давление из уравнения Пуассона lap(p) = rho/dt * div(uStar)
    p = solvePressure(pSolver, uStar, vStar, geom, prm, dt);

    % 3 этап. Корректор: u = uStar - dt/rho * grad(p)
    [u, v] = correctVelocity(uStar, vStar, p, geom, prm, dt);

    t = t + dt;
    iStep = iStep + 1;

    if mod(iStep, num.plotEvery) == 0
        updatePlot(hPlot, u, v, t);
    end
end

% Финальный кадр
updatePlot(hPlot, u, v, t);
