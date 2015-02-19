#! /bin/env python

from Tkinter import *

from random import *
from decimal import *
import datetime
import time
import random
from games import * 
from copy import deepcopy
from TicTacToeDisplay import *
from TicTacToeRepresentation import *
from math import *



class TicTacToeAI(Game):
    
    def __init__( self,n  ):
        print "AI agent started!"
        self.nbrCase=n
    
    def make_move( self, action, state ):
        '''
        Renvoi l etat qui resulte d un mouvement valide a partir d un etat courant
        ''' 
        rep=state
        P4_rep=rep.clone()
        P4_rep.play_action(action)
        return P4_rep

    
    
    def successors(self, state):
        '''
        Renvoi la liste des successeurs pour letat courant state
        '''
        ok=True
        caseUtilisee_rep=state.getState()
        succ=[]
        if (len(caseUtilisee_rep)-1)%2==0:
            player = 'red'
        else:
            player = '#FFCC00'

        ok=True
        for n in range(0,(self.nbrCase*self.nbrCase),1):
           ok=True
           for l in range(0, len(caseUtilisee_rep)):
                        if n == caseUtilisee_rep[l]:
                                ok =False
           if ok:         
               action = n
               succ.append((n, self.make_move(action,state)))   
                 
        return succ
                
    
    def utility(self, state, player,test=False):
        '''
        Renvoi la valeur dutilite pour le joueur player pour letat state
        '''
        caseUtilisee_rep=state.getState()
        liste=[]
        listerouge=[]
        listejaune=[]
        stateO=state
        state=state.getState()
        n = caseUtilisee_rep[len(caseUtilisee_rep)-1]
        for index in range(0,len(state)):
            if index%2==0:
                listejaune.append(caseUtilisee_rep[index]) 
            if index%2==1:
                listerouge.append(caseUtilisee_rep[index])
                
        listeplayer=[]        
        
            
       # n = caseUtilisee_rep[len(caseUtilisee_rep)-1][0] #derniere case utilisee
       # couleurPlayer = caseUtilisee_rep[len(caseUtilisee_rep)-1][1]
        countLignes=0
        if (len(caseUtilisee_rep)-1)%2==0:
            #caseUtilisee_rep=listejaune
            couleurPlayer='#FFCC00'
        else:
            #caseUtilisee_rep=listerouge
            couleurPlayer='red'
            
        if couleurPlayer=='#FFCC00':
            listeplayer=listejaune
            listeplayer2=listerouge
        else:
            listeplayer=listerouge
            listeplayer2=listejaune
        
        #vertical 
        for u in range(0,self.nbrCase): 
            okVJ=False
            if u in listeplayer or u not in listeplayer2:
                okVJ=True
                for y in range(u,(self.nbrCase*self.nbrCase),self.nbrCase):
                    if y not in listeplayer and y in listeplayer2:
                        okVJ=False
                        break
            if okVJ:
                countLignes=countLignes+1
        
        
       #horizontale
        for u in range(0,(self.nbrCase*self.nbrCase),self.nbrCase):
            okHJ=False
            if u in listeplayer or u not in listeplayer2:
                okHJ=True
                for y in range(u,(u+self.nbrCase),1):
                    if y not in listeplayer and y in listeplayer2:
                        okHJ=False
                        break
            if okHJ:
                countLignes=countLignes+1 
                
        #Diagonale
        if 0 in listeplayer or 0 not in listeplayer2:
                okDJ=True
                for y in range(0,self.nbrCase*self.nbrCase,self.nbrCase+1):
                    if y not in listeplayer and y in listeplayer2:
                        okDJ=False
                        break
                if okDJ:
                    countLignes=countLignes+1 
                    

        if (self.nbrCase-1) in listeplayer or (self.nbrCase-1) not in listeplayer2:
                okDJ=True
                for y in range((self.nbrCase-1),(self.nbrCase*self.nbrCase)-self.nbrCase+1,self.nbrCase-1):
                    if y not in listeplayer and y in listeplayer2:
                        okDJ=False
                        break
                if okDJ:
                    countLignes=countLignes+1   
                    
                    
        tmp = self.terminal_test(stateO)
        if tmp[0]!=True and test:
            countLignes=1

        if tmp[0]==True and tmp[1]!='N':
            #if couleurPlayer!=player:
            if tmp[1]!='R' and test:
                #countLignes=countLignes+5
                countLignes=-5
                return countLignes
            elif tmp[1]!='J' and test:
                #countLignes=countLignes+5
                countLignes=-10
                return countLignes
                #-30 et -60 et rien pour N fonctionne pas du tout
                #-60 et -30 et rien pour N fonctionne pas du tout
                #-30 et -30 et  N -20 fonctionne pas bien
            if tmp[1]!='R' and  not test:
                countLignes=countLignes+5
            elif tmp[1]!='J' and  not test:
                countLignes=countLignes+5
 
        if tmp[0]==True and tmp[1]=='N' and test:
                countLignes=-10
        if test:
            #print stateO.getState()," Gagnant : ",tmp[1] , " eval ", countLignes
            return countLignes
                     
        if player==couleurPlayer:
            return countLignes
        else:
            return -countLignes
        
              

    def terminal_test(self, stateR):
        '''
        Renvoi true si letat stateR est terminal et false sinon
        '''
        listerouge=[]
        listejaune=[]
        state=stateR.getState()
        n = state[len(state)-1]
        for index in range(0,len(state)):
            if index%2==0:
                listejaune.append(state[index])
            if index%2==1:
                listerouge.append(state[index])
        #vertical 
        for u in range(0,self.nbrCase):
            okVJ=False
            if u in listejaune:
                okVJ=True
                for y in range(u,(self.nbrCase*self.nbrCase),self.nbrCase):
                    if y not in listejaune:
                        okVJ=False
                        break
                if okVJ:
                    return (True,'J')
                
            elif u in listerouge:
                okVR=True
                for y in range(u,(self.nbrCase*self.nbrCase),self.nbrCase):
                    if y not in listerouge:
                        okVR=False
                        break
                if okVR:
                    return (True,'R') 
                
        #Horizontale
        for u in range(0,(self.nbrCase*self.nbrCase),self.nbrCase):
            okHJ=False
            if u in listejaune:
                okHJ=True
                for y in range(u,(u+self.nbrCase),1):
                    if y not in listejaune:
                        okHJ=False
                        break
                if okHJ:
                    return (True,'J')
                
            elif u in listerouge:
                okHR=True
                for y in range(u,(u+self.nbrCase),1):
                    if y not in listerouge:
                        okHR=False
                        break
                if okHR:
                    return (True,'R')    
        
        #diagonale De gauche a droite
        if 0 in listejaune:
            okDJ=True
            for u in range(0,self.nbrCase*self.nbrCase,self.nbrCase+1):
                if u not in listejaune:
                        okDJ=False
                        break
            if okDJ:
                return (True,'J')
                
        elif 0 in listerouge:
                okDR=True
                for u in range(0,self.nbrCase*self.nbrCase,self.nbrCase+1):
                    if u not in listerouge:
                        okDR=False
                        break
                if okDR:
                    return (True,'R')            
    
    
       #diagonale De droite  a gauche
        if (self.nbrCase-1) in listejaune:
            okD2J=True
            for u in range((self.nbrCase-1),(self.nbrCase*self.nbrCase)-self.nbrCase+1,self.nbrCase-1):
                if u not in listejaune:
                        okD2J=False
                        break
            if okD2J:
                return (True,'J')
                
        elif (self.nbrCase-1) in listerouge:
                okD2R=True
                for u in range((self.nbrCase-1),(self.nbrCase*self.nbrCase)-self.nbrCase+1,self.nbrCase-1):
                    if u not in listerouge:
                        okD2R=False
                        break
                if okD2R:
                    return (True,'R')
                
                
        if len(state) == (self.nbrCase*self.nbrCase): 
             return (True,"N") 

        return (False,'n')                

    def to_move(self, stateR):
        '''
        Renvoi qui est le prochain joueur a jouer
        '''
        state1=stateR.getState()
        if len(state1)%2==0:
            return '#FFCC00'
        else:
            return 'red'
        
        
