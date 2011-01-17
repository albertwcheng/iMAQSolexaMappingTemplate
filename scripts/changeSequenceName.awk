  
  	BEGIN{
  		
  		if(length(seqName)<1){
			printf("seqName not defined, exit\n") > "/dev/stderr"
  			exit;	
  		}	
  		
  	}
	
    {
    	
    	remainder=FNR%4;
     	
     	if(remainder==1){
        	readNo=((FNR-1)/4+1)
        	printf("@%s:%d\n",seqName,readNo);
        	if(readNo%100000==1){
        		printf("processing read#%d\n",readNo) > "/dev/stderr"
        	}
        }
        
        if(remainder==2 || remainder==0){
        	printf("%s\n",$0);
        }
        
        if(remainder==3){
        	printf("+\n");
        }
        
             	
     	
     }