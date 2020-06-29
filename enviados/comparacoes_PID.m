%% Start

clear; close all; clc;

%%% Deixa os eixos em LaTeX
set(groot, 'defaultTextInterpreter','latex');

%% Definindo FT's

%%% Parametros
m = 2;
Mbase = 6;
L = 0.5;
c = 8.5e-5;
b = 7.12e-3;
g = 9.81;

%%% Espaco de estados

M = [1, 0, 0, 0, 0, 0; 0, (2*m+Mbase)*L, 0, 3*m*(L^2)/2, 0, m*(L^2)/2; 0, 0, 1, 0, 0, 0; 0, 2*m*L, 0, 3*m*(L^2)/2, 0, 2*m*(L^2)/3; 0, 0, 0, 0, 1, 0; 0, m*L/2, 0, m*(L^2)/6, 0, m*(L^2)/3];

I = eye(6);

Minv = I/M;

Atil = [0, 1, 0, 0, 0, 0; 0, -b*L, 0, 0, 0, 0; 0, 0, 0, 1, 0, 0; 0, 0, -3*m*L*g/2, -c, -m*L*g/2, 0; 0, 0, 0, 0, 0, 1; 0, 0, 0, c, -m*L*g/2, c];

Btil = [0, 0, 0; L, 0, 0; 0, 0, 0; 0, 1, 0; 0, 0, 0; 0, 0, 1];

A = Minv*Atil;

B = Minv*Btil;

C = eye(6);

D = zeros(6,3);

ee = ss(A,B,C,D); % Espaco de Estados de malha aberta

fts = tf(ee); % Mudanca para FTs

FT_T2_theta2dot = fts(6,3); % FT relacionando thetadot2 x T2

%%% Consertando FT1

[num,den]=tfdata(FT_T2_theta2dot,'v');
num2 = [num 0];
den2 = [den 0];
FT_T2_theta2dot = tf(num2,den2);

%% Ganhos PID definidos por ITAE

PID_ITAE = pid(65,1250);
PID_LR = pid(63.049, 63.049*5.643);
PID_tuner = pid(19.5, 1822.4, 0.05);
PID_aloc = pid(50.77, 136.3, 1.31);

%% FTMF
FTMF_ITAE = feedback(PID_ITAE * FT_T2_theta2dot,1);
FTMF_LR = feedback(PID_LR * FT_T2_theta2dot,1);
FTMF_tuner = feedback(PID_tuner * FT_T2_theta2dot,1);
FTMF_aloc = feedback(PID_aloc * FT_T2_theta2dot,1);

%% Plots de PID

step(FTMF_ITAE)
hold on
step(FTMF_LR)
hold on 
step(FTMF_tuner)
hold on
step(FTMF_aloc)
yline(1,'-.');
title({'Resposta ao degrau com diferentes sintonizações de PID'}, 'Fontsize', 12)
xlabel('Tempo')
xlim([0 0.15])
ylabel('Velocidade Angular (rad/s)')
legend({'ITAE','LR','PID tuner','Alocação de polos'}, 'Fontsize', 9)

%% Parametros do Step

disp('ITAE: ')

(PID_ITAE)

stepinfo(FTMF_ITAE)

[resposta, ~] = step(FTMF_ITAE);
erro_RP = abs(1.0 - resposta(length(resposta)))

disp('LR: ')

(PID_LR)

stepinfo(FTMF_LR)

[resposta, ~] = step(FTMF_LR);
erro_RP = abs(1.0 - resposta(length(resposta)))

disp('Tuner: ')

(PID_tuner)

stepinfo(FTMF_tuner)

[resposta, ~] = step(FTMF_tuner);
erro_RP = abs(1.0 - resposta(length(resposta)))

disp('Aloc: ')

(PID_aloc)

stepinfo(FTMF_aloc)

[resposta, ~] = step(FTMF_aloc);
erro_RP = abs(1.0 - resposta(length(resposta)))