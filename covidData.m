% type: 'Cases' or 'Death'


function covidData(T)
T = readtable('rows.csv');
%Scrub data
T(:, [13:15]) = [];
T{:,3:end}(isnan(T{:,3:end})) = 0;

Tsort = sortrows(T, 'submission_date');   %Sort all rows by date (earliest to latest)

fig = uifigure;             %creates a parent figure called 'fig'
%fig.AutoResizeChildren = 'off';
fig.Position(1:2:3:4) = [20 20 900 600];

g = uigridlayout(fig);       %creates a grid within fig (child of fig)
g.RowHeight = {'1x'};
g.ColumnWidth = {300,600};     %size of grid

g_left = uigridlayout(g);     %creates another grid called g_left within grid g (child of g)
g_left.Layout.Row = 1;        %this allows for more add ons to the figure in the future 
g_left.Layout.Column = 1;
g_left.RowHeight = {30, '1x'};
g_left.ColumnWidth = {250};

%ax = uiaxes('Parent',fig,...
  %  'Position',[10 10 300 300]);

val = 'CA';
Tfiltered = Tsort(strcmp(Tsort.state, val),:);     %sorts all rows by date

p = uipanel(g);            %creates a panel within the grid g (child of g)
p.Layout.Row = 1;
p.Layout.Column = 2;
p.AutoResizeChildren = 'off';

ax1 = subplot(2,1,1,'Parent', p);
plot(ax1, Tfiltered.submission_date, Tfiltered.tot_cases, 'b');     %plot of cases

xlabel(ax1, 'Date');
ylabel(ax1, 'Cases');
ax1.XGrid = 'on';
ax1.YGrid = 'on';
titleCases = "Total COVID Cases in  Over Time";
overallTitleCases = insertAfter(titleCases, "Total COVID Cases in ", val);
title(ax1, overallTitleCases);

ax2 = subplot(2,1,2,'Parent', p);
plot(ax2, Tfiltered.submission_date, Tfiltered.tot_death, 'r');     %plot of deaths

xlabel(ax2, 'Date');
ylabel(ax2, 'Death');
ax2.XGrid = 'on';
ax2.YGrid = 'on';
titleDeath = "Total COVID Deaths in  Over Time";
overallTitleDeath = insertAfter(titleDeath, "Total COVID Deaths in ", val);
title(ax2, overallTitleDeath);


dd = uidropdown(g_left, ...            %Create a dropdown menu
    'Position',[20 20 150 40],...
    'Items',{'AL', 'AK', 'AS', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FM', 'FL', 'GA', 'GU', 'HI', 'ID', 'IL', 'IN', 'IA','KS', 'KY', 'LA', 'ME', 'MH', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'MP', 'OH', 'OK', 'OR', 'PW', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VI', 'VA', 'WA', 'WV', 'WI', 'WY'},... 
    'Value','CA',...
   'ValueChangedFcn',@(dd,event) selection(dd, Tsort,ax1, ax2));
dd.Layout.Row = 1;
dd.Layout.Column = 1;

end


% Create ValueChangedFcn callback:
function selection(dd, Tsort, ax1, ax2)

val = dd.Value;
fprintf('%s\n', val);     %Filter out rows based on dropdown selection 

Tfiltered = Tsort(strcmp(Tsort.state, val),:);  

plot(ax1, Tfiltered.submission_date, Tfiltered.tot_cases, 'b');     %plot of cases
xlabel(ax1, 'Date');
ylabel(ax1, 'Cases');
ax1.XGrid = 'on';
ax1.YGrid = 'on';
titleCases = "Total COVID Cases in  Over Time";
overallTitleCases = insertAfter(titleCases, "Total COVID Cases in ", val);
title(ax1, overallTitleCases);

plot(ax2, Tfiltered.submission_date, Tfiltered.tot_death, 'r');     %plot of deaths
xlabel(ax2, 'Date');
ylabel(ax2, 'Death');
ax2.XGrid = 'on';
ax2.YGrid = 'on';
titleDeath = "Total COVID Deaths in  Over Time";
overallTitleDeath = insertAfter(titleDeath, "Total COVID Deaths in ", val);
title(ax2, overallTitleDeath);

end


