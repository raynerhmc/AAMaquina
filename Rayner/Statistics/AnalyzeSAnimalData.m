%function AnalyzeSAnimalData()
clc;
clear all;
close all;

fprintf('-----> loading  dataset \n');
tic;
fid = fopen('../Source/orig_train.csv');



cell_data = textscan(fid,'%s %s %s %s %s %s %s %s %s %s', 26730, 'Delimiter',',');
fclose(fid);

%X = cell2mat( cell_data(1:4) ); %ignores the last column of strings
index = cell_data(1);
num_examples = size(index{1},1);
num_variables = size(cell_data, 2);
key_set = {'Return_to_owner', 'Euthanasia', 'Adoption', 'Transfer', 'Died'};
value_set = [1, 2, 3, 4, 5];
maper = containers.Map(key_set, value_set);

key_set_year = {'2013', '2014', '2015', '2016'};
value_set_year = [0, 1, 2, 3];
length_year = length(value_set_year);
maper_year = containers.Map(key_set_year, value_set_year);

key_set_month = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'};
value_set_month = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
length_month = length( value_set_month );
maper_month = containers.Map(key_set_month, value_set_month);

key_set_type = {'Dog', 'Cat'};
value_set_type = {1, 2};
maper_type = containers.Map(key_set_type, value_set_type);

key_set_sex = {'Neutered Male', 'Spayed Female', 'Intact Male', 'Intact Female', 'Unknown', ''};
value_set_sex = {1, 2, 3, 4, 5,5};
length_sex = length(value_set_sex) - 1;
maper_sex = containers.Map(key_set_sex, value_set_sex);

num_classes = length(key_set);

y = zeros(num_examples, 1);

freq_sex_dog = zeros(num_classes, length_sex);
freq_sex_cat = zeros(num_classes, length_sex);

total_freq_date = zeros ( num_classes, length_year * length_month );
dog_freq_date = zeros ( num_classes, length_year * length_month );
cat_freq_date = zeros ( num_classes, length_year * length_month );

labels = cell_data(4);
datetime = cell_data(3);
animal_type = cell_data(6);
animal_sex = cell_data(7);
for ind = 2:num_examples
    y(ind) = maper( cast( labels{1}(ind), 'char') );
    animal_id = maper_type ( cast( animal_type{1}(ind), 'char') );
    datetime_str = cast( datetime{1}(ind), 'char');
    [year_str, datetime_str] = strtok( datetime_str, '-' );
    month_str = strtok( datetime_str, '-' );
    index = maper_year( year_str ) * length_month + maper_month( month_str );
    total_freq_date(y(ind), index + 1) = total_freq_date(y(ind), index + 1) + 1;
    index_sex = maper_sex( cast( animal_sex{1}(ind), 'char') );
    if ( animal_id == maper_type('Dog') )
        dog_freq_date(y(ind), index + 1) = dog_freq_date(y(ind), index + 1) + 1;
        freq_sex_dog(y(ind), index_sex) = freq_sex_dog(y(ind), index_sex) + 1;
    else
        cat_freq_date(y(ind), index + 1) = cat_freq_date(y(ind), index + 1) + 1;
        freq_sex_cat(y(ind), index_sex) = freq_sex_cat(y(ind), index_sex) + 1;
    end
    %pause();
end

figure,
normalizer = ones(length_sex, 1) * sum(freq_sex_dog);
bar(freq_sex_dog./normalizer);
ax = gca;
set(ax,'XTick',[1, 2, 3, 4, 5])
classes_l = ['Return owner'; ' Euthanasia '; '  Adoption  '; '  Transfer  '; '    Died    '];
set(ax,'XTickLabel',classes_l, 'FontSize', 16);
legend({'Neutered Male', 'Spayed Female', 'Intact Male', 'Intact Female', 'Unknown'}, 'FontSize', 16, 'Location', 'best');
title('Sex vs Outcome Type (Dog)', 'FontSize', 26);

