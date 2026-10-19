function T=Tsat(A,B,C,P)
T_degree = (B / ( A - log(P) )) - C;
T= T_degree;
end
