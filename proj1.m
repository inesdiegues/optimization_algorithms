
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
pi=[0,5]; %initial position
pf=[15,-15]; %final position
K=6;

W=[10 20 30 30 20 10; 10 10 10 0 0 -10]; %matrix with the positions!
ts=[10 25 30 40 50 60];


A=[1 0 0.1 0; 0 1 0 0.1; 0 1 0 0.1; 0 0 0.9];
B=[0 0; 0 0; 0.1 0; 0 0.1];
C=[10 20 30 30 20 10; 10 10 10 0 0 -10];
Umax=15;

cvx_begin quiet
	%Initializations
	variable x(4,T);
	variable u(2,T);	
	f=0;
	
	%Define Objective Function
	for i=1:k
		f=f+square_pos(norm(x(1:2,ts(i))-W(:,i),2));
	end
	
	minimize(f)

	subject to
	
		x(1:2,1)==pi; %not assuming vi=0
		x(1:2,T)==pf; %not assuming vf =0
		for i=T
			norm(u(:,1),2)<=Umax;
		end
		
		for i=2:T
			x(:,i)=A*x(t)+B*u(:,i-1);
		end
		
cvx_end

%-------------------- Task 9

%% a) Plot the optimal positions of the Robot (t=0:T-1) - mark positions times tk
fig=figure(1); 
set(fig,'units','normalized','outerposition',[0 0 1 1])
scatter(x(1,:),x(2,:)); hold on;
for i=1:k
    cx = C(1,i);
    cy = C(2,i);

    n = 50;                           % 50 point approximation
    R = 1;                            % Unit radius
    angle = 0:2*pi/n:2*pi;            % vector of angles at which points are drawn

    x1 = cx+R*cos(angle);  y1 = cy+R*sin(angle); % Coordinates of circle
    plot(x1,y1,'color','r');                                 % Plot the circle

    axis equal;
    
    hold on;
	
%% b) Optimal Control Signal u(t)=(u1(t),u2(t)) (t=0:T-1)
figure(2)
plot(1:80,u(1,:),1:80,u(2,:))
legend({'u1(t)','u2(t)'})
xlabel('Time stamp')
ylabel('Control signal intensity')
title('Optimal control signal')


%% C) How many waypoints are captured?
thrs=10^-6;
a=zeros(6);

for i=1:k
	if x(1:2,ts(i))-W(:,i)<thrs
		a(i)=1;
	end
end
n_wpoints=a*ones(6);
disp(n_wpoints)

%-----------------------4.3 l-2  Formulation------------------

%% ----------Constants:
T=80;
pi=[0,5]; %initial position
pf=[15,-15] %final position
K=6;

W=[10 20 30 30 20 10; 10 10 10 0 0 -10]; %matrix with the positions!
ts=[10 25 30 40 50 60];


A=[1 0 0.1 0; 0 1 0 0.1; 0 1 0 0.1; 0 0 0.9];
B=[0 0; 0 0; 0.1 0; 0 0.1];
C=[10 20 30 30 20 10; 10 10 10 0 0 -10];
Umax=15;

%% ------------Model:
cvx_begin quiet
	%Initializations
	variable x(4,T);
	variable u(2,T);	
	f=0;
	
	%Define Objective Function
	for i=1:k
		f=f+norm(x(1:2,ts(i))-W(:,i),2);
	end
	
	minimize(f)

	subject to
	
		x(1:2,1)==pi; %not assuming vi=0
		x(1:2,T)==pf; %not assuming vf =0
		for i=T
			norm(u(:,1),2)<=Umax;
		end
		
		for i=2:T
			x(:,i)=A*x(t)+B*u(:,i-1);
		end
		
cvx_end

%-------------------- Task 10

%% a) Plot the optimal positions of the Robot (t=0:T-1) - mark positions times tk
fig=figure(2); 
set(fig,'units','normalized','outerposition',[0 0 1 1])

