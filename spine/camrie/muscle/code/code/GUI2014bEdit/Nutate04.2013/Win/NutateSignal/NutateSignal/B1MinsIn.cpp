/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: B1MinsIn.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"B1MinsIn.h"
#include<cassert>
#include<fstream>
#include<iostream>

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().b1Mins" accesses a public data value instead of 
// using a method to return the value.
B1MinsIn::B1MinsIn(CmdInterp & cmdInterp, std::vector<unsigned int> & geomList)  
{
	fName.clear();
	b1MinsHeader.totNumVox.clear();
	b1MinsData.clear();

	if (cmdInterp.getCmdFlags().b1Mins == true)
	{
		fName = cmdInterp.getCmdValues().b1Mins; // :TODO: (comment not by jmm) The cmdline interpretor has not taken care of numTx/Rx in sequence file.
		b1MinsFlag = readB1MinsHeader() && readB1MinsData(geomList);
	}
	else
	{
		fName.assign(1,NULLSTR);
		b1MinsFlag = true;
	}
}

B1MinsIn::~B1MinsIn()
{
	b1MinsHeader.totNumVox.clear();
	for (unsigned int i = 0; i < b1MinsData.size(); i++)
	{
		b1MinsData[i].clear();
	}
	b1MinsData.clear();
	fName.clear();
}

// ------------------------------------------------------------------------------

bool B1MinsIn::readB1MinsHeader()
{
	printf("Reading B1- data...");

	std::fstream fHandle;
	float buff;
	
	for (unsigned int i=0; i<fName.size(); i++) // for each file name
	{
		fHandle.open(fName[i].c_str(), std::ios::in | std::ios::binary);
	
		if (fHandle.fail())
		{
			std::cout << "\n\"" << fName[i] << "\" failed to open!\n";
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}

		// totNumVox__________________________________________________
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		b1MinsHeader.totNumVox.push_back((unsigned int) buff); // :TODO: verify this number against other file header information, perhaps in the calling routine

		fHandle.close();
	}

	printf("Finished!\n");

	return true;
}

// ------------------------------------------------------------------------------

bool B1MinsIn::readB1MinsData(std::vector<unsigned int> & geomList)
{
	std::fstream fHandle;

	std::complex<float> temp; float realBuff, imagBuff;
	std::vector<std::complex<float > > tempB1Mins;

	for (unsigned int i=0; i<fName.size(); i++) // for each file name
	{
		fHandle.open(fName[i].c_str(), std::ios::in | std::ios::binary);
	
		if (fHandle.fail()) // :TODO: consider making this a fatal error, since the file opened once already
		{
			std::cout << "\n\"" << fName[i] << "\" failed to open!\n";
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}

		tempB1Mins.clear();
		for (unsigned int j = 0; j < geomList.size(); j++)
		{
			fHandle.seekg (4*(2*geomList[j]+1), std::ios::beg); // move 'get' pointer to the data that goes with each particular voxel
																// 4 is for float size, 2 because there are two data points for each B1-Minus
																// file entry, and add 1 to skip the header information of the B1-Minus file.

			// B1MinsData_________________________________________________
			fHandle.read(reinterpret_cast<char*>(&realBuff), sizeof(realBuff));
			fHandle.read(reinterpret_cast<char*>(&imagBuff), sizeof(imagBuff));
			tempB1Mins.push_back(std::complex<float> (realBuff, imagBuff));
		}

		b1MinsData.push_back(tempB1Mins);
		fHandle.close();
	}

	return true;
}

// ------------------------------------------------------------------------------
