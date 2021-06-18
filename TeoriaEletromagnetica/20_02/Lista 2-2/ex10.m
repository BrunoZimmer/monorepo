%% Quest�o 10                   Arthur A S Ara�jo
% Um disco de raio a pertence ao plano xy, com o eixo z passando pelo seu centro.
% Uma carga superficial de densidade uniforme ?s est� presente no disco, que gira 
% em volta do eixo z em uma velocidade angular de ? rad/s. Calcule numericamente 
% o potencial vetorial magn�tico A e apartir dele a densidade de fluxo mangn�tico 
% B, em qualquer posi��o.  Fa�a uma representa��o gr�fica de A e de B no plano xz.
% Afim de valiar sua resposta calcule a magnitude da intensidade de campo 
% magn�tico na posi��o x = 0, y = 0, z= 6,0 m. 
% Considere a = 4,8 m, ?s = 5,4 C/m2 e ? = 9,6 rad/s

%% Vari�veis Dadas
clc
clear all
close all

u0 = 4*pi*10^-7; % permeablidade do espa�o livre (em H/m)

a = 4.8;     % raio do anel
w = 9.6;     % velocidade angular [rad/s]
ps = 5.4;    % densidade superficial [C/m^2]

lim_z = 6;

%% Vari�veis Criadas
lim = 2*a; % limite para as coordenadas x, y e z
passo = a/5; % passo

dx = passo;
dy = passo;
dz = passo;

x = [-lim:dx:lim]; %variação da coordenada x onde será calculado H
y = [-lim:dy:lim]; %variação da coordenada y onde será calculado H
z = [-2*lim_z:dz:2*lim_z]; %variação da coordenada z onde será calculado H

dphi = 2*pi/14;
drho = a/20;
phil = [0:dphi:2*pi-dphi/2]; % notar que exclu�mos 2*pi, pois j� temos 0.
rhol = [0:drho:a];

%incializa o potencial vetorial magn�tico
A(1,:,:,:) = zeros(length(x),length(y),length(z));      %Componente x do potencial vetorial magn�tico
A(2,:,:,:) = zeros(length(x),length(y),length(z));      %Componente y do potencial vetorial magn�tico
A(3,:,:,:) = zeros(length(x),length(y),length(z));      %Componente z do potencial vetorial magn�tico

