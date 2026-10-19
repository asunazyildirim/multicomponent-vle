clc
clear all
close all
%acetone (1)/methanol (2)/water (3) /methyl acetate (4)/benzene (5).
wilson=table2array(readtable("wilson parameter.txt"));
antoine=table2array(readtable("Antoine.txt"));
others=table2array(readtable("other parameter.txt")); % w Tc Pc Zc Vc

while 1
fprintf("1=> Bubble Pressure  2=> Dew Pressure  3=> Bubble Temperature  4=> DewTemperature \n")
calculation=input("Which calculation do we perform?: ");
fprintf("\n")
if ismember(calculation,[1,2,3,4])==1;
    break
else
    fprintf("Please enter valid input! \n")
end
end


while 1
fprintf("1=> Raoult's Law 2=> Modified Raoult's Law  3=> Gama-Phi \n")
formulation=input("Which formulation do we use?: ");
fprintf("\n")
if ismember(formulation,[1,2,3])==1;
    break
else
    fprintf("Please enter valid input! \n")
end
end

while 1
fprintf("Our system consists of at most 5 components which are acetone, methanol, water, methyl acetate, benzene. \n")
component_number = input("How many components do we have? : ");
fprintf("\n")
numbers=[1 2 3 4 5] ;
if ismember(component_number,[1,2,3,4,5])==1;
    break
else
    fprintf("Please enter valid input! \n")
end
end


while 1
component_list=[];
mole_fraction=[];
if ismember(component_number,numbers)
    fprintf("Our components: 1=> acetone  2=> methanol  3=> water  4=> methyl acetate  5=> benzene  \n")
    fprintf("Please enter unique components \n")
    for i=[1:component_number];
        component=input("Type your component: ");
        molefraction=input("Its mole fraction: ");
        fprintf("\n")
        component_list(i)=component;
        mole_fraction(i)=molefraction;
    end
end
if membercheck(component_number,component_list)
    fprintf("Please enter valid input! \n")
elseif BUNUNADIBASKA(component_number,component_list);
    if sum(mole_fraction)~= 1;
        fprintf("Please enter unique components and Sum of your mole fraction is not equal to 1! \n")
    else
        fprintf("Please enter unique components \n")
    end
elseif sum(mole_fraction)~= 1 ;
    fprintf("Sum of your mole fraction is not equal to 1! \n")   
elseif ismember(0,mole_fraction);
    fprintf("You have typed 0 mole fraction for one component. Please each component do exist according to component number. \n")
else
    break  
end
end


while 1
if calculation==1 || calculation==2;
    T_celcius=input("At what temperature? (at celcius) : ");
    fprintf("\n")
    T_Kelvin=T_celcius+273.15;
    if  T_celcius < -273.15;
        fprintf("Your temperature is meaningless! \n")
    else
        break
    end
elseif calculation==3 || calculation==4
    P = input("At what pressure? (at kpa) : ");
    fprintf("\n")
    if  P < 0;
        fprintf("Your pressure is meaningless! \n")
    else 
        break
    end
end
end



%BubbleP
if calculation==1 
    if formulation==1 
        Activity_Coefficient_list=ones(1,component_number);
    else
        Gama_list=GL(T_Kelvin,wilson,others,component_list);
        Activity_Coefficient_list=ACL(component_number,mole_fraction,Gama_list);
    end
    Psat_list=PL(component_list,antoine,T_celcius);
    fi_list=ones(1,component_number);
    P=Bubble_P(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list);
    Bij_list=BL(component_list,others,T_Kelvin);
    deltaij_list=DL(component_number,Bij_list);
    error=100;
    while (error>= 10^-4)
        y_list=Bubble_y(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P);
        if formulation==1  
            Pnew=Bubble_P(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list);
            error= 10^-5;
        elseif formulation==2 
            Pnew=Bubble_P(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list);
            error= 10^-5;
        else
            fi_list=FL(component_number,Bij_list,P,Psat_list,y_list,deltaij_list,T_Kelvin);
            Pnew=Bubble_P(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list);
            error= abs(Pnew-P);
            P=Pnew;
        end 
    end
    P
    y_list=Bubble_y(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P)

%DEwP
elseif calculation==2
    Psat_list=PL(component_list,antoine,T_celcius);
    fi_list=ones(1,component_number);
    Activity_Coefficient_list = ones(1,component_number);
    P=Dew_P(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list);
    x_list=Dew_x(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P);
    if formulation==1 
        P
        x_list
    else 
        Gama_list=GL(T_Kelvin,wilson,others,component_list);  % T'ye bağlı
        Activity_Coefficient_list=ACL(component_number,x_list,Gama_list);
        Bij_list=BL(component_list,others,T_Kelvin);  %B; delta T'ye bağlı
        deltaij_list=DL(component_number,Bij_list);   %delta; delta T'ye bağlı
        
        error=100;
        while (error>= 10^-4)
            if formulation==2 
                error=10^-5;
            else
                fi_list=FL(component_number,Bij_list,P,Psat_list,mole_fraction,deltaij_list,T_Kelvin);
            end
            while 1
                x_list=Dew_x(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P);
                x_normalize=x_normal(component_number,x_list);
                x_list = x_normalize ;
                Activity_Coefficient_list_new=ACL(component_number,x_list,Gama_list);
                error_list=EL(component_number,Activity_Coefficient_list,Activity_Coefficient_list_new);
                if sum(error_list)==0;
                    break
                end
                Activity_Coefficient_list=Activity_Coefficient_list_new;
            end      
            Pnew = Dew_P(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list);
            error= abs(Pnew-P);
            P=Pnew;
        end
        P
        x_list=Dew_x(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P)
    end


