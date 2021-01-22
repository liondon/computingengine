/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: Voxel.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 19:52:34 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"Voxel.h"
#include<iostream>

// ------------------------------------------------------------------------------

Voxel::~Voxel()
{
	eInfo.e1Mins.clear();
}

bool Voxel::setTiss(const std::map<int, TissType> & tissMap) 
{
	TissType tissType;
	std::map<int, TissType>::const_iterator itr;
	itr = tissMap.find(geomInfo.id);
	if ( itr != tissMap.end() )
	{
		tissType = itr->second;

		tissInfo.sigmaCon = tissType.sigmaCon;

		return true;
	}
	else
	{
		std::cout<< "Fatal Error:Tissue Id=" << geomInfo.id << " cannot be found in Tissue Type File." << std::endl;
		return false;
	}
}

// ------------------------------------------------------------------------------

bool Voxel::setE1Mins(const std::vector<Vect3D<std::complex<float> > > & e1Mins) // [Coil]
{
	for (unsigned int n=0; n<e1Mins.size(); n++)
	{
		eInfo.e1Mins.push_back(e1Mins[n]);
	}
	return true;
}
