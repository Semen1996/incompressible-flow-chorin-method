function f = donorCellFlux(a, phiL, phiR, gammaDC)
% DONORCELLFLUX Конвективный поток через грань: смесь центральной и donor-cell схем
%
% f = donorCellFlux(a, phiL, phiR, gammaDC)
%
% a       - переносящая скорость на грани
% phiL    - переносимая величина слева (снизу) от грани
% phiR    - переносимая величина справа (сверху) от грани
% gammaDC - вес donor-cell: 0 - центральная схема, 1 - противопоточная

    f = a .* (phiL + phiR) / 2 + gammaDC * abs(a) .* (phiL - phiR) / 2;
end
