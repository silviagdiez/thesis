"""
Author: Laforge Jerome
"""
import math

from copy import deepcopy

class InValidAction(Exception):
    def __repr__(self):
        return "Exception: invalid action"


class P4Representation:    
    
    def __init__(self,state=None):
        self.state = state #case utilise avec couleur

    def set_percept(self,percepts):
        self.state=[percepts[j] for j in range(len(percepts))]
        
    def clone(self):
        cl=P4Representation()
        cl.set_percept(deepcopy(self.state))
        return cl

    def play_action(self,action):
        self.state.append(action)
            
        
    def getState(self):
        return self.state     
            
    def prettyprint(self):
        for i in range(self.size):
            print self.board[i] 
        print " "

    def get_percepts(self,player):
        if player==0:
            return [self.board[i][:] for i in range(self.size)] 
        else: #player==1
            percept= [[self.board[i][j] for j in range(self.size)] for i in range(self.size)] #INVERSER 0 et 1
            for i in range(self.size):
                for j in range(self.size):
                    if percept[i][j]>=0:
                        percept[i][j]=1-percept[i][j]
            return percept
    
    
    def add_observer(self,observer):
        self.observers.append(observer)
        
    def notify_observers(self):
        for o in self.observers:
            o.notify()



