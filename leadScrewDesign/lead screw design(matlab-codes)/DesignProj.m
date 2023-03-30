 clc
close all
p=6;
f=0.15;
n=1.85;
kf=3;
u=0.7;
s=200:2:800;
for d=30:2:50
        
        F=3.85/((3.74*(10^-7))+(1.172*(10^-6)*110/u));
        T=(F*(d-p/2)/2)*(p+pi*f*(d-p/2)/cos(14.5*pi/180))/(pi*(d-p/2)-f*p/cos(14.5*pi/180));
        t=(16*T)/(pi*((d-p)^3));
        sx=(4*F)/(pi*((d-p)^2));
        sb=(6*0.38*F)/(pi*(d-p)*p);
        S=(sb^2+sx^2+(sb-sx)^2+6*(t^2))^0.5/(2^0.5);
        sm=S/2;
        sa=S/2;
        
        se=(0.8)*4.51*(s.^(-0.265)).*(0.504*s);
        %define G as left side of Gerber eq.
        G =(n*kf*sa) * se.^(-1) + (n*kf*sm)^2 * s.^(-2);
        
        plot(s,G)
        xlabel('Sut');
        ylabel('Gerb.  G=(nk(sa)/Se) + (nk(sm)/Sut)^2');
        title(['(ultimate tensile),mu=',num2str(u),',n=',num2str(n)])
        grid on
        hold on
end
 plot([200,800],[1,1],'r')          %line: G=1