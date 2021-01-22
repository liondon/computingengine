/*=========================================================================

  Program:   Nutate (This file is identical for SAR and Signal calcuation)
  Module:    $RCSfile: B1PlusIn.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef B1PLUS_H
#define B1PLUS_H

#include<vector>
#include<complex>
#include<string>

#include "CmdInterp.h"

// class B1PlusIn handles the file input for the B1 Plus distribution file(s). The objects in this class
// will hold the header info and the data read from the B1 Plus file(s). fName in this class is defined
// as a vector to hold multiple file names in order to simulate multiple coils.
class B1PlusIn
{
private:
	class B1PlusHeader
	{
	public:
		std::vector<unsigned int> totNumVox;
	} b1PlusHeader;

	// The b1PlusData object will hold the B1 Plus information for each coil. The first index shows the
	// coil number, and the second index holds the information pertaining to a particular voxel for the
	// associated coil, as shown below.
	std::vector<std::vector<std::complex<float> > > b1PlusData; // [Coil][Voxel]

	// These two functions are used in the constructor B1PlusIn(CmdInterp cmdInterp)
	bool readB1PlusHeader();
	bool readB1PlusData(std::vector<unsigned int> & geomList);

public:
	
	bool b1PlusFlag;
	std::vector<std::string> fName;

	B1PlusIn(CmdInterp & cmdInterp, std::vector<unsigned int> & geomList);
	~B1PlusIn();

	// 'get' functions
	B1PlusHeader & getB1PlusHeader(){ return b1PlusHeader; }; // NOTE: Using '&' increases performance, but 'const' can't be used.
	const std::vector<std::vector<std::complex<float> > > & getB1PlusData() const { return b1PlusData; };
};

#endif /* B1PLUS_H */
