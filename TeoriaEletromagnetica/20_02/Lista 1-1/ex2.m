%% Questao 2
% Uma densidade volum�trica de carga uniforme de 0,2 uC/m3 est� presente em
% uma casca esf�rica que se estende de r = 3 cm a r = 7,4 cm. Se pv = 0 em qualquer
% outra regi�o, calcule numericamente a carga total presente na casca.

%% Variaveis Dadas
clc
clear all
close all

pv=0.2*10^(-6);  %Densidade Volum�trica de Carga na Casca[C/m^3]
r1=3*10^(-2);    %Raio Menor
r2=7.4*10^(-2);  %Raio Maior

e0=8.854*10^(-12);  %Constante
k=1/(4*pi*e0);      %Constante

%% Variaveis Criadas

passo=1/500;

%Gerador do campo:
xl=[-r2:passo:r2]; % varia��o da coordenada x onde est� a carga 
yl=[-r2:passo:r2];
zl=[-r2:passo:r2];

V = passo^3; %volume de cada segmento
Q = 0;

%% Desenvolvimento

for i = 1:length(xl)            % varre a coordenada x da carga
    disp(i)
    for j = 1:length(yl)        % varre a coordenada y da carga
        for k = 1:length(zl)    % varre a coordenada z da carga
            
            if (sqrt(xl(i)^2+yl(j)^2+zl(k)^2)<=r2)
                if (sqrt(xl(i)^2+yl(j)^2+zl(k)^2)>=r1)
                     Q = Q + (pv*V); 
                end
            end
            
        end
    end
end
disp(double(Q))
