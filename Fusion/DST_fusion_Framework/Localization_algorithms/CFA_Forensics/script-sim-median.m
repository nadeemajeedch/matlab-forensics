%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Calcolo ROC per Dataset separati con predittore bicubico e Algoritmo EM ZM
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% dimensione del tampering per dataset. l'ordinamento dipende da come sono
% ordinate le cartelle nel path

tamper_size=128;

% Inizializzazione di parametri che sono funzione della dimensione dei
% blocchi
Nb = 8;
TOL = 1e-3;
MAX_ITER = 500;

% Generazione dei dati sui quali effettuare le misure

%failures = main_dataset_median_ZM(['/users/ferrara/Desktop/dataset_predittori/median'],['/users/ferrara/Desktop/Simulazioni ideale/median'],Nb,MAX_ITER,TOL);
%verosimiglianza(['/users/ferrara/Desktop/Simulazioni ideale/median']);
ROC_verosimiglianza8x8(['/users/ferrara/Desktop/Simulazioni ideale/median'],tamper_size);       