function Volume=Volume(Vc,Zc,T,Tc)
Tr=T/Tc;
Volume=Vc*Zc^((1-Tr)^(2/7));
end