figure,
normalizer = ones(length_sex, 1) * sum(freq_sex_cat);
bar(freq_sex_cat./normalizer);
ax = gca;
set(ax,'XTick',[1, 2, 3, 4, 5])
classes_l = ['Return owner'; ' Euthanasia '; '  Adoption  '; '  Transfer  '; '    Died    '];
set(ax,'XTickLabel',classes_l, 'FontSize', 16);
legend({'Neutered Male', 'Spayed Female', 'Intact Male', 'Intact Female', 'Unknown'}, 'FontSize', 16, 'Location', 'best');
title('Sex vs Outcome Type (Cat)', 'FontSize', 26);

figure,
subplot(2, 1, 1);
hold on;
%plot( 1:(length_year * length_month), sum(total_freq_date) , 'r', 'linewidth', 2);
plot( 1:(length_year * length_month), sum(dog_freq_date) , 'b', 'linewidth', 2);
plot( 1:(length_year * length_month), sum(cat_freq_date) , 'k', 'linewidth', 2);
ax = gca;
axis([10 38 -inf inf])
set(ax,'XTick',[6, 12, 18, 24, 30, 36, 42, 48])
months = [ 'Jun(2013)'; 'Dec(2013)'; 'Jun(2014)' ;'Dec(2014)'; 'Jun(2015)';'Dec(2015)';'Jun(2016)';'Dec(2016)'];
set(ax,'XTickLabel',months, 'FontSize', 16)
%set(ax,'YTick',[-1 -0.5 0 0.5 1])
legend({'dog', 'cat'}, 'FontSize', 16, 'Location', 'best');
title('-------- Frequencies --------', 'FontSize', 26);
xlabel('Year/Month', 'FontSize', 19); % x-axis label
ylabel('Frequency', 'FontSize', 19); % y-axis label
grid on


subplot(2, 1, 2);
hold on 
%plot( 1:(length_year * length_month), ( sum(total_freq_date) / sum( sum(total_freq_date) ) ), 'r', 'linewidth', 2);
plot( 1:(length_year * length_month), ( sum(dog_freq_date) / sum( sum(dog_freq_date) ) ) , 'b', 'linewidth', 2);
plot( 1:(length_year * length_month), ( sum(cat_freq_date) / sum( sum(cat_freq_date) ) ) , 'k', 'linewidth', 2);
ax = gca;
axis([10 38 -inf inf])
set(ax,'XTick',[6, 12, 18, 24, 30, 36, 42, 48])
months = [ 'Jun(2013)'; 'Dec(2013)'; 'Jun(2014)' ;'Dec(2014)'; 'Jun(2015)';'Dec(2015)';'Jun(2016)';'Dec(2016)'];
set(ax,'XTickLabel',months, 'FontSize', 16)
legend({'dog', 'cat'}, 'FontSize', 16, 'Location', 'best');
title('-------- Frequencies (Normalized) --------', 'FontSize', 26);
xlabel('Year/Month', 'FontSize', 19); % x-axis label
ylabel('Frequency', 'FontSize', 19); % y-axis label
grid on

figure,
subplot(2, 1, 1);
hold on;
plot( 1:(length_year * length_month), total_freq_date( 1, : ) , 'r', 'linewidth', 2);
plot( 1:(length_year * length_month), total_freq_date( 2, : ) , 'b', 'linewidth', 2);
plot( 1:(length_year * length_month), total_freq_date( 3, : ) , 'g', 'linewidth', 2);
plot( 1:(length_year * length_month), total_freq_date( 4, : ) , 'm', 'linewidth', 2);
plot( 1:(length_year * length_month), total_freq_date( 5, : ) , 'k', 'linewidth', 2);
ax = gca;
axis([10 38 -inf inf])
set(ax,'XTick',[6, 12, 18, 24, 30, 36, 42, 48])
months = [ 'Jun(2013)'; 'Dec(2013)'; 'Jun(2014)' ;'Dec(2014)'; 'Jun(2015)';'Dec(2015)';'Jun(2016)';'Dec(2016)'];
set(ax,'XTickLabel',months, 'FontSize', 16)
legend({'Return to owner', 'Euthanasia', 'Adoption', 'Transfer', 'Died'}, 'FontSize', 14, 'Location', 'best');
title('-------- Frequencies for each target --------', 'FontSize', 26);
xlabel('Year/Month', 'FontSize', 19); % x-axis label
ylabel('Frequency', 'FontSize', 19); % y-axis label
grid on

