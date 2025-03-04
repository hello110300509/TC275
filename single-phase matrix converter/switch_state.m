
function [sys,x0,str,ts] = switch_state(t,x,u,flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 1,
    sys=[];
  case 2,
    sys=[];
  case 3,
    sys=mdlOutputs(t,x,u);
  case 4,
    sys=[];
  case 9,
    sys=[];
   otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
end
% mdlInitializeSizes
function [sys,x0,str,ts]=mdlInitializeSizes

sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 5;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [0.00001 0];     % 采样时间0.0001s,100000 Hz

% mdlOutputs
end
function sys=mdlOutputs(t,x,u)

ui=u(1);io=u(2);io_g=u(3);
Rl=2;Ll=0.04;Ts=0.00002;
%%%%开关管自上到下从左到右S1S2S3SS4%%%%%%%%
%%[1001]
uo=(1-0)*ui;
ii=(1-0)*io;
io_1=(1-(Rl*Ts)/Ll)*io+Ts/Ll*uo;
g1=abs(io_g-io_1);
ss1=[1 0 0 1];v1=1;
%%[0110]
uo=(0-1)*ui;
ii=(0-1)*io;
io_1=(1-(Rl*Ts)/Ll)*io+Ts/Ll*uo;
g2=abs(io_g-io_1);
ss2=[0 1 1 0];v2=2;
if(g1<=g2)
else
    g1=g2;ss1=ss2;v1=v2;
end
%%%%%[0101]
uo=(0-0)*ui;
ii=(0-0)*io;
io_1=(1-(Rl*Ts)/Ll)*io+Ts/Ll*uo;
g2=abs(io_g-io_1);
ss2=[0 1 0 1];v2=-1;
if(g1<=g2)
else
    g1=g2;ss1=ss2;v1=v2;
end
%%%[1010]
uo=(1-1)*ui;
ii=(1-1)*io;
io_1=(1-(Rl*Ts)/Ll)*io+Ts/Ll*uo;
g2=abs(io_g-io_1);
ss2=[1 0 1 0];v2=-2;
if(g1<=g2)
else
    g1=g2;ss1=ss2;v1=v2;
end
           sys=[ss1 v1];

end

        
       
   
     
    
