%% Start

clear; close all; clc;

%%% Deixa os eixos em LaTeX
set(groot, 'defaultTextInterpreter','latex');

%% Calculando num e den ITAE

syms s KP KD KI;

KPID_num = (KD*s^2+KP*s+KI);
KPID_den = s;

% Original
% FT_num = 7.281*s^5 + 0.01002*s^4 + 238.1*s^3 + 0.1695*s^2;
% FT_den = s^6 + 0.001017*s^5 + 68.78*s^4 + 0.05918*s^3 + 1168*s^2 + 0.8315*s;

% Reduzida Ordem 4
FT_num = 7.281*s^3 + 0.004831*s^2 + 238.1*s - 1.32e-10;
FT_den = s^4 + 0.0003049*s^3 + 68.78*s^2 + 0.01021*s + 1168;

% Reduzida Ordem 3
% FT_num = 5.236*s^2 + 0.0237*s;
% FT_den = s^3 + 0.0001885*s^2 + 38.25*s;

% Reduzida Ordem 2 -> diverge
% FT_num = -0.004794*s^2 + 5.31*s + 2.697e-14;
% FT_den = s^2 + 0.0001898*s + 38.34;

Numerador = FT_num * KPID_num;
expand(Numerador);
collect(Numerador)

F_den = FT_den * KPID_den;
expand(F_den);
Denominador = F_den + Numerador;
expand(Denominador);
collect(Denominador)

EqCarac = (s+7.5+7.5*1i)*(s+7.5-7.5*1i)*(s+9.5)*(s+11.5)*(s+13.5);
expand(EqCarac)