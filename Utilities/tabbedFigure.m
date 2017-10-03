function [axesHandle,tabHandle]=tabbedFigure(parentFig,tabName)
%TABBEDFIGURE creates a new tabbed figure window or adds a new tab to an existing
%one.
%   AX = TABBEDFIGURE(H,TABNAME) creates new axes in a tab with title 'TabName'
%   inside the figure H and returns its handle. 
%   If TABNAME is a character cell-array of length N, N new tabs are
%   created, each with name TABNAME{i}
%
%   [AX,TAB] = TABBEDFIGURE(_) returns both the handle of the axes and the
%   parent tab.
%
%   Right-clicking on a tab's label or anywhere inside, it's possible to:
%      * RENAME current tab   
%      * CLOSE current tab
%      * COPY current tab to a new standalone figure (The tab name is
%      setted both as name and tag of the new figure)
%      * COPY ALL TABS to new standalone figures (The tab name of each tab is
%      setted both as name and tag of each new figure)
%      * SAVE current tab as a standalone figure in a .fig file
%      * SAVE ALL TABS as standalone figures in .fig files
%
%   Example:
%      f=figure;
%      ax=tabbedFigure(f,'test);
%      plot(1:10,randn(1,10));
%
%   By Luca Amerio
%   luca.amerio@polimi.it
%   28/01/2016

narginchk(2,2)
nargoutchk(0,2)

%Converts tabName to cell-array
if ischar(tabName)
    tabName={tabName};
elseif iscellstr(tabname)
else
    error('Tab name must be a string or a cell array of strings')
end

%Check if parentFig exists. If it doesn't, open a new figure
if ~(ishandle(parentFig) && strcmp(get(parentFig,'type'),'figure'))
    error('First input must be a valid figure handle')
end

%Check if the figure contains a uitabgroup. If not, create one.
tgroup=findobj(get(parentFig,'Children'),'type','uitabgroup');
if isempty(tgroup)
    tgroup = uitabgroup('Parent', parentFig);
elseif length(tgroup)>1
    error('Found more than one uitabgroup')
end

for i=1:length(tabName)
    %Creates the new tab
    tab=uitab('Parent', tgroup, 'Title', tabName{i},'Tag',tabName{i});
    c = uicontextmenu('Parent',parentFig);
    tab.UIContextMenu = c;
    
    %Creates the uimenu
    uimenu(c,'Label','Rename Tab','Callback',{@renameTab,tab});
    uimenu(c,'Label','Close Tab','Callback',{@closeTab,tab});
    uimenu(c,'Label','Copy this tab to a new figure','Callback',{@copyTab,tab},'Separator','on');
    uimenu(c,'Label','Copy all tabs to new figures','Callback',{@copyAllTabs,tgroup});
    uimenu(c,'Label','Save this tab as a stand-alone figure','Callback',{@saveTab,tab},'Separator','on');
    uimenu(c,'Label','Save all tabs as stand-alone figures','Callback',{@saveAllTabs,tgroup});
    
    axesHandle(i)=axes('Parent', tab);
    tabHandle(i)=tab;
end

    function renameTab(~,~,tab)
        newName=inputdlg('New name:');
        if isempty(newName{1})
            return
        else
            tab.Title=newName{1};
            tab.Tag=newName{1};
        end
    end

    function closeTab(~,~,tab)
        delete(tab)
    end

    function copyTab(~,~,tab)
        newFig=figure;
        copyobj(tab.Children,newFig);
        newFig.Name=tab.Title;
        newFig.Tag=tab.Title;
    end

    function copyAllTabs(~,~,tGroup)
        for t=tGroup.Children'
            newFig=figure;
            copyobj(t.Children,newFig);
            newFig.Name=t.Title;
            newFig.Tag=t.Title;
        end
    end

    function saveTab(~,~,tab)
        newFig=figure;
        copyobj(tab.Children,newFig);
        newFig.Name=tab.Title;
        [f,d]=uiputfile('*.fig','Save Tab',fullfile(pwd,tab.Title));
        if d==0
            return
        end
        savefig(newFig,fullfile(d,f))
        close(newFig)
    end

    function saveAllTabs(~,~,tGroup)
        default_d=uigetdir('Choose target dir',pwd);
        if default_d==0
            return
        end
        for t=tGroup.Children'
            d=default_d;
            newFig=figure;
            copyobj(t.Children,newFig);
            newFig.Name=t.Title;
            f=t.Title;
            if exist(fullfile(default_d,[f,'.fig']),'file')
                button = questdlg(sprintf('File %s already exists. Do you want to overwrite it?',default_d),'Overwrite','Yes','No','Rename','No');
                switch button
                    case 'Yes'
                    case 'No'
                        close(newFig)
                        continue
                    case 'Rename'
                        [f,d]=uiputfile('*.fig','Save Tab',pwd);
                        if d==0
                            close(newFig)
                            continue
                        end
                end
            end
            savefig(newFig,fullfile(d,f))
            close(newFig)
        end
    end
end