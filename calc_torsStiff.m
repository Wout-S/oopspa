    function Ip = calc_torsStiff(t, w)
        % Compute the polar moment of inertia for rectangular cross-sections
        if w > t
            a = t/2;
            b = w/2;
        else
            a = w/2;
            b = t/2;
        end
        sumN_new    = 0;
        sumN        = 0;
        n           = 1;
        while (n < 3 || abs((sumN_new/sumN)) > 0.0001)
            sumN_new    = (1/n^5) * tanh(n*pi*b/(2*a));
            n           = n + 2;
            sumN        = sumN + sumN_new;
        end
        Ip = 1/3 * (2*a)^3*(2*b) * (1 - (192/pi^5)*(a/b)*sumN);
    end