subplot(2, 1, 2);
hold on;
plot( 1:(length_year * length_month), ( total_freq_date( 1, : ) ./ sum( total_freq_date ) ), 'r', 'linewidth', 2);
plot( 1:(length_year * length_month), ( total_freq_date( 2, : ) ./ sum( total_freq_date ) ), 'b', 'linewidth', 2);
plot( 1:(length_year * length_month), ( total_freq_date( 3, : ) ./ sum( total_freq_date ) ), 'g', 'linewidth', 2);
plot( 1:(length_year * length_month), ( total_freq_date( 4, : ) ./ sum( total_freq_date ) ), 'm', 'linewidth', 2);
plot( 1:(length_year * length_month), ( total_freq_date( 5, : ) ./ sum( total_freq_date ) ), 'k', 'linewidth', 2);
ax = gca;
axis([10 38 -inf inf])
set(ax,'XTick',[6, 12, 18, 24, 30, 36, 42, 48])
months = [ 'Jun(2013)'; 'Dec(2013)'; 'Jun(2014)' ;'Dec(2014)'; 'Jun(2015)';'Dec(2015)';'Jun(2016)';'Dec(2016)'];
set(ax,'XTickLabel',months, 'FontSize', 16)
legend({'Return to owner', 'Euthanasia', 'Adoption', 'Transfer', 'Died'}, 'FontSize', 14, 'Location', 'best');
title('-------- Frequencies for each target (normalized) --------', 'FontSize', 26);
xlabel('Year/Month', 'FontSize', 19); % x-axis label
ylabel('Frequency', 'FontSize', 19); % y-axis label
grid on



figure,
subplot(2, 1, 1);
hold on;
plot( 1:(length_year * length_month), dog_freq_date( 1, : ) , 'r', 'linewidth', 2);
plot( 1:(length_year * length_month), dog_freq_date( 2, : ) , 'b', 'linewidth', 2);
plot( 1:(length_year * length_month), dog_freq_date( 3, : ) , 'g', 'linewidth', 2);
plot( 1:(length_year * length_month), dog_freq_date( 4, : ) , 'm', 'linewidth', 2);
plot( 1:(length_year * length_month), dog_freq_date( 5, : ) , 'k', 'linewidth', 2);
ax = gca;
axis([10 38 -inf inf])
set(ax,'XTick',[6, 12, 18, 24, 30, 36, 42, 48])
months = [ 'Jun(2013)'; 'Dec(2013)'; 'Jun(2014)' ;'Dec(2014)'; 'Jun(2015)';'Dec(2015)';'Jun(2016)';'Dec(2016)'];
set(ax,'XTickLabel',months, 'FontSize', 16)
legend({'Return to owner', 'Euthanasia', 'Adoption', 'Transfer', 'Died'}, 'FontSize', 14, 'Location', 'best');
title('-------- Frequencies of DOGS for each target --------', 'FontSize', 26);
xlabel('Year/Month', 'FontSize', 19); % x-axis label
ylabel('Frequency', 'FontSize', 19); % y-axis label
grid on

