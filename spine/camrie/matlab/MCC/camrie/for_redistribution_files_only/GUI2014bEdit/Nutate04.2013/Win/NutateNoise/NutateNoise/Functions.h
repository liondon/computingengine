/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: Functions.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 18:54:15 $
  Version:   $Revision: 1.2 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#include <vector>

// Using Box-Muller Transform to generate gaussian random number with (mean,std) = (0,1).

float rdmNum();

// :TODO: what is this function for?
float uniformRdmNum();

// rdmMat() creates a matrix of random numbers using rdmNum(). rdmMat() takes an integer argument
// which determines the matrix size. The resulting matrix will be an m x m matrix where, symmetrically,
// matrix[a][b] = matrix[b][a] :TODO: why have a symmetrical matrix of random numbers?

//std::vector<std::vector<float> > rdmMat(unsigned short int m);
std::vector<float> rdmMat(unsigned short int m);

#endif /* FUNCTIONS_H */
