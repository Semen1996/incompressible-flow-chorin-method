function [u, v] = correctVelocity(uStar, vStar, p, geom, prm, dt)
% CORRECTVELOCITY Корректор схемы Чорина: u = uStar - dt/rho * grad(p)
%
% [u, v] = correctVelocity(uStar, vStar, p, geom, prm, dt)
%
% p - давление в центрах ячеек, размер (ny, nx)
% Градиент берется между соседними ячейками, т.е. ровно на гранях u и v.

    u = uStar;
    v = vStar;

    u(geom.jU, geom.iU) = uStar(geom.jU, geom.iU) - dt / prm.rho * diff(p, 1, 2) / geom.dx;
    v(geom.jV, geom.iV) = vStar(geom.jV, geom.iV) - dt / prm.rho * diff(p, 1, 1) / geom.dy;

    [u, v] = applyVelocityBC(u, v, prm.uLid);
end
