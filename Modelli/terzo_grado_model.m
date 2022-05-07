function [estimatedPower] = terzo_grado_model(ws, theta, cutoutWindspeed, saturationValue, cutinWindspeed)
% Restituisce il valore della stima della potenza generata. I parametri
% della funzione sono:
%   ws: un vettore colonna che rappresenta la velocità del vento.
%   theta: i pratametri del tratto cubico.
%   cutoutWindspeed: la velocità oltre la quale si ha saturazione
%   saturationValue: il valore della saturazione
    
    out = ones(length(ws), 1);
    out(ws <= cutinWindspeed) = 0;
    out(ws >= cutoutWindspeed) = saturationValue;
    out(ws > cutinWindspeed & ws < cutoutWindspeed) = [ ws(ws > cutinWindspeed & ws < cutoutWindspeed), ws(ws > cutinWindspeed & ws < cutoutWindspeed).^2, ws(ws > cutinWindspeed & ws < cutoutWindspeed).^3 ] * theta;
    
    estimatedPower = out;
end