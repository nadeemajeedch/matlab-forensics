%File per generare le varie immagini a jpeg a partire da 
%imamgini di tipo tiff

function crea_tampering_cfa(path,destfoldername,test_size,tamper_size,qsteps)
    
    dirname= fullfile(path,destfoldername);   
    mkdir(dirname);
    filetype='*.tif';
    
    % pattern di CFA

    Bayer_G=[0,1;
             1,0];
    
    Bayer_R=[1,0;
             0,0];
     
    Bayer_B=[0,0; 
             0,1];
     
    
    img_list=dir(fullfile(path,filetype));    
    for i=1:length(img_list)
        original_image_name=img_list(i).name;        
        %TIFF=imread(strcat(path,original_image_name)); 
        TIFF = takeCenterBlock(fullfile(path,original_image_name), test_size,'align');
        fprintf('Converto l''immagine %d/%d con CFA\n',i,length(img_list));
        % creo l'immagine tiff modificata (q2=0)
        % image selection
        [h,w,dummy] = size(TIFF);
       
        
        TIFF=uint8(filtro_bilineare(TIFF,Bayer_R,Bayer_G,Bayer_B));
        
        
        % regione manipolata
        p1 = floor(([h w] - tamper_size))/2 + 1;
        p2 = p1 + tamper_size - 1;
        region_tampered = TIFF(p1(1):p2(1),p1(2):p2(2),:);
        region_tampered = imresize(region_tampered,2);
        region_tampered(:,:,2) = medfilt2(region_tampered(:,:,2),[7 7],'symmetric');
        region_tampered(:,:,1) = medfilt2(region_tampered(:,:,1),[7 7],'symmetric');
        region_tampered(:,:,3) = medfilt2(region_tampered(:,:,3),[7 7],'symmetric');
        region_tampered = imresize(region_tampered,0.5);
        
        for k=p1(1):p2(1)
            for j=p1(2):p2(2)
                TIFF(k,j,:)=region_tampered(k-p1(1)+1,j-p1(2)+1,:);          
            end
        end                   
        
%        newdir='Q2_0';
%         if ispc
%             if(exist(strcat(dirname,'\',newdir),'dir')==0)
%                 mkdir(dirname,newdir);     
%             end
%             imwrite(TIFF,[dirname,'\',newdir,'\',original_image_name,'_Q1_','0','_Q2_','0','.tif']);            
%         else
%             if(exist(strcat(dirname,'/',newdir),'dir')==0)
%                 mkdir(dirname,newdir);                  
%             end                      
%             imwrite(TIFF,[dirname,'/',newdir,'/',original_image_name,'_Q1_','0','_Q2_','0','.tif']);            
%         end      
        
        for Q1=qsteps 
%            newdir=strcat('Q2_',num2str(Q1));
             imwrite(TIFF,fullfile(dirname,[original_image_name,'.CFA_Q1_',num2str(Q1),'_Q2_','0','.jpg']),'Mode','lossy','Quality',Q1);                                      
        end
    end 
end