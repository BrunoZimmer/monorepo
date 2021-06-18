%% Quest�o 2                Arthur A. S. Ara�jo
% Uma espira filamentar quadrada de lado a est� inicialmente posicionada no plano xy, com seu centro alinhado com o eixo z
% , numa regi�o de campo uniforme B(y,t) = B0 az. A espira come�a a girar com velocidade angular ? sobre o eixo x. 
% Determine numericamente o fluxo magn�tico atrav�s da espira e a FEM induzida nessa espira ao longo do tempo. Trace 
% os gr�ficos das duas quantidades em fun��o do tempo.

%% Vari�veis Dadas
clc
clear all
close all

%VARI�VEIS FORNECIDAS
a = 0.08; %[m]
B0 = 8.1; %[A/m^2]
w = 15; 
tempo = 5.8; %[s]

%% Vari�veis Criadas
periodo = 1/(w/(2*pi));
%Passos
passo = a/5;
lim = 2*a;
lim_t = 2*tempo;

dx=passo;
dy=passo;
dz=passo;

dt=periodo/20;
%Espa�os
x = [-lim:dx:lim]; %variacao da coordenada x
y = [-lim:dy:lim]; %variacao da coordenada y
z = [-lim:dz:lim]; %variacao da coordenada z

tempo = [0:dt:lim_t];

% GR�FICO DE B (YZ)
midx = ceil(length(x)/2);
midy = ceil(length(y)/2);
midz = ceil(length(z)/2);

% Inicializa a densidade de fluxo magnético
B(1,:,:,:,:) = zeros(length(x),length(y),length(z),length(tempo));
B(2,:,:,:,:) = zeros(length(x),length(y),length(z),length(tempo));
B(3,:,:,:,:) = zeros(length(x),length(y),length(z),length(tempo));


%% C�LCULO B
for p = 1:length(tempo)
    disp(p)
    for i = 1:length(x)
        for j = 1:length(y)
            for k = 1:length(z)
                
                B(:,i,j,k,p) = [0,0,B0];
                
            end
        end
    end
end

%% C�LCULO DO FLUXO NA ESPIRA
%integral de B dS -> dS = n*dA
fluxo = zeros([1,length(tempo)]);
for p = 1:length(tempo)
    disp(p)
    for i = 1:length(x)
        for j = 1:length(y)
            
            if (x(i)<= a/2 && x(i)>= -a/2 && y(j)<= a/2 && y(j)>= -a/2)
                dA=dx*dy;
                n = [0,-sin(w*tempo(p)),cos(w*tempo(p))];
                %n = [0,0,1];
                dS = n*dA;
                
                fluxo(1,p) = fluxo(1,p) + dot(B(:,i,j,midz,p),dS);
            end
        end
    end
end

%%  GR�FICO DO FLUXO X TEMPO (YZ)
figure(2);
plot(tempo,fluxo);
xlabel('tempo')
ylabel('fluxo')
title('Fluxo no tempo');

%% Calcula FEM
Vfem = zeros([1,length(tempo)]);
for i = 2:length(tempo)-1% varre a coordenada x onde E ser� calculado
    disp(i);
    Vfem(1,i) = -(fluxo(1,i+1)-fluxo(1,i-1))/2/dt;
end

%%  GR�FICO DA FOR�A ELETROMOTRIZ X TEMPO (YZ)
figure(3);
plot(tempo,Vfem);
xlabel('tempo')
ylabel('V')
title('FEM no tempo');
