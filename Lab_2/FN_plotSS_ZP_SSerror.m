function SS_error = FN_plotSS_ZP_SSerror(K, J, B)
    TF_thetaOverThetar = tf([0 0 K], [J B K]);
    figure
    step(TF_thetaOverThetar)
    figure
    pzplot(TF_thetaOverThetar)
    grid on
    [y, t] = step(TF_thetaOverThetar);
    SS_error = abs(1 - y(end));
end