/*=========================================================================

  Program:   NutateSAR
  Module:    $RCSfile: E1PlusIn.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"E1PlusIn.h"
#include<cassert>
#include<fstream>
#include<iostream>
#include<complex>

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().e1Plus" accesses a public data value instead of 
// using a method to return the value.
E1PlusIn::E1PlusIn(CmdInterp & cmdInterp, std::vector<unsigned int> & geomList)
{
	fName.clear();
	e1PlusHeader.totNumVox.clear();
	e1PlusData.clear();

	e1PlusFlag = 1;

	if (cmdInterp.getCmdFlags().e1Plus == true) // if E1 file was given
	{
		fName = cmdInterp.getCmdValues().e1Plus; // :TODO: (not by jmm) The cmdline interpretor has not taken care of numTx/Rx in sequence file.
		e1PlusFlag = e1PlusFlag && readE1PlusHeader();
		e1PlusFlag = e1PlusFlag && readE1PlusData(geomList);
	}
	else
	{
		fName.assign(1,NULLSTR); // :TODO: what happens in this case? is E1+ necessary for execution?
	}
}

E1PlusIn::~E1PlusIn()
{
	e1PlusHeader.totNumVox.clear();
	for (unsigned int i = 0; i < e1PlusData.size(); i++)
	{
		e1PlusData[i].clear();
	}
	e1PlusData.clear();
	fName.clear();
}

// ------------------------------------------------------------------------------

bool E1PlusIn::readE1PlusHeader()
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
		e1PlusHeader.totNumVox.push_back((unsigned int) buff);

		fHandle.close();
	}
	return true;
}

// ------------------------------------------------------------------------------

bool E1PlusIn::readE1PlusData(std::vector<unsigned int> & geomList)
{
	printf("Reading E1+ data...");

	std::fstream fHandle;

	std::complex<float> temp; float realBuff, imagBuff;
	std::vector<Vect3D< std::complex<float> > > tempE1PlusData;

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

		unsigned int j = 0;

		tempE1PlusData.clear();
		Vect3D<std::complex<float> > Vect3DBuff;
		while(j < geomList.size())
		{
			fHandle.seekg (4*(6*geomList[j]+1), std::ios::beg); // move to appropriate location in file: 4 is float size, 6 because there are
												// 6 data points for each entry, and + 1 to skip the file header

			// E1PlusData_________________________________________________
			fHandle.read(reinterpret_cast<char*>(&realBuff), sizeof(realBuff));
			fHandle.read(reinterpret_cast<char*>(&imagBuff), sizeof(imagBuff));
			Vect3DBuff.x = std::complex<float>(realBuff, imagBuff);

			fHandle.read(reinterpret_cast<char*>(&realBuff), sizeof(realBuff));
			fHandle.read(reinterpret_cast<char*>(&imagBuff), sizeof(imagBuff));
			Vect3DBuff.y = std::complex<float>(realBuff, imagBuff);
			
			fHandle.read(reinterpret_cast<char*>(&realBuff), sizeof(realBuff));
			fHandle.read(reinterpret_cast<char*>(&imagBuff), sizeof(imagBuff));
			Vect3DBuff.z = std::complex<float>(realBuff, imagBuff);

			tempE1PlusData.push_back(Vect3DBuff);
			j++;
		}

		e1PlusData.push_back(tempE1PlusData);
		fHandle.close();
	}
	
	printf("Finished!\n");

	return true;
}

// ------------------------------------------------------------------------------
