/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: TissIn.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include "TissIn.h"
#include<cassert>
#include<fstream>
#include<iostream>
#include<sstream>

/* ********************

1) A TissueType file is written as:

id, t1, t2, rho, sigmaChem, sigmaCon, rhoMass name
...

******************** */

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().tiss" accesses a public data value instead of 
// using a method to return the value.
TissIn::TissIn(CmdInterp & cmdInterp)
{
	fName = cmdInterp.getCmdValues().tiss;
	tissFlag = readTissData();
}

// ------------------------------------------------------------------------------

bool TissIn::readTissData()
{
	printf("Reading Tissue Type data...");

	std::fstream fHandle;
	std::string lineBuff, strId, strT1, strT2, strRho, strSigmaChem, strSigmaCon, strRhoMass;
	int tempId;

	TissType tempTissType;
	
	fHandle.open(fName.c_str(), std::ios::in);
	
	if (fHandle.fail())
	{
		std::cout << "\n\"" << fName << "\" failed to open!\n";
		printf("Execution terminated, press enter to exit.\n");
		std::cin.get();
		return false;
	}

	getline(fHandle, lineBuff); // skip line of labels in the .txt file
	// :TODO: check to make sure the first line does not contain values

	while (!fHandle.eof())
	{
		getline(fHandle, lineBuff);
		std::istringstream inputString(lineBuff);
		inputString >> strId >> strT1 >> strT2 >> strRho >> strSigmaChem >> strSigmaCon >> strRhoMass;

		// Extract the desired values, for noise calculation, only ID and SigmaCon are necessary
		// Id
		tempId = (int)strtod(strId.c_str(), NULL);

		// SigmaCon
		tempTissType.sigmaCon = (float)strtod(strSigmaCon.c_str(), NULL);

		// Store to map
		tissMap[tempId] = tempTissType;
	}

	fHandle.close();
	printf("Finished!\n");

	return true;
}

// ------------------------------------------------------------------------------
