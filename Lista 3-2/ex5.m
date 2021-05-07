%% Quest�o 5
%Um fio reto de comprimento infinito transporta uma corrente I(t) = kt
%(onde k � uma constante), para t > 0. Encontre, numericamente, os campos
%el�trico e magn�tico gerados. Afim de avaliar a sua resposta calcule a
%magnitude da densidade de fluxo magn�tico, num instante t = 12,3 ns a uma
%dist�ncia ? = 1,8 m do fio e considere k = 1 A/s.
%Fa�a representa��es gr�ficas de A, E e B nos planos xy, xz e yz.
%Obs.: considere a velocidade da luz c = 3x10^8 m/s

%% Vari�veis Dadas
clc
clear all
close all

u0=4*pi*10^(-7);
c = 3*10^(8); %vel. da luz
I0 = 1; %corrente
lim = 4;
const_k=1;
t = 12.3*10^(-9);

%% Vari�veis Criadas
passo=lim/5; % passo

dx=passo;
dy=passo;
dz=passo;

x= -1.5*lim:dx:1.5*lim; %variacao da coordenada x
y= -1.5*lim:dy:1.5*lim; %variacao da coordenada y
z= -1.5*lim:dz:1.5*lim; %variacao da coordenada z

%fio infinito centrado em xy
xl=0;
yl=0;
zl= -2*lim:dz:2*lim;

%varia��o de tmepo
dt = t/20;
t = 0:dt:2*t;

xmedio = ceil(length(x)/2);
ymedio = ceil(length(y)/2);
zmedio = ceil(length(z)/2);
tmedio = ceil(length(t)/2);

%% Descobrindo valor do campo A
A = zeros(3, length(x), length(y), length(z), length(t));

for p = 1:length(t)
    disp(p)
    for i = 1:length(x)
        for j = 1:length(y)
            for k = 1:length(z)
                
                r = [x(i),y(j),z(k)];  %vetor posição do ponto de campo (onde calculamos B)
                dL = dz;
                
                for u = 1:length(zl)
                    
                    rl = [0,0,zl(u)];
                    modulo = norm(r-rl);
                    
                    Ir=[0,0,const_k*(t(p)- modulo/c)];
                    
                    if  ((t(p)- modulo/c) > 0)
                        dA = (Ir) /modulo;
                        A(1,i,j,k,p) = A(1,i,j,k,p) + dA(1)*dL;
                        A(2,i,j,k,p) = A(2,i,j,k,p) + dA(2)*dL;
                        A(3,i,j,k,p) = A(3,i,j,k,p) + dA(3)*dL;
                    end
                end
            end
        end
    end
end
A = ( u0/(4*pi) ) * A;

