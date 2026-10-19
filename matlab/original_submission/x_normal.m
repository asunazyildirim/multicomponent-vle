function norm=x_normal(component_number,x_list)
 x_normalize = [];
        for i=[1:component_number];
            sumxlist = sum(x_list);
            x_normalize(i) = x_list(i)/sumxlist;
        end
 norm=x_normalize;
end