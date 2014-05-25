function [] = bom()

% Browse for the file
cd 'C:\'
filename = fileBrowse();

excelbom = xlsread(filename);
disp('awesome');
end

function filename = fileBrowse()
    folderSelect = true;
    filename = '';
    while folderSelect == true

        % List the files / folders in the cd
        ls = dir;
        x = size(ls);
        menuList = cell(1,x(1)+1);
        menuList(1,1) = cellstr('Back up one level');
        for i = 1:x(1)
            menuList(1, i+1) = cellstr(ls(i).name);
        end
        sel = menu('Browse',menuList);

        if sel == 1
            cd ..
        else
            %Check if the selection is a file or a folder
            result = exist(ls(sel-1).name, 'file');

            % result is a folder
            if result == 7
                cdSel = strcat(pwd, '\', ls(sel-1).name,'\');
                cd(cdSel);
            end

            %result is a file
            if result == 2 
                filename = ls(sel-1).name;
                folderSelect = false;
            end
        end
    end

end

