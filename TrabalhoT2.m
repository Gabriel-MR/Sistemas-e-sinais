%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 0 - Proposta 
%% 
%%  a. implementar a série discreta
%%  Xn = 1/N somatoria_{k=0}^{N-1} gk(k) exp(-j*n*k*2*pi/N)
%%  b. visualizar graficamente
%%  c. interpretar o resultado
%%  d. comparar com tempo
%%
%%  Trabalho em Octave
%%
%%  a. Analisar as cinco vogais: Xa, Xe, Xi, Xo, e Xu.
%%
%%     gráficos plotados (mudar a vogal nas linhas 49 - 53)
%%
%%  b. Os tempos de execução de cada vogal.
%%
%%     configuracoes:   Intel(R) Core(TM) i7-4600M CPU @ 2.90GHz
%%                      RAM 8GB 
%%      Pelo "for":
%%      Xa: Elapsed time is 336.613 seconds.  4816 iteracões
%%      Xe: Elapsed time is 465.273 seconds.  5722 iteracoes
%%      Xi: Elapsed time is 228.503 seconds.  3966 iteracoes
%%      Xo: Elapsed time is 283.962 seconds.  4419 ietracoes
%%      Xu: Elapsed time is 664.754 seconds.  6799 iteracoes
%%
%%      Pelo "produto matricial":
%%
%%      Xa: Elapsed time is 3.41039 seconds.
%%      Xe: Elapsed time is 4.72366 seconds.
%%      Xi: Elapsed time is 2.41938 seconds.
%%      Xo: Elapsed time is 2.91605 seconds.
%%      Xu: Elapsed time is 6.53456 seconds.
%%
%%  c. O que voce observa de diferente em cada serie de Fourier.
%%
%%     As amplitudes variam na frequencia, 
%%     e as formas de onda são diferentes para cada vogal.
%%
%%  d. Você conseguiria analisar no tempo?
%%
%%     Sim, atraves dos gráficos percebe-se que as amplitudes variam no periodo, 
%%     e as formas de onda são diferentes para cada vogal.      
%%
%%  e. Como você transformaria o "for" em produto matricial como foi feito na teoria?
%%
%%     WN = exp(-j*2*pi/N);
%%
%%     Jotas = WN*ones(N,N);  % matriz exp(-j*n*k*2*pi/N)
%%     nn = [0:1:N-1];        % indice frequencia
%%     kk = [0:1:N-1];        % indice tempo
%%     nk = nn'*kk;           % matriz expoentes
%%     WNm = Jotas.^nk;       % matriz Fourier
%%
%%     Xn = WNm*gk            % Fourier
%%     Xn  = fftshift(Xn);    % rotaciona o resultado de Fourier
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1 - Preparaçao do codigo 
%% 
%% Boas praticas: limpeza de variaveis; variaveis globais
%% Constantes; carregar bibliotecas;...
%%
%%% Limpeza
%%
clc;          % limpa visual da tela de comandos
close all;    % limpa as figuras
clear all;    % limpa as variaveis
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  2 - Pre - processamento
%%
%%%%  Xn = 1/N somatoria_{k=0}^{N-1} gk(k) exp(-j*n*k*2*pi/N)
%%
    [gk,fs] = audioread ('a.wav');  % audio Xa
%%  [gk,fs] = audioread ('e.wav');  % audio Xe
%%  [gk,fs] = audioread ('i.wav');  % audio Xi
%%  [gk,fs] = audioread ('o.wav');  % audio Xo 
%%  [gk,fs] = audioread ('u.wav');  % audio Xu
%%
N       = length(gk);               % numero de pontos do sinal em analise
Ts      = 1/fs;                     % tempo de amostragem
ws      = 2*pi*fs;                  % frequencia angular
duracao = N*Ts;                     % duração do sinal
tempo   = linspace(0,N*Ts,N);       % vetor tempo computacional
fmax    = fs/2;                     % frequencia maxima de amostragem
%%
frequencia = linspace(-fs/2,fs/2,N);% vetor de frequencias de Fourier
resolucao  = fs/N;                  % resolucao em frequencia
a = 0;                              % atribui 0 a variavel
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  3 - Fourier
%%
%%%%  Xn = 1/N somatoria_{k=0}^{N-1} gk(k) exp(-j*n*k*2*pi/N)
%%
%%% usando a estrutura do tipo "for ... end"
tic;                                % inicia um contador
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
for n = 0 : N-1                     % N pontos
  a = a + 1
  aux_k = 0;                        % inicia com zero

      for k = 0 :  N-1              %  N pontos - somatoria_{k=0}^{N-1}
        
        %%% gk(k) exp(-j*n*k*2*pi/N)
        %%% +1 --> transforma k de variavel matematica para ponteiro
        
        aux_k  = aux_k + gk(k+1)*exp(-j*n*k*2*pi/N);
        
      end
      
      %%% +1 --> transforma n de variavel matematica para ponteiro
      
      Xn(n+1) = aux_k/N;            % valor final para n fixo - Fourier
      
end

Xn  = fftshift(Xn);                 % rotaciona o resultado de Fourier
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc;                                % estima o tempo de duracao
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  4 - Visualizacao
%%
%%
figure(1)

plot(tempo,gk,'k-','linewidth',1)              % configura plot(x,y, cor azul e linha cheia)
xlabel('Tempo em segundos')                    % tempo em segundos
ylabel('Amplitude')                            % amplitude em volts
title('Sinal g(k) amostrado')                  % titulo
grid

figure(2)

stem(frequencia,abs(Xn),'k-','linewidth',1)    % configura plot(x,y, cor azul e linha cheia)
xlabel('Frequência em Hz')                     % tempo em segundos
ylabel('Amplitude')                            % amplitude em volts
title('Espectro de amplitude')                 % titulo
grid