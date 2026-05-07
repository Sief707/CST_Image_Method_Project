clc;
clear;
close all;

%% =========================================================
%  LOAD CST EXPORTED DATA
%% =========================================================

data = readmatrix('Potential_Profile.txt');

% Extract columns
x = data(:,1);
y = data(:,2);
z = data(:,3);
V = data(:,4);

disp('Data imported successfully');

disp(['Number of samples = ', num2str(length(V))]);

disp(['X range: ', ...
      num2str(min(x)), ...
      ' to ', ...
      num2str(max(x))]);

disp(['Y range: ', ...
      num2str(min(y)), ...
      ' to ', ...
      num2str(max(y))]);

disp(['Z range: ', ...
      num2str(min(z)), ...
      ' to ', ...
      num2str(max(z))]);

disp(['Potential range: ', ...
      num2str(min(V)), ...
      ' to ', ...
      num2str(max(V)), ...
      ' V']);



%% =========================================================
%  EXTRACT SAME CST PLANE ORIENTATION
%  (y = nearest plane to zero)
%% =========================================================

y_unique = unique(y);

[~, idx_y] = min(abs(y_unique));

y_selected = y_unique(idx_y);

disp(['Selected Y plane = ', num2str(y_selected)]);

% Extract plane data
idx_plane = (y == y_selected);

x_plane = x(idx_plane);
z_plane = z(idx_plane);
V_plane = V(idx_plane);

disp(['Plane samples = ', ...
      num2str(length(V_plane))]);



%% =========================================================
%  BUILD INTERPOLATION GRID
%% =========================================================

xq = linspace( ...
        min(x_plane), ...
        max(x_plane), ...
        300);

zq = linspace( ...
        min(z_plane), ...
        max(z_plane), ...
        300);

[Xq,Zq] = meshgrid(xq,zq);

Vq = griddata( ...
        x_plane, ...
        z_plane, ...
        V_plane, ...
        Xq, ...
        Zq, ...
        'natural');

disp('Interpolation completed successfully');



%% =========================================================
%  FIGURE 1 — POTENTIAL CONTOUR
%% =========================================================

figure('Color','w');

contourf(Xq, Zq, Vq, ...
         120, ...
         'LineColor','none');

colormap(jet);

cb1 = colorbar;
cb1.Label.String = 'Potential [V]';

