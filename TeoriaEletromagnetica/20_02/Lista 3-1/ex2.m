%% Quest�o 2                Arthur A. S. Ara�jo
% Uma espira filamentar quadrada de lado a est� inicialmente posicionada no plano xy, com seu centro alinhado com o eixo z
% , numa regi�o de campo uniforme B(y,t) = B0 az. A espira come�a a girar com velocidade angular ? sobre o eixo x. 
% Determine numericamente o fluxo magn�tico atrav�s da espira e a FEM induzida nessa espira ao longo do tempo. Trace 
% os gr�ficos das duas quantidades em fun��o do tempo.

%% Vari�veis Dadas
clc
clear all
close all

a = 0.08; %[m]
b0 = 8.1; %[A/m^2]
w = 15; 
t_esp = 5.8; %[s]
B = [0,0,b0];

%% Vari�veis Criadas
D = 2*a; % limite para as coordenadas x, y e z 2*lim_x
passo = a/20; % passo posicao_rho/5

dx=passo;
dy=passo;
dz=passo;
%% Espa�o
dt = t_esp/20000;
t = [0:dt:2*t_esp];

%Fluxo Magn�tico
Fluxo = zeros ([1,length(t)]);

%FEM induzida
tn=(t(2:end-1));
Vfem = zeros([1,length(t)]);

%% Calcula Fluxo
for i = 1:length(t)
    disp(i)
    
    S = a^2;        %Area Constante
    a_n = [0, -sin(w*t(i)), cos(w*t(i))];
    
    dF = dot(B,a_n*S);
    Fluxo(1,i) = dF;
end

%% gr�fico do Fluxo variando no Tempo
figure;
plot(t, Fluxo);
xlabel('Tempo [s]')
ylabel('Fluxo [Wb]')
title('Varia��o do fluxo no tempo');

%% Calcula FEM induzida
for o = 2:length(t)-1% varre a coordenada x onde E ser� calculado
    disp(o);
    Vfem(1,o) = -(Fluxo(1,o+1)-Fluxo(1,o-1))/2/dt;
end

%%  GR�FICO DA FOR�A ELETROMOTRIZ X TEMPO (YZ)
figure(3);
plot(t,Vfem);
xlabel('t [s]')
ylabel('fem [V]')
title('Varia��o da fem no tempo');