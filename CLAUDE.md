# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

2D lid-driven cavity flow solved with Chorin's projection method (incompressible Navier–Stokes) on a staggered (MAC) grid, written in GNU Octave and kept MATLAB-compatible. Discretisation follows Griebel, Dornseifer, Neunhoeffer, *Numerical Simulation in Fluid Dynamics*. Code comments are in Russian; keep new comments in Russian to match.

## Running

Octave is installed at `/opt/homebrew/bin/octave` (MATLAB is not available). There is no build system, linter, or test suite.

```sh
octave --no-gui main.m          # run the full simulation (opens a figure)
```

`main.m` is a script, so `u`, `v`, `p` stay in the workspace when it is run from an interactive `octave` session. A heatmap of `|v|` is redrawn every `num.plotEvery` steps; nothing is saved to disk.

For a quick headless check, call the functions directly from a throwaway script (with `addpath` to the project dir) for a few dozen steps and run it with `octave --no-gui --no-window-system`; a correct projection gives `max|div u|` at round-off level (~1e-11).

## Structure

`main.m` only sets parameters and runs the loop; each Chorin stage is its own function file (file name must equal function name):

- `createGrid` — builds the `geom` struct (sizes, `dx`/`dy`, index ranges `iU, jU, iV, jV`, cell-centre coordinates).
- `computeTimeStep` — `dt` from diffusion + convective CFL limits, and the donor-cell weight `gammaDC = max(|u|dt/dx, |v|dt/dy)`.
- `predictVelocity` — explicit predictor `uStar, vStar` (diffusion + conservative convection); uses `donorCellFlux` and `discreteLaplacian`.
- `buildPressureSolver` / `solvePressure` — the Neumann pressure Laplacian is assembled once as a sparse matrix (`kron`), its level fixed by replacing row 1 with `p(1) = 0`, and LU-factorised; each step is then a direct solve (no iterations, no tolerance).
- `correctVelocity` — `u = uStar − (dt/ρ)·∇p`, then `applyVelocityBC`.
- `applyVelocityBC` — the single place where wall and ghost-cell velocity values are set.
- `initPlot` / `updatePlot` — figure setup and per-frame refresh via handles.

Parameters are grouped into structs: `prm` (physics: `rho, nu, L, H, uLid, tEnd`), `num` (numerics: `nx, ny, cfl, plotEvery`), `geom` (grid).

## Conventions that matter

- Index order is `(j, i)` = (y, x); **row 1 is the bottom**, so `v > 0` is upward.
  - `u` is `(ny+2, nx+1)` on vertical faces: columns 1/end lie on the side walls, rows 1/end are ghosts (bottom / lid).
  - `v` is `(ny+1, nx+2)` on horizontal faces: rows 1/end lie on bottom / lid, columns 1/end are ghosts.
  - `p` is `(ny, nx)` at cell centres with **no** ghost cells — `∂p/∂n = 0` lives in the matrix, and `p(:)` is column-major (y fastest), matching the `kron` ordering in `buildPressureSolver`.
- Velocities are updated only on `jU, iU` / `jV, iV`; never write wall or ghost values outside `applyVelocityBC`.
- Ghost values are excluded when estimating `dt` and `gammaDC`.
- Naming follows MATLAB style: `lowerCamelCase` variables and functions (verb-first), help text with an H1 line placed *after* the `function` line. Avoid names that shadow built-ins — this is why the grid struct is `geom` (not `grid`), the weight is `gammaDC` (not `gamma`), the step counter is `iStep` (not `step`), and the Laplacian is `discreteLaplacian`.
