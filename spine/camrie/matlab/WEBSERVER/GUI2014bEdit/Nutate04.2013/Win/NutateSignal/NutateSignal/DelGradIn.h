/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: DelGradIn.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef DELGRADIN_H
#define DELGRADIN_H

#include<string>

#include "CmdInterp.h"

struct DelGradData
{
	int x, y, z;
	float delGrad;
};

// class DelGradIn is defined to handle the file input of the delta gradient file
class DelGradIn
{
private:
	// class DelGradHeader holds all info from the header of the delta gradient file
	class DelGradHeader
	{
	public:
		unsigned int totNumVox;
		Vect3D<int> min;
		Vect3D<int> max;
		Vect3D<int> ctr;
		Vect3D<float> wid;
	} delGradHeader;

	std::vector<DelGradData> delGradData;

	// These two functions are used in the constructor DelGradIn(CmdInterp cmdInterp)
	bool readDelGradHeader(  Vect3D<float> min, Vect3D<float> max, Vect3D<float> wid );
	bool readDelGradData();
	
	// axisShift is used to change the coordinates of the grad data, shifting the center to the point specified in the header or in the command line
	void axisShift();

	unsigned int FindGrad(int x, int y, int z);

public:

	bool delGradFlag;
	std::string fName;

	DelGradIn(bool flag, std::string addr, Vect3D<float> min, Vect3D<float> max, Vect3D<float> wid);
	~DelGradIn();
	
	// 'get' functions
	DelGradHeader getDelGradHeader(){ return delGradHeader; };
	float getDelGradData(Vect3D<float> pos);
};

#endif /* DELGRADIN_H */
