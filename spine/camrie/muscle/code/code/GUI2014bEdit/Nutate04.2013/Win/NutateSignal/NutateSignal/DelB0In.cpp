/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: DelB0In.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"DelB0In.h"
#include<cassert>
#include<fstream>
#include<iostream>

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().b1Plus" accesses a public data value instead of 
// using a method to return the value.
DelB0In::DelB0In(CmdInterp & cmdInterp,std::vector<unsigned int> & geomList)
{
	fName.clear();
	delB0Header.totNumVox = 0;
	delB0Data.clear();
	
	if (cmdInterp.getCmdFlags().delB0 == true)
	{
		fName = cmdInterp.getCmdValues().delB0;
		delB0Flag = readDelB0Header() && readDelB0Data(geomList);
	}
	else
	{
		fName = NULLSTR;
		delB0Flag = true;
	}
}

DelB0In::~DelB0In()
{
	delB0Data.clear();
	devDelB0Data.clear();
}

// ------------------------------------------------------------------------------

bool DelB0In::readDelB0Header()
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
	delB0Header.totNumVox = (unsigned int) buff;
	
	fHandle.close();
	return true;
}

// ------------------------------------------------------------------------------

bool DelB0In::readDelB0Data(std::vector<unsigned int> & geomList)
{
	printf("Reading Delta B0 data... ");

	std::fstream fHandle;
	float buff, buffX, buffY, buffZ;
	Vect3D<float> tempDevDelB0Data;

	fHandle.open(fName.c_str(), std::ios::in | std::ios::binary);
	
	if (fHandle.fail())
	{
		std::cout << "\n\"" << fName << "\" failed to open!\n";
		printf("Execution terminated, press enter to exit.\n");
		std::cin.get();
		return false;
	}

	double tempAveDelB0 = 0;
	for (unsigned int j=0; j < geomList.size(); j++)
	{
		fHandle.seekg (4*(4*geomList[j]+1), std::ios::beg); // seek to the appropriate location in the Delta B0 file.
															// Multiply by 4 for size of a float, 4 again because there
															// are 4 floats for each data point, and add 1 to skip the
															// header information.

		// DelB0Data_________________________________________________
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		delB0Data.push_back((float)buff);
		tempAveDelB0 += (double)buff;

		// DevDelB0Data_________________________________________________
		fHandle.read(reinterpret_cast<char*>(&buffX), sizeof(buffX));
		fHandle.read(reinterpret_cast<char*>(&buffY), sizeof(buffY));
		fHandle.read(reinterpret_cast<char*>(&buffZ), sizeof(buffZ));
		
		tempDevDelB0Data.x = (float) buffX;
		tempDevDelB0Data.y = (float) buffY;
		tempDevDelB0Data.z = (float) buffZ;
		devDelB0Data.push_back(tempDevDelB0Data);
	}
	fHandle.close();

	delB0Header.aveDelB0 = (float) (tempAveDelB0 / delB0Data.size()); // Frequency Adjust

	//for (unsigned int j=0; j<delB0Data.size(); j++)
	//{
	//	delB0Data[j] -= delB0Header.aveDelB0;
	//}

	// Mannual Shimming (Freq Adjust)
	//delB0Header.aveDelB0 = -0.77728033
	for (unsigned int j=0; j<delB0Data.size(); j++)
	{
		delB0Data[j] -= (float)-0.77728033; // This ensures same result from whole head input and slab input.
	}

	printf("Finished!\n");
	
	return true;
}

// ------------------------------------------------------------------------------
