/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: DelB0In.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"DelTempIn.h"
#include<cassert>
#include<fstream>
#include<iostream>

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().b1Plus" accesses a public data value instead of 
// using a method to return the value.
DelTempIn::DelTempIn(CmdInterp & cmdInterp,std::vector<unsigned int> & geomList)
{
	fName.clear();
	delTempHeader.totNumVox = 0;
	delTempData.clear();
	
	if (cmdInterp.getCmdFlags().delTemp == true)
	{
		fName = cmdInterp.getCmdValues().delTemp;
		delTempFlag = readDelTempHeader() && readDelTempData(geomList);
	}
	else
	{
		fName = NULLSTR;
		delTempFlag = true;
	}
}

DelTempIn::~DelTempIn()
{
	delTempData.clear();
	devDelTempData.clear();
}

// ------------------------------------------------------------------------------

bool DelTempIn::readDelTempHeader()
{
	std::fstream fHandle;
	float buff;
	
	fHandle.open(fName.c_str(), std::ios::in | std::ios::binary);

	if (fHandle.fail())
	{
		std::cout << "\n\"" << fName << "\" failed to open!\n";
		printf("Execution terminated, press enter to exit.\n");
		std::cin.get();
		return false;
	}

	// totNumVox__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delTempHeader.totNumVox = (unsigned int) buff;
	
	fHandle.close();
	return true;
}

// ------------------------------------------------------------------------------

bool DelTempIn::readDelTempData(std::vector<unsigned int> & geomList)
{
	printf("Reading Delta Temp data... ");

	std::fstream fHandle;
	float buff, buffX, buffY, buffZ;
	Vect3D<float> tempDevDelTempData;

	fHandle.open(fName.c_str(), std::ios::in | std::ios::binary);
	
	if (fHandle.fail())
	{
		std::cout << "\n\"" << fName << "\" failed to open!\n";
		printf("Execution terminated, press enter to exit.\n");
		std::cin.get();
		return false;
	}

	double tempAveDelTemp = 0;
	for (unsigned int j=0; j < geomList.size(); j++)
	{
		fHandle.seekg (4*(4*geomList[j]+1), std::ios::beg); // seek to the appropriate location in the Delta Temp file.
															// Multiply by 4 for size of a float, 4 again because there
															// are 4 floats for each data point, and add 1 to skip the
															// header information.

		// DelTempData_________________________________________________
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		delTempData.push_back((float)buff);
		tempAveDelTemp += (double)buff;

		// DevDelTempData_________________________________________________
		fHandle.read(reinterpret_cast<char*>(&buffX), sizeof(buffX));
		fHandle.read(reinterpret_cast<char*>(&buffY), sizeof(buffY));
		fHandle.read(reinterpret_cast<char*>(&buffZ), sizeof(buffZ));
		
		tempDevDelTempData.x = (float) buffX;
		tempDevDelTempData.y = (float) buffY;
		tempDevDelTempData.z = (float) buffZ;
		devDelTempData.push_back(tempDevDelTempData);
	}
	fHandle.close();

	printf("Finished!\n");
	
	return true;
}

// ------------------------------------------------------------------------------
