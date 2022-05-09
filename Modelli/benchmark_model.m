function [estimatedPower] = benchmark_model(ws, theta, cutoutWindspeed, saturationValue)
% Restituisce il valore della stima della potenza generata. I parametri
% della funzione sono:
%   ws: un vettore colonna che rappresenta la velocità del vento.
%   theta: i pratametri del tratto cubico.
%   cutoutWindspeed: la velocità oltre la quale si ha saturazione
%   saturationValue: il valore della saturazione
    
    out = zeros(length(ws), 1);
    out(ws > cutoutWindspeed) = saturationValue;
    out(ws <= cutoutWindspeed) = (ws(ws<= cutoutWindspeed)).^3 * theta;

    estimatedPower = out;
end