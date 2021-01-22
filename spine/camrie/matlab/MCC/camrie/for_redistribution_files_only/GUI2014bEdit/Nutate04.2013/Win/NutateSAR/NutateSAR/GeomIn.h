/*=========================================================================

  Program:   NutateSAR
  Module:    $RCSfile: GeomIn.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef GEOMIN_H
#define GEOMIN_H

#include<string>
#include<vector>

#include "Voxel.h"
#include "CmdInterp.h"

// class GeomIn is designed to handle all aspects of file input regarding the sample
// geometry file. This includes header as well as data information.
class GeomIn
{
private:
	// class GeomHeader holds the values taken from the header of the sample geometry file
	class GeomHeader
	{
	public:
		unsigned int totNumVox;
		Vect3D<float> min, max; // Vect3D defines an x, y, and z component of min and max
		std::vector<unsigned int> geomList; // geomList will hold the voxel's line number as it
											// appears in the geometry file. This is done so that
											// the information associated with each particular voxel
											// taken from multiple input files can be properly matched.
	} geomHeader;

	std::vector<Voxel> geomData;

	// These two functions are called by the default constructor to read in the file's information.
	bool readGeomHeader(CmdInterp cmdInterp);
	bool readGeomData();
public:

	bool geomFlag;
	std::string fName;

	GeomIn(CmdInterp & cmdInterp);
	~GeomIn();

	// 'get' functions
	GeomHeader & getGeomHeader(){ return geomHeader; }; // NOTE: Using '&' increases performance, but 'const' can't be used.
	const std::vector<Voxel> & getGeomData() const { return geomData; };
};

#endif /* GEOFILEIN_H */
