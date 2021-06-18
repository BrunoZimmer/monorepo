%% Quest�o 9                Arthur A. S. Ara�jo
% Um longo cilindro de raio a tem magnetiza��o M = k*rho^2 �phy, onde k � uma constante.
% Determine numericamente o campo vetorial magnetiza��o. Trace um gr�fico de M
% em um plano paralelo �s linhas de campo. A partir de M, determine numericamente
% as densidades de corrente ligadas, e trace o gr�ficos dessas densidades, escolhendo
% o plano de visualiza��o mais conveniente. A partir dessas densidades, determine a
% densidade de fluxo magn�tico em todo o espa�o. Trace um gr�fico da densidade
% de fluxo magn�tico no mesmo plano escolhido para M (em um gr�fico separado).

%% Vari�veis fornecidas
clc
clear all
close all

u0=4*pi*10^(-7);
a = 0.1;% raio do cilindro
k0 = 6.1; %[A/m^2]

%% Vari�veis Criadas
lim = 2*a;
passo = a/12;

dx = passo;
dy = passo;
dz = passo;

dphi = 2*pi/7;
drho = a/2;

x = [-lim:dx:lim]; %varia��o da coordenada x onde ser� calculado M
y = [-lim:dy:lim]; %varia��o da coordenada y onde ser� calculado M
z = [-lim:dz:lim]; %varia��o da coordenada z onde ser� calculado M

phil = [0:dphi:2*pi-dphi/2];
rhol = [0:drho:a];
zl = [-(2*lim+dz/2):dz:(2*lim+dz/2)];

% Inicializa M
M(1,:,:,:) = zeros(length(x),length(y),length(z));
M(2,:,:,:) = zeros(length(x),length(y),length(z));
M(3,:,:,:) = zeros(length(x),length(y),length(z));

xn = (x(2:end-1));
yn = (y(2:end-1));
zn = (z(2:end-1));
% Inicializa J
Jb = zeros (1,length(xn),length(yn),length(zn)); %componente x
Jb = zeros (2,length(xn),length(yn),length(zn)); %componente y
Jb = zeros (3,length(xn),length(yn),length(zn)); %componente z

% Inicializa Kb
Kb = zeros (1,length(xn),length(yn),length(zn)); %componente x
Kb = zeros (2,length(xn),length(yn),length(zn)); %componente y
Kb = zeros (3,length(xn),length(yn),length(zn)); %componente z

% Inicializa o potencial vetorial magn�tico
A = zeros(1,length(xn),length(yn),length(zn));%Componente x do potencial vetorial magn�tico
A = zeros(2,length(xn),length(yn),length(zn));%Componente y do potencial vetorial magn�tico
A = zeros(3,length(xn),length(yn),length(zn));%Componente z do potencial vetorial magn�tico

xnn = (xn(2:end-1));
ynn = (yn(2:end-1));
znn = (zn(2:end-1));
% Inicializa B
B = zeros (1,length(xnn),length(ynn),length(znn)); %inicializa a densidade de fluxo magn�tico B, componente x
B = zeros (2,length(xnn),length(ynn),length(znn)); %componente y
B = zeros (3,length(xnn),length(ynn),length(znn)); %componente z

%% Calcula M
for i = 1:length(x)% varre a coordenada x onde M será calculado
    disp(i)
    for j = 1: length(y)  % varre a coordenada y onde M será calculado
        for k = 1:length(z) % varre a coordenada z onde M será calculado
            
            raio = sqrt(x(i)^2+y(j)^2);
            if (raio<=a)
                M(1,i,j,k) = k0*(raio^2)*(-y(j)/raio); %-const_k*sin(phil)*(rhol(n))^2;
                M(2,i,j,k) = k0*(raio^2)*(x(i)/raio);  %const_k*cos(phil)*(rhol(n))^2;
                M(3,i,j,k) = 0;
            end
            
        end
    end
end

