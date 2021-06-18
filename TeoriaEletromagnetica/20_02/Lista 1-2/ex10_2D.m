%% Questao 10
% Calcule numericamente o potencial produzido por uma linha de cargas
% ?L = k.x/(x� +a�) que se estende ao longo do eixo x, de x = a at� +?,
% com a = 9,7 m e k = 6,9 pC, em todo o espa�o. Considere o zero de refer�ncia
% no infinito. Trace o gr�fico das linhas equipotenciais nos planos yz e xz.
% Para validar sua resposta, calcule V na origem.

%% Variaveis Dadas
clc
clear all
close all

plk = 6.9*10^(-12);

a = 9.7;

e0=8.854*10^(-12);  %Constante
k=1/(4*pi*e0);      %Constante

%% Variaveis Criadas
passo = a/5;
lim = 50;
%Vamos considerar que o cabo se encontra sobre o eixo Z

%Gerador do potencial:
xl=[a:passo:lim];

%Onde o potencial sera medido: (Define as coordenadas)
x=[-lim:passo:lim]; %vetor na coordenada x onde ser� calculado E
%y=[-lim:passo:lim]; %vetor na coordenada y onde ser� calculado E
z=[-lim:passo:lim]; %vetor na coordenada y onde ser� calculado E

%inicializa o potencial el�trico:
V(:,:) = zeros (length(x),length(z));

%% Desenvolvimento (Calcula Pontos do Potencial El�trico)
for i = 1:length(x)
    disp(i)
    %for j = 1:length(y)
        for k = 1:length(z)
            
            for m = 1:length(xl)                % varre a coordenada x da carga
                
                r = [x(i),0,z(k)];      %vetor posi��o apontando para onde estamos calculando E
                rl= [xl(m),0,0];    % vetor posi��o apontando para a carga
                
                %if ((r-rl)*(r-rl)'>passo/10000)
                V(i,k) = V(i,k)+((plk*xl(m)/(x(m)^2 +a^2))*passo/sqrt((r-rl)*(r-rl)'))';
                %end
                
            end
            
        end
    %end
end
V= V*k;

%% Plot Gr�ficos POTENCIAL EL�TRICO
% [X,Y] = meshgrid(x,y);
% figure
% contour(X,Y,squeeze(V(:,:,1)),15)
% colorbar
% xlabel('eixo x (m)')
% ylabel('eixo y (m)')
% hold

[X,Z] = meshgrid(x,z);
figure
contour(X,Z,squeeze(V(:,:)),15)
colorbar
xlabel('eixo x (m)')
ylabel('eixo z (m)')
hold

% [Y,Z] = meshgrid(y,z);
% figure
% contour(Y,Z,squeeze(V(1,:,:)),15)
% colorbar
% xlabel('eixo y (m)')
% ylabel('eixo z (m)')
% hold