function B=Bij(Pcij,Tcij,wij,T)
R=83.14;
Tr=T/Tcij;
B_0 = 0.083- 0.422/Tr^(1.6);
B_1 = 0.139- 0.172/Tr^(4.2);
B_cm3_mol=((B_0 + wij*B_1)* R*Tcij)/Pcij; %cm3
B= B_cm3_mol * 10^(-6) ;
end
