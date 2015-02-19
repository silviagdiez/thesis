""" 
Author: Laforge Jerome
""" 

from Tkinter import *
import tkFont
import time
from games import * 
from MyAIPlayer import *
 
class Can(Canvas):
    
  
    def __init__(self,t1,t2): 
        #Classe servant a avoir une representation graphique du jeu
        #Desactivee pour le moment pour pouvoir faire les tests en ssh

        #Les deux thetas des joueurs
        #self.tetaJ=10.0 SILVIA
        #self.tetaR=10.0 SILVIA
        self.tetaJ=t1
        self.tetaR=t2
        
        self.cases = [] #case utilisee
        self.state = [] #case utilise avec couleur
        self.listerouge = [] # Liste des cases rouges
        self.listejaune = [] # Liste des cases jaunes
        self.dgagnantes = [] 
        self.gagnant = 0
        self.joueurCourant = 1;   
        self.running = 1 # Type de partie en cours
        self.couleur = ["Rouges", "Jaunes"]
        self.color = ["red", "#FFCC00"]
        self.fini=False

        self.game=Puissance4AI()
        
        self.clair      = "light blue"
        self.fonce      = "dark blue"
        self.police1    = "Times 17 normal"
        self.police2    = "Arial 10 normal"
        self.police3    = "Times 15 bold"
        # self.can        = Canvas.__init__(self, width =446, height = 380, bg=self.fonce, bd=0)
        
        # self.grid(row=1, columnspan =5)
        
             
        # Joueur en cours
        self.joueur = 1
       # self.create_rectangle(20,345,115,370,fill=self.clair)
       # self.create_text(35, 350, text ="Joueur :", anchor = NW, fill = self.fonce, font= self.police2)
       # self.indiccoul = self.create_oval(85, 350, 100, 365, fill = self.color[1])
        
            #Bouton Nouveau Jeu
        
       # self.create_rectangle(330,345,420,370,fill=self.clair)
        #self.create_text(340, 350, text ="Nouveau jeu", anchor = NW, fill = self.fonce, font= self.police2)
        
        
        #Affichage gagnant
       # self.create_rectangle(160,345, 290,370,fill=self.clair)
        
            #Creation des cases
        
#        self.ovals = []
#        for y in range(10, 335, 55):
#            for x in range(10, 437, 63):
#                self.ovals.append(self.create_oval(x, y, x + 50, y + 50 , fill= "white"))
                
            #En cas de click
                
        #self.bind("<Button-1>", self.click)
        
            # Pour relier a la fin les coordonnees des centres des cases
        
        self.coordscentres = []
        
            # Comptabilisation des suites de pieces
        
        self.rouges, self.jaunes = 0,0
        
            # Dictionnaire de reconnaissance
        
        self.dictionnaire = {}
        v = 0
        for y in range(10, 335, 55):
            for x in range(10, 437, 63):
                self.dictionnaire[(x, y, x + 50, y + 50)] = v
                v += 1
                self.coordscentres.append((x + 25, y + 25))
        


        
        
        res = self.ComputerAgainstComputer()
        #On ajoute le resultat des parties dans un fichier
        print "result : ",res
        print res
        textfile = "resultP4_"+str(t1)+"_"+str(t2)+".txt"
        output_file = open(textfile,'a')
        output_file.write(res+"\n")
        output_file.close()
        
