%% Quest�o 5
% 5)Um cabo coaxial infinitamente longo possui uma distribui��o superficial de cargas uniforme ?s na superf�cie
% do cilindro interno (raio a), e uma densidade superficial de carga uniforme ?s na casca do cilindro (raio b). Essa
% carga superficial � negativa e de magnitude exata para que o cabo, como um todo, seja eletricamente neutro.
% Entre os dois condutores h� um material de permissividade relativa ?r
% . Numericamente, determine o potencial
% eletrost�tico e a intensidade de campo el�trico entre os dois condutores. Determine, numericamente, a energia
% por unidade de comprimento armazenada no campo eletrost�tico (integrando D.E/2). Considere a = 1 mm, b = 2
% mm, Q = 1 pC e ?r = 4.

%% Vari�veis Dadas
clc
clear all
close all

e0=8.854*10^(-12); %permissividade do espa�o livre (em F/m)

a = 1*10^(-3); %raio a
b = 2*10^(-3); %raio b
Q = 1*10^(-12); %carga uniforme
er=4; %permissividade relativa do meio

%% Vari�veis Criadas
pSa = Q/(2*pi*a);  %desnsidade superficial de cargas em a
pSb = -Q/(2*pi*b); %desnsidade superficial de cargas em b

passo = a/15;
lim = 2*b;

%Espa�o
x=[-lim:passo:lim]; %varia��o da coordenada x onde ser� calculado E
y=[-lim:passo:lim]; %varia��o da coordenada y onde ser� calculado E

dr = a/10;
dtheta = 2*pi/100; 

thetal = [dtheta/2:dtheta:2*pi-dtheta/2];   % varia��o da coordenada theta onde est� a carga (j� em radianos)

%Potencial
V(:,:) = zeros (length(x), length(y));

%Campo El�trico
xn=(x(2:end-1)); % Varia��o da coordenada x onde ser� calculado E tirando as extremidades
yn=(y(2:end-1)); % Varia��o da coordenada y onde ser� calculado E tirando as extremidades

E(1,:,:) = zeros (length(xn),length(yn));
E(2,:,:) = zeros (length(xn),length(yn));

%% Calcula Potencial Cilindro INTERNO
for i = 1:length(x)% varre a coordenada x onde V ser� calculado
    disp(i);
    for j = 1: length(y)  % varre a coordenada y onde V ser� calculado
        
            for o = 1:length(thetal) %varre a coordenada  thetal da carga
                
                r = [x(i),y(j)]; %vetor posi��o apontando para onde estamos calculando V
                [rl(1),rl(2)] = pol2cart(thetal(o),a);% vetor posi��o apontando para um elemento de superficie dS.
                
                dSa = a*dtheta; %elemento de volume na posi��o rl, phil, thetal.
                
                if (sqrt((r-rl)*(r-rl)')>0.001*a) %remove os pontos muito pr�ximos das cargas.
                    V(i,j) = V(i,j)  + (pSa*dSa/sqrt((r-rl)*(r-rl)'))';
                    
%                     if ((sqrt(x(i)^2+y(j)^2)>=a) && (sqrt(x(i)^2+y(j)^2)<=b))
%                         V(i,j)= V(i,j)/(4*pi*e0*er);
%                     else
%                         V(i,j)= V(i,j)/(4*pi*e0);
%                     end
                end
                
            end
    end
end

%% Calcula Potencial CASCA
for i = 1:length(x)% varre a coordenada x onde V ser� calculado
    disp(i);
    for j = 1: length(y)  % varre a coordenada y onde V ser� calculado
        
            for o = 1:length(thetal) %varre a coordenada  thetal da carga
                
                r = [x(i),y(j)]; %vetor posi��o apontando para onde estamos calculando V
                [rll(1),rll(2)] = pol2cart(thetal(o),b);
                
                dSb = b*dtheta;
                
                if (sqrt((r-rll)*(r-rll)')>0.001*b) %remove os pontos muito pr�ximos das cargas.
                    V(i,j) = V(i,j)  + (pSb*dSb/(sqrt((r-rll)*(r-rll)')))';
                    
%                     if ((sqrt(x(i)^2+y(j)^2)>=a) && (sqrt(x(i)^2+y(j)^2)<=b))
%                         V(i,j)= V(i,j)/(4*pi*e0*er);
%                     else
%                         V(i,j)= V(i,j)/(4*pi*e0);
%                     end
                end
                
            end
    end
end

 V= V/(4*pi*e0*er);

%% Calcula E

for i = 2:length(x)-1% varre a coordenada x onde E ser� calculado
    disp(i);
    for j = 2 :length(y)-1
        
        E(1,i-1,j-1) = -(V(i+1,j)-V(i-1,j))/2/passo; %Calcula a componente x do campo el�trico Ex como a -dV/dx, fazendo usando uma aproxima��o de diferen�a central;
        E(2,i-1,j-1) = -(V(i,j+1)-V(i,j-1))/2/passo; % Calcula Ey
    end
end

%% CALCULAR ENERGIA TOTAL ARMAZENADA A PARTIR DO CAMPO ELETRICO
We=0; %energia total armazenada
partWe=0;

for i = 1:length(xn)% varre a coordenada x do E
    disp(i);
    for j = 1: length(yn)  % varre a coordenada y do E
        partWe= ((dot(E(:,i,j),E(:,i,j)))*(passo^2));
        
%         if ((sqrt(x(i)^2+y(j)^2)>=a) && (sqrt(x(i)^2+y(j)^2)<=b))
%             partWe = 0.5*partWe*e0*er;
%         else
%             partWe = 0.5*partWe*e0;
%         end
        partWe = 0.5*partWe*e0*er;
        We = We + partWe;
    end
end

%% Plot
[X,Y] = meshgrid(xn,yn);
figure
quiver(X,Y,squeeze(E(1,:,:))' , squeeze(E(2,:,:))')  %faz o gr�fico vetorial de E
xlabel('eixo x (m)')
ylabel('eixo y (m)')
hold

[X,Y] = meshgrid(x,y);
figure
contour(X,Y,squeeze(V(:,:)),50) %faz o gr�fico vetorial de V
colorbar
xlabel('eixo x (m)')
ylabel('eixo y (m)')
hold

disp(We);       %Resp: 9.1791e-09