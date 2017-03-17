# -*- coding: utf-8 -*-
"""
Created on Mon Nov 21 17:32:30 2016

@author: Pranjali
"""

import networkx as nx
G=nx.Graph()
import random


#ipvector=[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,1,1,1,1,1]
#ipvector=[1,1,1,0,1,0,1]
#ipvector=[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1]
#ipvector=[1,0,1]
with open("s27.txt") as f:
    M=f.readlines()
    N=len(M)
    
    Input=M[len(M)-2].split()
    PI=[]
    PI=Input[1:-1]
    
    
    Output=M[len(M)-1].split()
    
    
    
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




ipvector=[1,0,1,0,0,0,0]

G.node[6]['IP1']=5
G.node[6]['IP2']=1
    
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
                        G.node[i]['ot']=1
                        G.node[i]['OP']=6
                    elif (int(G.node[i]['IP1'])==1 and int(G.node[i]['IP2'])==3):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                    elif (int(G.node[i]['IP1'])==3 and int(G.node[i]['IP2'])==1):
                        G.node[i]['ot']=1
                        G.node[i]['OP']=3
                                
                    else:
                        G.node[i]['ot']=1
                        G.node[i]['OP']=1


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