'''
      Fuzzy Numbers
      Author: Andre Pacheco (pacheco.comp@gmail.com)
      This file implements the class FuzzyNumber, which is possible calculate the arithmetic operators with fuzzy number, as well as, measure the
      hamming distance between 2 fuzzy numbers and ranking them. This class work for either triangular or trapezoidal fuzzy numbers.
      For more:
      [1] Fuzzy Sets, Lotfi A. Zadeh, 1965.
      [2] Aggregation operators on trinagular intuitionistic fuzzy numbers and its application to multi-criteria decision making problems, Liang
      et. al., 2014

      If you use this code, please cite: IF-TODIM: An intuitionistic fuzzy TODIM to multi-criteria decision making. Knowledge-Based Systems,  Krohling,
      Pacheco and Siviero, 2013.

      If you find any bug, please, e-mail me
'''
import numpy as np

class FuzzyNumber:
      X = None
      pertX = None
      
#      Let X be the fuzzy number, triangular or trapezoidal, values and let pertX be the pertinence value, the object can be initialized in three different ways.:
#      1) FuzzyNumber (X,pertX)
#      2) FuzzyNumber (X) - pertX is inicialized as default values, i. e., 1
#      3) FuzzuNumvet () - X and pertX are inicialized as 0
#
#      If you are using normalized fuzzy numbers, the pertX aways will be 1, so you must to set only the X value (case 2)


      def __init__(self, *args):
            nargs = len (args)
            if nargs == 0:
                  self.X = np.array([0,0,0], dtype=float)
                  self.pertX = 0
            elif nargs == 1:
                  self.X = args[0]
                  self.pertX = 1
            elif nargs == 2:
                  self.X = args[0]
                  self.pertX = args[1]
            else:
                  print 'ERROR: You are using more than 2 arguments'
                  raise ValueError

      def __str__ (self):
            return '< %s; %s>' % (self.X, self.pertX)

      # This method add two Fuzzy Numbers by overloading the operator +
      def __add__ (self, FN2):
            r = FuzzyNumber ()
            r.X = self.X + FN2.X
            r.pertX = (self.pertX + FN2.pertX) - (self.pertX * FN2.pertX)
            return r

      # This method subtracs two Fuzzy Numbers by overloading the operator -
      def __sub__ (self, FN2):
            r = FuzzyNumber ()
            r.X = self.X - FN2.X
            r.pertX = (self.pertX - FN2.pertX) + (self.pertX * FN2.pertX)
            return r

      # This method multiplies two Fuzzy Numbers or a scalar and a Fuzzy Number by overloading the operator *
      def __mul__ (self, param):
            r = FuzzyNumber()
            if (type(param) == float) or (type(param) == int):
                  if lamb < 0:
                        print 'ERROR: the scalar must to be greater than zero'
                        raise ValueError
                  else:
                        r.X = self.X * param
                        r.pertX = 1 - (1-self.pertX)**param
            else:
                  r.X = self.X * param.X
                  r.pertX = self.pertX * param.pertX

            return r

      # This method multiplies two Fuzzy Numbers by overloading the operator /
      def __div__ (self,FN2):
            r = FuzzyNumber()
            r.X = self.X / FN2.X
            r.pertX = self.pertX / FN2.pertX
            return r

      # This method calculates the power of Fuzzy Numbers by a scalar by overloading the operator **
      def __pow__ (self,lamb):
            r = FuzzyNumber()
            r.X = self.X ** lamb
            r.pertX = self.pertX ** lamb
            return r

      # This method calculates the comparision between two fuzzy numbers (It works like cmp in C)
      def cmp (self, FN2):
            n = self.X.shape[0]
            E1 = self.X.sum()
            E2 = FN2.X.sum()
            E1 = E1 *(1+self.pertX)/(n*2)
            E2 = E2 *(1+FN2.pertX)/(n*2)
            S1 = E1 * self.pertX
            S2 = E2 * FN2.pertX

            if S1 > S2:
                  return 1
            elif S2 > S1:
                  return -1
            else:
                  return 0

      # This method calculates the Hamming distance between two fuzzy numbers
      def distanceHamming (self,FN2):
            n = self.X.shape[0]
            d = abs (((1+self.pertX)*self.X) - ((1+FN2.pertX)*FN2.X))
            d = (sum(d))/(n*2)
            return d




'''
Example:
a = FuzzyNumber (np.array([1,2,3],dtype=float),1)
b = FuzzyNumber (np.array([4,5,6],dtype=float),1)

print a+b
print a*2
print a.distanceHamming(b)

'''

