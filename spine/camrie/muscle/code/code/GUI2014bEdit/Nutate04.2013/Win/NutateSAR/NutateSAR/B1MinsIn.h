/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: B1MinsIn.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef B1MINSIN_H
#define B1MINSIN_H

#include<vector>
#include<complex>
#include<string>

#include "CmdInterp.h"

// class B1MinsIn is written to open and read-in all data from the B1-Minus file(s). Note that it is possible to use
// many B1-Minus files and that, in this class, fName is a vector of strings. 
class B1MinsIn
{
private:
	class B1MinsHeader
	{
	public:
		std::vector<unsigned int> totNumVox;
	} b1MinsHeader;

	std::vector<std::vector<std::complex<float> > > b1MinsData; // [Coil][Voxel]
	
	// These two functions are used in the constructor B1MinsIn(CmdInterp cmdInterp)
	bool readB1MinsHeader();
	bool readB1MinsData(std::vector<unsigned int> & geomList);

public:
	
	bool b1MinsFlag;
	std::vector<std::string> fName; // A vector of strings holding the file name of each B1-Minus file to be used.

	B1MinsIn(CmdInterp & cmdInterp, std::vector<unsigned int> & geomList);
	~B1MinsIn();

	// 'get' functions
	B1MinsHeader & getB1MinsHeader(){ return b1MinsHeader; }; // NOTE: Using '&' increases performance, but 'const' can't be used.
	const std::vector<std::vector<std::complex<float> > > & getB1MinsData() const { return b1MinsData; };
};

#endif /* B1MINSIN_H */