subplot(2, 1, 2);
hold on;
plot( 1:(length_year * length_month), ( dog_freq_date( 1, : ) ./ sum( dog_freq_date ) ) , 'r', 'linewidth', 2);
plot( 1:(length_year * length_month), ( dog_freq_date( 2, : ) ./ sum( dog_freq_date ) ) , 'b', 'linewidth', 2);
plot( 1:(length_year * length_month), ( dog_freq_date( 3, : ) ./ sum( dog_freq_date ) ) , 'g', 'linewidth', 2);
plot( 1:(length_year * length_month), ( dog_freq_date( 4, : ) ./ sum( dog_freq_date ) ) , 'm', 'linewidth', 2);
plot( 1:(length_year * length_month), ( dog_freq_date( 5, : ) ./ sum( dog_freq_date ) ) , 'k', 'linewidth', 2);
ax = gca;
axis([10 38 -inf inf])
set(ax,'XTick',[6, 12, 18, 24, 30, 36, 42, 48])
months = [ 'Jun(2013)'; 'Dec(2013)'; 'Jun(2014)' ;'Dec(2014)'; 'Jun(2015)';'Dec(2015)';'Jun(2016)';'Dec(2016)'];
set(ax,'XTickLabel',months, 'FontSize', 16)
legend({'Return to owner', 'Euthanasia', 'Adoption', 'Transfer', 'Died'}, 'FontSize', 14, 'Location', 'best');
title('-------- Frequencies of DOGS for each target (normalized) --------', 'FontSize', 26);
xlabel('Year/Month', 'FontSize', 19); % x-axis label
ylabel('Frequency', 'FontSize', 19); % y-axis label
grid on



figure,
subplot(2, 1, 1);
hold on;
plot( 1:(length_year * length_month), cat_freq_date( 1, : ) , 'r', 'linewidth', 2, 'linewidth', 2);
plot( 1:(length_year * length_month), cat_freq_date( 2, : ) , 'b', 'linewidth', 2, 'linewidth', 2);
plot( 1:(length_year * length_month), cat_freq_date( 3, : ) , 'g', 'linewidth', 2, 'linewidth', 2);
plot( 1:(length_year * length_month), cat_freq_date( 4, : ) , 'm', 'linewidth', 2, 'linewidth', 2);
plot( 1:(length_year * length_month), cat_freq_date( 5, : ) , 'k', 'linewidth', 2, 'linewidth', 2);
ax = gca;
axis([10 38 -inf inf])
set(ax,'XTick',[6, 12, 18, 24, 30, 36, 42, 48])
months = [ 'Jun(2013)'; 'Dec(2013)'; 'Jun(2014)' ;'Dec(2014)'; 'Jun(2015)';'Dec(2015)';'Jun(2016)';'Dec(2016)'];
set(ax,'XTickLabel',months, 'FontSize', 16)
legend({'Return to owner', 'Euthanasia', 'Adoption', 'Transfer', 'Died'}, 'FontSize', 14, 'Location', 'best');
title('-------- Frequencies of CATS for each target --------', 'FontSize', 26);
xlabel('Year/Month', 'FontSize', 19); % x-axis label
ylabel('Frequency', 'FontSize', 19); % y-axis label
grid on

subplot(2, 1, 2);
hold on;
plot( 1:(length_year * length_month), ( cat_freq_date( 1, : ) ./ sum( cat_freq_date ) ) , 'r', 'linewidth', 2);
plot( 1:(length_year * length_month), ( cat_freq_date( 2, : ) ./ sum( cat_freq_date ) ) , 'b', 'linewidth', 2);
plot( 1:(length_year * length_month), ( cat_freq_date( 3, : ) ./ sum( cat_freq_date ) ) , 'g', 'linewidth', 2);
plot( 1:(length_year * length_month), ( cat_freq_date( 4, : ) ./ sum( cat_freq_date ) ) , 'm', 'linewidth', 2);
plot( 1:(length_year * length_month), ( cat_freq_date( 5, : ) ./ sum( cat_freq_date ) ) , 'k', 'linewidth', 2);
ax = gca;
axis([10 38 -inf inf])
set(ax,'XTick',[6, 12, 18, 24, 30, 36, 42, 48])
months = [ 'Jun(2013)'; 'Dec(2013)'; 'Jun(2014)' ;'Dec(2014)'; 'Jun(2015)';'Dec(2015)';'Jun(2016)';'Dec(2016)'];
set(ax,'XTickLabel',months, 'FontSize', 16)
legend({'Return to owner', 'Euthanasia', 'Adoption', 'Transfer', 'Died'}, 'FontSize', 14, 'Location', 'best');
title('-------- Frequencies of CATS for each target (Normalized)--------', 'FontSize', 26);
xlabel('Year/Month', 'FontSize', 19); % x-axis label
ylabel('Frequency', 'FontSize', 19); % y-axis label
grid on