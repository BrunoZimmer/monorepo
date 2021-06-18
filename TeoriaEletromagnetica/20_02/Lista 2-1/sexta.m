%% Quest�o SEXTA                       Arthur A S Ara�jo
% Considere uma densidade de corrente superficial K = K0(�x - �y(1+x)),
% que existe apenas numa por��o do primeiro quadrante do plano xy,
% delimitada pela rela��o a� <= x^2 + y^2 <= 4a�. Determine numericamente
% a densidade de corrente superficial na regi�o em que ela existe.
% Trace o gr�fico dessa K no plano xy. Em seguida, determine a intensidade
% do campo magn�tico nos pontos necess�rios para tra�ar o gr�fico de
% H no plano z=a. Trace esse gr�fico.

%% Vari�veis Dadas
clc
clear all
close all

a = 1;        % limite da l�mina
kx = 1;       %na dire��o ax
z1 = a;

%% Vari�veis Criadas
lim = 2*a; % limite para as coordenadas x, y e z
passo = a/6; % passo

dx=passo;
dy=passo;
dz=passo;

x=[-lim:dx:lim];            %variação da coordenada x onde será calculado H
y=[-lim:dy:lim];            %variação da coordenada y onde será calculado H
z=[-2*z1:dz:2*z1];          %variação da coordenada z onde será calculado H

xl=[a:dx:2*a];              %variação da coordenada x onde est� a carga
yl=[a:dy:2*a];              %variação da coordenada y onde est� a carga

Km(1,:,:,:) = zeros(length(x),length(y),length(z));
Km(2,:,:,:) = zeros(length(x),length(y),length(z));
Km(3,:,:,:) = zeros(length(x),length(y),length(z));

H(1,:,:,:) = zeros(length(x),length(y),length(z));
H(2,:,:,:) = zeros(length(x),length(y),length(z));
H(3,:,:,:) = zeros(length(x),length(y),length(z));

%% Desenvolvimento
for i = 1:length(x)% varre a coordenada x onde H ser� calculado
    disp(i)
    for j = 1: length(y)  % varre a coordenada y onde H ser� calculado
        for k = 1:length(z) % varre a coordenada z onde H ser� calculado
            
            for m = 1:length(xl)  % varre a coordenada xl, onde existe a corrente
                for n = 1:length(yl)
                    
                    r = [x(i),y(j),z(k)];  %vetor posi��o do ponto de campo (onde calculamos H)
                    rl = [xl(m), yl(n), 0];
                    K = [0,0,0];
                    % Utilizamos a condi��o abaixo para evitar a divis�o por zero, no caso em que r e rl s�o iguais.
                    %if (yl(n)>=-a && yl(n)<=a)
                    if (xl(m)>=0 && yl(n)>= 0)
                        if (sqrt(xl(m)^2+yl(n)^2)>a && sqrt(xl(m)^2+yl(n)^2)<2*a)
                            K = [kx,-(1+xl(m)), 0];
                        end
                    end
                    
                    % Agora calculamos o produto vetorial K x (r-rl)
                    K_x_rrl = cross(K, r-rl);
                    if  ((r-rl)*(r-rl)' > dz/2)
                        
                        dH = K_x_rrl'*dx*dy/(sqrt((r-rl)*(r-rl)')^3);
                        
                        H(1,i,j,k) = H(1,i,j,k) + dH(1);
                        H(2,i,j,k) = H(2,i,j,k) + dH(2);
                        H(3,i,j,k) = H(3,i,j,k) + dH(3);
                    end
                    %end
                    
                end
            end
        end
    end
end

%% Calcula K
for i = 1:length(x)% varre a coordenada x onde H ser� calculado
    disp(i)
    for j = 1: length(y)  % varre a coordenada y onde H ser� calculado
        for k = 1:length(z) % varre a coordenada z onde H ser� calculado
            
            for m = 1:length(xl)  % varre a coordenada xl, onde existe a corrente
                for n = 1:length(yl)
                    
                    K = [kx,-(1+xl(m)), 0];
                    
                    % Utilizamos a condi��o abaixo para evitar a divis�o por zero, no caso em que r e rl s�o iguais.
                    %if (yl(n)>=-a && yl(n)<=a)
                    if (x(i)>=0 && y(j)>= 0)
                        if (sqrt(x(i)^2+y(j)^2)>a && sqrt(x(i)^2+y(j)^2)<2*a)
                            if  ((r-rl)*(r-rl)' > dz/2)
                                Km(:,i,j,k) = K;
                            end
                        end
                    end
                    %end
                    
                end
            end
        end
    end
end

H = H/(4*pi);

midx=ceil(length(x)/2);
midy=ceil(length(y)/2);
midz=ceil(length(z)/2);

%% Plot

figure(2);
[X,Y] = meshgrid(x,y);
quiver(X, Y, squeeze(H(1,:,:,ceil(midz*1.5)))', squeeze(H(2,:,:,ceil(midz*1.5)))');
xlabel('eixo x (m)')
ylabel('eixo y (m)')
title('H, plano XY (z=a)');

%gr�fico de k no plano z
figure(3);
[X,Y] = meshgrid(x,y);
quiver(X, Y, squeeze(Km(1,:,:,midz))', squeeze(Km(2,:,:,midz))');
xlabel('eixo x (m)')
ylabel('eixo y (m)')
title('K no plano z = 0');