%% Calcula Jb -> Rot(M)
for i = 2:length(x)-1% varre a coordenada x onde Jb ser� calculado
    disp(i)
    for j = 2 :length(y)-1 % varre a coordenada y onde Jb ser� calculado
        for k = 2: length(z)-1  % varre a coordenada z onde Jb ser� calculado
            if (x(i)^2+y(j)^2<=(a-((dx+dy)*(sqrt(2)/2)))^2)
                
                dMz_dy = (M(3,i,j+1,k)-M(3,i,j-1,k))/2/dy; %derivada de Mz em rela��o a y
                dMy_dz = (M(2,i,j,k+1)-M(2,i,j,k-1))/2/dz; %derivada de My em rela��o a z
                
                dMx_dz = (M(1,i,j,k+1)-M(1,i,j,k-1))/2/dz; %derivada de Mx em rela��o a z
                dMz_dx = (M(3,i+1,j,k)-M(3,i-1,j,k))/2/dx;%derivada de Mz em rela��o a x
                
                dMy_dx = (M(2,i+1,j,k)-M(2,i-1,j,k))/2/dx; %derivada de My em rela��o a x
                dMx_dy = (M(1,i,j+1,k)-M(1,i,j-1,k))/2/dy;%derivada de Mx em rela��o a y
                
                Jb(1,i-1,j-1,k-1) = dMz_dy-dMy_dz; %a componente x de Jb � dMz/dy-dMy/dz
                Jb(2,i-1,j-1,k-1) = dMx_dz-dMz_dx;%a componente y de Jb � dMx/dz-dMz/dx
                Jb(3,i-1,j-1,k-1) = dMy_dx-dMx_dy;%a componente z de Jb � dMy/dx-dMx/dy
            end
        end
    end
end

%% Calcula Kb -> M x �n
for i = 2:length(x)-1
    disp(i)
    for j = 2 :length(y)-1
        for k = 2: length(z)-1 
            
            for m = 1:length(phil)
                for n =1:length(rhol)
                    for o = 1:length(zl)
                        
                        an = [0,1,0]; %�(pho)  %(THETA,RHO,Z)
                        raio = sqrt(x(i)^2+y(j)^2);
                        
                        if (raio > 0.95*a && raio < 1.05*a) %existe somente da casca
                            vetorial = cross(an,[(k0*(rhol(n))^2),0,0]);    %PQ Negativo?
                            [vetorial_ret(1),vetorial_ret(2),vetorial_ret(3)] = pol2cart(vetorial(1),vetorial(2),vetorial(3));
                            Kb(:,i-1,j-1,k-1) = vetorial_ret;
                            
                        end
                        
                    end
                end
            end
        end
    end
end