xlabel('x [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

ylabel('z [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

title('CST Electrostatic Potential Contour', ...
      'FontSize',14, ...
      'FontWeight','bold');

axis equal;
axis tight;

grid on;

caxis([0 1.1]);

xlim([-40 40]);
ylim([-20 20]);



%% =========================================================
%  FIGURE 2 — 3D POTENTIAL SURFACE
%% =========================================================

figure('Color','w');

surf(Xq, Zq, Vq, ...
     'EdgeColor','none');

shading interp;

colormap(jet);

cb2 = colorbar;
cb2.Label.String = 'Potential [V]';

xlabel('x [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

ylabel('z [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

zlabel('Potential [V]', ...
       'FontSize',13, ...
       'FontWeight','bold');

title('3D CST Electrostatic Potential Surface', ...
      'FontSize',14, ...
      'FontWeight','bold');

view(45,35);

grid on;

caxis([0 1.1]);

xlim([-40 40]);
ylim([-20 20]);



%% =========================================================
%  FIGURE 3 — RADIAL DISTANCE ANALYSIS
%% =========================================================

% Sphere center coordinates
x0 = 0;
y0 = 0;
z0 = 10;

% Radial distance from sphere center
r = sqrt( ...
        (x - x0).^2 + ...
        (y - y0).^2 + ...
        (z - z0).^2 );

figure('Color','w');

scatter(r, V, ...
        8, ...
        V, ...
        'filled');

colormap(jet);

cb3 = colorbar;
cb3.Label.String = 'Potential [V]';

xlabel('Radial Distance r [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

ylabel('Potential [V]', ...
       'FontSize',13, ...
       'FontWeight','bold');

title('Potential vs Radial Distance from Sphere', ...
      'FontSize',14, ...
      'FontWeight','bold');

grid on;

xlim([0 40]);

ylim([0 1.1]);

caxis([0 1.1]);



%% =========================================================
%  FIGURE 4 — TRUE 3D FIELD CLOUD
%% =========================================================

figure('Color','w');

step = 20;

scatter3( ...
    x(1:step:end), ...
    y(1:step:end), ...
    z(1:step:end), ...
    6, ...
    V(1:step:end), ...
    'filled');

colormap(jet);

cb4 = colorbar;
cb4.Label.String = 'Potential [V]';

xlabel('x [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

ylabel('y [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

zlabel('z [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

title('True 3D CST Electrostatic Potential Distribution', ...
      'FontSize',14, ...
      'FontWeight','bold');

grid on;
axis equal;

view(40,30);

caxis([0 1.1]);

xlim([-40 40]);
ylim([-40 40]);
zlim([-20 20]);



disp('All plots generated successfully');


%% =========================================================
%  ANALYTICAL IMAGE-METHOD POTENTIAL
%% =========================================================

% Charge height
d = 10;     % cm

% Distance to real charge
R1 = sqrt( ...
    Xq.^2 + ...
    (Zq - d).^2 );

% Distance to image charge
R2 = sqrt( ...
    Xq.^2 + ...
    (Zq + d).^2 );

% Analytical potential
V_analytical = (1 ./ R1) - (1 ./ R2);

% Normalize to 1 V peak
V_analytical = V_analytical ./ max(V_analytical(:));

disp('Analytical potential computed');

%% =========================================================
%  FIGURE 5 — ANALYTICAL POTENTIAL MAP
%% =========================================================

figure('Color','w');

contourf(Xq, Zq, V_analytical, ...
         150, ...
         'LineColor','none');

colormap(jet);

cb = colorbar;
cb.Label.String = 'Potential [V]';

xlabel('x [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

ylabel('z [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

title('Analytical Potential Distribution (Image Method)', ...
      'FontSize',14, ...
      'FontWeight','bold');

axis equal;
axis tight;

grid on;

caxis([0 1.1]);

xlim([-40 40]);
ylim([-20 20]);

%% =========================================================
%  CORRECT IMAGE-METHOD ANALYTICAL RADIAL POTENTIAL
%% =========================================================

% Observation line:
% Along z-axis above the plane

z_theory = linspace(0.5,40,2000);

d = 10;   % charge height

% Real charge contribution
R1 = abs(z_theory - d);

% Image charge contribution
R2 = abs(z_theory + d);

% Avoid singularity
R1(R1 < 0.2) = 0.2;

% Image-method potential
V_theory = (1 ./ R1) - (1 ./ R2);

% Normalize
V_theory = V_theory ./ max(V_theory);

%% =========================================================
%  CST CENTERLINE EXTRACTION
%% =========================================================

idx_center = abs(x) < 0.5 & abs(y) < 0.5;

z_cst = z(idx_center);
V_cst = V(idx_center);

[z_cst, order] = sort(z_cst);

V_cst = V_cst(order);

% Normalize CST too
V_cst = V_cst ./ max(V_cst);

%% =========================================================
%  FIGURE — CST vs ANALYTICAL
%% =========================================================

figure('Color','w');

plot(z_theory, ...
     V_theory, ...
     'b', ...
     'LineWidth',3);

hold on;

scatter(z_cst, ...
        V_cst, ...
        30, ...
        'ro', ...
        'filled');

xlabel('z [cm]', ...
       'FontSize',13, ...
       'FontWeight','bold');

ylabel('Normalized Potential', ...
       'FontSize',13, ...
       'FontWeight','bold');

title('Potential Comparison: CST vs Image-Method Analytical', ...
      'FontSize',14, ...
      'FontWeight','bold');

legend('Analytical Image Method', ...
       'CST Data Points', ...
       'Location','northeast');

grid on;

xlim([0 40]);

ylim([0 1.1]);

set(gca, ...
    'FontSize',12, ...
    'LineWidth',1.2);

%% =========================================================
%  COMPARISON: CST vs ANALYTICAL POTENTIAL
%% =========================================================
figure('Color','w');

% =====================================================
% TOP GRAPH — CST
% =====================================================

subplot(2,1,1)

contourf(Xq, Zq, Vq, ...
         120, ...
         'LineColor','none');

colormap(jet);

colorbar;

title('CST Potential Distribution', ...
      'FontSize',14, ...
      'FontWeight','bold');

xlabel('x [cm]');
ylabel('z [cm]');

axis equal tight;
grid on;

xlim([-40 40]);
ylim([-20 20]);

caxis([0 1.1]);

% =====================================================
% BOTTOM GRAPH — ANALYTICAL
% =====================================================

subplot(2,1,2)

contourf(Xq, Zq, V_analytical, ...
         120, ...
         'LineColor','none');

colormap(jet);

colorbar;

title('Analytical Image-Method Distribution', ...
      'FontSize',14, ...
      'FontWeight','bold');

xlabel('x [cm]');
ylabel('z [cm]');

axis equal tight;
grid on;

xlim([-40 40]);
ylim([-20 20]);

caxis([0 1.1]);

sgtitle('CST vs Analytical Potential Comparison', ...
        'FontSize',16, ...
        'FontWeight','bold');