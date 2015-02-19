"""Games, or Adversarial Search. (Chapters 6)
Code modifie depuis la version daima
"""

from utils import *
import random 



def minimax_decision(state, game):
    player = game.to_move(state)
    SolList = [] #Liste des solutions pour le graphe des solutions

    
    def max_value(state):
        test = game.terminal_test(state)
        if test[0]: 
            if (test[1]=='J') or (test[1]=='R') or (test[1]=='N'):
                #Quand on trouve un etat terminal du jeu, on le stocke
                SolList.append(state) 
            return game.utility(state, player)
        v = -infinity
        for (a, s) in game.successors(state):
                v = max(v, min_value(s))
        return v

    def min_value(state):
        test = game.terminal_test(state)
        if test[0]:
            if (test[1]=='J') or (test[1]=='R') or (test[1]=='N'):
                #Quand on trouve un etat terminal du jeu, on le stocke
                SolList.append(state)
            return game.utility(state, player)
        v = infinity
        for (a, s) in game.successors(state):
                v = min(v, max_value(s))
        return v

    # Body of minimax_decision starts here:
    action, state = argmax(game.successors(state),
                           lambda ((a, s)): min_value(s))
    
    #print game.utility(state, player)
    return (action,SolList,state)









#
##______________________________________________________________________________
#    
def alphabeta_full_search(state, game):


    player = game.to_move(state)
    SolList = []
    def max_value(state, alpha, beta):
        test = game.terminal_test(state)
        if test[0]:
            if (test[1]=='J') or (test[1]=='R') or (test[1]=='N'):
                SolList.append(state)
            #elif 'red'==player and test[1]=='R' :
             #   SolList.append(state)
            return game.utility(state, player)
        v = -infinity
        for (a, s) in game.successors(state):
            v = max(v, min_value(s, alpha, beta))
            if v >= beta:
                return v
            alpha = max(alpha, v)
        return v

    def min_value(state, alpha, beta):
        test = game.terminal_test(state)
        if test[0]:
            if (test[1]=='J') or (test[1]=='R') or (test[1]=='N'):
                SolList.append(state)
            #elif 'red'==player and test[1]=='R' :
             #   SolList.append(state)
            return game.utility(state, player)
        v = infinity
        for (a, s) in game.successors(state):
            v = min(v, max_value(s, alpha, beta))
            if v <= alpha:
                return v
            beta = min(beta, v)
        return v

    # Body of alphabeta_search starts here:
    action, state = argmax(game.successors(state),
                           lambda ((a, s)): min_value(s, -infinity, infinity))
    return (action,SolList,state)
#
#def alphabeta_search(state, game, d=4, cutoff_test=None, eval_fn=None):
#    """Search game to determine best action; use alpha-beta pruning.
#    This version cuts off search and uses an evaluation function."""
#
#    player = game.to_move(state)
#
#    def max_value(state, alpha, beta, depth):
#        if cutoff_test(state, depth):
#            return eval_fn(state)
#        v = -infinity
#        for (a, s) in game.successors(state):
#            v = max(v, min_value(s, alpha, beta, depth+1))
#            if v >= beta:
#                return v
#            alpha = max(alpha, v)
#        return v
#
#    def min_value(state, alpha, beta, depth):
#        if cutoff_test(state, depth):
#            return eval_fn(state)
#        v = infinity
#        for (a, s) in game.successors(state):
#            v = min(v, max_value(s, alpha, beta, depth+1))
#            if v <= alpha:
#                return v
#            beta = min(beta, v)
#        return v
#
#    # Body of alphabeta_search starts here:
#    # The default test cuts off at depth d or at a terminal state
#    cutoff_test = (cutoff_test or
#                   (lambda state,depth: depth>d or game.terminal_test(state)))
#    eval_fn = eval_fn or (lambda state: game.utility(state, player))
#    action, state = argmax(game.successors(state),
#                           lambda ((a, s)): min_value(s, -infinity, infinity, 0))
#    return action

#______________________________________________________________________________
# Players for Games

def query_player(game, state):
    "Make a move by querying standard input."
    game.display(state)
    return num_or_str(raw_input('Your move? '))

def random_player(game, state):
    "A player that chooses a legal move at random."
    return random.choice(game.legal_moves())

def alphabeta_player(game, state):
    return alphabeta_search(state, game)

def play_game(game, *players):
    "Play an n-person, move-alternating game."
    state = game.initial
    while True:
        for player in players:
            move = player(game, state)
            state = game.make_move(move, state)
            if game.terminal_test(state):
                return game.utility(state, players[0])

#______________________________________________________________________________
# Some Sample Games

class Game:
    """A game is similar to a problem, but it has a utility for each
    state and a terminal test instead of a path cost and a goal
    test. To create a game, subclass this class and implement
    legal_moves, make_move, utility, and terminal_test. You may
    override display and successors or you can inherit their default
    methods. You will also need to set the .initial attribute to the
    initial state; this can be done in the constructor."""

    def legal_moves(self, state):
        "Return a list of the allowable moves at this point."
        abstract

    def make_move(self, move, state):
        "Return the state that results from making a move from a state."
        abstract
            
    def utility(self, state, player):
        "Return the value of this final state to player."
        abstract

    def terminal_test(self, state):
        "Return True if this is a final state for the game."
        return not self.legal_moves(state)

    def to_move(self, state):
        "Return the player whose move it is in this state."
        return state.to_move

    def display(self, state):
        "Print or otherwise display the state."
        print state

    def successors(self, state):
        "Return a list of legal (move, state) pairs."
        return [(move, self.make_move(move, state))
                for move in self.legal_moves(state)]

    def __repr__(self):
        return '<%s>' % self.__class__.__name__

