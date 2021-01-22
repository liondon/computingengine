/*=========================================================================

  Program:   Nutate (This file is identical for SAR and Signal calcuation)
  Module:    $RCSfile: B1PlusIn.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"B1PlusIn.h"
#include<cassert>
#include<fstream>
#include<iostream>

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().b1Plus" accesses a public data value instead of 
// using a method to return the value.
B1PlusIn::B1PlusIn(CmdInterp & cmdInterp, std::vector<unsigned int> & geomList)
{
	fName.clear();
	b1PlusHeader.totNumVox.clear();
	b1PlusData.clear();

	if (cmdInterp.getCmdFlags().b1Plus == true) // if B1 Filenames were provided
	{
		fName = cmdInterp.getCmdValues().b1Plus; // :TODO: (not by jmm) The cmdline interpretor has not taken care of numTx/Rx in sequence file.
		b1PlusFlag = readB1PlusHeader() && readB1PlusData(geomList);
	}
	else
	{
		fName.assign(1,NULLSTR);
		b1PlusFlag = true;
	}
}

B1PlusIn::~B1PlusIn()
{
	b1PlusHeader.totNumVox.clear();
	for (unsigned int i = 0; i < b1PlusData.size(); i++)
	{
		b1PlusData[i].clear();
	}
	b1PlusData.clear();
	fName.clear();
}

// ------------------------------------------------------------------------------

bool B1PlusIn::readB1PlusHeader()
{
	std::fstream fHandle;
	float buff;
	
	for (unsigned int i=0; i<fName.size(); i++)
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
		b1PlusHeader.totNumVox.push_back((unsigned int) buff);

		fHandle.close();
	}
	
	return true;
}

// ------------------------------------------------------------------------------

bool B1PlusIn::readB1PlusData(std::vector<unsigned int> & geomList)
{
	printf("Reading B1+ data...");

	std::fstream fHandle;

	std::complex<float> temp; float realBuff, imagBuff;
	std::vector<std::complex<float > > tempB1Plus;

	for (unsigned int i=0; i<fName.size(); i++) // for each B1+ file
	{
		fHandle.open(fName[i].c_str(), std::ios::in | std::ios::binary);
		
		if (fHandle.fail())
		{
			std::cout << "\n\"" << fName[i] << "\" failed to open!\n";
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}

		unsigned int j = 0;

		tempB1Plus.clear();
		while(j < geomList.size())
		{
			fHandle.seekg (4*(2*geomList[j]+1), std::ios::beg); // seek to the appropriate location in the B1+ file
												// 4 is the size of a float, 2 because there are two data points for
												// each voxel, and + 1 because we must skip the header info

			// B1PlusData_________________________________________________
			fHandle.read(reinterpret_cast<char*>(&realBuff), sizeof(realBuff));
			fHandle.read(reinterpret_cast<char*>(&imagBuff), sizeof(imagBuff));
			tempB1Plus.push_back(std::complex<float> (realBuff, imagBuff));
			j++;
		}

		b1PlusData.push_back(tempB1Plus);
		fHandle.close();
	}

	printf("Finished!\n");

	return true;
}

// ------------------------------------------------------------------------------