#        print "resultat : ",res
#        print res
#        textfile = "resultP4.txt"
#        file = open(textfile,'r')
#        output_file = open('resultP4Cop.txt','w')
#        line =file.readline()
#        l=""
#        while line:
#            output_file.write(line)
#            line =file.readline()
#        file.close()
#        output_file.write(res+"\n")
#        output_file.close()
        
        
#        textfile = "resultP4Cop.txt"
#        file = open(textfile,'r')
#        output_file = open('resultP4.txt','w')
#        line =file.readline()
#        l=""
#        while line:
#            output_file.write(line)
#            line =file.readline()
#        file.close()
#        output_file.close()
        
        #SILVIA
        #if myGlobal < 100:
         #   self.new(self,t1,t2) #Et on relance une nouvelle partie



    def click(self,event): 
     #En cas de click sur linterface graphique
     if 330 < event.x and 345 < event.y and event.x < 420 and event.y < 370:
         self.new()# =>Nouveau jeu si on clicke sur new
         self.fini=False


     else :
         #Jeu en cours: reconnaissance de la case jouee
         if self.joueurCourant==1 and not self.fini:
             self.joueurCourant=0;
             if self.running != 0:
                 for (w, x, y, z) in self.dictionnaire:
                     if event.x > (w, x, y, z)[0] and event.y >(w, x, y, z)[1] and event.x < (w, x, y, z)[2] and event.y < (w, x, y, z)[3]:
                         if self.gagnant != 1:
                             self.colorier(self.dictionnaire[(w, x, y, z)]) # => Jouer
                     
                     
         else:
              print "Mauvais click"           
                     
    def new(self):
    # Nouveau Jeu

 # Operations non certaines

#        try:
#            self.BtnContinuer.destroy()
#        except:
#         pass
#        try:
#            self.texte.destroy()
#        except:
#         pass
#        try:
#            self.texte2.destroy()
#        except:
#         pass
#        try:
#            self.pRouges.destroy()
#        except:
#         pass
#        try:
#            self.pJaunes.destroy()
#        except:
#         pass
#    
#     # Operations qui le sont
#    
#        self.destroy()
        self.__init__()    
        print "New game"
        
    def colorier(self, n, nb=0): #Gere la coloration des cases

     if n in self.cases : return # Une case coloriee ne peut plus changer de couleur

     if n + 7 not in self.cases and n + 7 < 42: #Si la case en dessous est vide et existe, on essaie d'abord de colorier celle-la
             self.colorier(n+7)

     else:
         #Sinon on colorie celle-ci
         self.itemconfigure(self.ovals[n], fill = self.color[self.joueur])
         self.cases.append(n)
         self.state.append((n,self.color[self.joueur]))
         self.color[self.joueur] == 'red' and self.listerouge.append(n) or self.listejaune.append(n)
         self.listejaune = [case for case in self.listejaune if case not in self.listerouge]
