% clc; clear;
load length_james.mat; load length_an.mat;
p=an_bin_num;
l=bin_num;
t= 1:size(m,1);

thick=semilogy(p, '-', 'LineWidth', 3, 'Color', 'k');
hold on
semilogy(l, '--', 'Color', 'k');

[hleg1, hobj1]=legend('Proposed method','Lim''s method', 'Location', [0.45 0.85 0.45 0.05]);
textobj = findobj(hobj1, 'type', 'text');
set(textobj, 'Interpreter', 'latex', 'fontsize', 15);

xlabel('Length (Pixel)', 'FontSize', 15, 'FontWeight','bold');
ylabel('Number of CC', 'FontSize', 15, 'FontWeight','bold');
title('Number of connected component (length)', 'FontSize', 15, 'FontWeight','bold', ...
    'Color', 'k');
ylim([10^1 10^5]);