%% Calcula A -> Int(Jb)' + Int(Kb)'
for i = 1:length(xn)% varre a coordenada x onde A ser� calculado
    disp(i)
    for j = 1: length(yn)  % varre a coordenada y onde A ser� calculado
        for k = 1:length(zn) % varre a coordenada z onde A ser� calculado
            
            for m = 1:length(phil)  % varre a coordenada phil, onde existe a corrente
                for n =1:length(rhol)
                    for o = 1:length(zl)
                        
                        r = [xn(i),yn(j),zn(k)];  % vetor posi��o onde calculamos A
                        [rl(1), rl(2), rl(3)] = pol2cart(phil(m), rhol(n), zl(o)); % convertemos rl para coord retangulares
                        
                        raio = sqrt(x(i)^2+y(j)^2);
                        
                        if (raio<a)
                            dV = rhol(n)*drho*dz*dphi;
                            
                            dAx = (Jb(1,i,j,k)*dV)/sqrt((r-rl)*(r-rl)'); % contribui��o para o potencial A devido a a corrente I no segmento dzl
                            dAy = (Jb(2,i,j,k)*dV)/sqrt((r-rl)*(r-rl)');
                            dAz = (Jb(3,i,j,k)*dV)/sqrt((r-rl)*(r-rl)');
                            
                            A(1,i,j,k)=A(1,i,j,k) + dAx; %soma em Ax a componente x da contribui��o em dA
                            A(2,i,j,k)=A(2,i,j,k) + dAy; %soma em Ay a componente y da contribui��o em dA
                            A(3,i,j,k)=A(3,i,j,k) + dAz; %soma em Az a componente z da contribui��o em dA
                        end
                        
                        if (raio > 0.95*a && raio < 1.05*a) %existe somente da casca
                            [rl(1), rl(2), rl(3)] = pol2cart(phil(m), a, zl(o));
                            dS = a*dphi*dz;
                            
                            dAx_k = (Kb(1,i,j,k)*dS)/sqrt((r-rl)*(r-rl)'); % contribui��o para o potencial A devido a a corrente I no segmento dzl
                            dAy_k = (Kb(2,i,j,k)*dS)/sqrt((r-rl)*(r-rl)');
                            dAz_k = (Kb(3,i,j,k)*dS)/sqrt((r-rl)*(r-rl)');
                            
                            A(1,i,j,k)=A(1,i,j,k)+dAx_k; %soma em Ax a componente x da contribui��o em dA
                            A(2,i,j,k)=A(2,i,j,k)+dAy_k;%soma em Ay a componente y da contribui��o em dA
                            A(3,i,j,k)=A(3,i,j,k)+dAz_k;%soma em Az a componente z da contribui��o em dA
                        end
                    end
                end
            end
        end
    end
end
A=(u0/(4*pi))*A;

%% Calcula B  -> Rot(A)
for i = 2:length(xn)-1           % varre a coordenada x onde B ser� calculado
    disp(i);
    for j = 2 :length(yn)-1      % varre a coordenada y onde B ser� calculado
        for k = 2: length(zn)-1  % varre a coordenada z onde E ser� calculado
            
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

%% Plot M
midx=ceil(length(x)/2);
midy=ceil(length(y)/2);
midz=ceil(length(z)/2);

figure(1)
[X,Y] = meshgrid(x,y);
quiver(X, Y, squeeze(M(1,:,:,midz))', squeeze(M(2,:,:,midz))');
xlabel('eixo x (m)')
ylabel('eixo y (m)')
title('M no plano xy');

%% Plot Jb
midxn=ceil(length(xn)/2);
midyn=ceil(length(yn)/2);
midzn=ceil(length(zn)/2);

figure(2)
[X,Z] = meshgrid(xn,zn);
quiver(X,Z,squeeze(Jb(1,:,midyn,:))' , squeeze(Jb(3,:,midyn,:))')
xlabel('eixo x (m)')
ylabel('eixo Z (m)')
title('J, plano XZ (y=0)');

figure(3)
[Y,Z] = meshgrid(yn,zn);
quiver(Y,Z,squeeze(Jb(2,midxn,:,:))' , squeeze(Jb(3,midxn,:,:))')
xlabel('eixo y (m)')
ylabel('eixo Z (m)')
title('J, plano YZ (x=0)');

%% Plot Kb
figure(4);
[Y,Z] = meshgrid(yn,zn);
quiver(Y, Z, squeeze(Kb(2,midxn,:,:))', squeeze(Kb(3,midxn,:,:))');
xlabel('eixo y (m)')
ylabel('eixo z (m)')
title('Kb no plano yz');

figure(5);
[X,Z] = meshgrid(xn,zn);
quiver(X, Z, squeeze(Kb(1,:,midyn,:))', squeeze(Kb(3,:,midyn,:))');
xlabel('eixo x (m)')
ylabel('eixo z (m)')
title('Kb no plano xz');

%% Plot A
figure(6)
[X,Z] = meshgrid(xn,zn);
quiver(X,Z,squeeze(A(1,:,midyn,:))' , squeeze(A(3,:,midyn,:))')
xlabel('eixo x (m)')
ylabel('eixo Z (m)')
title('A, plano XZ (y=0)');

figure(7)
[Y,Z] = meshgrid(yn,zn);
quiver(Y,Z,squeeze(A(2,midxn,:,:))' , squeeze(A(3,midxn,:,:))')
xlabel('eixo y (m)')
ylabel('eixo Z (m)')
title('A, plano YZ (x=0)');

%% Plot B
%GR�FICO DE B EM XZ
midxnn=ceil(length(xnn)/2);
midynn=ceil(length(ynn)/2);
midznn=ceil(length(znn)/2);

[X,Z] = meshgrid(xnn,ynn);
figure(8)
quiver(X,Z,squeeze(B(1,:,:,midznn))' , squeeze(B(2,:,:,midznn))')
xlabel('eixo x (m)')
ylabel('eixo z (m)')
title('B, plano XZ (y=0)');