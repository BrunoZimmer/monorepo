%% Quest�o 10                           Arthur A S Ara�jo
% Uma l�mina de corrente K flui na regi�o  -a < y < a no plano z =0.
% A partir da densidade de corrente K, calcule numericamente a intensidade
% de campo magn�tico gerado por essa l�mina em qualquer posi��o do espa�o.
% Afim de avaliar sua resposta calcule a componente y da intensidade de 
% campo magn�tico na posi��o (x = 0, y = 0, z = 2,6 m), 
% considere K = 2,3 ax A/m e a = 5,6 m.

%% Vari�veis Dadas
clc
clear all
close all

a = 5.6;        % limite da l�mina
kx = 2.3;       %na dire��o ax
z1 = 2.6;

%% Vari�veis Criadas
lim = 2*a; % limite para as coordenadas x, y e z
passo = a/6; % passo

dx=passo;
dy=passo;
dz=passo;

x=[-a/2:dx:a/2];            %variação da coordenada x onde será calculado H
y=[-lim:dy:lim];            %variação da coordenada y onde será calculado H
z=[-2*z1:dz:2*z1];        %variação da coordenada z onde será calculado H

xl=[-lim+dx:dx:lim];           %variação da coordenada x onde est� a carga
yl=[-a+dy:dy:a];               %variação da coordenada y onde est� a carga

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
                    
                    K = [kx, 0, 0];
                    
                    % Agora calculamos o produto vetorial K x (r-rl)
                    K_x_rrl = cross(K, r-rl);              
                    
                    % Utilizamos a condi��o abaixo para evitar a divis�o por zero, no caso em que r e rl s�o iguais.
                    %if (yl(n)>=-a && yl(n)<=a)
                        if  ((r-rl)*(r-rl)' > dz/2)
                            
                            dH = K_x_rrl'/(sqrt((r-rl)*(r-rl)')^3); 
                            
                            H(1,i,j,k) = H(1,i,j,k) + dH(1)*dx*dy;
                            H(2,i,j,k) = H(2,i,j,k) + dH(2)*dx*dy;
                            H(3,i,j,k) = H(3,i,j,k) + dH(3)*dx*dy;
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

%% Resposta
disp('A componente y do campo magn�tico em x=0, y=0 e z=z_desejado vale:');
z_desejado = midz * 1.5;
disp(H(2,midx,midy,z_desejado));    %resp:   -0.8333

%% Plot
figure(1);
[Y,Z] = meshgrid(y,z);
quiver(Y, Z, squeeze(H(2,midx,:,:))', squeeze(H(3,midx,:,:))');

xlabel('eixo y (m)')
ylabel('eixo z (m)')
title('H, plano YZ (x=0)');
