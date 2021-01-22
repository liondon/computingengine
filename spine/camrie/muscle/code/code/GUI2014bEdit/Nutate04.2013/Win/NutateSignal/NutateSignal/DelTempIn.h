/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: DelB0In.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef DELTEMPIN_H
#define DELTEMPIN_H

#include<string>

#include "CmdInterp.h"

// class DelTempIn is written to extract and hold data from the Delta Temp File.
class DelTempIn
{
private:
	// class DelTempHeader holds info taken from the header of the Delta Temp File.
	class DelTempHeader
	{
	public:
		unsigned int totNumVox;
	} delTempHeader;

	std::vector<float> delTempData; // Delta Temp information for each voxel
	std::vector<Vect3D<float> > devDelTempData; // Delta Temp derivative

	// These two functions are used in the constructor DelTempIn(CmdInterp cmdInterp)
	bool readDelTempHeader();
	bool readDelTempData(std::vector<unsigned int> & geomList);

public:

	bool delTempFlag;
	std::string fName;

	DelTempIn(CmdInterp & cmdInterp, std::vector<unsigned int> & geomList);
	~DelTempIn();

	// 'get' functions
	DelTempHeader getDelTempHeader(){ return delTempHeader; };
	const std::vector<float> & getDelTempData() const { return delTempData; };
	const std::vector<Vect3D<float> > & getDevDelTempData() const { return devDelTempData; };
};

#endif /* DELTEMPIN_H */