#         if self.game.terminal_test(self.state): 
#             if len(self.state) == 41 : 
#                 print "Match Nul"
#             print "Fin du jeu"
#             self.gagnant=1
#             return
         t=self.verif(n)
         if t[0]:
             self.create_text(175, 350, text ="Gagnant : "+"Jaune", anchor = NW, fill = self.fonce, font= self.police2)
             self.fini=True
             return 
         else:
             if t[1]=='N':
                 self.create_text(175, 350, text ="Match Nul", anchor = NW, fill = self.fonce, font= self.police2)
                 self.fini=True
                 return
         #print self.game.terminal_test(self.state)
         
         #Changement de joueur
         
         self.joueur = [0,1][[0,1].index(self.joueur)-1]
         self.itemconfigure(self.indiccoul, fill = self.color[self.joueur])
         self.update()
         #On regarde toutes les cases sont remplies
         
         #si on a joue, cest a l'ordinateur mtnt
         #appeler MYai
         if self.joueurCourant==0:
             prout = AProut(self.game)
             n=prout.getAction(self.cases)
             self.itemconfigure(self.ovals[n], fill = self.color[self.joueur])
             self.cases.append(n)
             self.state.append((n,self.color[self.joueur]))
             self.color[self.joueur] == 'red' and self.listerouge.append(n) or self.listejaune.append(n)
             self.listejaune = [case for case in self.listejaune if case not in self.listerouge]
             self.joueur = [0,1][[0,1].index(self.joueur)-1]
             self.itemconfigure(self.indiccoul, fill = self.color[self.joueur])
             self.joueurCourant=1
             t=self.verif(n)
             if t[0]:
                 self.create_text(175, 350, text ="Gagnant : "+"Rouge", anchor = NW, fill = self.fonce, font= self.police2)
                 self.fini=True
             else:
                 if t[1]=='N':
                     self.create_text(175, 350, text ="Match Nul", anchor = NW, fill = self.fonce, font= self.police2)
                     self.fini=True
        # self.joueurCourant=0
         #Apres l'ordi le joueur peut rejouer
         #self.verificationFinale()

     return
    

    def ComputerAgainstComputer(self):
        #Lorsque lon fait jouer lordinateur contre lordinateur
        print "Go"
        while True:
            if self.joueurCourant==1:
                 print "Jaune joue"
                 partie = AI(self.game)

                 n=partie.getAction(self.cases,self.joueur,self.tetaJ)

                 #self.itemconfigure(self.ovals[n], fill = self.color[self.joueur])
                 self.cases.append(n)
                 self.state.append((n,self.color[self.joueur]))
                 #self.color[self.joueur] == 'red' and self.listerouge.append(n) or self.listejaune.append(n)
                 #self.listejaune = [case for case in self.listejaune if case not in self.listerouge]
                 self.listejaune.append(n)
                 self.joueurCourant=0
                 t=self.verif(n)
                 if t[0] and t[1]=='J':
                     #self.create_text(175, 350, text ="Gagnant : "+"Jaune", anchor = NW, fill = self.fonce, font= self.police2)
                     self.fini=True
                     return 'J'
                 elif t[0] and t[1]=='N':
                      #   self.create_text(175, 350, text ="Match Nul", anchor = NW, fill = self.fonce, font= self.police2)
                         self.fini=True
                         return 'N'
             
             
                 #Changement de joueur
                 self.joueur = [0,1][[0,1].index(self.joueur)-1]
                 # self.itemconfigure(self.indiccoul, fill = self.color[self.joueur])
                 #self.update()

            elif self.joueurCourant==0:
                 print "Rouge joue"
                 partie = AI(self.game)
                 n=partie.getAction(self.cases,self.joueur,self.tetaR)
                 #self.itemconfigure(self.ovals[n], fill = self.color[self.joueur])
                 self.cases.append(n)
                 self.state.append((n,self.color[self.joueur]))
                 #self.color[self.joueur] == 'red' and self.listerouge.append(n) or self.listejaune.append(n)
                 #self.listejaune = [case for case in self.listejaune if case not in self.listerouge]
                 self.listerouge.append(n)
                 self.joueur = [0,1][[0,1].index(self.joueur)-1]
                 #self.itemconfigure(self.indiccoul, fill = self.color[self.joueur])
                 self.joueurCourant=1
                 t=self.verif(n)
                 if t[0] and t[1]=='R':
                    # self.create_text(175, 350, text ="Gagnant : "+"Rouge", anchor = NW, fill = self.fonce, font= self.police2)
                     self.fini=True
                     return 'R'
                 elif t[0] and t[1]=='N':
                         #self.create_text(175, 350, text ="Match Nul", anchor = NW, fill = self.fonce, font= self.police2)
                         self.fini=True
                         return 'N'

        return        

    def verif(self, n): 
        # Verifie si on a un etat terminal        
        if self.running == 0 : 
            return (True,'N')
         
        if len(self.cases) == 42 : 
            return (True,'N')
        
         
        if n in self.listerouge and n+7 in self.listerouge and n+14 in self.listerouge and n+21 in self.listerouge: 
             # Dabord a la verticale,
             liste=[n, n+7, n+14, n+21] 
             return (True,'R')
    
        #idem pour jaunes
    
        if n in self.listejaune and n+7 in self.listejaune and n+14 in self.listejaune and n+21 in self.listejaune:
             liste=[n, n+7, n+14, n+21]
            # print "Jaune gagne"
             return (True,'J')
    
        for x in (1,-6,8):
        
             if n in self.listerouge: 
                 if n % 7 != 6 and n+x in self.listerouge:
                     if n % 7 != 5 and n+ 2*x in self.listerouge:
                         if n % 7 != 4 and n + 3*x in self.listerouge:
                             liste = [n, n+x, n+2*x, n+3*x]
                             #print "Rouge gagne"
                             return (True,'R')
                         if n%7 > 0 and (n-x) in self.listerouge:
                             liste = [n-x,n, n+x, n+2*x]
                             #print "Rouge gagne"
                             return (True,'R')
                         if n%7 > 1 and (n-x) in self.listerouge:
                             if n%7 > 2 and n-(2*x) in self.listerouge:
                                 liste = [n-2*x, n-x,n, n+x]
                                 #print "Rouge gagne"
                                 return (True,'R')
        
             #Pareil pour les jaune
             if n in self.listejaune:
                 if n % 7 != 6 and n+x in self.listejaune:
                     if n % 7 != 5 and n+ 2*x in self.listejaune:
                         if n % 7 != 4 and n + 3*x in self.listejaune:
                             liste = [n, n+x, n+2*x, n+3*x]
                             #print "Jaune gagne"
                             return (True,'J') 
                         if n%7 > 0 and (n-x) in self.listejaune:
                             liste = [n-x,n, n+x, n+2*x]
                             #print "Jaune gagne"
                             return (True,'J') 
                         if n%7 > 1 and (n-x) in self.listejaune:
                             if n%7 > 2 and n-(2*x) in self.listejaune:
                                 liste = [n-2*x, n-x,n, n+x]
                                 #print "Jaune gagne"
                                 return (True,'J') 
        
        
        for x in (-1,6,-8):
             if n in self.listejaune:
                 if n % 7 != 0 and (n+x) in self.listejaune:
                     if n % 7 != 1 and n+(2*x) in self.listejaune:
                         if n % 7 != 2 and n + (3*x) in self.listejaune:
                             liste = [n, n+x, n+2*x, n+3*x]
                            # print "Jaune gagne"
                             return (True,'J') 
                         if n%7 <6 and (n-x) in self.listejaune:
                             liste = [n-x,n, n+x, n+2*x]
                             #print "Jaune gagne"
                             return (True,'J') 
                         if n%7 < 5 and (n-x) in self.listejaune:
                             if n%7 < 4 and n-(2*x) in self.listejaune:
                                 liste = [n-2*x, n-x,n, n+x]
                                 print "Jaune gagne"
                                 return (True,'J') 
        
             if n in self.listerouge:
                 if n % 7 != 0 and (n+x) in self.listerouge:
                     if n % 7 != 1 and n+(2*x) in self.listerouge:
                         if n % 7 != 2 and n + (3*x) in self.listerouge:
                             liste = [n, n+x, n+2*x, n+3*x]
                            # print "Rouge gagne"
                             return (True,'R') 
                         if n%7 <6 and (n-x) in self.listerouge:
                             liste = [n-x,n, n+x, n+2*x]
                             #print "Rouge gagne"
                             return (True,'R') 
                         if n%7 < 5 and (n-x) in self.listerouge:
                             if n%7 < 4 and n-(2*x) in self.listerouge:
                                 liste = [n-2*x, n-x,n, n+x]
                                #print "Rouge gagne"
                                 return (True,'R') 
     
 
        return (False,'n')                    

if __name__ == "__main__" :
#     fen = Tk()
#     fen.title("Puissance 4")
#     fen.config(bg="dark blue")
      v1 = [0.01,0.1,10.0]
      v2 = [0.05,0.05,0.05]
      for i in range(0,len(v1)):
          for j in range(0,100): # NUMBER OF TIMES
              lecan = Can(v1[i],v2[i])
      v1 = [0.05,0.05,0.05,0.05,0.05,0.05,0.05,1.0,1.0,1.0,1.0,1.0,1.0,1.0,10.0,10.0,10.0,10.0,10.0,10.0,10.0]
      v2 = [0.01,0.05,0.1,0.5,1.0,5.0,10.0,0.01,0.05,0.1,0.5,1.0,5.0,10.0,0.01,0.05,0.1,0.5,1.0,5.0,10.0]
      for i in range(0,len(v1)):
          for j in range(0,100): # NUMBER OF TIMES
              lecan = Can(v1[i],v2[i])
     
     #fen.mainloop()