class AT:
    def __init__( self,game  ):
        print "AI agent started!"
        self.game=game
        

    def dedans2(self, table ,etat1,etat2,dicoEtatsIndices):
        '''
        Regarde si la transition de letat1 a letat2 se trouve deja dans la dictionnaire 
        '''
        ind1=etat1
        ind2=etat2
        indice1=0
        find1=False
        find2=False
        indice2=0
        if table.has_key(str(ind1)+" "+str(ind2)): 
                    indice1=ind1
                    indice2=ind2
                    find2=True 
                    find1=True

        return (find1,find2,indice1,indice2)

    def dedans1(self, table ,etat1):
        '''
        Regarde si letat1 se trouve deja dans la table et renvoie son indice si il est deja present 
        '''
        list=etat1.split()
        indice1=0
        find1=False
        for s in table:
            ok=True
            listCleTable=s.split()
            if len(listCleTable)==len(list):
                index1=0
                for words in list:
                    trouve=False
                    index2=0
                    if index1%2==0:
                        if words in listCleTable[::2]:
                            trouve=True
                    elif index1%2==1:
                        if words in listCleTable[1::2]:
                                trouve=True
                    index1=index1+1
                    if trouve==False:
                        ok=False
                        break
            else:
                ok=False
            if ok:
                    find1=True
                    return (find1,table[s])
            
        return (find1,0)
    
    
    def w_choice(self,lst):
        '''
        Renvoie le prochain coup a jouer en fonction des probabilites de transition 
        '''
        n = random.uniform(0, 1)
        for item, weight in lst:
            if n < weight:
                break
            n = n - weight
        return item

    
    def getAction( self, state,joueur,teta ):
        '''   
        Pre : le plateau de jeu courant de la partie, le prochain joueur a jouer,
               et le teta du joueur a jouer
        Return : le prochain coup randomise a jouer pour le joueur a jouer en fonction 
                 de son teta et du plateau courant de jeu.
        La fonction cherche d abord toutes les solutions finales du jeu en cours grace 
        a l algorithme minimax. Elle cree ensuite le graphe acyclique de ces solutions,
        calculs les Z et les probabilites des prochains coups possibles a jouer.
        Et renvoi le prochain coup en fonction de ces probabilites.
        Cette methode implemente l algorithme Rminimax
        '''
        
        
        # representation de l objet du plateau courant de jeu
        representation1= TicTacToeRepresentation(state)
        t0 = datetime.datetime.now()
        print t0
        #Recherche des solutions terminales du plateau de jeu courant
        #grace a l algorithme alpha beta
        action= alphabeta_full_search(representation1,self.game)
        Solutions=action[1]
        SolState=action[2]
        SolDef=[]
        i=0
        gagnant=""
        if joueur==1:
            gagnant='J'
        else:
            gagnant='R'

        #if len(state)==0:
        if len(state)==-300: # SILVIA
            #Si on commence la partie depuis le debut, cela donne directement les probabilites de transition
            #de letat initial au premier coup a jouer (pour plus de rapidite lors des calculs)
            print "action choisie normalement : ",action[0]
            delta_t = datetime.datetime.now() - t0
            #teta=10 
            listWeight=[(6,0.0886075949367),(3,0.0759493670886),(2,0.0886075949367),(1,0.0759493670886),(4,0.341772151899),(8,0.0886075949367),(0,0.0886075949367),(7,0.0759493670886),(5,0.0759493670886)]
            #teta=0.01 pour les jaunes
            #listWeight=[(6,0.136228066286),(3,0.114691181492),(2,0.136228066286),(1,0.111068823625),(4,0.139655362391),(8,0.118312530729),(0,0.146999488729),(7,0.0430231708652),(5,0.053793309596)]
            #teta=5
            #listWeight=[(6,0.00647256837884),(3,0.00952895689563),(2,0.0220296455209),(1,0.472602696423),(4,0.00369131442018),(8,0.000148149377456),(0,0.478905951228),(7,0.00328919468137),(5,0.00333152307493)]
            #teta=1
            #listWeight=[(6,0.000638303167059),(3,0.000699699678248),(2,0.00106815451469),(1,0.49883871027),(4,6.19901679064e-005),(8,3.93704544839e-007),(0,0.498569275422),(7,6.16933886447e-005),(5,6.17796868463e-005)]
            #teta=0.5
            #listWeight=[(6,0.230387879892),(3,0.0514596730164),(2,0.230462095813),(1,0.102835922364),(4,9.39089543898e-005),(8,6.712861982e-005),(0,0.384604233928),(7,4.60463840936e-005),(5,4.31110290511e-005)]
            #teta=0.3
            #listWeight=[(6,0.173867031351),(3,0.0550406775555),(2,0.343922832314),(1,0.0851229493554),(4,0.04532716695),(8,0.0272070385189),(0,0.246238145101),(7,0.01418979764),(5,0.0090843612134)]
            #teta=0.7
            #listWeight=[(6,0.0491762935295),(3,0.0492118454709),(2,0.0494006214688),(1,0.450503830459),(4,5.69989049515e-005),(8,2.24764031457e-005),(0,0.401535385926),(7,4.34983086416e-005),(5,4.90495290682e-005)]
            #teta=0.85
            #listWeight=[(6,0.0057652035173),(3,0.00581686782899),(2,0.00612383187244),(1,0.493792817852),(4,5.47736077145e-005),(8,3.06131008268e-006),(0,0.488337067988),(7,5.28942885838e-005),(5,5.34817346487e-005)]
            #teta=0.6
            #listWeight=[(6,0.120953168149),(3,0.120978378982),(2,0.121075730843),(1,0.29532209721),(4,7.22447633178e-005),(8,5.00228940327e-005),(0,0.341451657178),(7,4.22406320106e-005),(5,5.44593483695e-005)]
            #teta=0.1
            #listWeight=[(6,0.159901826429 ),(3,0.0831976115296),(2,0.159901826429),(1,0.0831966792984),(4,0.134475946647),(8,0.0836139325383),(0,0.211208128484),(7,0.0530374502604),(5,0.0314665983841)]
            x = self.w_choice(listWeight)
            print x
            print "temps dexecution : ", delta_t     
            return int(x)
        else:

            print """Creation du Graphe acyclique a partir des etats terminaux trouves
                    par lalgorithme Minimax ou Alpha beta pruning"""
            
            P={} # Pour les probabilites de transitions
            dicoIndicesEtats={}
            dicoEtatsIndices={}
            tableIndicesEtatsCouts={}
            tableIndicesEtatsCoutsB={}
            tableIndicesEtatsCoutsBListe={}
            listeDerniersElts= [] #Liste des derniers noeuds pour les Zkn
            index=0
            nbrd=0
            print len(Solutions) #Nombre de solutions
            cleCourante=""
            tableIndicesEtatsTour={}
            tableIndicesEtatsTourFirst={}
            maximum=0
            cleArray=[]
            #Trouver la cle courante
            for w in state:
                cleCourante=cleCourante+str(w)+" "
            
            #Construction du graphe dirige    
            for sol in Solutions:
                indAdv=0
                cle=cleCourante
                cle=""
                cle1=""
                cle2=""
                poids=1
                cleArray=[]
                #Calcul du pourcentage deja acheve
                nbrd=nbrd+1
                if nbrd%1000==0:
                    print (nbrd*100.0)/len(Solutions)," % acheves"
                    
                ancienTupleBoolCle=""
                tupleBoolCle=""
                for i in range(len(state),len(sol.getState())):
                    if i < len(sol.getState()):
                        #Recuperation du premier indice de transition
                        ancienTupleBoolCle=tupleBoolCle
                        if ancienTupleBoolCle!="":
                            if not ancienTupleBoolCle[0]:
                                    ancienTupleBoolCle=(ancienTupleBoolCle[0],index-1)
                        
                        if dicoEtatsIndices.has_key(cle):
                            tupleBoolCle=dicoEtatsIndices[cle]
                            tupleBoolCle=(True,tupleBoolCle)
                        else:
                            tupleBoolCle=self.dedans1(dicoEtatsIndices,cle)
                                
                        if not tupleBoolCle[0]:
                            dicoIndicesEtats[index]=cle
                            if index < 2:
                                if len(cle)==0:
                                    r=5
                                else:
                                    q= [-1]*(5-len(cleArray))
                                    t=cleArray
                                    t.extend(q)
                                    cleArray=cleArray[:(5-len(cleArray)+1)]
                            else:
                                q= [-1]*(5-len(cleArray))
                                t=cleArray
                                t.extend(q)
                                t=t[:(5-len(cleArray))]
                                cleArray=cleArray[:(5-len(cleArray)+1)]
                            dicoEtatsIndices[cle]=index
                            index=index+1
                
        
                    if (i > len(state) and i < len(sol.getState())) :
                        #Recuperation de l'indice du noeud suivant
                        ind1=ancienTupleBoolCle[1]
                            
                        if tupleBoolCle[0]:
                                cle2=tupleBoolCle[1]
                        else:
                                cle2=index-1
                                
                        quad=self.dedans2(tableIndicesEtatsCouts ,ind1,cle2,dicoEtatsIndices)
                        if not quad[0] and not quad[1]:
        
                            repTest= TicTacToeRepresentation(sol.getState()[:(i)])
        
                            if tupleBoolCle[0]:
                                ind2=tupleBoolCle[1]
                            else:
                                ind2=index-1
        
                            P[str(ind1)+" "+str(ind2)]=0
                            tableIndicesEtatsCouts[str(ind1)+" "+str(ind2)]=1
                            tableIndicesEtatsCoutsB[str(ind1)+" "+str(ind2)]=False
                            tableIndicesEtatsTour[str(ind1)+" "+str(ind2)]=indAdv
                            if tableIndicesEtatsTourFirst.has_key(str(ind1)):
                                if tableIndicesEtatsTourFirst[str(ind1)]!=indAdv:
                                    print "Erreur" 
                            tableIndicesEtatsTourFirst[str(ind1)]=indAdv   
                            if tableIndicesEtatsCoutsBListe.has_key(str(ind1)):
                                t = tableIndicesEtatsCoutsBListe[str(ind1)]
                                t[len(t):]=[str(ind2)]
                                tableIndicesEtatsCoutsBListe[str(ind1)]=t
                            else:
                                l=[str(ind2)]
                                tableIndicesEtatsCoutsBListe[str(ind1)]=l
                           
                              #On stocke tous les noeuds finaux        
                    if i+1 == len(sol.getState()): 
                        t = cle+str(sol.getState()[i])+" "
                        cleArray.append(sol.getState()[i])
    
                        if tupleBoolCle[0]:
                                indP=tupleBoolCle[1]
                        else:
                                indP=index-1
        
        
                        #On prend les index des etats qui sont finaux
                        if dicoEtatsIndices.has_key(t):
                            lal=dicoEtatsIndices[t]
                            lal=(True,lal)
                        else:
                            lal=self.dedans1(dicoEtatsIndices,t)
        
                                
                        if not lal[0]:
                            dicoIndicesEtats[index]=t
                            dicoEtatsIndices[t]=index
                            if index < 2:
                                if len(cle)==0:
                                    r=5
                                else:
                                    q= [-1]*(5-len(cleArray))
                                    t=cleArray
                                    t.extend(q)
                                    cleArray=cleArray[:(5-len(cleArray)+1)]
                            else:
                                q= [-1]*(5-len(cleArray))
                                t=cleArray
                                t.extend(q)
                                t=t[:(5-len(cleArray))]
                                cleArray=cleArray[:(5-len(cleArray)+1)]
                            
                            index=index+1
                        
                        if lal[0]:
                            indF=lal[1]
                        else:
                            indF=index-1
                        if str(indF) not in listeDerniersElts:
                            listeDerniersElts.append(str(indF))
                            
                        if not tableIndicesEtatsCouts.has_key(str(indP)+" "+str(indF)):
                            repTest= TicTacToeRepresentation(sol.getState()[:(i+1)])
                            tmp = self.game.terminal_test(repTest)
                            if not dicoEtatsIndices.has_key(cle):
                                 y = self.dedans1(dicoEtatsIndices,cle)
                                 y=y[1]
                            else:
                                y=dicoEtatsIndices[cle]
                            tableIndicesEtatsCoutsB[str(y)+" "+str(indF)]=False
                            tableIndicesEtatsTour[str(y)+" "+str(indF)]=(indAdv+1)%2
        
                            if tableIndicesEtatsTourFirst.has_key(str(y)):
                                if tableIndicesEtatsTourFirst[str(y)]!=(indAdv+1)%2:
                                    print "Erreur" 
                            tableIndicesEtatsTourFirst[str(y)]=(indAdv+1)%2
                            
                            if tableIndicesEtatsCoutsBListe.has_key(str(y)):
                                t = tableIndicesEtatsCoutsBListe[str(y)]
                                t[len(t):]=[str(indF)]
                                tableIndicesEtatsCoutsBListe[str(y)]=t
                            else:
                                l=[str(indF)]
                                tableIndicesEtatsCoutsBListe[str(y)]=l                            
                                
                                 
                            if tmp[0]==True and tmp[1]!='N':
                                #On met une valeur dutilite a chaque etat terminal
                                if tmp[1]!=gagnant:
                                    #etat terminal perdant
                                    tableIndicesEtatsCouts[str(y)+" "+str(indF)]=41
                                elif tmp[1]==gagnant:
                                    #etat terminal gagnant
                                    tableIndicesEtatsCouts[str(y)+" "+str(indF)]=1
                            if tmp[0]==True and tmp[1]=='N':
                                #etat terminal nul
                                tableIndicesEtatsCouts[str(y)+" "+str(indF)]=22
      
                    cle=cle+str(sol.getState()[i])+" "
                    cleArray.append(sol.getState()[i])
                    indAdv=(indAdv+1)%2
    
            
            print "Creation Des Z" 
            Z = {}
            listeP = {}    
            Z[str(-10000)+" "+str(-10000)]=1 #tous les znn = 1 
    
            #Pour tous les etats qui menent a un etat final
            listeIndiceMenantAuFinal = []
            listeIndiceMenantAuFinalFinal = []
            DicoIndiceMenantAuFinal = {}
            for cle in tableIndicesEtatsCouts:
                cle2 = cle.split()[1]
                if cle2 in listeDerniersElts:
                    listeIndiceMenantAuFinal.append(cle.split()[0])
                    if DicoIndiceMenantAuFinal.has_key(cle.split()[0]):
                        t = DicoIndiceMenantAuFinal[cle.split()[0]]
                        t[len(t):]=[cle]
                        DicoIndiceMenantAuFinal[cle.split()[0]]=t
                    else:
                        l=[cle]
                        DicoIndiceMenantAuFinal[cle.split()[0]] = l
        
            
            while len(listeIndiceMenantAuFinal) != 0:
                tmp = {}
                p=0
                for indice in listeIndiceMenantAuFinal:
                    if len(listeP)==0:
                        #Lorsque aucun zxn na encore ete calcule
                        cleZP = DicoIndiceMenantAuFinal[indice].pop(0)
                        
                        tableIndicesEtatsCoutsB[cleZP]=True
                        
                        if tableIndicesEtatsTour[cleZP]==1:
                            #Si le joueur doit faire la somme 
                            tmp[cleZP] = 1.0 * math.exp(-teta*tableIndicesEtatsCouts[cleZP])
                            if Z.has_key(str(indice)+" "+str(-10000)):
                                Z[str(indice)+" "+str(-10000)] = Z[str(indice)+" "+str(-10000)]+tmp[cleZP]
                            else:
                                Z[str(indice)+" "+str(-10000)] = tmp[cleZP]
                        elif tableIndicesEtatsTour[cleZP]==0:
                            #Si le joueur doit prendre le minimum
                            tmp[cleZP] = 1.0 * math.exp(-teta*tableIndicesEtatsCouts[cleZP])
                            if Z.has_key(str(indice)+" "+str(-10000)):
                                if (tmp[cleZP] < Z[str(indice)+" "+str(-10000)] or Z[str(indice)+" "+str(-10000)]==0) and tmp[cleZP]!=0:
                                    Z[str(indice)+" "+str(-10000)] = tmp[cleZP]
                            else:
                                Z[str(indice)+" "+str(-10000)] = tmp[cleZP]
                        
                        tmp[cleZP]=Z[str(indice)+" "+str(-10000)]
                                        
                    else:
                        #Si il y a deja des zxn qui ont ete calcule
                        valeurZ = 0
                        cle1=""
                        t=""
                        for elt in tableIndicesEtatsCoutsBListe[str(indice)]:
                            if not tableIndicesEtatsCoutsB[str(indice)+" "+elt]:
                                    if tableIndicesEtatsCouts.has_key(str(indice)+" "+elt):
                                        t=elt
                                        if not Z.has_key(elt+" "+str(-10000)):
                                            Z[elt+" "+str(-10000)]=0
                                        else:
                                            tableIndicesEtatsCoutsB[str(indice)+" "+elt]=True
                                            
                                        if tableIndicesEtatsTourFirst[str(indice)]==0:
                                            #Si le joueur doit prendre le minimum
                                            if not Z.has_key(str(indice)+" "+str(-10000)):
                                                Z[str(indice)+" "+str(-10000)]=Z[elt+" "+str(-10000)]*math.exp(-teta*tableIndicesEtatsCouts[str(indice)+" "+elt])
                                            else:
                                                valeurzTmp = Z[elt+" "+str(-10000)]*math.exp(-10.0*tableIndicesEtatsCouts[str(indice)+" "+elt])
                                                if (Z[str(indice)+" "+str(-10000)] > valeurzTmp or Z[str(indice)+" "+str(-10000)]==0) and valeurzTmp!=0:
                                                    Z[str(indice)+" "+str(-10000)]=valeurzTmp
                                        else:
                                            #Si le joueur doit faire la somme        
                                            valeurZ=valeurZ+(Z[elt+" "+str(-10000)]*math.exp(-teta*tableIndicesEtatsCouts[str(indice)+" "+elt]))
                                            
                                        
                        if tableIndicesEtatsTourFirst[str(indice)]==1: 
                            #Si le joueur doit faire la somme
                            if Z.has_key(str(indice)+" "+str(-10000)):    
                                Z[str(indice)+" "+str(-10000)]= Z[str(indice)+" "+str(-10000)]+valeurZ
                            else:
                                #Si le joueur doit prendre le minimum
                                Z[str(indice)+" "+str(-10000)]=valeurZ
        
                        
                        tmp[str(indice)+" "+cle1]=Z[str(indice)+" "+str(-10000)]
                        
                        
                #Comme on part des etats terminaux, il faut trouver quels sont les etats menant aux etats que lon vient de visiter      
                listeP=tmp
                listeTmp = []
                listeTmp2 = []
                DicoIndiceMenantAuFinal = {}
                for cle in tableIndicesEtatsCouts:
                    cle2 = cle.split()[1]
                    if cle2 in listeIndiceMenantAuFinal:
                        if cle.split()[0] not in listeTmp:
                            ok=True
                            for te in tableIndicesEtatsCoutsBListe[cle2]:
                                if not tableIndicesEtatsCoutsB[cle2+" "+te]:
                                    ok=False
                            if ok:
                                listeTmp.append(cle.split()[0])
                                listeTmp2.append(cle.split()[0])
                                if DicoIndiceMenantAuFinal.has_key(cle.split()[0]):
                                    DicoIndiceMenantAuFinal[cle.split()[0]].append(cle)
                                else:
                                    DicoIndiceMenantAuFinal[cle.split()[0]]=[]
                                    DicoIndiceMenantAuFinal[cle.split()[0]].append(cle)
               
                #on regarde que le prochain etat dont on va calculer les zxn nest pas encore dans la liste
                liste=[]        
                for elt in listeTmp:
                    ok=True
                    for elt2 in listeTmp2:
                        if tableIndicesEtatsCouts.has_key(elt+" "+elt2):
                            ok=False
                            break
                        
                    if ok:
                        liste.append(elt)
                    
                listeIndiceMenantAuFinal = liste   
            
            
            #Indice de la sol courante
            cleCourante=""
            indiceCourant=0
            for w in state:
                cleCourante=cleCourante+str(w)+"/"
            if dicoEtatsIndices.has_key(cleCourante):
                indiceCourant=dicoEtatsIndices[cleCourante]
            
            SolutionsSuivantesPossibles= {}
        
            
            print "Calculs des probabilites de transition" 
            Z[str(-10000)+" "+str(-10000)]=1
            r = 0
            for final in listeDerniersElts:
                if not Z.has_key(final+" "+str(-10000)):
                    r=r+1
                    Z[final+" "+str(-10000)]=1
            print "nombre de sans cle ", r/len(listeDerniersElts)
            listWeight=[]
            for cle in tableIndicesEtatsCouts:
                listeCle = cle.split()
                cle1 = listeCle[0]
                cle2 = listeCle[1]
                if cle1!=str(-10000):
                    if Z[cle1+" "+str(-10000)]==0:
                        print "cle1==0"
                        P[cle]=1.0**math.exp(-teta*tableIndicesEtatsCouts[cle])
                    else:
                        if tableIndicesEtatsTour[cle]==1:
                            P[cle]= (Z[cle2+" "+str(-10000)]/Z[cle1+" "+str(-10000)])*math.exp(-teta*tableIndicesEtatsCouts[cle])
                        else:
                            P[cle]= (Z[cle2+" "+str(-10000)]/Z[cle1+" "+str(-10000)])*math.exp(-teta*tableIndicesEtatsCouts[cle])
                        
                    if cle.split()[0]==str(indiceCourant):
                        #Affichage des probabilites de transition du prochain coup a jouer
                        print "Proba pour la cle : ", cle , " : " , P[cle], " letat suivant : ", dicoIndicesEtats[int(cle.split()[1])] 
                        SolutionsSuivantesPossibles[dicoIndicesEtats[int(cle.split()[1])]]=P[cle]
                        listWeight.append((dicoIndicesEtats[int(cle.split()[1])],P[cle]))
                      
            
            probaTotale=0
            maxProba=-1.0
            res=1
            for all in SolutionsSuivantesPossibles:
                #Verification si la somme des probabilites des prochains coups est egal a 1 
                probaTotale=probaTotale+SolutionsSuivantesPossibles[all]
                if maxProba<SolutionsSuivantesPossibles[all]:
                    maxProba=SolutionsSuivantesPossibles[all]
                    res=all
                    
            print "Somme des probas : ", probaTotale            
            print len(P)
            print "plus grande proba trouvee : ",res
            print "action optimal choisie normalement : ",action[0]
            delta_t = datetime.datetime.now() - t0
            #calcul du temps pris pour trouver la solution 
            x = self.w_choice(listWeight)
            #on choisit la prochaine action en fonction des probabilites de transition
            print "temps dexecution : ", delta_t     
            print "Etat courant : ",cleCourante
            print x
            return int(x)
           
    #############################################################################
    
    
