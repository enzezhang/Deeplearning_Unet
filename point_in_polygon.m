function point_in_polygon(calving_file,polygon_file,output_file)

format long
%calving_file='/home/zez/test_deep_learning/u_net/test16/post_process_gmt/20140804_out_post.gmt';
%polygon_file='/home/zez/test_deep_learning/u_net/test16/cut_polygon.gmt';
%output_file='/home/zez/test_deep_learning/u_net/test16/in_polygon_calving_front/20140804_out_post.gmt';

calving_data=load(calving_file);
polygon_data=load(polygon_file);
index=inpolygon(calving_data(:,1),calving_data(:,2),polygon_data(:,1),polygon_data(:,2));
inpolygon_data=calving_data(index,:);

dlmwrite(output_file,inpolygon_data,'delimiter',' ','precision',15);

end
