/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: DelB0In.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef DELB0IN_H
#define DELB0IN_H

#include<string>

#include "CmdInterp.h"

// class DelB0In is written to extract and hold data from the Delta B0 File.
class DelB0In
{
private:
	// class DelB0Header holds info taken from the header of the Delta B0 File.
	class DelB0Header
	{
	public:
		unsigned int totNumVox;
		float aveDelB0;
	} delB0Header;

	std::vector<float> delB0Data; // Delta B0 information for each voxel
	std::vector<Vect3D<float> > devDelB0Data; // Delta B0 derivative

	// These two functions are used in the constructor DelB0In(CmdInterp cmdInterp)
	bool readDelB0Header();
	bool readDelB0Data(std::vector<unsigned int> & geomList);

public:

	bool delB0Flag;
	std::string fName;

	DelB0In(CmdInterp & cmdInterp, std::vector<unsigned int> & geomList);
	~DelB0In();

	// 'get' functions
	DelB0Header getDelB0Header(){ return delB0Header; };
	const std::vector<float> & getDelB0Data() const { return delB0Data; };
	const std::vector<Vect3D<float> > & getDevDelB0Data() const { return devDelB0Data; };
};

#endif /* DELB0IN_H */
