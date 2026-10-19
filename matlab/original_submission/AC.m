function ActivityCoef=AC(n,component_number,mole_fraction,Gama_list)
last_term=0;
for k=[1:component_number];
    mf_k=mole_fraction(k);
    gama_ki=Gama_list(k,n);
    numerator=mf_k*gama_ki;
    denumerator=0;
    for j=[1:component_number];
        mf_j = mole_fraction(j);
        denumerator= denumerator + mf_j *Gama_list(k,j);
    end
    last_term= last_term + numerator/denumerator;
end

second_term_summation=0;
for j=[1:component_number];
    mf_j = mole_fraction(j);
    second_term_summation= second_term_summation + mf_j *Gama_list(n,j);
end
second_term= log(second_term_summation);

ActivityCoef=exp(1-second_term - last_term);
end