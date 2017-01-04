function vtkWrite(datapts,filename,connSize)

    connectivitySize = connSize;
    celltype = 4;
    fid = fopen(filename, 'w'); 
    fprintf(fid, '# vtk DataFile Version 2.0\n');
    fprintf(fid, 'VTK from Matlab\n');
    fprintf(fid, 'ASCII\n');
    fprintf(fid, 'DATASET UNSTRUCTURED_GRID\n');
    n_elements = size(datapts);
    fprintf(fid, ['POINTS ' num2str(n_elements(1)) ' float\n']);
    fprintf(fid,'%f %f %f\n', [datapts(:,:)']);
    cellSize = n_elements(1)/connectivitySize;
    fprintf(fid,'CELLS %d %d\n',cellSize,(connectivitySize+1)*cellSize);
    format = [];

    for indd = 1:connectivitySize+1
        if indd == connectivitySize+1
            format = [format '%d\n'];
        else
            format = [format '%d ']; 
        end
    end

    for ij = 1:cellSize
        ending = (ij*connectivitySize)-1;
        start = ending-(connectivitySize-1);
% % % % % % % % % %         l = start:ending;
        fprintf(fid,format,connectivitySize,start:ending);
    end

    fprintf(fid,'CELL_TYPES %d\n',cellSize);

    for jk = 1:cellSize
        if(jk == cellSize)
            fprintf(fid,'%d',celltype);
        else    
            fprintf(fid,'%d\n',celltype);
        end
    end


end


% % ? ?? datapts ? visualize ??? 3D coordinate list ??? i.e, [(1, 2, 3),(3,4,5)....].
% % 
% % filename ?  ?? ???? ?? ????? ??? ???? ???. 
% % 
% % connSize? '2' ? ???? ????? ?