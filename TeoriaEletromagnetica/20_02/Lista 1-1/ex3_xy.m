%% Quest�o 3
% Considere uma linha de carga, no eixo z, com densidade linear de cargas
% uniforme pL = 1 C/m, se estendendo de z = -1 m at� z = 1 m. Calcule,
% numericamente, a intensidade de campo el�trico E em qualquer posi��o espa�o.
% Fa�a uma representa��o gr�fica de E no plano xz e uma no plano xy.


%% Variaveis Dadas
clc
clear all
close all

z1=-1;
z2=1;
pL=1;  %Densidade Superficial de Carga [C/m^2]
k=1/(4*pi*8.854*10^(-12));  %Constante

%% Variaveis Criadas

%Onde o campo sera medido:
x=[-2:1/20:2]; %vetor na coordenada x onde ser� calculado E
z=[-2:1/20:2]; %vetor na coordenada z onde ser� calculado E
y=[-2:1/20:2]; %vetor na coordenada y onde ser� calculado E

%Gerador do campo:
zl=[z1:1/20:z2]; % varia��o da coordenada x onde est� a carga (centro dos segmentos)

%A = 1; %�rea de cada segmento

%inicializa o campo el�trico:
E(1,:,:) = zeros (length(x),length(y)); 
E(2,:,:) = zeros (length(x),length(y));
E(3,:,:) = zeros (length(x),length(y));

%% Desenvolvimento
for i = 1:length(x)% varre a coordenada x onde E ser� calculado
    for j = 1: length(y)  % varre a coordenada y onde E ser� calculado
        
        for m = 1:length(zl)  % varre a coordenada x da carga
                
                r = [x(i),y(j),0]; %vetor posi��o apontando para onde estamos calculando E
                rl= [0,0,zl(m)];% vetor posi��o apontando para um segmento da placa
                
                if ((r-rl)*(r-rl)'>1/100) %??????
                E(:,i,j) = E(:,i,j)  + (pL*1/sqrt((r-rl)*(r-rl)')^3*(r-rl))'; % para cada ponto (xl, yl)  da placa somo a contribui��o da carga para o campo na posi��o (x,z). Considero a carga concentrada no centro do segmento.
                end

        end
        
    end
end
E= E*k;

%% Grafico
[X,Y] = meshgrid(x,y);
quiver(X,Y,squeeze(E(1,:,:))' , squeeze(E(2,:,:))')  %faz o gr�fico vetorial
xlabel('eixo x (m)')
ylabel('eixo y (m)')

