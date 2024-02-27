clear all
close all
clc

load('proj_fit_03.mat');
x1_id=id.X{1};
x2_id=id.X{2};
x1_val = val.X{1};
x2_val = val.X{2};
y_id=id.Y;
y_val = val.Y;

mse_vector_id=[];
mse_vector_val=[];

for m=1:20
PHI_id=[];
PHI_val=[];
Y_id=[];
 Y_val=[];
 for n=1:41 % pt x1
    for k=1:41 %pt x2
       phi_id=[];
% for pentru puteriile indicilor 
        for i=0:1:m
            for j=0:1:m-i
                %g(x1(n),x2(k))
                phi_id(end+1)= (x1_id(n)^i).*(x2_id(k)^j);%phi pentru linie 1 x1 x2 x
            end
        end
        PHI_id=[PHI_id; phi_id];
        %Y_id(end+1)=y_id(n,k);
    end
 end

 for n=1:71
    for k=1:71 
        phi_val = [];
% for pentru puteriile indicilor 
        for i=0:1:m
            for j=0:1:m-i
                phi_val(end+1)=(x1_val(n)^i).*(x2_val(k)^j);
            end
        end
        PHI_val=[PHI_val;phi_val];
        %Y_val(end+1)=y_val(n,k);
    end
  end

 Y_id=[];
 Y_val=[];
 for j=1:41
     for i=1:41
         Y_id(end+1)=y_id(j,i);
     end
 end

 for j=1:71
    for i=1:71
        Y_val(end+1)=y_val(j,i);
    end
 end

theta=PHI_id\Y_id';
% parametrii theta
y_hat_identificare=PHI_id*theta;
y_hat_validare=PHI_val*theta;

%matrici pentru y hat
Y_hat_id_matrice = [];
Y_hat_val_matrice=[];

var = 0;
for j=1:41
    for i=1:41
        var = var + 1;
        Y_hat_id_matrice(j,i) = y_hat_identificare(var);
    end
end

var2 = 0;
for j=1:71
    for i=1:71  
        var2 = var2 + 1;
        Y_hat_val_matrice(j,i)=y_hat_validare(var2);
    end
end

%calcul erori MSE
N=length(y_id);
s_identificare=0;
for i=1:41
    for j=1:41
        s_identificare=s_identificare +(y_id(i,j)-Y_hat_id_matrice(i,j)).^2;
    end
end

N_validare=length(y_val);
s_validare=0;
for i=1:71
    for j=1:71
        s_validare=s_validare+(Y_hat_val_matrice(i,j)-y_val(i,j)).^2;
    end
end

MSE_identificare=(1/N)*s_identificare;
MSE_validare=(1/N_validare)*s_validare;

mse_vector_id(m)=MSE_identificare;
mse_vector_val(m)=MSE_validare;
end

mse_id=mse_vector_id';
mse_val=mse_vector_val';

[mse_min_id,index_id_minim]=min(mse_vector_id)
[mse_min_val,index_val_minim]=min(mse_vector_val)

% afisare
figure
surf(x1_id,x2_id,y_id);
colormap('cool')
hold on
surf(x1_id,x2_id, Y_hat_id_matrice,'FaceColor','g', 'EdgeColor', 'black');
title("Y hat identificare si Y identificare");
xlabel('x1');
ylabel ('x2')
zlabel('y')

figure
surf(x1_val,x2_val,y_val);
colormap("cool");
hold on
surf(x1_val,x2_val, Y_hat_val_matrice,'FaceColor','g', 'EdgeColor', 'black');
%colormap('cool')
title("Y hat validare si Y validare");
xlabel('x1');
ylabel ('x2')
zlabel('y')


figure
plot(mse_vector_id);
hold on
plot(index_id_minim,mse_min_id,'*r');
title("MSE identificare");
xlabel('m')
ylabel('msevector')
figure
plot(mse_vector_val,'r');
hold on
plot(index_val_minim,mse_min_val,'*g');
title("MSE validare");
xlabel('m')
ylabel('msevector')