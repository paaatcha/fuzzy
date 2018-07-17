'''
      Fuzzy Numbers
      Author: Andre Pacheco (pacheco.comp@gmail.com)
      This file implements the class IntuitionisticFuzzyNumber, which is possible calculate the arithmetic operators with intuitionistic fuzzy number, as well as, measure the
      hamming distance between 2 intuitionistic fuzzy numbers and ranking them. This class work for either triangular or trapezoidal fuzzy numbers.
      For more:
      [1] Fuzzy Sets, Lotfi A. Zadeh, 1965.
      [3] K.T. Atanassov, Intuitionistic fuzzy sets, Fuzzy Sets and Systems 20 (1986) 87-96.
      [2] Aggregation operators on triangular intuitionistic fuzzy numbers and its application to multi-criteria decision making problems, Liang
      et. al., 2014

      If you use this code, please cite: IF-TODIM: An intuitionistic fuzzy TODIM to multi-criteria decision making. Knowledge-Based Systems,  Krohling,
      Pacheco and Siviero, 2013.

      If you find any bug, please, e-mail me.
'''
import numpy as np

class IntuitionisticFuzzyNumber:
      '''
      Let X be the fuzzy number, triangular or trapezoidal, values and let pertX be the pertinence value and nonPertX the nonpertinence value, the object can be initialized in three different ways.:
      1) IntuitionisticFuzzyNumber (X,pertX,nonPertX)
      2) IntuitionisticFuzzyNumber (X) - pertX and nonPertX are inicialized as default values, i. e., 1 and 0
      3) FuzzuNumvet () - X, pertX and nonPertX are inicialized as 0

      If you are using normalized fuzzy numbers, the pertX aways will be 1, so you must to set only the X value (case 2)
      '''
      X= None
      pertX = None
      nonPertX = None
      def __init__(self, *args):
            nargs = len (args)
            if nargs == 0:
                  self.X = np.array([0,0,0], dtype=float)
                  self.pertX = 0
                  self.nonPertX = 0                  
            elif nargs == 1:
                  self.X = np.asarray(args[0])
                  self.pertX = 1
                  self.nonPertX = 0
            elif nargs == 3:
                  self.X = np.asarray(args[0])
                  self.pertX = args[1]
                  self.nonPertX = args[2]
            else:
                  print 'ERROR: You are using more than 2 arguments'
                  raise ValueError

      def __str__ (self):            
            return '< %s; %s, %s >' % (self.X, self.pertX, self.nonPertX)

      # This method add two Fuzzy Numbers by overloading the operator +
      def __add__ (self, FN2):
            r = IntuitionisticFuzzyNumber ()
            r.X = self.X + FN2.X
            r.pertX = (self.pertX + FN2.pertX) - (self.pertX * FN2.pertX)
            r.nonPertX = self.nonPertX * FN2.nonPertX
            return r

      # This method subtracs two Fuzzy Numbers by overloading the operator -
      def __sub__ (self, FN2):
            r = IntuitionisticFuzzyNumber ()
            r.X = self.X - FN2.X
            r.pertX = (self.pertX - FN2.pertX) + (self.pertX * FN2.pertX)
            r.nonPertX = self.nonPertX * FN2.nonPertX
            return r

      # This method multiplies two Fuzzy Numbers or a scalar and a Fuzzy Number by overloading the operator *
      def __mul__ (self, param):
            r = IntuitionisticFuzzyNumber()

            # Crisp number
            if (type(param) == float) or (type(param) == int):
                  if param < 0:
                        print 'ERROR: the scalar must to be greater than zero'
                        raise ValueError
                  else:
                        r.X = self.X * param
                        r.pertX = 1 - (1-self.pertX)**param
                        r.nonPertX = self.nonPertX ** param
            # IFN
            else:
                r.X = self.X * param.X
                r.pertX = self.pertX * param.pertX
                r.nonPertX = self.nonPertX + param.nonPertX - (self.nonPertX * param.nonPertX)


            return r

      # This method multiplies two Fuzzy Numbers by overloading the operator /
      def __div__ (self,FN2):
            r = IntuitionisticFuzzyNumber()
            r.X = self.X / FN2.X
            r.pertX = self.pertX / FN2.pertX
            r.nonPertX = self.nonPertX - param.nonPertX + (self.nonPertX * param.nonPertX)
            return r

      # This method calculates the power of Fuzzy Numbers by a scalar by overloading the operator **
      def __pow__ (self,lamb):
            r = IntuitionisticFuzzyNumber()
            r.X = self.X ** lamb
            r.pertX = self.pertX ** lamb
            r.nonPertX = 1-(self.nonPertX-1)**2
            return r

      # This method calculates the comparision between two fuzzy numbers (It works like cmp in C)
      def cmp (self, FN2):
            n = self.X.shape[0]
            E1 = (self.X.sum()) * (1+self.pertX-self.nonPertX)/(n*2)
            E2 = (FN2.X.sum()) * (1+FN2.pertX-FN2.nonPertX)/(n*2)
            
            S1 = E1 * (self.pertX-self.nonPertX)
            H1 = E1 * (self.pertX+self.nonPertX)
            
            S2 = E2 * (FN2.pertX-FN2.nonPertX)
            H2 = E2 * (FN2.pertX+FN2.nonPertX)
                        
            if S1 > S2:
                  return 1
            elif S1 < S2:
                  return -1
            elif S1 == S2:
                if H1 > H2:
                    return 1
                elif H1 < H2:
                    return -1
                else:
                    return 0

      # This method calculates the Hamming distance between two fuzzy numbers
      def distanceHamming (self,FN2):
            n = self.X.shape[0]
            alpha = (1+self.pertX-self.nonPertX)
            beta = (1+FN2.pertX-FN2.nonPertX)           
            
            d = abs ((self.X * alpha) - (FN2.X * beta))            
            d = (sum(d))/(n*2)
            return d

      def maxminX (self):
          return self.X.max(), self.X.min()

#Example:
#a = IntuitionisticFuzzyNumber (np.array([1,2,3,4],dtype=float),0.8,0.1)
#b = IntuitionisticFuzzyNumber (np.array([2,2,2,2],dtype=float),0.7,0.1)

#print a





#print a*2
#print a.distanceHamming(b)



