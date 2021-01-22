/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: Functions.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 18:54:15 $
  Version:   $Revision: 1.2 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include <vector>
#include <stdlib.h>
#include <math.h>

float sinc(float x)
{
	if (x == 0)
	{
		return (float) 1;
	}
	else
	{
		return (sin(x)/x);
	}
}