%% Desenvolvimento: Calcula Potencial A
for i = 1:length(x)% varre a coordenada x onde H ser� calculado
    disp(i)
    for j = 1: length(y)  % varre a coordenada y onde H ser� calculado
        for k = 1:length(z) % varre a coordenada z onde H ser� calculado
            
            for m = 1:length(phil)  % varre a coordenada phil, onde existe a corrente
                for n =1:length(rhol)
                    
                    r = [x(i),y(j),z(k)];  % vetor posi��o onde calculamos A
                    [rl(1), rl(2), rl(3)] = pol2cart(phil(m), rhol(n), 0); % convertemos rl para coord retangulares
                    
                    %K = [rhol(n)*ps*w*(-sin(phil(m))), rhol(n)*ps*w*cos(phil(m)), 0];
                    [K(1), K(2), K(3)] = pol2cart(pi/2+phil(m), rhol(n)*ps*w, 0); %�_phi = �_y*cos(phi) - �_x*sen(phi)
                    
                    dS = rhol(n)*drho*dphi;
                    K_dS = K*dS; %produto KdS, K -> �_phi %dS = rho*drho*dphi
                    
                    dA = K_dS/sqrt( (r-rl)*(r-rl)'); % contribui��o para o potencial A devido a a corrente I no segmento dzl
                    
                    A(1,i,j,k)=A(1,i,j,k)+dA(1); %soma em Ax a componente x da contribui��o em dA
                    A(2,i,j,k)=A(2,i,j,k)+dA(2);%soma em Ay a componente y da contribui��o em dA
                    A(3,i,j,k)=A(3,i,j,k)+dA(3);%soma em Az a componente z da contribui��o em dA
                end
            end
        end
    end
end

A=(u0/(4*pi))*A;

%% Calcula B
xn = (x(2:end-1));
yn = (y(2:end-1));
zn = (z(2:end-1));

B(1,:,:,:) = zeros (length(xn),length(yn),length(zn)); %inicializa a densidade de fluxo magn�tico B, componente x
B(2,:,:,:) = zeros (length(xn),length(yn),length(zn)); %componente y
B(3,:,:,:) = zeros (length(xn),length(yn),length(zn)); %componente z

%vamos calcular o B a partir do rotacional de A (rot A = (dAz/dy-dAy/dz) ax
%(dAx/dz-dAz/dx) ay + (dAy/dx-dAx/dy) az
for i = 2:length(x)-1% varre a coordenada x onde B ser� calculado
    disp(i)
    for j = 2 :length(y)-1 % varre a coordenada y onde B ser� calculado
        for k = 2: length(z)-1  % varre a coordenada z onde E ser� calculado
            
            dAz_dy = (A(3,i,j+1,k)-A(3,i,j-1,k))/2/dy; %derivada de Az em rela��o a y
            dAy_dz = (A(2,i,j,k+1)-A(2,i,j,k-1))/2/dz; %derivada de Ay em rela��o a z
            
            dAx_dz = (A(1,i,j,k+1)-A(1,i,j,k-1))/2/dz; %derivada de Ax em rela��o a z
            dAz_dx = (A(3,i+1,j,k)-A(3,i-1,j,k))/2/dx;%derivada de Az em rela��o a x
            
            dAy_dx = (A(2,i+1,j,k)-A(2,i-1,j,k))/2/dx; %derivada de Ay em rela��o a x
            dAx_dy = (A(1,i,j+1,k)-A(1,i,j-1,k))/2/dy;%derivada de Ax em rela��o a y
            
            B(1,i-1,j-1,k-1) = dAz_dy-dAy_dz; %a componente x de B � dAz/dy-dAy/dz
            B(2,i-1,j-1,k-1) = dAx_dz-dAz_dx;%a componente y de B � dAx/dz-dAz/dx
            B(3,i-1,j-1,k-1) = dAy_dx-dAx_dy;%a componente z de B � dAy/dx-dAx/dy
        end
    end
end

%% Plot A
midx=ceil(length(x)/2);
midy=ceil(length(y)/2);
midz=ceil(length(z)/2);

figure(1);
[X,Z] = meshgrid(x,z);
quiver(X, Z, squeeze(A(1,:,midy,:))', squeeze(A(3,:,midy,:))');  %faz o gr�fico de A no plano y = 0
hold on
contour(X, Z, squeeze(A(2,:,midy,:))',40)
xlabel('eixo x (m)')
ylabel('eixo z (m)')
title('A, plano XZ (y=0)');

figure(2);
[Y,Z] = meshgrid(y,z);
quiver(Y, Z, squeeze(A(2,midx,:,:))', squeeze(A(3,midx,:,:))');  %faz o gr�fico de A no plano y = 0
hold on
contour(Y, Z, squeeze(A(1,midx,:,:))',40)
xlabel('eixo y (m)')
ylabel('eixo z (m)')
title('A, plano YZ (x=0)');

figure(3);
[X,Y] = meshgrid(x,y);
quiver(X, Y, squeeze(A(1,:,:,midz))', squeeze(A(2,:,:,midz))');  %faz o gr�fico de A no plano y = 0
xlabel('eixo x (m)')
ylabel('eixo y (m)')
title('A, plano XY (z=0)');

%% Plot B
midxn=ceil(length(xn)/2);
midyn=ceil(length(yn)/2);
midzn=ceil(length(zn)/2);

figure(4);
[X,Z] = meshgrid(xn,zn);
quiver(X,Z,squeeze(B(1,:,midyn,:))' , squeeze(B(3,:,midyn,:))')  %faz o gr�fico vetorial de B no plano z =0
xlabel('eixo x (m)')
ylabel('eixo Z (m)')
title('B, plano XZ (y=0)');

H=B/u0;
pontoz = ceil(0.75*length(zn));
disp(norm(H(:,midxn,midyn,pontoz)));