/*=========================================================================

  Program:   NutateSAR
  Module:    $RCSfile: Voxel.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 19:52:34 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"Voxel.h"
#include<iostream>

//#define SimpleTx
#define AdvancedTx

// ------------------------------------------------------------------------------

Voxel::~Voxel()
{
	bInfo.b1Plus.clear();
	eInfo.e1Plus.clear();
	sarInfo.sar0.clear();
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
		tissInfo.rhoMass = tissType.rhoMass;

		return true;
	}
	else
	{
		std::cout<< "Fatal Error:Tissue Id=" << geomInfo.id << " cannot be found in Tissue Type File." << std::endl;
		return false;
	}
}

// ------------------------------------------------------------------------------

bool Voxel::setB1Mins(const std::vector<std::complex<float> > & b1Mins) // [Coil]
{
	// the 'b1Mins' vector's index indicates the number of the coil causing the B1- distribution
	for (unsigned int n=0; n<b1Mins.size(); n++)
	{
		bInfo.b1Mins.push_back(b1Mins[n]);
	}
	return true;
}

// ------------------------------------------------------------------------------

bool Voxel::setB1Plus(const std::vector<std::complex<float> > & b1Plus) // [Coil]
{
	for (unsigned int n=0; n<b1Plus.size(); n++)
	{
		bInfo.b1Plus.push_back(b1Plus[n]);
	}
	return true;
}

// ------------------------------------------------------------------------------

bool Voxel::setE1Plus(const std::vector<Vect3D<std::complex<float> > > & e1Plus) // [Coil]
{
	for (unsigned int n=0; n<e1Plus.size(); n++)
	{
		eInfo.e1Plus.push_back(e1Plus[n]);
	}
	return true;
}

// ------------------------------------------------------------------------------

float Voxel::calSAR(const std::vector<std::complex<float> > & rf, float time)
{
	Vect3D<std::complex<float> > temp;
	for (unsigned int n = 0; n < eInfo.e1Plus.size(); n++)
	{
		temp += (sarInfo.sar0[n] * rf[n]);
	}
	return (float)((pow(abs(temp.x),(float)2.0) + pow(abs(temp.y),(float)2.0) + pow(abs(temp.z),(float)2.0)) * time /(double)2.0); // Peak Power vs. Average Power.
}

// ------------------------------------------------------------------------------

void Voxel::initSAR0(const std::vector<std::complex<float> > & aveB1Plus)
{
	sarInfo.sar0.resize(eInfo.e1Plus.size());
	for (unsigned int n = 0; n < eInfo.e1Plus.size(); n++)
	{
		if (tissInfo.rhoMass != 0)
		{
#ifdef AdvancedTx
			sarInfo.sar0[n] = eInfo.e1Plus[n] / (std::complex<float>((float)5.8718524e-007,0)) * sqrt(tissInfo.sigmaCon) / sqrt(tissInfo.rhoMass);  // For Multi-TX.
#endif
#ifdef SimpleTx
			sarInfo.sar0[n] = eInfo.e1Plus[n] / aveB1Plus[n] * sqrt(tissInfo.sigmaCon) / sqrt(tissInfo.rhoMass); // this will cause problem for paralellism with inhomogeneous B1+.
#endif
		}
		else
		{
			sarInfo.sar0[n] = 0;
		}
	}
}
