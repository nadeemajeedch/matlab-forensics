 % verifica sul modello
 
 N=2048;          % dimensione dell'immagine
 Nb=2;
 N_window=7;     % dimensione della finestra di filtraggio
 sigma=1;        % deviazione standard del fltro
 
 
% generazione di una immagine sintetica con CFA di Bayer e interpolazione
% bicubica

DSC1=imread('C:\Users\Pasquale\Desktop\NikonD90\DSC_0017.tif');
im1=DSC1(1:N,1:N,2);

Bayer=[0,1;
       1,0];

pattern=kron(ones(N/2,N/2),Bayer);

pattern_blocco=kron(ones(Nb/2,Nb/2),Bayer);

% generazione dell'immagine sintetica con interpolazione bicubica

immagine=interpolationG(im1,N,Bayer);


% generazione della maschera della stima

[x, y]=meshgrid(-(ceil(sigma*2)):4*sigma/(N_window-1):ceil(sigma*2));
window=(1/(2*pi*(sigma^2))).*exp(-0.5.*(x.^2+y.^2)./(sigma^2));


% calcolo delle mappe delle varianze dell'errore di predizione

%errore di predizione sull'immagine

Hpred=[0, 0, 0, 1, 0, 0, 0;
       0, 0,-9, 0,-9, 0, 0;
       0,-9, 0,81, 0,-9, 0;
       1, 0,81,-256,81,0,1;
       0,-9, 0, 81, 0,-9,0;
       0, 0,-9,  0, -9,0,0;
       0, 0, 0, 1, 0, 0, 0]/256;
   
errorePred=imfilter(double(immagine),double(Hpred),'replicate');


acquisiti=errorePred.*(pattern);
mappa_varianza_acquisiti=(sum(sum(window)))*imfilter(acquisiti.^2,window,'replicate').*pattern;


interpolati=errorePred.*(1-pattern);
mappa_varianza_interpolati=(sum(sum(window)))*imfilter(interpolati.^2,window,'replicate').*(1-pattern);

mappa_varianza=mappa_varianza_interpolati+mappa_varianza_acquisiti;

passo_var=0.2;

bin_var=0:passo_var:50;

h_var_A=(1/passo_var)*(1/length(mappa_varianza(logical(pattern))))*histc(mappa_varianza(logical(pattern)),bin_var);
h_var_I=(1/passo_var)*(1/length(mappa_varianza(not(logical(pattern)))))*histc(mappa_varianza(not(logical(pattern))),bin_var);

figure;plot(bin_var,h_var_A);title('Istogramma della varianza sui pixel acquisiti');
figure;plot(bin_var,h_var_I);title('Istogramma della varianza sui pixel interpolati');


func= @(sigma) (prod(sigma(logical(pattern_blocco)))/prod(sigma(not(logical(pattern_blocco)))));

statistica_M1=blkproc(mappa_varianza,[Nb Nb],func);



passo2=1 ;

bin2=0:passo2:100;

h2=(1/length(statistica_M1(not(logical(isnan(statistica_M1)+isinf(statistica_M1)))))).*(1/passo2).*histc((statistica_M1(not(logical(isnan(statistica_M1)+isinf(statistica_M1))))),bin2);

figure;plot(bin2,h2);title('Distribuzione in presenza di CFA');