%% Plot A
%gr�fico vetorial de A no plano XY
[X,Y] = meshgrid(x,y);
figure (1);
quiver(X, Y, squeeze(A(1,:,:,zmedio,tmedio))', squeeze(A(2,:,:,zmedio,tmedio))');
hold
contour(x,y,squeeze(A(3,:,:,zmedio,tmedio))',40);
xlabel('eixo x (m)')
ylabel('eixo y (m)')
title('A, plano XY (z=0)');

%gr�fico vetorial de A no plano YZ
[Y,Z] = meshgrid(y,z);
figure (2);
quiver(Y, Z, squeeze(A(2,xmedio,:,:,tmedio))', squeeze(A(3,xmedio,:,:,tmedio))');
xlabel('eixo y (m)')
ylabel('eixo z (m)')
title('A, plano YZ (x=0)');

%gr�fico vetorial de A no plano XZ
[X,Z] = meshgrid(x,z);
figure (3);
quiver(X, Z, squeeze(A(1,:,ymedio,:,tmedio))', squeeze(A(3,:,ymedio,:,tmedio))');
xlabel('eixo x (m)')
ylabel('eixo z (m)')
title('A, plano XZ (y=0)');

%% Calculo de B a partir do rotacional de A
% rotacional de A
%Derivada � um espa�o menor tirando o "cantos" do espa�o
xn = (x(2:end-1));
yn = (y(2:end-1));
zn = (z(2:end-1));
tn = (t(2:end-1));

%Zerando densidades de corrente ligadas
B  = zeros (3,length(xn),length(yn),length(zn),length(t));

%rot M = (dAz/dy-dAy/dz) ax + (dAx/dz-dAz/dx) ay + (dAy/dx-dAx/dy) az
for p = 1:length(t)
    disp(p);
    for i = 2:length(x)-1
        for j = 2 :length(y)-1
            for k = 2: length(z)-1
                
                dAz_dy= (A(3,i,j+1,k,p)-A(3,i,j-1,k,p))/2/dy; %derivada de Az em rela��o a y
                dAy_dz = (A(2,i,j,k+1,p)-A(2,i,j,k-1,p))/2/dz; %derivada de Ay em rela��o a z
                
                dAx_dz=(A(1,i,j,k+1,p)-A(1,i,j,k-1,p))/2/dz; %derivada de Ax em rela��o a z
                dAz_dx=(A(3,i+1,j,k,p)-A(3,i-1,j,k,p))/2/dx;%derivada de Az em rela��o a x
                
                dAy_dx=(A(2,i+1,j,k,p)-A(2,i-1,j,k,p))/2/dx; %derivada de Ay em rela��o a x
                dAx_dy=(A(1,i,j+1,k,p)-A(1,i,j-1,k,p))/2/dy;%derivada de Ax em rela��o a y
                
                B(1,i-1,j-1,k-1,p) = dAz_dy-dAy_dz; %a componente x de B � dAz_dy-dAy_dz
                B(2,i-1,j-1,k-1,p) = dAx_dz-dAz_dx;%a componente y de B � dAx_dz-dAz_dx
                B(3,i-1,j-1,k-1,p) = dAy_dx-dAx_dy;%a componente z de B � dAy_dx-dAx_dy
                
            end
        end
    end
end


%% Plot B
xmedio2=ceil(length(xn)/2);
ymedio2=ceil(length(yn)/2);
zmedio2=ceil(length(zn)/2);

%gr�fico vetorial de B no plano XY
[X,Y] = meshgrid(xn,yn);
figure (4);
quiver(X, Y, squeeze(B(1,:,:,zmedio2,tmedio))', squeeze(B(2,:,:,zmedio2,tmedio))');
xlabel('eixo x (m)')
ylabel('eixo y (m)')
title('B, plano XY (z=0)');

%gr�fico vetorial de B no plano YZ
[Y,Z] = meshgrid(yn,zn);
figure (5);
quiver(Y, Z, squeeze(B(2,xmedio2,:,:,tmedio))', squeeze(B(3,xmedio2,:,:,tmedio))');
xlabel('eixo y (m)')
ylabel('eixo z (m)')
title('B, plano YZ (x=0)');

%gr�fico vetorial de A no plano XZ
[X,Z] = meshgrid(xn,zn);
figure (6);
quiver(X, Z, squeeze(B(1,:,ymedio2,:,tmedio))', squeeze(B(3,:,ymedio2,:,tmedio))');
xlabel('eixo x (m)')
ylabel('eixo z (m)')
title('B, plano XZ (y=0)');

%% Calculo de E a partir da derivada negativa de A
%Zerando densidades de corrente ligadas
E = zeros (3,length(x),length(y),length(z),length(tn));
%E= -dA/dt
for p = 2:length(t)-1
    disp(p);
    for i = 1:length(x)
        for j = 1:length(y)
            for k = 1:length(z)
                
                dAx_dt= (A(1,i,j,k,p+1)-A(1,i,j,k,p-1))/(2*dt); %derivada de Ax em rela��o a t
                dAy_dt= (A(2,i,j,k,p+1)-A(2,i,j,k,p-1))/(2*dt); %derivada de Ay em rela��o a t
                dAz_dt= (A(3,i,j,k,p+1)-A(3,i,j,k,p-1))/(2*dt); %derivada de Az em rela��o a t
                
                E(1,i,j,k,p-1) = dAx_dt;
                E(2,i,j,k,p-1) = dAy_dt;
                E(3,i,j,k,p-1) = dAz_dt;
                
            end
        end
    end
end

%% Plot E
tmedio2=ceil(length(tn)/2);

%gr�fico vetorial de E no plano XY
[X,Y] = meshgrid(x,y);
figure (7);
quiver(X, Y, squeeze(E(1,:,:,zmedio,tmedio2))', squeeze(E(2,:,:,zmedio,tmedio2))');
xlabel('eixo x (m)')
ylabel('eixo y (m)')
title('E, plano XY (z=0)');

%gr�fico vetorial de E no plano YZ
[Y,Z] = meshgrid(y,z);
figure (8);
quiver(Y, Z, squeeze(E(2,xmedio,:,:,tmedio2))', squeeze(E(3,xmedio,:,:,tmedio2))');
xlabel('eixo y (m)')
ylabel('eixo z (m)')
title('E, plano YZ (x=0)');

%gr�fico vetorial de A no plano XZ
[X,Z] = meshgrid(x,z);
figure (9);
quiver(X, Z, squeeze(E(1,:,ymedio,:,tmedio2))', squeeze(E(3,:,ymedio,:,tmedio2))');
xlabel('eixo x (m)')
ylabel('eixo z (m)')
title('E, plano XZ (y=0)');

