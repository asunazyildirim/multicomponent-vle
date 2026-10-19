function Gama=Gama(Vi,Vj,aij,T)
R=1.9872; %cal/(mol*k)
Gama=(Vj/Vi)*exp(-aij/(R*T));
end