/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: E1MinsIn.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"E1MinsIn.h"
#include<cassert>
#include<fstream>
#include<iostream>
#include<complex>

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().e1Mins" accesses a public data value instead of 
// using a method to return the value.
E1MinsIn::E1MinsIn(CmdInterp & cmdInterp, std::vector<unsigned int> & geomList)
{
	fName.clear();
	e1MinsHeader.totNumVox.clear();
	e1MinsData.clear();

	if (cmdInterp.getCmdFlags().e1Mins == true)
	{
		fName = cmdInterp.getCmdValues().e1Mins; // :TODO: (comment NOT by jmm) The cmdline interpretor has not taken care of numTx/Rx in sequence file.
		e1MinsFlag = readE1MinsHeader() && readE1MinsData(geomList);
	}
	else
	{
		fName.assign(1,NULLSTR);
		e1MinsFlag = true;
	}
}

// ------------------------------------------------------------------------------

E1MinsIn::~E1MinsIn()
{
	e1MinsHeader.totNumVox.clear();
	for (unsigned int i = 0; i < e1MinsData.size(); i++)
	{
		e1MinsData[i].clear();
	}
	e1MinsData.clear();
	fName.clear();
}

// ------------------------------------------------------------------------------

bool E1MinsIn::readE1MinsHeader()
{
	std::fstream fHandle;
	float buff;
	
	// loop through each file to open the file and read its header information
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
		e1MinsHeader.totNumVox.push_back((unsigned int) buff);

		fHandle.close();
	}

	return true;
}

// ------------------------------------------------------------------------------
bool E1MinsIn::readE1MinsData(std::vector<unsigned int> & geomList)
{
	printf("Reading E1- data...");

	std::fstream fHandle;

	std::complex<float> temp; float realBuff, imagBuff;
	std::vector<Vect3D< std::complex<float> > > tempE1MinsData;

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

		tempE1MinsData.clear();
		Vect3D<std::complex<float> > Vect3DBuff;
		for (unsigned int j = 0; j < geomList.size(); j++)
		{
			// move the get pointer to the appropriate location in the E1 Minus file, which corresponds to a
			// particular voxel in the geometry file. Multiply by 4 because that is the size in bytes of a
			// float, and by 6 because there are six data points for each line (voxel) in the E1 Minus file.
			// geomList[n] holds the voxel's original position in the geometry file so that we can find the
			// associated info in other files.
			fHandle.seekg (4*(6*geomList[j]+1), std::ios::beg);

			// E1MinsDataData_________________________________________________
			fHandle.read(reinterpret_cast<char*>(&realBuff), sizeof(realBuff));
			fHandle.read(reinterpret_cast<char*>(&imagBuff), sizeof(imagBuff));
			Vect3DBuff.x = std::complex<float>(realBuff, imagBuff);

			fHandle.read(reinterpret_cast<char*>(&realBuff), sizeof(realBuff));
			fHandle.read(reinterpret_cast<char*>(&imagBuff), sizeof(imagBuff));
			Vect3DBuff.y = std::complex<float>(realBuff, imagBuff);
			
			fHandle.read(reinterpret_cast<char*>(&realBuff), sizeof(realBuff));
			fHandle.read(reinterpret_cast<char*>(&imagBuff), sizeof(imagBuff));
			Vect3DBuff.z = std::complex<float>(realBuff, imagBuff);

			tempE1MinsData.push_back(Vect3DBuff);
		}

		e1MinsData.push_back(tempE1MinsData);
		fHandle.close();
	} /* for (unsigned int i=0; i<fName.size(); i++) */

	printf("Finished!\n");

	return true;
}

// ------------------------------------------------------------------------------
