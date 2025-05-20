
clear all; clc; close all;

tic;

%%
% Wells

aux = ones(8,1);
aux2 = 1:8; aux2 = aux2';
n = 1:48; n = n';
aux = [aux; 2*aux; 3*aux; 4*aux; 5*aux; 6*aux];

W = [n aux repmat(aux2,6,1)];

clear n aux aux2;

%%

wells = 1:48;

%%

Res = [];

F = dir('*.spk');


pat = F(1).name;
Data = AxisFile(pat).SpikeData.LoadData; 


%t1 = [0 600 1200 1800 2400 3000];
%t2 = [600 1200 1800 2400 3000 3600];

t1 = 0;
t2 = 600;


for w = 1:length(wells)
    ww = wells(w);
    tt = Data(W(ww,2),W(ww,3),:,:);
    % electrodo
    CV = zeros(16,length(t1));
    Nspk = zeros(16,length(t1));
    Rate = zeros(16,length(t1));
    e = 1;
    for i=1:4
        for j=1:4
            a = tt{:,:,i,j};
            if isempty(a)==0
                aux0 = cat(2,a(1,:).Start); % timestamps of the spikes 
                for t = 1:length(t1)
                    aux = aux0(aux0>=t1(t) & aux0<t2(t));
                    isi = diff(aux);
                    CV(e,t) = std(isi)/mean(isi);
                    Nspk(e,t) = length(aux);
                    Rate(e,t) = Nspk(e,t)/(t2(t)-t1(t));
                    clear aux;
                end
                clear aux0;
            end
            e = e+1;
        end
    end
    Res(w).CV = CV;
    Res(w).Nspk = Nspk;
    Res(w).Rate = Rate;
end

save('Res.mat', 'Res');


%%

toc;


% 
