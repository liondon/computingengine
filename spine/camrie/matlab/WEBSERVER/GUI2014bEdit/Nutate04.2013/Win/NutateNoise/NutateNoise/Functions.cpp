/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: Functions.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 18:54:15 $
  Version:   $Revision: 1.2 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include <vector>
#include <stdlib.h>
#include <math.h>


// ------------------------------------------------------------------------------

// Using Box-Muller Transform to generate gaussian random number with zero mean & unit variance.

float rdmNum()
{
	float V1, X;
    static float V2, S;	// declared as static so they will be kept until the next call of rdmNum()
    static int phase = 0; // used as a binary switch so that rdmNum() follows a different path for each call
   
    if ( phase == 0 )
	{
        do {			
            float U1 = (float)rand() / RAND_MAX; // generate two random numbers between 0 and 1
            float U2 = (float)rand() / RAND_MAX;
           
            V1 = 2 * U1 - 1; // scale the random numbers to fall between -1 and 1
            V2 = 2 * U2 - 1;
            S = V1 * V1 + V2 * V2; // square each number and add them together
        } while(S >= 1 || S == 0); // accept only numbers which fall between the open interval (0,1)
       
        X = V1 * sqrt(-2 * log(S) / S);
    }
	else
	{
        X = V2 * sqrt(-2 * log(S) / S);
	}
       
    phase = 1 - phase; // change the phase for the next call to this function

    return X;
}

// ------------------------------------------------------------------------------

float uniformRdmNum()
{
	return (float) (rand() / RAND_MAX - (float) 0.5);
}

// ------------------------------------------------------------------------------

//std::vector<std::vector<float> > rdmMat(unsigned short int m)
//{
//	std::vector<std::vector<float> > x;
//	x.resize(m);
//	for (unsigned short int k=0; k<m; k++)
//	{
//		x[k].resize(m);
//	}
//
//	for (unsigned short int i=0; i<m; i++)
//	{
//		for (unsigned short int j=0; j<m; j++)
//		{
//			//if (i <= j)
//			//{
//			//	x[i][j]	= rdmNum();
//			//}
//			//else
//			//{
//			//	x[i][j]	= x[j][i]; // :TODO: remove this, if it is to save time
//			//}
//
//			x[i][j]	= rdmNum();
//		}
//	}
//	return x;
//}

std::vector<float> rdmMat(unsigned short int m)
{
	std::vector<float> x;
	x.resize(m);

	for (unsigned short int i=0; i<m; i++)
	{
		x[i] = rdmNum();
	}
	return x;
}