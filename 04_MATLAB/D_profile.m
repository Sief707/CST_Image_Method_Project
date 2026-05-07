%% =========================================================
%  D-FIELD VALIDATION: CST vs IMAGE METHOD
%% =========================================================

clc;
clear;
close all;

%% =========================================================
%  LOAD CST D-FIELD DATA
%% =========================================================

data = readmatrix('D_Profile.txt');

% ---------------------------------------------------------
% Columns from CST export
% ---------------------------------------------------------
x  = data(:,1);
y  = data(:,2);
z  = data(:,3);

Dx = data(:,4);
Dy = data(:,5);
Dz = data(:,6);

disp('D-field data imported successfully');

disp(['Total CST samples = ', num2str(length(Dz))]);

%% =========================================================
%  EXTRACT GROUND-PLANE LINE
%  (ROBUST VERSION)
%% =========================================================

% Find nearest available y-plane
y_unique = unique(y);

[~, iy] = min(abs(y_unique));

y0 = y_unique(iy);

% Find nearest available z-plane
z_unique = unique(z);

[~, iz] = min(abs(z_unique));

z0 = z_unique(iz);

disp(['Selected y plane = ', num2str(y0)]);
disp(['Selected z plane = ', num2str(z0)]);

% Extract line
idx = (y == y0) & (z == z0);

x_cst  = x(idx);
Dz_cst = Dz(idx);

% Sort points
[x_cst, order] = sort(x_cst);

Dz_cst = Dz_cst(order);

disp(['Extracted CST line samples = ', ...
      num2str(length(Dz_cst))]);

%% =========================================================
%  ANALYTICAL IMAGE-METHOD D-FIELD
%% =========================================================

% ---------------------------------------------------------
% Charge height above grounded plane
% ---------------------------------------------------------

d = 10;      % cm

% ---------------------------------------------------------
% Arbitrary normalization charge
% ---------------------------------------------------------

q = 1;

% ---------------------------------------------------------
% Smooth analytical axis
% ---------------------------------------------------------

x_theory = linspace( ...
                min(x_cst), ...
                max(x_cst), ...
                3000);

% ---------------------------------------------------------
% Analytical image-method D-field
%
% Dz(x) = -(2qd)/(4*pi*(x^2+d^2)^(3/2))
% ---------------------------------------------------------

Dz_theory = ...
-(2*q*d) ./ ...
(4*pi*(x_theory.^2 + d^2).^(3/2));

%% =========================================================
%  NORMALIZATION
%% =========================================================

Dz_theory = ...
Dz_theory ./ max(abs(Dz_theory));

Dz_cst = ...
Dz_cst ./ max(abs(Dz_cst));

disp('Normalization completed');

%% =========================================================
%  FIGURE 1 — ANALYTICAL ONLY
%% =========================================================

figure('Color','w');

plot(x_theory, ...
     Dz_theory, ...
     'b', ...
     'LineWidth',3);

xlabel('Length Along Ground Plane x [cm]', ...
       'FontSize',14, ...
       'FontWeight','bold');

ylabel('Normalized Electric Flux Density D_z', ...
       'FontSize',14, ...
       'FontWeight','bold');

title('Analytical D-Field Distribution (Image Method)', ...
      'FontSize',15, ...
      'FontWeight','bold');

grid on;

set(gca, ...
    'FontSize',13, ...
    'LineWidth',1.3);

xlim([-40 40]);

ylim([-1.1 0.1]);

%% =========================================================
%  FIGURE 2 — CST ONLY
%% =========================================================

figure('Color','w');

scatter(x_cst, ...
        Dz_cst, ...
        120, ...
        'ro', ...
        'LineWidth',2);

xlabel('Length Along Ground Plane x [cm]', ...
       'FontSize',14, ...
       'FontWeight','bold');

ylabel('Normalized Electric Flux Density D_z', ...
       'FontSize',14, ...
       'FontWeight','bold');

title('CST D-Field Samples on Ground Plane', ...
      'FontSize',15, ...
      'FontWeight','bold');

grid on;

set(gca, ...
    'FontSize',13, ...
    'LineWidth',1.3);

xlim([-40 40]);

ylim([-1.1 0.1]);

%% =========================================================
%  FIGURE 3 — CST vs ANALYTICAL
%% =========================================================

figure('Color','w');

plot(x_theory, ...
     Dz_theory, ...
     'b', ...
     'LineWidth',3);

hold on;

scatter(x_cst, ...
        Dz_cst, ...
        120, ...
        'ro', ...
        'LineWidth',2);

xlabel('Length Along Ground Plane x [cm]', ...
       'FontSize',14, ...
       'FontWeight','bold');

ylabel('Normalized Electric Flux Density D_z', ...
       'FontSize',14, ...
       'FontWeight','bold');

title('D-Field on Ground Plane: CST vs Analytical', ...
      'FontSize',15, ...
      'FontWeight','bold');

legend('Analytical Image Method', ...
       'CST Data Points', ...
       'Location','northeast');

grid on;

set(gca, ...
    'FontSize',13, ...
    'LineWidth',1.3);

xlim([-40 40]);

ylim([-1.1 0.1]);

%% =========================================================
%  FIGURE 4 — SUBPLOT COMPARISON
%% =========================================================

figure('Color','w');

% ---------------------------------------------------------
% TOP — ANALYTICAL
% ---------------------------------------------------------

subplot(2,1,1)

plot(x_theory, ...
     Dz_theory, ...
     'b', ...
     'LineWidth',3);

xlabel('Length Along Ground Plane x [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

ylabel('Normalized D_z', ...
       'FontSize',13, ...
       'FontWeight','bold');

title('Analytical Image-Method D-Field', ...
      'FontSize',14, ...
      'FontWeight','bold');

grid on;

xlim([-40 40]);

ylim([-1.1 0.1]);

set(gca, ...
    'FontSize',12, ...
    'LineWidth',1.2);

% ---------------------------------------------------------
% BOTTOM — CST
% ---------------------------------------------------------

subplot(2,1,2)

scatter(x_cst, ...
        Dz_cst, ...
        120, ...
        'ro', ...
        'LineWidth',2);

xlabel('Length Along Ground Plane x [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

ylabel('Normalized D_z', ...
       'FontSize',13, ...
       'FontWeight','bold');

title('CST D-Field Samples', ...
      'FontSize',14, ...
      'FontWeight','bold');

grid on;

xlim([-40 40]);

ylim([-1.1 0.1]);

set(gca, ...
    'FontSize',12, ...
    'LineWidth',1.2);

sgtitle('D-Field Validation: CST vs Analytical Image Method', ...
        'FontSize',16, ...
        'FontWeight','bold');

disp('All D-field validation plots generated successfully');