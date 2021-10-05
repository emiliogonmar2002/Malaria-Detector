function resultado = globuloCalculo_2(tamanoPlacaN,tamanoPlacaP,distanciaPlacas,n,x_globulo,y_globulo,z_globulo,dG)
dm = 0.5; %Incremento entre puntos 

% Lado izquiero del Glóbulo
radioG = dG/2;
xg_izq = x_globulo - radioG;
yg_izq = y_globulo;

%Lado derecho del Glóbulo
xg_der = x_globulo + radioG;
yg_der = y_globulo;

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

%Calcular campos de la placa positiva 
Ex = zeros(length(X)); 
Ey = zeros(length(Y));
Ez = zeros(length(Z));

Ri = zeros(length(n));
Rd = zeros(length(n));
Rz = zeros(length(n));

Ex_izq = 0;
Ey_izq = 0;
Ez_izq = 0;

Ex_der = 0;
Ey_der = 0;
Ez_der = 0;

for j = 1:n 
    
    Xpi = positiveX(j); 
    Ypi = positiveY(j);
    Zpi = positiveZ(j);
    
    Xni = negativeX(j);    
    Yni = negativeY(j);
    Zni = negativeZ(j);
    
    
    xii = xg_izq-Xni;
    yii = yg_izq-Yni;
    zii = z_globulo-Zni;
    
    rii = sqrt(xii.^2 + yii.^2 + zii.^2);
    
    xid = xg_der-Xpi;
    yid = yg_izq-Ypi;
    zid = z_globulo-Zpi;
    
    rid = sqrt(xid.^2 + yid.^2 + zii.^2);
    
    Exii = (k*-Q*xg_izq)/rii.^3;
    Eyii = (k*-Q*yg_izq)/rii.^3;
    Ezii = (k*-Q*y_globulo)/rii.^3;
    
    Ex_izq = Ex_izq + Exii;
    Ey_izq = Ey_izq + Eyii;
    Ez_izq = Ez_izq + Ezii;
    
    Exid = (k*Q*xg_der)/rid.^3;
    Eyid = (k*Q*yg_der)/rid.^3;
    Ezid = (k*Q*z_globulo)/rid.^3;
    
    Ex_der = Ex_der + Exid;
    Ey_der = Ey_der + Eyid;
    Ez_der = Ez_der + Ezid;
   
              
end

E_izq = sqrt(Ex_izq.^2+Ey_izq.^2+Ez_izq.^2);
E_der = sqrt(Ex_der.^2+Ey_der.^2+Ez_der.^2);

dif_campos = abs(E_izq-E_der);

if dif_campos >= 1.8645e-11
    resultado = "Infectado";
else
    resultado = "Sano";
end

end


