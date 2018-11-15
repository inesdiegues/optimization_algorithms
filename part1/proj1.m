
%-------------------------Otimization and Algorithms----------------------%
%-------------------------------Projet - Part 1 --------------------------%
%-------------------------------------------------------------------------%


% --------Work by:------%
% Catia Fortunato
% Maria In�s Diegues
% Joao Carvalho
% -------Supervision by------%
% Profesor Jo�o Xavier
%test2

%%
clear all;
close all;

%% --------------------------Variation A



%% ---------------------------------------------------------------
%%---------------------------Variation C--------------------------
%%----------------------------------------------------------------



%-----------------------4.2 Squared l-2  Formulation--------------


%----------Constants:
T=80;
ci=[0;5;0;0]; %initial condition
pi=[0;5]; %initial position
cf=[15;-15;0;0]; %final condition
pf=[15;-15]; %final position
K=6;

W=[10 20 30 30 20 10; 10 10 10 0 0 -10]; %matrix with the positions!
ts=[10 25 30 40 50 60];


A=[1 0 0.1 0;
    0 1 0 0.1; 
    0 0 0.9 0;
    0 0 0 0.9];
B=[0 0;
    0 0;
    0.1 0;
    0 0.1];

Umax=15;

disp('Constants loaded in 4.2')

%% ----------Optimization Problem

cvx_begin quiet
    %Initializations
    variable x(4,T);
    variable u(2,T);
    f=0;

    %Define Objective Function
    for i=1:K
        f=f+square_pos(norm(x(1:2,ts(i))-W(:,i),2));
    end
   
    
    
    minimize(f)

    subject to

        x(1:4,1)==ci; %assuming vi=0
        x(1:4,T)==cf; %assuming vf=0
        for i=1:T
            norm(u(:,i),2)<=Umax;
        end

        for i=2:T
            x(:,i)==A*x(:,i-1)+B*u(:,i-1);
        end

cvx_end

disp('Optimization Solved in 4.2')

%-------------------- Task 9

%% a) Plot the optimal positions of the Robot (t=0:T-1) - mark positions times tk
fig=figure(1);
set(fig,'units','normalized','outerposition',[0 0 1 1])
scatter(x(1,:),x(2,:)); hold on;
scatter(W(1,:),W(2,:),'x','r')



%% b) Optimal Control Signal u(t)=(u1(t),u2(t)) (t=0:T-1)
fig=figure(2);
set(fig,'units','normalized','outerposition',[0 0 1 1])

plot(1:80,u(1,:),1:80,u(2,:))
legend({'u1(t)','u2(t)'})
xlabel('Time stamp')
ylabel('Control signal intensity')
title('Optimal control signal')


%% C) How many waypoints are captured?
thrs=10^-6;
a=zeros(1,6);
for i=1:K
    if x(1:2,ts(i))-W(:,i)<thrs
        a(i)=1;
    end
end
n_wpoints=a*ones(6,1);
disp(n_wpoints)

%-----------------------4.3 l-2  Formulation------------------

%% ----------Constants:
T=80;
ci=[0;5;0;0]; %initial condition
pi=[0;5]; %initial position
cf=[15;-15;0;0]; %final condition
pf=[15;-15]; %final position
K=6;

W=[10 20 30 30 20 10; 10 10 10 0 0 -10]; %matrix with the positions!
ts=[10 25 30 40 50 60];


A=[1 0 0.1 0;
    0 1 0 0.1; 
    0 0 0.9 0;
    0 0 0 0.9];
B=[0 0;
    0 0;
    0.1 0;
    0 0.1];

Umax=15;

disp('Constants loaded in 4.3')

%% ------------Model:
cvx_begin quiet
    %Initializations
    variable x(4,T);
    variable u(2,T);
    f=0;

    %Define Objective Function
    for i=1:K
        f=f+norm(x(1:2,ts(i))-W(:,i),2);
    end

    minimize(f)

    subject to

%         x(1:2,1)==pi; %not assuming vi=0
%         x(1:2,T)==pf; %not assuming vf=0
        x(:,1)==ci; %assuming vi=0
        x(:,T)==cf; %assuming vf=0
        for i=1:T
            norm(u(:,i),2)<=Umax;
        end

        for i=2:T
            x(:,i)==A*x(:,i-1)+B*u(:,i-1);
        end

