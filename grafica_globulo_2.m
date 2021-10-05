function grafica_globulo_2(tamanoPlacaN,tamanoPlacaP,distanciaPlacas,n,x_globulo,y_globulo,z_globulo,dG)
cla;
dm = 0.5; %Incremento entre puntos 

%Crear malla 
x = -5:dm:5;
y = -5:dm:5;
z = -5:dm:5;
[X,Y,Z] = meshgrid(x,y,z); 

%Cargas y constantes de coulomb 
k = 8.987e9;
Q = 1.6e-19;

amp = 0.5;
positiveX = [ones(1,n).*distanciaPlacas];
positiveY = [linspace(-amp*tamanoPlacaP,amp*tamanoPlacaP,n)]; 

negativeX = [ones(1,n).*-distanciaPlacas]; 
negativeY = [linspace(-amp*tamanoPlacaN,amp*tamanoPlacaN,n)];

positiveZ = zeros(1,length(positiveX)); 
negativeZ = zeros(1,length(positiveX));

% positivePoints = [positiveX ; positiveY]'; 
% negativePoints = [negativeX ; negativeY]';

%Calcular campos de la placa positiva 
Ex = zeros(length(X)); 
Ey = zeros(length(Y));
Ez = zeros(length(Z));

%Campos X
for j = 1:n 
    Xpi = positiveX(j); 
    Xni = negativeX(j);  
    Ypi = positiveY(j);  
    Yni = negativeY(j);
    Zpi = positiveZ(j);
    Zni = positiveZ(j);
    
    Expi = k*(Q/n).*(X-Xpi)./((X-Xpi).^2+(Y-Ypi).^2).^1.5;  
    Exni =  k*(Q/n).*(X-Xni)./((X-Xni).^2+(Y-Yni).^2).^1.5; 
    Ex = Ex+Expi-Exni;
    
    Eypi = k*(Q/n).*(Y-Ypi)./((X-Xpi).^2+(Y-Ypi).^2).^1.5;  
    Eyni =  k*(Q/n).*(Y-Yni)./((X-Xni).^2+(Y-Yni).^2).^1.5; 
    Ey = Ey+Eypi-Eyni;
    
    Ezpi = k*(Q/n).*(Z-Zpi)./((X-Xpi).^2+(Y-Ypi).^2).^1.5;  
    Ezni =  k*(Q/n).*(Z-Zni)./((X-Xni).^2+(Y-Yni).^2).^1.5; 
    Ez = Ez+Ezpi-Ezni;
end


EE = sqrt(Ex.^2+Ey.^2+Ez.^2);
i=Ex./EE;
j=Ey./EE;
k=Ez./EE;

%Propiedades de las placas
v=0.5;
ancho = 0.2;
largoN = tamanoPlacaN;
largoP = tamanoPlacaP;
moverx = distanciaPlacas;

verticesP=[[v*ancho+moverx -v*largoP -v]; %v1
          [-v*ancho+moverx -v*largoP -v]; %v2
          [-v*ancho+moverx v*largoP -v];%v3
          [v*ancho+moverx v*largoP -v];%v4
          [v*ancho+moverx -v*largoP v];%v5
          [-v*ancho+moverx -v*largoP v];%v6
          [-v*ancho+moverx v*largoP v];%v7
          [v*ancho+moverx v*largoP v]];%v8
      
verticesN=[[v*ancho-moverx -v*largoN -v]; %v1
          [-v*ancho-moverx -v*largoN -v]; %v2
          [-v*ancho-moverx v*largoN -v];%v3
          [v*ancho-moverx v*largoN -v];%v4
          [v*ancho-moverx -v*largoN v];%v5
          [-v*ancho-moverx -v*largoN v];%v6
          [-v*ancho-moverx v*largoN v];%v7
          [v*ancho-moverx v*largoN v]];%v8

caras = [1 2 6 5; %cara xz frontal
         2 3 7 6; %cara zy frontal
         3 4 8 7; %cara 3
         1 4 8 5; %cara 4
         5 6 7 8; %cara arriba
         1 2 3 4];%cara abajo 
     

plot3(x_globulo,y_globulo,z_globulo,'red o','MarkerSize',dG*10+10) 
     
%Campo eléctrico 

hold on; 
quiver3(X,Y,Z,i,j,k,0.5,"b");
LaminaP = patch('Faces', caras, 'Vertices', verticesP, 'FaceColor', 'r');
LaminaN = patch('Faces', caras, 'Vertices', verticesN, 'FaceColor', 'b');
grid on; 
xlabel('X'); 
ylabel('Y'); 
zlabel('Z');
% axis equal;
title("Campo Eléctrico de 2 cargas")
box on;

rotate3d on;