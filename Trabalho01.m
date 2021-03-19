%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Preparacao do codigo 
%% 
%% Boas praticas: limpeza de variaveis; variaveis globais
%% Constantes; carregar bibliotecas;...
%%
%%% Limpeza

clc;          % limpa visual da tela de comandos

display('1 - Preparacao do codigo ...')

close all;    % limpa as figuras
clear all;    % limpa as variaveis

%%% Carregar bibliotecas

pkg load symbolic;  % biblioteca simbolica


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  2 - calcular o valor de Dn
%% 
%%  Ambiente de calculo integral e simbolico
%%  
%%  Symbolic pkg v2.9.0: 
%%  Python communication link active, SymPy v1.5.1.
%%
%%  g(t) = exp(-t)
%%  Dn   = 1/To int_0^To g(t) exp(-j n wo t) dt
%%
%%  Dn   = 1/To int_0^To exp(-t) exp(-j n wo t) dt
%%
%%  exp(-t) exp(-j n wo t) =  exp(-(t + j n wo t)) = exp(-(1 + j n wo)t)

display('2 - Calcular simbolicamente a funcao de Dn ...')

syms n wo to To t  % t - tempo variavel simbolica

%%% numerador de Dn

%%% Integral - int( funcao , variavel, extremo inferior, extremo superior )

Inum   = int(exp(-(1+j*n*wo)*t),t,to,to+To); % intervalo de integracao

%%% determinar Dn

Dn = Inum/To;         % da teoria - Denominador = To

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - Problema
%%
%% Um sinal periodico g(t) e definido pela eq 2 no intervalo 0 <= t <= 1 que
%% representa exatamente a eq de um periodo deste sinal que equivale a T0 = 1s.
%% 
%% Definir a onda quadrada

display('3 - Definindo valores numericos de g(t) ...')

To = 1;    % periodo da onda quadrada
to = 0;    % instante inicial de g(t)

%%% Parametros calculados

fo = 1/To;    % frequencia da onda quadrada
wo = 2*pi*fo; % frequencia angular de g(t)

%%% Funcao teorica g(t)

gtTeo = @(t) exp(-t);   % cria a funcao teorica


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4.1 - Determinar numericamente os valores de p1 e r1

n     = [-1 0 +1];        % atribui valores para a variavel n

DnNum = eval(Dn);         % substitui os valores numericos

M     = 1000;             % numero de pontos da analise
tempo = linspace(0,To,M); % cria o vetor tempo

%%% Sintetizar a primeira harmanica de aproximacao

p1    = DnNum(1)*exp(j*n(1)*wo*tempo) + DnNum(2)*exp(j*n(2)*wo*tempo) + DnNum(3)*exp(j*n(3)*wo*tempo);

%%% Deteminar g(t)

gt    = gtTeo(tempo);  % sinal teorico

%%% Determinar o erro entre p1 e gt

r1    = gt - p1;       % erro ou residuo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4.2 - Determinar numericamente os valores de p2 e r2

n     = [-2 2];           % atribui valores para a variavel n

DnNum = eval(Dn);         % substitui os valores numericos

M     = 1000;             % numero de pontos da analise
tempo = linspace(0,To,M); % cria o vetor tempo

%%% Sintetizar a segunda harmonica de aproximacao

p2    = p1 + DnNum(1)*exp(j*n(1)*wo*tempo) + DnNum(2)*exp(j*n(2)*wo*tempo);

%%% Deteminar g(t)

gt    = gtTeo(tempo);  % sinal teorico

%%% Determinar o erro entre p1 e gt

r2   = gt - p2;        % erro ou residuo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4.3 - Determinar numericamente os valores de pn e rn

M = 1000;                 % intervalo  

n = [-M/2 : M/2];         % numero de pontos da analise

DnNum = eval(Dn);         % substitui os valores numericos

pn = 0;                   % atribui zero a variavel (declarar)

tempo = linspace(0,To,M); % cria o vetor tempo

%%% Sintetizar a pn harmonicanicas de aproximacao

for k = 1 : M

  pn = pn + DnNum(k)*exp(n(k)*j*wo*tempo);

end

%%% Deteminar g(t)

gt    = gtTeo(tempo);  % sinal teorico

%%% Determinar o erro entre pn e gt

rn   = gt - pn;        % erro ou residuo 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  5.1 -  Visualizar as variaveis: r1, p1 e gt

figure(1)

subplot(2,1,1);                         % divide a figura em duas linhas
plot(tempo,gt, 'b..', 'linewidth',3);
hold;
plot(tempo,p1, 'g-.', 'linewidth',3);
xlabel('tempo em segundos');
ylabel('Amplitude em volts');
title('Sinal sintetizado e original - p1')
grid

subplot(2,1,2);                         % divide a figura em duas linhas
plot(tempo,r1, 'k-', 'linewidth',3);
xlabel('tempo em segundos');
ylabel('Amplitude em volts');
title('Sinal do residuo - r1')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  5.2 -  Visualizar as variaveis: r2, p2 e gt
figure(2)

subplot(2,1,1);                         % divide a figura em duas linhas
plot(tempo,gt, 'b..', 'linewidth',3);
hold;
plot(tempo,p2, 'g-.', 'linewidth',3);
xlabel('tempo em segundos');
ylabel('Amplitude em volts');
title('Sinal sintetizado e original - p2')
grid

subplot(2,1,2);                         % divide a figura em duas linhas
plot(tempo,r2, 'k-', 'linewidth',3);
xlabel('tempo em segundos');
ylabel('Amplitude em volts');
title('Sinal do residuo - r2')
grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  5.3 -  Visualizar as variaveis: rn, pn e gt
figure(3)

subplot(2,1,1);                         % divide a figura em duas linhas
plot(tempo,gt, 'b..', 'linewidth',3);
hold;
plot(tempo,pn, 'g-.', 'linewidth',3);
xlabel('tempo em segundos');
ylabel('Amplitude em volts');
title('Sinal sintetizado e original - pn')
grid

subplot(2,1,2);                         % divide a figura em duas linhas
plot(tempo,rn, 'k-', 'linewidth',3);
xlabel('tempo em segundos');
ylabel('Amplitude em volts');
title('Sinal do residuo - rn')
grid
