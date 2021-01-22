/*=========================================================================

  Program:   NutateSAR
  Module:    $RCSfile: E1PlusIn.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef E1PLUSIN_H
#define E1PLUSIN_H

#include<vector>
#include<complex>
#include<string>

#include "CmdInterp.h"

// class E1PlusIn will handle the file input of the E1+ file and store the data. As there
// can be multiple coils, there must be multiple E1+ files. This is why some of the variables
// seen here are vectors and/or two-dimensional vectors
class E1PlusIn
{
	class E1PlusHeader
	{
	public:
		std::vector<unsigned int> totNumVox;
	} e1PlusHeader;

	std::vector<std::vector< Vect3D< std::complex<float> > > > e1PlusData; // [Coil][Voxel]

	// These two functions are used in the constructor E1PlusIn(CmdInterp cmdInterp)
	bool readE1PlusHeader();
	bool readE1PlusData(std::vector<unsigned int> & geomList);

public:
	
	bool e1PlusFlag;
	std::vector<std::string> fName;

	E1PlusIn(CmdInterp & cmdInterp, std::vector<unsigned int> & geomList);
	~E1PlusIn();

	// 'get' functions
	E1PlusHeader & getE1PlusHeader(){ return e1PlusHeader; }; // NOTE: Using '&' increases performance, but 'const' can't be used.
	const std::vector<std::vector< Vect3D<std::complex<float> > > > & getE1PlusData() const { return e1PlusData; };
};

#endif /* E1PLUSIN_H */