scatter(x(1,:),x(2,:)); hold on;
for i=1:k
    cx = C(1,i);
    cy = C(2,i);

    n = 50;                           % 50 point approximation
    R = 1;                            % Unit radius
    angle = 0:2*pi/n:2*pi;            % vector of angles at which points are drawn

    x1 = cx+R*cos(angle);  y1 = cy+R*sin(angle); % Coordinates of circle
    plot(x1,y1,'color','r');                                 % Plot the circle

    axis equal;
    
    hold on;
	
%% b) Optimal Control Signal u(t)=(u1(t),u2(t)) (t=0:T-1)
fig=figure(3)
set(fig,'units','normalized','outerposition',[0 0 1 1])

plot(1:80,u(1,:),1:80,u(2,:))
legend({'u1(t)','u2(t)'})
xlabel('Time stamp')
ylabel('Control signal intensity')
title('Optimal control signal')


%% C) How many waypoints are captured?
thrs=10^-6;
a=zeros(6)
for i=1:k
	if x(1:2,ts(i))-W(:,i)<thrs
		a(i)=1;
	end
end
n_wpoints=a*ones(6);
disp(n_wpoints)

%% -----------------------4.3 The Iterative Reweighting Technique-----------------
%----------Constants:
T=80;
pi=[0,5]; %initial position
pf=[15,-15] %final position
K=6;

W=[10 20 30 30 20 10; 10 10 10 0 0 -10]; %matrix with the positions!
ts=[10 25 30 40 50 60];


A=[1 0 0.1 0; 0 1 0 0.1; 0 1 0 0.1; 0 0 0.9];
B=[0 0; 0 0; 0.1 0; 0 0.1];
C=[10 20 30 30 20 10; 10 10 10 0 0 -10];
Umax=15;

%Hyperparameters
epsilon=10^-6;
M=10;


%% Task 11
%Results from previous otpimization model
x_it=x;
u_it=u;


%Prep Figures for plots
fig=figure(1);
set(fig,'units','normalized','outerposition',[0 0 1 1])
out_wpoints=zeros(10,6)

%------------Model:
for m=0:M-1
    cvx_begin quiet
    
    %Initializations
    variable x(4,T);
    variable u(2,T);
    
    f=0;
    %Define Objective Function
    for i=1:k
        fi=norm(x(1:2,ts(i))-W(:,i),2);
        weight=1/(norm(x_it(1:2,ts(i))-W(:,i),2)+epsilon)
        f=(fi/weight)+fM
    end
    
    minimize(f)
    
    subject to
    
    x(1:2,1)==pi; %not assuming vi=0
    x(1:2,T)==pf; %not assuming vf =0
    for i=T
        norm(u(:,1),2)<=Umax;
    end
    
    for i=2:T
        x(:,i)=A*x(t)+B*u(:,i-1);
    end
    
    cvx_end
    
    x_it=x;
    u_it=u;
    
    %a) plot positions in each iteration (t=0:T); mark position for tk, (1<=k<=K)
    subplot(10,2,m*2+1)
    scatter(x(1,:),x(2,:)); hold on;
    for i=1:k
        cx = C(1,i);
        cy = C(2,i);
        
        n = 50;                           % 50 point approximation
        R = 1;                            % Unit radius
        angle = 0:2*pi/n:2*pi;            % vector of angles at which points are drawn
        
        x1 = cx+R*cos(angle);  y1 = cy+R*sin(angle); % Coordinates of circle
        plot(x1,y1,'color','r');                                 % Plot the circle
        
        axis equal;
        
        hold on;
        
        %b) plot control signal for each iteration Control Signal u(t)=(u1(t),u2(t)) (t=0:T-1)
        
        subplot(10,2,m*2+2)
        
        plot(1:80,u(1,:),1:80,u(2,:))
        legend({'u1(t)','u2(t)'})
        xlabel('Time stamp')
        ylabel('Control signal intensity')
        title('Optimal control signal')
        
        % C) How many waypoints are captured?
        thrs=10^-6;
        for i=1:k
            if x(1:2,ts(i))-W(:,i)<thrs
                out_wpoints(m+1,i)=1;
            end
        end
        n_wpoints=out_wpoints*ones(10,1);
        disp(n_wpoints)
    end
	
