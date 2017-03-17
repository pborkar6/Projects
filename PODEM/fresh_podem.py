
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 24 17:58:25 2016

@author: Pranjali
"""






def Imply(ipvector):
    print('entering imply')
    
    for i in range(N-2):
        
        G.node[i]['ot']=0
        if(G.node[i]['type']=='INV' or G.node[i]['type']=='BUF'):
            G.node[i]['it']=0
        if(G.node[i]['type']!='INV' and G.node[i]['type']!='BUF'):
            G.node[i]['it1']=0
            G.node[i]['it2']=0
        
        # Initializing inputs 
    for y in range(1,len(Input)-1):
        for x in range (N-2):    
            if(G.node[x]['type']=='INV' or G.node[x]['type']=='BUF'):
                if(Input[y]==G.node[x]['ip']):
                    G.node[x]['IP'] = ipvector[y-1]
                    G.node[x]['it']=1
                    
                    
                        
            if(G.node[x]['type']!='INV' and G.node[x]['type']!='BUF'):
                if(Input[y]==G.node[x]['ip1']):
                    G.node[x]['IP1'] = ipvector[y-1]
                    G.node[x]['it1']=1
                    
                if(Input[y]==G.node[x]['ip2']):
                    G.node[x]['IP2'] = ipvector[y-1]
                    G.node[x]['it2']=1
                    
        
       
    a=0
    #G.nodes(data=True)
    for b in range (0, 300):
        for i in range(N-2):
            if(G.node[i]['type']=='INV'):
                if(int(G.node[i]['ot'])==0 and int(G.node[i]['it'])==1):
                    if (int(G.node[i]['IP'])==1):
                        G.node[i]['OP']=0
                        G.node[i]['ot']=1
                    elif (int(G.node[i]['IP'])==0):
                        G.node[i]['OP']=1
                        G.node[i]['ot']=1
                    elif (int(G.node[i]['IP'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3

                    for j in range(N-2): 
                #print('enter for loop')
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[fault_gate]['type']=='INV' or G.node[fault_gate]['type']=='BUF'):
                                if(int(G.node[fault_gate]['ip'])==fault_net ):
                                    #print("Ip or buf activated")
                                    if(f_v==0 and int(G.node[fault_gate]['IP']==1)):
                                        (G.node[fault_gate]['IP'])=5  
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['IP'])==0)):
                                        (G.node[fault_gate]['IP'])=6
                                        act=1
                                        print('fault activated')
                                        
                                if (int(G.node[fault_gate]['op'])==fault_net):
                                    if(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                    if(f_v==0 and (int(G.node[fault_gate]['OP'])==1)):
                                        (G.node[fault_gate]['OP'])=5
                                        act=1
                                        print('fault activated')
                                        
                                
                                  
                                     
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            #print('2 input')
                            if(G.node[fault_gate]['type']!='INV' and G.node[fault_gate]['type']!='BUF'):
                                if(int(G.node[fault_gate]['ip1'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP1 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP1']==1)):
                                        print('fault activated')
                                        (G.node[fault_gate]['IP1'])=5
                                        print("fault gate =", fault_gate)
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP1'])==0):
                                        (G.node[fault_gate]['IP1'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif(int(G.node[fault_gate]['ip2'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP2 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP2'])==1):
                                        (G.node[fault_gate]['IP2'])=5 
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP2'])==0):
                                        (G.node[fault_gate]['IP2'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif((G.node[fault_gate]['op'])==fault_net):
                                    #print("op is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['OP'])==1):
                                        (G.node[fault_gate]['OP'])=5 
                                        act=1
                                        print('fault activated')
            #                            S='Success'
            #                            return S
                                        
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
            #                            S='Success'
            #                            return S
                    

                    for j in range(len(M)-2):
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip']):
                                print('getting transferred')
                                G.node[j]['IP']=G.node[i]['OP']
                                G.node[j]['it']=G.node[i]['ot']
                                
                                #G.node[j]['ipfault'].extend([(G.node[i]['outfault'])])
                                #print (G.node[i]['ipfault'])
                                
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip1']):
                                G.node[j]['IP1']=G.node[i]['OP']
                                G.node[j]['it1']=G.node[i]['ot']
                                #G.node[j]['ip1fault'].extend([(G.node[i]['outfault'])])
                                a=a+1
                                #print (G.node[i]['ip1fault'])
                                
                            if(G.node[i]['op']==G.node[j]['ip2']):
                                G.node[j]['IP2']=G.node[i]['OP']
                                G.node[j]['it2']=G.node[i]['ot']
                                

                    
                    

                                
            if(G.node[i]['type']=='BUF'):
                if(int(G.node[i]['ot'])==0 and int(G.node[i]['it'])==1):
                    
                    if (int(G.node[i]['IP'])==1):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=1
                    elif (int(G.node[i]['IP'])==0):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=0
                    elif (int(G.node[i]['IP'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3

                    for j in range(N-2): 
                #print('enter for loop')
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[fault_gate]['type']=='INV' or G.node[fault_gate]['type']=='BUF'):
                                if(int(G.node[fault_gate]['ip'])==fault_net ):
                                    #print("Ip or buf activated")
                                    if(f_v==0 and int(G.node[fault_gate]['IP']==1)):
                                        (G.node[fault_gate]['IP'])=5  
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['IP'])==0)):
                                        (G.node[fault_gate]['IP'])=6
                                        act=1
                                        print('fault activated')
                                        
                                if (int(G.node[fault_gate]['op'])==fault_net):
                                    if(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                    if(f_v==0 and (int(G.node[fault_gate]['OP'])==1)):
                                        (G.node[fault_gate]['OP'])=5
                                        act=1
                                        print('fault activated')
                                        
                                
                                  
                                     
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            #print('2 input')
                            if(G.node[fault_gate]['type']!='INV' and G.node[fault_gate]['type']!='BUF'):
                                if(int(G.node[fault_gate]['ip1'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP1 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP1']==1)):
                                        print('fault activated')
                                        (G.node[fault_gate]['IP1'])=5
                                        print("fault gate =", fault_gate)
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP1'])==0):
                                        (G.node[fault_gate]['IP1'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif(int(G.node[fault_gate]['ip2'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP2 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP2'])==1):
                                        (G.node[fault_gate]['IP2'])=5 
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP2'])==0):
                                        (G.node[fault_gate]['IP2'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif((G.node[fault_gate]['op'])==fault_net):
                                    
                                    if(f_v==0 and int(G.node[fault_gate]['OP'])==1):
                                        (G.node[fault_gate]['OP'])=5 
                                        act=1
                                        print('fault activated')
            
                                        
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
           
                    for j in range(len(M)-2):
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip']):
                                print('getting transferred')
                                G.node[j]['IP']=G.node[i]['OP']
                                G.node[j]['it']=G.node[i]['ot']
                                
                                
                                
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip1']):
                                G.node[j]['IP1']=G.node[i]['OP']
                                G.node[j]['it1']=G.node[i]['ot']
                                
                                a=a+1
                                #print (G.node[i]['ip1fault'])
                                
                            if(G.node[i]['op']==G.node[j]['ip2']):
                                G.node[j]['IP2']=G.node[i]['OP']
                                G.node[j]['it2']=G.node[i]['ot']
                    

 
            if(G.node[i]['type']=='AND'):
                if(int(G.node[i]['ot'])==0 and int(G.node[i]['it1'])==1 and int(G.node[i]['it2'])==1):
                    
                    
                    if (int(G.node[i]['IP1'])==1 and int(G.node[i]['IP2'])==1):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=1
                    elif (int(G.node[i]['IP1'])==1 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==1 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==1 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==1):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==1):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==1):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=0
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=0
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    else:
                        G.node[i]['OP']=0
                        G.node[i]['ot']=1
                        


                    for j in range(N-2): 
               
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[fault_gate]['type']=='INV' or G.node[fault_gate]['type']=='BUF'):
                                if(int(G.node[fault_gate]['ip'])==fault_net ):
                                   
                                    if(f_v==0 and int(G.node[fault_gate]['IP']==1)):
                                        (G.node[fault_gate]['IP'])=5  
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['IP'])==0)):
                                        (G.node[fault_gate]['IP'])=6
                                        act=1
                                        print('fault activated')
                                        
                                if (int(G.node[fault_gate]['op'])==fault_net):
                                    if(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                    if(f_v==0 and (int(G.node[fault_gate]['OP'])==1)):
                                        (G.node[fault_gate]['OP'])=5
                                        act=1
                                        print('fault activated')
                                        
                                
                                  
                                     
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            
                            if(G.node[fault_gate]['type']!='INV' and G.node[fault_gate]['type']!='BUF'):
                                if(int(G.node[fault_gate]['ip1'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                  
                                    if(f_v==0 and int(G.node[fault_gate]['IP1']==1)):
                                        print('fault activated')
                                        (G.node[fault_gate]['IP1'])=5
                                        print("fault gate =", fault_gate)
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP1'])==0):
                                        (G.node[fault_gate]['IP1'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif(int(G.node[fault_gate]['ip2'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP2 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP2'])==1):
                                        (G.node[fault_gate]['IP2'])=5 
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP2'])==0):
                                        (G.node[fault_gate]['IP2'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif((G.node[fault_gate]['op'])==fault_net):
                                    #print("op is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['OP'])==1):
                                        (G.node[fault_gate]['OP'])=5 
                                        act=1
                                        print('fault activated')
            
                                        
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
           
                    for j in range(len(M)-2):
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip']):
                                G.node[j]['IP']=G.node[i]['OP']
                                G.node[j]['it']=G.node[i]['ot']
                                
                                #G.node[j]['ipfault'].extend([(G.node[i]['outfault'])])
                                #print (G.node[i]['ipfault'])
                                
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip1']):
                                G.node[j]['IP1']=G.node[i]['OP']
                                G.node[j]['it1']=G.node[i]['ot']
                                #G.node[j]['ip1fault'].extend([(G.node[i]['outfault'])])
                                a=a+1
                                #print (G.node[i]['ip1fault'])
                                
                            if(G.node[i]['op']==G.node[j]['ip2']):
                                G.node[j]['IP2']=G.node[i]['OP']
                                G.node[j]['it2']=G.node[i]['ot']

                    


                      
                    
                
                
            if(G.node[i]['type']=='OR'):
                 if(int(G.node[i]['ot'])==0 and int(G.node[i]['it1'])==1 and int(G.node[i]['it2'])==1):
                    if (int(G.node[i]['IP1'])==0 and int(G.node[i]['IP2'])==0):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=0
                    elif (int(G.node[i]['IP1'])==0 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==0 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==0 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==0):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==0):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==0):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=1
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=1
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                                
                    else:
                        G.node[i]['OP']=1
                        G.node[i]['ot']=1

                    for j in range(N-2): 
                
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[fault_gate]['type']=='INV' or G.node[fault_gate]['type']=='BUF'):
                                if(int(G.node[fault_gate]['ip'])==fault_net ):
                                    #print("Ip or buf activated")
                                    if(f_v==0 and int(G.node[fault_gate]['IP']==1)):
                                        (G.node[fault_gate]['IP'])=5  
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['IP'])==0)):
                                        (G.node[fault_gate]['IP'])=6
                                        act=1
                                        print('fault activated')
                                        
                                if (int(G.node[fault_gate]['op'])==fault_net):
                                    if(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                    if(f_v==0 and (int(G.node[fault_gate]['OP'])==1)):
                                        (G.node[fault_gate]['OP'])=5
                                        act=1
                                        print('fault activated')
                                        
                                
                                  
                                     
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            
                            if(G.node[fault_gate]['type']!='INV' and G.node[fault_gate]['type']!='BUF'):
                                if(int(G.node[fault_gate]['ip1'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP1 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP1']==1)):
                                        print('fault activated')
                                        (G.node[fault_gate]['IP1'])=5
                                        print("fault gate =", fault_gate)
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP1'])==0):
                                        (G.node[fault_gate]['IP1'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif(int(G.node[fault_gate]['ip2'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP2 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP2'])==1):
                                        (G.node[fault_gate]['IP2'])=5 
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP2'])==0):
                                        (G.node[fault_gate]['IP2'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif((G.node[fault_gate]['op'])==fault_net):
                                    #print("op is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['OP'])==1):
                                        (G.node[fault_gate]['OP'])=5 
                                        act=1
                                        print('fault activated')
            
                                        
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
           
                    for j in range(len(M)-2):
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip']):
                                G.node[j]['IP']=G.node[i]['OP']
                                G.node[j]['it']=G.node[i]['ot']
                                
                                #G.node[j]['ipfault'].extend([(G.node[i]['outfault'])])
                                #print (G.node[i]['ipfault'])
                                
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip1']):
                                G.node[j]['IP1']=G.node[i]['OP']
                                G.node[j]['it1']=G.node[i]['ot']
                                #G.node[j]['ip1fault'].extend([(G.node[i]['outfault'])])
                                a=a+1
                                #print (G.node[i]['ip1fault'])
                                
                            if(G.node[i]['op']==G.node[j]['ip2']):
                                G.node[j]['IP2']=G.node[i]['OP']
                                G.node[j]['it2']=G.node[i]['ot']

#                    


                                
            if(G.node[i]['type']=='NAND'):
                
                if(int(G.node[i]['ot'])==0 and int(G.node[i]['it1'])==1 and int(G.node[i]['it2'])==1):
                    if (int(G.node[i]['IP1'])==1 and int(G.node[i]['IP2'])==1):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=0
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=1
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=1
                    elif (int(G.node[i]['IP1'])==1 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==1 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==1):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==1):
                        print("ip1 5 ip2 1")
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                        if(i==6):
                            print("op val of 6th node:",G.node[i]['OP'])
                    elif (int(G.node[i]['IP1'])==1 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==1):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                                
                    else:
                        G.node[i]['ot']=1
                        G.node[i]['OP']=1

                    for j in range(N-2): 
                #print('enter for loop')
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[fault_gate]['type']=='INV' or G.node[fault_gate]['type']=='BUF'):
                                if(int(G.node[fault_gate]['ip'])==fault_net ):
                                    #print("Ip or buf activated")
                                    if(f_v==0 and int(G.node[fault_gate]['IP']==1)):
                                        (G.node[fault_gate]['IP'])=5  
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['IP'])==0)):
                                        (G.node[fault_gate]['IP'])=6
                                        act=1
                                        print('fault activated')
                                        
                                if (int(G.node[fault_gate]['op'])==fault_net):
                                    if(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                    if(f_v==0 and (int(G.node[fault_gate]['OP'])==1)):
                                        (G.node[fault_gate]['OP'])=5
                                        act=1
                                        print('fault activated')
                                        
                                
                                  
                                     
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            #print('2 input')
                            if(G.node[fault_gate]['type']!='INV' and G.node[fault_gate]['type']!='BUF'):
                                if(int(G.node[fault_gate]['ip1'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP1 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP1']==1)):
                                        print('fault activated')
                                        (G.node[fault_gate]['IP1'])=5
                                        print("fault gate =", fault_gate)
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP1'])==0):
                                        (G.node[fault_gate]['IP1'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif(int(G.node[fault_gate]['ip2'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP2 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP2'])==1):
                                        (G.node[fault_gate]['IP2'])=5 
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP2'])==0):
                                        (G.node[fault_gate]['IP2'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif((G.node[fault_gate]['op'])==fault_net):
                                    #print("op is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['OP'])==1):
                                        (G.node[fault_gate]['OP'])=5 
                                        act=1
                                        print('fault activated')
            #                            S='Success'
            #                            return S
                                        
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
            #                            S='Success'
            #                            return S
                    for j in range(len(M)-2):
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip']):
                                G.node[j]['IP']=G.node[i]['OP']
                                G.node[j]['it']=G.node[i]['ot']
                                
                                #G.node[j]['ipfault'].extend([(G.node[i]['outfault'])])
                                #print (G.node[i]['ipfault'])
                                
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip1']):
                                G.node[j]['IP1']=G.node[i]['OP']
                                G.node[j]['it1']=G.node[i]['ot']
                                #G.node[j]['ip1fault'].extend([(G.node[i]['outfault'])])
                                a=a+1
                                #print (G.node[i]['ip1fault'])
                                
                            if(G.node[i]['op']==G.node[j]['ip2']):
                                G.node[j]['IP2']=G.node[i]['OP']
                                G.node[j]['it2']=G.node[i]['ot']

#                   

                
            
            if(G.node[i]['type']=='NOR'):
                if(int(G.node[i]['ot'])==0 and int(G.node[i]['it1'])==1 and int(G.node[i]['it2'])==1):
                    if (int(G.node[i]['IP1'])==0 and int(G.node[i]['IP2'])==0):
                        print('hahahaha')
                        G.node[i]['ot']=1
                        G.node[i]['OP']=1
                    elif (int(G.node[i]['IP1'])==0 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==0 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==0 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==0):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==0):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==0):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=5
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=0
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=0
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==5):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==6):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==5 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==6 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                                
                    else:
                        G.node[i]['ot']=1
                        G.node[i]['OP']=0
                    
                    for j in range(N-2): 
                #print('enter for loop')
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[fault_gate]['type']=='INV' or G.node[fault_gate]['type']=='BUF'):
                                if(int(G.node[fault_gate]['ip'])==fault_net ):
                                    #print("Ip or buf activated")
                                    if(f_v==0 and int(G.node[fault_gate]['IP']==1)):
                                        (G.node[fault_gate]['IP'])=5  
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['IP'])==0)):
                                        (G.node[fault_gate]['IP'])=6
                                        act=1
                                        print('fault activated')
                                        
                                if (int(G.node[fault_gate]['op'])==fault_net):
                                    if(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                    if(f_v==0 and (int(G.node[fault_gate]['OP'])==1)):
                                        (G.node[fault_gate]['OP'])=5
                                        act=1
                                        print('fault activated')
                                        
                                
                                  
                                     
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            #print('2 input')
                            if(G.node[fault_gate]['type']!='INV' and G.node[fault_gate]['type']!='BUF'):
                                if(int(G.node[fault_gate]['ip1'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP1 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP1']==1)):
                                        print('fault activated')
                                        (G.node[fault_gate]['IP1'])=5
                                        print("fault gate =", fault_gate)
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP1'])==0):
                                        (G.node[fault_gate]['IP1'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif(int(G.node[fault_gate]['ip2'])==fault_net or int(G.node[fault_gate]['op'])==fault_net):
                                    #print("IP2 is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['IP2'])==1):
                                        (G.node[fault_gate]['IP2'])=5 
                                        act=1
                                        print('fault activated')
                                    elif (f_v==1 and int(G.node[fault_gate]['IP2'])==0):
                                        (G.node[fault_gate]['IP2'])=6
                                        act=1
                                        print('fault activated')
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
                                elif((G.node[fault_gate]['op'])==fault_net):
                                    #print("op is at fault net")
                                    if(f_v==0 and int(G.node[fault_gate]['OP'])==1):
                                        (G.node[fault_gate]['OP'])=5 
                                        act=1
                                        print('fault activated')
                                        
                                        
                                    elif(f_v==1 and (int(G.node[fault_gate]['OP'])==0)):
                                        (G.node[fault_gate]['OP'])=6
                                        act=1
                                        print('fault activated')
           
                    for j in range(len(M)-2):
                        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip']):
                                G.node[j]['IP']=G.node[i]['OP']
                                G.node[j]['it']=G.node[i]['ot']
                                
                               
                                
                        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
                            if(G.node[i]['op']==G.node[j]['ip1']):
                                G.node[j]['IP1']=G.node[i]['OP']
                                G.node[j]['it1']=G.node[i]['ot']
                                a=a+1
                            if(G.node[i]['op']==G.node[j]['ip2']):
                                G.node[j]['IP2']=G.node[i]['OP']
                                G.node[j]['it2']=G.node[i]['ot']

    global DF
    ###############################################################################
    for j in range(N-2):
        if(G.node[j]['type']=='INV' or G.node[j]['type']=='BUF'):
                    if ((int(G.node[j]['IP'])==5 or int(G.node[j]['IP'])==6) and int(G.node[j]['OP'])==3):
                        if(DF.count(j)!=1):
                            DF.append(j)
                    if (int(G.node[j]['OP'])==5 or int(G.node[j]['OP'])==6):
                        if(DF.count(j)==1):
                            DF.remove(j)   
                            
        if(G.node[j]['type']!='INV' and G.node[j]['type']!='BUF'):
            if((G.node[j]['IP1']==5)):
                
                if(G.node[j]['OP']==3):
                    if(DF.count(j)!=1):
                        DF.append(j)
                        print('DF in imply =',DF)           
            if( G.node[j]['IP2']==5):
                print('IP2=5')            
                if(G.node[j]['OP']==3):
                    print('and OP = 3')
                    if(DF.count(j)!=1):
                        DF.append(j)
                        print('DF in Imply=',DF)                       
            if((G.node[j]['IP1']==6)):
                if(G.node[j]['OP']==3):
                    if(DF.count(j)!=1):
                        DF.append(j)
                        print('DF in imply=',DF)                
            if(( G.node[j]['IP2']==6)):
                if(G.node[j]['OP']==3):
                    if(DF.count(j)!=1):
                        DF.append(j)
                        print('DF in imply =',DF)
                        
            if((G.node[j]['OP'])==5 or (G.node[j]['OP']==6)):
                if(DF.count(j)==1):
                    print('removing from DF',j)
                    DF.remove(j)
        
       
    
    ###############################################################################                                    
                            
                                    
################################ END OF IMPLY FUNCTION #########################################################

################################# OBJECTIVE FUNCTION #########################################################
    
def Objective():
    
   
    for i in range(N-2): #(l,!v)
        if(G.node[i]['type']=='INV' or G.node[i]['type']=='BUF'):
            
            if (int(G.node[i]['ip'])==f_l) :
                
                if(G.node[i]['IP']==3):
                    return ((G.node[i]['ip'],int(not(f_v))))
                    
            elif (int(G.node[i]['op'])==f_l) :
                
                if(G.node[i]['OP']==3):
                    return ((G.node[i]['op'],int(not(f_v))))
                    
            
    
        if(G.node[i]['type']!='INV' and G.node[i]['type']!='BUF'):
          #  oo=oo+1
            #print(G.node[i]['type'])
            if (int(G.node[i]['ip1'])==f_l):
                if(G.node[i]['IP1']==3):
                    return ((G.node[i]['ip1'],int(not(f_v))));
            elif (int(G.node[i]['ip2'])==f_l):
                if(G.node[i]['IP2']==3):
                    return ((G.node[i]['ip2'],int(not(f_v)))); 
                             
            elif (int(G.node[i]['op'])==f_l) :
                
                if(G.node[i]['OP']==3):
                    print('printing because output was entered in Objective')
                    return ((G.node[i]['op'],int(not(f_v))))                
   

    
    
    Dl=len(DF) 
    print(DF)
    print('Length DF',Dl) #selecting the gate from the d frontier
    if(Dl!= 0):
        print('inside df selection')
        
        
        d= DF[len(DF)-1]
        print(d)
        print(G.node[d])
        
            


        dgate=d            
                         
        if(G.node[dgate]['type']!='INV' and G.node[dgate]['type']!='BUF'): 
            print('entered dgate type if statement')  #select only one DF and one net of selected DF gate
            if G.node[dgate]['IP1']==3:
                print('entering objective because fault activated')
                if G.node[dgate]['type']== 'AND':
                    c=0
                if G.node[dgate]['type']== 'OR':
                    c=1
                if G.node[dgate]['type']== 'NAND':
                    c=0
                if G.node[dgate]['type']== 'NOR':
                    c=1   
                        
                return ((G.node[dgate]['ip1'],int(not(c))));    ## what if both are at 3??
                    
            elif G.node[dgate]['IP2']==3:
                print('entering objective because fault activated')
                if G.node[dgate]['type']== 'AND':
                    c=0
                if G.node[dgate]['type']== 'OR':
                    c=1
                if G.node[dgate]['type']== 'NAND':
                    c=0
                if G.node[dgate]['type']== 'NOR':
                    c=1   
                        
                return ((G.node[dgate]['ip2'],int(not(c))));
            
                     
    
    
################################ END OF OBJECTIVE #######################################################

################################### BACKTRACE ###########################################################

def Backtrace (kk):
    j=0
  
    kkk=int(kk[0])
    v=kk[1]
    for i in range(N-2): 
            if(G.node[i]['type']=='INV' or G.node[i]['type']=='BUF'):
                if int((G.node[i]['op'])) ==kkk :
                    gate=i
    
            if(G.node[i]['type']!='INV' and G.node[i]['type']!='BUF'):
            
                if int((G.node[i]['op'])) == kkk :
                    gate=i                   
                elif int((G.node[i]['op'])) == kkk :
                    gate=i

                    
   
        
               
    while(int(kkk) not in (PI)):
        
        if(G.node[gate]['type']=='INV'):
            j=j+1
            #j=1
            print (j)
        elif(G.node[gate]['type']=='BUF'):
            
            print (j)
        elif(G.node[gate]['type']=='AND'):
            
            print (j)
        elif(G.node[gate]['type']=='OR'):
            
            print (j)
        elif(G.node[gate]['type']=='NAND'):
            j=j+1
            
            print (j)
        
        elif(G.node[gate]['type']=='NOR'):
            j=j+1
           
            print (j)
#            
        #j=j%2   
        if(G.node[gate]['type']=='INV' or G.node[gate]['type']=='BUF'):
            if(G.node[gate]['IP']==3): #decide which one to select
                print("Before computing v and j = ",v,j) 
                print("After computing v and j =",v,j)
                print('j',j)
                kkk=(int(G.node[gate]['ip']))                
        if(G.node[gate]['type']!='INV' and G.node[gate]['type']!='BUF'):
            if(G.node[gate]['IP1']==3 and G.node[gate]['IP2']==3):
                kkk=(int(G.node[gate]['ip1']))
                print("Before computing v and j = ",v,j) 
                #v=v^j
                print("After computing v and j =",v,j)
                print(kkk)
            if(G.node[gate]['IP1']==3 and G.node[gate]['IP2']!=3): #decide which one to select
                print("Before computing v and j = ",v,j)  
                #v= v^j
                kkk=(int(G.node[gate]['ip1']))
                print("After computing v and j =",v,j)
                print(kkk)
                #print (kkk)
            if(G.node[gate]['IP2']==3 and G.node[gate]['IP1']!=3):
                print("Before computing v and j = ",v,j)                                     # this will be j
                #v= v^j
                kkk=(int(G.node[gate]['ip2'])) 
                print("After computing v and j =",v,j) 
                print(kkk)
                #print (kkk)
                
        for i in range(N-2): 
            if(G.node[i]['type']=='INV' or G.node[i]['type']=='BUF'):
#            oo=oo+1
            #print(G.node[i]['type'])
                if (int((G.node[i]['op']))) ==kkk :
                    gate=i
                    #print (i)
                
    
            if(G.node[i]['type']!='INV' and G.node[i]['type']!='BUF'):
              #  oo=oo+1
                #print(G.node[i]['type'])
                if (int(G.node[i]['op']) )== kkk :
                    gate=i
                    #print (i)
                    
                elif (int(G.node[i]['op'])) == kkk :
                    gate=i
                  #print (i)
    j=j%2
    v=v^j              
    l= (kkk,v)    
    return(l)
    
################################### END OF BACKTRACE ####################################################

########################################## XPATH ########################################################

def xpath(k):
    
    
    iter=0
    
    print('enter xpath',k)
    print('k=',k)
    
        
    for i in range(N-2):
        if(int(G.node[i]['op'])==k):
            xgate=i
            print(xgate)
    
    if k in PI:                     # If k is a PI
        print('STOP')
        s=1
        return s
    
    
    if(G.node[xgate]['type']=='INV' or G.node[xgate]['type']=='BUF'):   ####select an input with x 
                if(G.node[xgate]['IP']==3): #decide which one to select
                   
                    kkk=(int(G.node[xgate]['ip']))
                    iter=iter+1
                    if(iter==1):
                        first_net=kkk
                    print('selected x path =')
                    print(kkk)
    if(G.node[xgate]['type']!='INV' and G.node[xgate]['type']!='BUF'):
                if(G.node[xgate]['IP1']==3 and G.node[xgate]['IP2']==3):
                    
                    kkk=(int(G.node[xgate]['ip1']))
                    iter=iter+1
                    if(iter==1):
                        first_net=kkk
                    print('selected x path =')
                    print(kkk)
                if(G.node[xgate]['IP1']==3 and G.node[xgate]['IP2']!=3): #decide which one to select
                    
                    kkk=(int(G.node[xgate]['ip1']))
                    iter=iter+1
                    if(iter==1):
                        first_net=kkk
                    print('selected x path =')
                    print(kkk)
                    #print (kkk)
                if(G.node[xgate]['IP2']==3 and G.node[xgate]['IP1']!=3): # this will be j
                    
                    kkk=(int(G.node[xgate]['ip2']))
                    iter=iter+1
                    if(iter==1):
                        first_net=kkk
                    print('selected x path =')
                    print(kkk)
                    #print (kkk)
                if(G.node[xgate]['IP2']!=3 and G.node[xgate]['IP1']!=3):
                    s=0
                    return (s)
    #print(kkk)
    return xpath(kkk)
    
########################################  END OF XPATH ####################################################   
    
######################################## PODEM ############################################################



def Podem():
    print('inside PODEM')
    # Condition for success
    for o in range(N-2):
        for ou in range(len(Output1)):
            
            if((G.node[o]['op'])== Output1[ou]):
                if(((G.node[o]['OP']))==5 or (G.node[o]['OP'])==6 ):
                    print('S')
                    S='Success'
                    return (S)
                    
    print('I am here')               
    # Conditions for failure 
    flag=0
    for o in range(N-2):
        for ou in range(len(Output1)):
            
            if((G.node[o]['op'])== Output1[ou]):
                if(G.node[o]['OP']==3 ):
                    flag=1
    if(flag==0):
        S='outputs at 1 or 0 Failure'
        return (S)
        
    dflag=0
    
    if(len(DF)==0):
        print('Value D or Db?',G.node[fault_gate][ipi],G.node[fault_gate][IPV])
        if(int(G.node[fault_gate][IPV])==5 or int(G.node[fault_gate][IPV])==6):
           
            print('DF = 0 F  ')
            S='Failure'
            return(S)
#            if(dflag==1):
#                print('dflag=1')
#                return (S)
            dflag=1
    if(G.node[fault_gate][IPV]==f_v):
            print(' fault stuck at F')
            S='Failure'
            return (S) 
    print('Success')
    S='Success'
      
  
    print('Before calling objective')
        
        
    k=Objective()
    print('objective o/p',k)
    
    ll=Backtrace(k)

    print ('backtrace o/p',ll)
    
    
    for n in range(len(Input1)):
        if((ll[0])==int(Input1[n])):
            a=n
    ipv[a]=int(ll[1])
    print(ipv)
    #print(G.node[11])
    Imply(ipv)
    print('end')
    
    
    
    print('ITERATION=',u+1)
    if(Podem()=='Success'):
        print (ipv)
        S='Success'
        return (S)
        print(ipv)
       
     
    #reverse decision
    
    for n in range(len(Input1)):
        if(ll[0]==Input1[n]):
            a=n
    ipv[a]=int(not(ll[1]))
    
    Imply(ipv)
    print(ipv)
    
    
    
    if(Podem()=='Success'):
        print (ipv)
        S='Success'
        return (S)
        
     
    ipv[int(ll[0])]=3
    Imply(ipv)
    S='Failure end'
    print(S)
    return (S)
    
    
    
    
if __name__=="__main__":
    import networkx as nx
    G=nx.Graph()
    import random
    
    
    global dflag
    global f_l
    global f_v
    global ipi
    global IPV
    (f_l,f_v)=(12,0) #input fault
    print('f_l= ',f_l)
    print('f_v=',f_v)
    #ipv=[3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
    #ipv=[3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
    ipv=[3,3,3,3,3,3,3]
    with open("s27.txt") as f:
        M=f.readlines()
        N=len(M)
        
        Input=M[len(M)-2].split()
        Output=M[len(M)-1].split()
        Input=M[len(M)-2].split()
        Input1=Input[1:-1]
        Output=M[len(M)-1].split()
        Output1=Output[1:-1]
        PI=[]
        for a in range(len(Input1)):
            PI.append(int(Input1[a]))
        
        
        
        
        for i in range(N-2):
            M1=M[i].split()
            if len(M1)==3:
                for x in range(len(M1)):
                    G.add_node(i, OP =3, IP=3,it=0,ot=0)
                    if x==0:
                        G.node[i]['type']=M1[x]
                    if x==1:
                        G.node[i]['ip']=M1[x]
                    if x==2:
                        G.node[i]['op']=M1[x]
                        G.node[i]['ipfault']=[]
                        G.node[i]['outfault']=[]
                        
                    
            if len(M1)==4:
                G.add_node(i, OP =3, IP1=3, IP2=3,it1=0,it2=0,ot=0)
                for x in range(len(M1)):
                    if x==0:
                        G.node[i]['type']=M1[x]
                    if x==1:
                        G.node[i]['ip1']=M1[x]
                    if x==2:
                        G.node[i]['ip2']=M1[x]
                    if x==3:
                        G.node[i]['op']=M1[x]
                    G.node[i]['ip1fault']=[]
                    G.node[i]['ip2fault']=[]
                    G.node[i]['outfault']=[]
    print('START')
    
    Input=M[len(M)-2].split()
    Input1=Input[1:-1]
    Output=M[len(M)-1].split()
    Output1=Output[1:-1]
   
    print('here after first imply')
    
    
    
   
    global DF
    DF=[]
    u=1
    global fault_gate
    global fault_net
    global ipi
    for i in range(N-2): #(l,!v)
            if(G.node[i]['type']=='INV' or G.node[i]['type']=='BUF'):
                 if(int(G.node[i]['ip'])==f_l  ):
                    fault_gate=i
                    ipi='ip'
                    IPV='IP'
                    fault_net=int(G.node[i]['ip'])
                    print('op is',G.node[i]['op'])
                    print('fault_net',fault_net)
                    print('fault_gate',fault_gate)
                    print('gate type=',G.node[fault_gate]['type'])
                    break
                 elif(int(G.node[i]['op'])==f_l):
                    fault_gate=i
                    ipi='op'
                    IPV='OP'
                    fault_net=int(G.node[i]['op'])                   
                    print('fault_net',fault_net)
                    print('fault_gate',fault_gate)
                    print('gate type=',G.node[fault_gate]['type'])
                    print('op is',G.node[i]['op'])
                    break
               
                
    
            
            if(G.node[i]['type']!='INV' and G.node[i]['type']!='BUF'):
              #  oo=oo+1
                #print(G.node[i]['type'])
                if(int(G.node[i]['op'])==f_l):
                    fault_gate=i
                    ipi='op'
                    IPV='OP'
                    fault_net=G.node[i]['op']                   
                    print('fault_net',fault_net)
                    print('fault_gate',fault_gate)
                    print('gate type=',G.node[fault_gate]['type'])
                    print('op is',G.node[i]['op'])
                    break
                elif(int(G.node[i]['ip1'])==f_l):
                    fault_gate=i
                    
                    ipi='ip1'
                    IPV='IP1'
                    fault_net=int(G.node[i]['ip1'])                   
                    print('fault_net',fault_net)
                    print('fault_gate',fault_gate)
                    print('gate type=',G.node[fault_gate]['type'])
                    print('op is',G.node[i]['op'])
                    break
                elif(int(G.node[i]['ip2'])==f_l):
                    fault_gate=i
                    IPV='IP2'
                    ipi='ip2'
                    fault_net=int(G.node[i]['ip2'] )                  
                    print('fault_net',fault_net)
                    print('gate type=',G.node[fault_gate]['type'])
                    print('fault_gate',fault_gate)
                    print('op is',G.node[i]['op'])
                    break
                
                
    

    a=Podem()
    print(a)
    
    
    
