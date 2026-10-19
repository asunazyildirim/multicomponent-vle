function uni=BUNUNADIBASKA(component_number,component_list);
u=0;
for i=[1:component_number-1];
    for j=[i+1:component_number];
        if component_list(i)==component_list(j);
            u=1;
        end
    end
end
uni=u;
end

