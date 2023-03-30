#include <stdio.h>
#include <math.h>
#define pi 3.1416
 /*   supp:     Stress Concentration Factor=3    &   maximum diameter of work piece= 110 mm   */


int main ()
{
    FILE*ofp,*ifp;
        ofp=fopen("F.S.txt","w");

    float F,T,f,p,t,e,sx,sB,sb,S,sm,sa,sut,se,Sy,FS,FS1;

        printf("Please Enter Friction Factor & pace:");
        scanf("%f %f",&f,&p);
        printf("Now Enter Yielding & Ultimate Tensile Stresses:");
        scanf("%f %f",&Sy,&sut);

for (float u=.85;u>.45;u-=.05)
{
        fprintf(ofp,"\nmu=%.2f\n",u);
        fprintf(ofp,"\td(mm)\tF(N)\t\tT(N.mm)\t\te(%%)\t von.(MPa)\tF.S(Gerb.)\tF.S(Lang.)\n");

    for (int d=30;d<=50;d+=2)
    {
        printf("\nd=%d mm",d);
        printf("\n\nmu=%.2f",u);
        fprintf(ofp,"\t%d",d);

        F=3.85/((3.74*pow(10,-7))+(1.172*pow(10,-6)*110/u));
            printf("\nF=%f N",F);
            fprintf(ofp,"\t%.2f",F);

        T=(F*(d-p/2)/2)*(p+pi*f*(d-p/2)/cos(14.5*pi/180))/(pi*(d-p/2)-f*p/cos(14.5*pi/180));
            printf("\nT=%f N.mm",T);
            printf("\ndm=%f mm",d-p/2);
            fprintf(ofp,"\t%.2f",T);

        e=(F*p)/(2*pi*T);
            printf("\ne=%f %%",100*e);
            fprintf(ofp,"\t%.2f",100*e);

        t=(16*T)/(pi*pow(d-p,3));
            printf("\ntaw=%f MPa",t);

        sx=(4*F)/(pi*pow(d-p,2));
            printf("\nsigma x=%f MPa",sx);

        sB=(2*0.38*F)/(pi*(d-p/2)*p);
            printf("\nsigma B=%f MPa",sB);

        sb=(6*0.38*F)/(pi*(d-p)*p);
            printf("\nsigma b=%f MPa",sb);


        S=pow(pow(sb,2)+pow(sx,2)+pow((sb-sx),2)+(6*pow(t,2)),0.5)/pow(2,0.5);
        sm=S/2;
        sa=S/2;
            printf("\nsm=%f MPa",sm);
            printf("\nsa=%f MPa",sa);
            fprintf(ofp,"\t %.2f",sm);
    int k=3;
        se=(0.8)*(4.51*pow(sut,-0.265))*(0.504*sut);
        printf("\nse=%f",se);
        FS=(pow(sut,2)/(2*k*sm))*((-1/se)+pow(1/pow(se,2)+4/pow(sut,2),0.5));
            printf("\nFactor of Safety (Gerber method)=%f",FS);
            fprintf(ofp,"\t\t%.2f",FS);

        FS1=Sy/(k*S);
            printf("\nFactor of Safety (Langer method)=%f\n\n\n",FS1);
            fprintf(ofp,"\t\t%.2f\n",FS1);
    }
}
    fclose(ofp);
return 0;
}
