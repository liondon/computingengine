/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: E1MinsIn.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef E1MINSIN_H
#define E1MINSIN_H

#include<vector>
#include<complex>
#include<string>

#include "CmdInterp.h"

// class E1MinsIn is dedicated to read-in of the E1Minus file(s)
class E1MinsIn
{
private:
	// subclass E1MinsHeader 
	class E1MinsHeader
	{
	public:
		std::vector<unsigned int> totNumVox;
	} e1MinsHeader;

	// e1MinsData must be stored as a double indexed vector of x, y, and z associated
	// complex floating point numbers. As shown below, the first index pertains to the
	// coil causing the E1 Minus interference, while the second index corresponds to
	// a voxel number.
	// :TODO: verify that the above comment makes sense
	std::vector<std::vector< Vect3D< std::complex<float> > > > e1MinsData; // [Coil][Voxel]

	// These two functions are called in the constructor E1MinsIn(CmdInterp cmdInterp) to
	// read the E1 Minus file(s) data into e1MinsData
	bool readE1MinsHeader();
	bool readE1MinsData(std::vector<unsigned int> & geomList);

public:
	
	bool e1MinsFlag;
	std::vector<std::string> fName;

	E1MinsIn(CmdInterp & cmdInterp, std::vector<unsigned int> & geomList);
	~E1MinsIn();

	E1MinsHeader & getE1MinsHeader(){ return e1MinsHeader; };
	const std::vector<std::vector< Vect3D<std::complex<float> > > > & getE1MinsData() const { return e1MinsData; };
};

#endif /* E1MINSIN_H */
