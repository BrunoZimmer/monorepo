%% Quest�o 9                    Arthur A S Ara�jo
% Encontre numericamente o potencial vetorial magn�tico de um segmento 
% finito de fio reto pelo qual passa a corrente I. Coloque o fio no 
% eixo z, de z1 a z2. A partir do potencial vetorial magn�tico calcule 
% a densidade de fluxo magn�tico. Afim de avaliar a sua reposta  calcule 
% a magnitude do potencial vetorial magn�tico num ponto 
% P( x= 9,7 m, y =0, z =0), considerando I = 1,8 A, z1 = 1,9 m e z2 = 6,3 m.

%% Vari�veis Dadas
clc
clear all;
close all;

u0 = 4*pi*10^-7; % permeablidade do espa�o livre (em H/m)

z_inf = 2.3;
z_sup = 7.8;

Ponto_x = 3.4;
L = z_sup - z_inf; %comprimento do filamento (em m)
I = 5.9; %corrente no filamento

%% Vari�veis Criadas
%limites das coordendas x, y, z onde ser� calculado A
limx = 2*Ponto_x;
limy = L;
limz = L;

%passos
dx = Ponto_x/20;
dy = L/20;
dz = L/20;

%posi��es onde ser� calculado A
x = [-limx:dx:limx];
y = [-limy:dy:limy];
z = [-2*limz:dz:2*limz];

%vou dividir o filamento em segmentos de tamanho dzl
dzl=L/20; %passo

%posi��es centrais dos segmentos do filmaento
zl = [z_inf+dzl/2:dzl:z_sup-dzl/2];

%incializa o potencial vetorial magn�tico
A(1,:,:,:) = zeros(length(x),length(y),length(z));      %Componente x do potencial vetorial magn�tico
A(2,:,:,:) = zeros(length(x),length(y),length(z));      %Componente y do potencial vetorial magn�tico
A(3,:,:,:) = zeros(length(x),length(y),length(z));      %Componente z do potencial vetorial magn�tico

%% Desenvolvimento: Calcula Potencial A
for i = 1:length(x) % varre a coordenada x onde ser� calculado A
    disp(i)
    for j = 1:length(y)% varre a coordenada y onde ser� calculado A
        for k = 1 : length(z)% varre a coordenada z onde ser� calculado A
            for kl=1:length(zl) % varre a coordenada zl onde est� a carga
                
                I_dl = I*dzl*[0,0,1]; %produto Idl, % dl = dz az
                
                r = [x(i),y(j),z(k)]; % vetor posi��o onde calculamos A
                rl= [0,0,zl(kl)]; % vetor posi��o de um segmento dzl
                
                dA = I_dl/sqrt( (r-rl)*(r-rl)'); % contribui��o para o potencial A devido a a corrente I no segmento dzl
                
                A(1,i,j,k)=A(1,i,j,k)+dA(1); %soma em Ax a componente x da contribui��o em dA
                A(2,i,j,k)=A(2,i,j,k)+dA(2);%soma em Ay a componente y da contribui��o em dA
                A(3,i,j,k)=A(3,i,j,k)+dA(3);%soma em Az a componente z da contribui��o em dA
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
%�ndice do valor m�dio dos vetores x, y e z,
xmed=ceil(length(x)/2);
ymed=ceil(length(y)/2);
zmed=ceil(length(z)/2);

figure(1);
[X,Z] = meshgrid(x,z);
quiver(X, Z, squeeze(A(1,:,ymed,:))', squeeze(A(3,:,ymed,:))');  %faz o gr�fico de A no plano y = 0
xlabel('eixo x (m)')
ylabel('eixo z (m)')
title('A, plano XZ (y=0)');

figure(2);
[X,Y] = meshgrid(x,y);
surf(X, Y, squeeze(A(3,:,:,length(z)))');  %faz o gr�fico de A no plano y = 0
xlabel('eixo x (m)')
ylabel('eixo y (m)')
title('A, plano XY (z=0)');

%% Plot B
midzn = ceil(length(zn)/2);

figure(3);
[X,Y] = meshgrid(xn,yn);
quiver(X,Y,squeeze(B(1,:,:,midzn))' , squeeze(B(2,:,:,midzn))')  %faz o gr�fico vetorial de B no plano z =0
xlabel('eixo x (m)')
ylabel('eixo y (m)')
title('B, plano XY (z=0)');

%% Disp
pontox = ceil(0.75*length(x));
disp('A no ponto (9,7; 0; 0) vale:');
disp(norm(A(:,pontox,ymed,zmed)));