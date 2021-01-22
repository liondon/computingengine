/*=========================================================================

  Program:   NutateSAR
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

#define PI (float) 3.14159265358979323846264338327950288419716939937510
#define GAMMA (float) (42576000.0 * 2 * PI) // 267522209.9 /* rad/T/s */ // -> 42576000.0 /* Hz/T */
#define B1Pl (float)(PI/2/GAMMA/0.001) /* T */ // -> 90 degree flip angle in 1ms.

// The parameters set in Voxel should be position dependent. (<--not by jmm) :TODO: explain this further
// class Voxel will hold all pertinent information about a single sample of tissue. Each voxel has an ID
// number referring to its particular tissue type, which is used to identify the properties of that tissue
// such as T1, T2, and so on. Each voxel also has a position, denoted by a Vect3D object which has x, y, and
// z coordinates.
class Voxel
{
private:
	// class TissInfo holds the tissue properties of the voxel.
	class TissInfo
	{
	public:
		float sigmaCon, rhoMass; // :TODO: why is this here if we are using a map from ID to TissType?
	};

	// class GeomInfo holds the x, y, and z position, and the tissue ID number
	class GeomInfo
	{
	public:	
		Vect3D<float> pos;
		unsigned int id;
	};

	// class BInfo holds a vector of complex numbers. Each coil gives a complex number to a voxel.
	class BInfo
	{
	public:
		std::vector<std::complex<float> > b1Plus, b1Mins; // [Coil]
	};

	// class EInfo holds a vector of Vect3D of complex numbers. Each coil gives x, y, and z complex
	// number data to each voxel.
	class EInfo
	{
	public:
		std::vector<Vect3D<std::complex<float> > > e1Plus; // [Coil]
	};

	// class SARInfo holds a vector of Vect3D of complex numbers. Each coil gives x, y, and z complex
	// number data to each voxel.
	class SARInfo
	{
	public:
		std::vector<Vect3D<std::complex<float> > > sar0; // [Coil]
	};

public:
	~Voxel();

	GeomInfo geomInfo;
	TissInfo tissInfo;
	BInfo bInfo;
	EInfo eInfo;
	SARInfo sarInfo;

	// setTiss is a lookup function that assigns tissue properties to the voxel via a tissue map
	bool setTiss(const std::map<int, TissType> & tissMap);
	bool setB1Mins(const std::vector<std::complex<float> > & b1Mins);
	bool setB1Plus(const std::vector<std::complex<float> > & b1Plus);
	bool setE1Plus(const std::vector<Vect3D<std::complex<float> > > & e1Plus);

	// called by the default constructor of Execution
	void initSAR0(const std::vector<std::complex<float> > & aveB1Plus);

	float calSAR(const std::vector<std::complex<float> > & rf, float time);

};  /* class Voxel */

#endif /* VOXEL_H */

