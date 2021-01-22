/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: Voxel.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 19:52:34 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef VOXEL_H
#define VOXEL_H

#include<complex>
#include<vector>
#include<cassert>
#include<map>

#include "Vect3D.h"
#include "TissType.h"
#include "Functions.h"

// The parameters set in Voxel should be position dependent. (<--not by jmm) :TODO: explain this further
// class Voxel will hold all pertinent information about a single sample of tissue. Each voxel has an ID
// number referring to its particular tissue type, which is used to identify the properties of that tissue
// such as T1, T2, and so on. Each voxel also has a position, denoted by a Vect3D object which has x, y, and
// z coordinates.
// For noise calculation, we are also concerned with E1 Minus information. Each voxel also holds information
// about E1 Minus for each coil being used.
class Voxel
{
private:
	// class TissInfo holds the tissue properties of the voxel. For noise calculation, we need only sigmaCon
	class TissInfo
	{
	public:
		float sigmaCon; // :TODO: why is this here if we are using a map from ID to TissType?
	};

	// class GeomInfo holds the x, y, and z position, and the tissue ID number
	class GeomInfo
	{
	public:	
		Vect3D<float> pos;
		unsigned int id;
	};

	// class EInfo holds a vector of Vect3D of complex numbers. Each coil gives x, y, and z complex
	// numbers to each voxel.
	class EInfo
	{
	public:
		std::vector<Vect3D<std::complex<float> > > e1Mins; // [Coil]
	};

public:
	GeomInfo geomInfo;
	TissInfo tissInfo;
	EInfo eInfo;

	~Voxel();

	// setTiss is a lookup function that assigns tissue properties to the voxel via a tissue map
	bool setTiss(const std::map<int, TissType> & tissMap);
	bool setE1Mins(const std::vector<Vect3D<std::complex<float> > > & e1Mins);

};  /* class Voxel */

#endif /* VOXEL_H */