%         for i=1:K
%             x(1:2,ts(i))==W(:,i);
%         end

cvx_end

disp('Optimization Solved in 4.3')




%-------------------- Task 10

%% a) Plot the optimal positions of the Robot (t=0:T-1) - mark positions times tk
fig=figure(2);
set(fig,'units','normalized','outerposition',[0 0 1 1])

scatter(x(1,:),x(2,:)); hold on;
scatter(W(1,:),W(2,:),'x','r')


%% b) Optimal Control Signal u(t)=(u1(t),u2(t)) (t=0:T-1)
fig=figure(3);
set(fig,'units','normalized','outerposition',[0 0 1 1])

plot(1:80,u(1,:),1:80,u(2,:))
legend({'u1(t)','u2(t)'})
xlabel('Time stamp')
ylabel('Control signal intensity')
title('Optimal control signal')


%% C) How many waypoints are captured?
thrs=10^-6;
a=zeros(1,6);
for i=1:K
    if x(1:2,ts(i))-W(:,i)<thrs
        a(i)=1;
    end
end
n_wpoints=a*ones(6,1);
disp(n_wpoints)

%% -----------------------4.4 The Iterative Reweighting Technique-----------------
%----------Constants:
T=80;
ci=[0;5;0;0]; %initial condition
pi=[0;5]; %initial position
cf=[15;-15;0;0]; %final condition
pf=[15;-15]; %final position
K=6;

W=[10 20 30 30 20 10; 10 10 10 0 0 -10]; %matrix with the positions!
ts=[10 25 30 40 50 60];


A=[1 0 0.1 0;
    0 1 0 0.1; 
    0 0 0.9 0;
    0 0 0 0.9];
B=[0 0;
    0 0;
    0.1 0;
    0 0.1];

Umax=15;

%Hyperparameters
epsilon=10^-6;
M=10;

disp('Constants loaded in 4.4')

%% Task 11
%Results from previous otpimization model
x_it=x;
u_it=u;

close all

%Prep Figures for plots
fig=figure(1);
set(fig,'units','normalized','outerposition',[0 0 1 1])
fig2=figure(2);
set(fig2,'units','normalized','outerposition',[0 0 1 1])
out_wpoints=zeros(10,6);

%------------Model:
for m=0:M-1
    cvx_begin quiet
    disp('running')
    if m==M-2
        disp('almost there')
    end           
        
        
    %Initializations
    variable x(4,T);
    variable u(2,T);
    
    f=0;
    %Define Objective Function
    for i=1:K
        fi=norm(x(1:2,ts(i))-W(:,i),2);
        weight=power(norm(x_it(1:2,ts(i))-W(:,i),2)+epsilon,1);
        f=fi*weight+f;
    end
    
    minimize(f)
    
    subject to

%         x(1:2,1)==pi; %not assuming vi=0
%         x(1:2,T)==pf; %not assuming vf=0
        x(:,1)==ci; %assuming vi=0
        x(:,T)==cf; %assuming vf=0
        for i=1:T
            norm(u(:,i),2)<=Umax;
        end

        for i=2:T
            x(:,i)==A*x(:,i-1)+B*u(:,i-1);
        end

%         for i=1:K
%             x(1:2,ts(i))==W(:,i);
%         end
    
    cvx_end
    
    
    x_it=x;
    u_it=u;
    
    %a) plot positions in each iteration (t=0:T); mark position for tk, (1<=k<=K)
    figure(1)
    subplot(5,2,m+1)
    scatter(x(1,:),x(2,:)); hold on;
    scatter(W(1,:),W(2,:),'x','r')

    
    %b) plot control signal for each iteration Control Signal u(t)=(u1(t),u2(t)) (t=0:T-1)
    figure(2)
    subplot(5,2,m+1)
    
    plot(1:80,u(1,:),1:80,u(2,:))
    legend({'u1(t)','u2(t)'})
    xlabel('Time stamp')
    ylabel('Control signal intensity')
    title('Optimal control signal')
end
disp('Optimization Solved in 4.4')

%% C) How many waypoints are captured?
thrs=10^-6;
for i=1:K
    if x(1:2,ts(i))-W(:,i)<thrs
        out_wpoints(m+1,i)=1;
    end
end
n_wpoints=out_wpoints'*ones(10,1);
disp(n_wpoints)
