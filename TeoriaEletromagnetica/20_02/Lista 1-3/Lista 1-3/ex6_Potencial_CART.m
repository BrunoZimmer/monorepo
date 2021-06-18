%% Quest�o 6
% Uma densidade superficial de carga, ?s, est� distribu�da em uma casca esf�rica de raio b, 
% centrada na origem e imersa no espa�o livre. Calcule, numericamente, a energia armazenada 
% na esfera por meio da considera��o da densidade de carga e do potencial. Calcule tamb�m a 
% energia armazenada no campo el�trico e mostre que esses dois resultados s�o id�nticos. 
% Avalie sua resposta considerando  ?s = 10,0 ?C/m� e b = 5,1 m. 

%% Vari�veis Dadas
clc
clear all
close all

e0=8.854*10^(-12); %permissividade do espa�o livre (em F/m)

b = 5.1; %raio a
ps = 10*10^-6; 

%% Vari�veis Criadas

passo = b/5;
lim = 2*b;

%Espa�o
x=[-lim:passo:lim]; %varia��o da coordenada x onde ser� calculado E
y=[-lim:passo:lim]; %varia��o da coordenada y onde ser� calculado E
z=[-lim:passo:lim]; %varia��o da coordenada z onde ser� calculado E

dphi = pi/10;    %rad %passo da varia��o da coordenada phi que indica a posi��o de um elmento de carga.
dr = b/10;        %idem para coordenada radial
dtheta = pi/10;  %rad % idem para coordenada theta

thetal = [dtheta/2:dtheta:pi-dtheta/2];   % varia��o da coordenada theta onde est� a carga (j� em radianos)
phil = [dphi/2:dphi:2*pi-dphi/2];         % varia��o da coordenada phi onde est� a carga (j� em radianos)

%Potencial
V(:,:,:) = zeros (length(x), length(y), length(z));

%% Calcula Potencial Esfera INTERNA
for i = 1:length(x)% varre a coordenada x onde v ser� calculado
    disp(i);
    for j = 1: length(y)  % varre a coordenada z onde V ser� calculado
        for k = 1:length(z) % varre a coordenada z onde V ser� calculado
            
                for n = 1:length(phil) % varre a coordenada  phil da carga
                    for o = 1:length(thetal) %varre a coordenada  thetal da carga
                        
                        r = [x(i),y(j),z(k)]; %vetor posi��o apontando para onde estamos calculando V
                        [rl(1),rl(2),rl(3)] = sph2cart(phil(n), pi/2-thetal(o),b);% vetor posi��o apontando para um elemento de superficie dS.
                        
                        dV = b^2*sin(thetal(o))*dphi*dtheta; %elemento de volume na posi��o rl, phil, thetal.
                        
                        if (sqrt((r-rl)*(r-rl)')>0.001*b) %remove os pontos muito pr�ximos das cargas.
                            V(i,j,k) = V(i,j,k)  + (ps*dV/sqrt((r-rl)*(r-rl)'))';
                            
                        end
                        
                    end
                end
        end
    end
end

V= V/(4*pi*e0);

%% CALCULAR ENERGIA TOTAL ARMAZENADA A PARTIR DO CAMPO ELETRICO
We=0; %energia total armazenada

for i = 1:length(x)% varre a coordenada x do E
    disp(i);
    for j = 1: length(y)  % varre a coordenada y do E
        for k = 1:length(z) % varre a coordenada z do E
            if((sqrt(x(i)^2+y(j)^2+z(k)^2)<b)) %raio phi e theta
                We = We + (ps*V(i,j,k)*passo^3);
            else
                We = We + 0;
            end
        end
    end
end

We = We/2;

%% Plot
midz = int64(length(z)/2);
[X,Y] = meshgrid(x,y);
figure
contour(X,Y,squeeze(V(:,:,midz)),50)
colorbar
xlabel('eixo x (m)')
ylabel('eixo y (m)')
hold

disp(We);       %Resp: 9413,49 J.