%BubbleT
elseif calculation==3
    fi_list=ones(1,component_number);
    Tsatcelcius_list=TL(component_list,antoine,P);
    
    T_celcius=0;
    for i=[1:component_number];
        T_celcius= T_celcius + mole_fraction(i)*Tsatcelcius_list(i);
    end
    T_Kelvin = T_celcius + 273.15;
    
    Psat_list=PL(component_list,antoine,T_celcius);
    
    if formulation==1 
        Activity_Coefficient_list=ones(1,component_number);
    else
        Gama_list=GL(T_Kelvin,wilson,others,component_list);
        Activity_Coefficient_list=ACL(component_number,mole_fraction,Gama_list) ;
    end
    
    component_no=1;
    P_j=Pjsat_bubble(component_no,component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P);
    component_type_no=component_list(component_no);
    A_component_type= antoine(component_type_no,1);
    B_component_type= antoine(component_type_no,2);
    C_component_type= antoine(component_type_no,3);
    T_celcius = Tsat(A_component_type,B_component_type,C_component_type,P_j);
    
    error=100;
    while (error>= 10^-4)
        
        Psat_list=PL(component_list,antoine,T_celcius);
        y_list=Bubble_y(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P); 
    
        if formulation==3
            Bij_list=BL(component_list,others,T_Kelvin);
            deltaij_list=DL(component_number,Bij_list);
            fi_list=FL(component_number,Bij_list,P,Psat_list,y_list,deltaij_list,T_Kelvin);
        end
    
        if formulation==2 || formulation==3
            Gama_list=GL(T_Kelvin,wilson,others,component_list);
            Activity_Coefficient_list=ACL(component_number,mole_fraction,Gama_list) ;
        end
    
        P_j=Pjsat_bubble(component_no,component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P);
        component_type_no=component_list(component_no);
        A_component_type= antoine(component_type_no,1);
        B_component_type= antoine(component_type_no,2);
        C_component_type= antoine(component_type_no,3);
        T_celcius_new = Tsat(A_component_type,B_component_type,C_component_type,P_j);
        error= abs(T_celcius_new -T_celcius);
        T_celcius=T_celcius_new;
        T_Kelvin = T_celcius +273.15;
    end
    T_celcius
    y_list=Bubble_y(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P)

%DewT
else
    fi_list=ones(1,component_number);
    Activity_Coefficient_list = ones(1,component_number);
    
    Tsatcelcius_list=TL(component_list,antoine,P);
    
    T_celcius=0;
    for i=[1:component_number];
        T_celcius= T_celcius + mole_fraction(i)*Tsatcelcius_list(i);
    end
    T_Kelvin = T_celcius + 273.15;
    
    Psat_list=PL(component_list,antoine,T_celcius);
    
    component_no=1;
    P_j =Pjsat_dew(component_no,component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P);
    
    component_type_no = component_list(component_no);
    A_component_type = antoine(component_type_no,1);
    B_component_type = antoine(component_type_no,2);
    C_component_type = antoine(component_type_no,3);
    T_celcius = Tsat(A_component_type,B_component_type,C_component_type,P_j);
    
    Psat_list=PL(component_list,antoine,T_celcius);
    
    if formulation==3
        Bij_list=BL(component_list,others,T_Kelvin);
        deltaij_list=DL(component_number,Bij_list);
        fi_list=FL(component_number,Bij_list,P,Psat_list,mole_fraction,deltaij_list,T_Kelvin);
    end
    
    x_list = Dew_x(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P);
    
    if formulation==2 || formulation==3
        Gama_list=GL(T_Kelvin,wilson,others,component_list);
        Activity_Coefficient_list=ACL(component_number,x_list,Gama_list);
    end
    
    component_no=1;
    P_j =Pjsat_dew(component_no,component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P);
    T_celcius= Tsat(A_component_type,B_component_type,C_component_type,P_j);
    T_Kelvin = T_celcius +273.15;
    
    error=100;
    while (error>= 10^-4)
    
        Psat_list=PL(component_list,antoine,T_celcius);
        if formulation==3
            Bij_list=BL(component_list,others,T_Kelvin);
            deltaij_list=DL(component_number,Bij_list);
            fi_list=FL(component_number,Bij_list,P,Psat_list,mole_fraction,deltaij_list,T_Kelvin);
        end

        while 1
            x_list = Dew_x(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P);
            x_normalize=x_normal(component_number,x_list);
            x_list = x_normalize ;

            if formulation==2 || formulation==3
                Gama_list=GL(T_Kelvin,wilson,others,component_list);
                Activity_Coefficient_list_new=ACL(component_number,x_list,Gama_list);
                error_list=EL(component_number,Activity_Coefficient_list,Activity_Coefficient_list_new);
                if sum(error_list)==0;
                    break
                end
                Activity_Coefficient_list=Activity_Coefficient_list_new;
            else
                break
            end
        end
        P_j = Pjsat_dew(component_no,component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P);
        T_celcius_new = Tsat(A_component_type,B_component_type,C_component_type,P_j);
        error= abs(T_celcius_new -T_celcius);
        T_celcius=T_celcius_new;
        T_Kelvin = T_celcius +273.15;
    end
    T_celcius
    x_list = Dew_x(component_number,mole_fraction,Activity_Coefficient_list,Psat_list,fi_list,P)
end



