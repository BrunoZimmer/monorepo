%% Quest�o 5                Arthur A. S. Ara�jo
% Determine, numericamente, a indut�ncia m�tua entre um longo fio reto 
% e uma espira em formato de tri�nguilo equil�tero de labo b (em metros). 
% Um dos v�rtices do tri�ngulo � o ponto mais pr�ximo do fio, e est� a 
% uma dist�ncia d (em metros), conforme a figura. Para avaliar sua resposta,
% considere b=9 cm e d=5 cm.

%% Vari�veis fornecidas
clc
clear all
close all

u0 = 4*pi*10^(-7); %permeabilidade magn�tica do espa�o livre (em H/m)

b = 9*10^(-2); %lado tri�ngulo (em m)
d = 5*10^(-2); %dist�ncia (em m)

h = b*sqrt(3)/2; %altura do tri�ngulo

I = [0,0,1]; %corrente arbitr�ria (em A)

%% Vari�veis Criadas
lim = 1.5*(d+h); %limite para as coordenadas x e y
passo = d/2;

%varia��o das coordenadas onde ser� calculado B
dx = passo;
dy = passo;
dz = passo;

x = [-lim:dx:lim];
y = [-lim:dy:lim];
z = [-b:dz:b];

%varia��o das coordenadas do fio
zl = [-2*lim+dz/2:dz:2*lim-dz/2];

%inicializa a densidade de fluxo magn�tico B
B(1,:,:,:) = zeros(length(x),length(y),length(z));
B(2,:,:,:) = zeros(length(x),length(y),length(z));
B(3,:,:,:) = zeros(length(x),length(y),length(z));

%�ndices para x = y = z = 0
midx = ceil(length(x)/2);
midy = ceil(length(y)/2);
midz = ceil(length(z)/2);

%% Calcula B Fio
for i = 1:length(x) %varre as coordenadas onde B2 ser� calculado
    disp(i)
    for j = 1:length(y)
        for k = 1:length(z)
            
            for n = 1:length(zl) %varre a coordenada do fio

                r = [x(i),y(j),z(k)];  %vetor posi��o do ponto de campo (onde calculamos B)
                rl1 = [0,0,zl(n)]; %vetor posi��o do fio

                    if ((r-rl1)*(r-rl1)' > (dz/2)^2) %evitando a divis�o por zero, no caso em que r = rl

                    dL = dz;
                    I_x_rrl = cross(I, r-rl1);
                    dB = (I_x_rrl')*dL / (((r-rl1)*(r-rl1)')^(3/2)); %essa � a contribui��o dB devida a I

                    B(:,i,j,k) = B(:,i,j,k) + dB;

                    end
            end
        end
    end
end
B = B*u0/(4*pi);

%% Calcula Fluxo
%calcular o fluxo magn�tico
psi = 0; 
for j = 1:length(y) %varre as coordenadas onde Psi ser� calculado
    disp(i)
    for k = 1:length(z)
        
        if( (z(k) <= 1/sqrt(3)*(y(j)-d)) && (z(k) >= -1/sqrt(3)*(y(j)-d)) && (y(j) >= d) && (y(j)<= d+h) )
            %psi = integral(Bfio*dS2)
            psi = psi + dot(B(:,midx,j,k),[-dy*dz,0,0]);
        end
    end
end

L = psi/norm(I);
disp(L);    %A resposta correta �: 7,15093871e-9 H.
% Encontrado: 7.3920e-09

%% Plot B
%gr�fico vetorial de B no plano XY
[X,Y] = meshgrid(x,y);
figure (1);
quiver(X, Y, squeeze(B(1,:,:,midz))', squeeze(B(2,:,:,midz))'); 
line([d,d+h], [0, 0], 'Color', 'r');
xlabel('eixo x (m)')
ylabel('eixo y (m)')
title('B, plano XY (z=0)');
