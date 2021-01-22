/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: SeqnIn.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include "SeqnIn.h"
#include<cassert>
#include<fstream>
#include<iostream>

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().seqn" accesses a public data value instead of 
// using a method to return the value.
SeqnIn::SeqnIn(CmdInterp & cmdInterp)
{
	fName = cmdInterp.getCmdValues().seqn;
	seqnFlag = readSeqnHeader() && readSeqnData();
}

SeqnIn::~SeqnIn()
{
	time.clear();
	acq.clear();
}

// ------------------------------------------------------------------------------

bool SeqnIn::readSeqnHeader()
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
	
	// SeqnHeader_________________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	seqnHeader.totNumData = (unsigned int)buff;

	fHandle.seekg (4*1, std::ios::cur); // skip number of transmit header info

	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	seqnHeader.numRx = (unsigned short int) buff;

	fHandle.close();

	return true;
}

// ------------------------------------------------------------------------------

bool SeqnIn::readSeqnData()
{
	printf("Reading Sequence data...");

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
	
	// Skip SeqnHeader
	fHandle.seekg (4*3, std::ios::cur);

	// SeqnData___________________________________________________________
	int numLines, numRepts, i, j;
	unsigned int counter;

	// EOF can be useless when reading-in files with logic already.
	
	// Time_______________________________________________________
	std::vector<float> tempTime;
	counter = 0;
	while (counter < seqnHeader.totNumData)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numLines = (int)buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numRepts = (int)buff;
		
		tempTime.clear();
		j = 0; i = 1;
		while (i <= numLines) // read one block of time information
		{
			fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
			tempTime.push_back((float)buff/(float)1000.0); // scale time from file into (:TODO:)secs
			i++;
		}

		while (j < numRepts)
		{
			for (int k=0; k<numLines; k++)
			{
				time.push_back(tempTime[k]); // extend the block 'numRepts' times so that 'time' contains a serial list of time values
			}
			j++;
		}
		counter+=(unsigned int)(numLines * numRepts);
	}

	// Checkpoint
	assert(counter == seqnHeader.totNumData);

	// Acq________________________________________________________
	std::vector<short int> tempAcq;
	counter = 0;
	while (counter < seqnHeader.totNumData)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numLines = (int)buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numRepts = (int)buff;
		
		j = 0; i = 1;
		tempAcq.clear();
		while (i <= numLines) // read one block of acq information
		{
			fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
			tempAcq.push_back((unsigned short int)buff);
			i++;
		};

		while (j < numRepts)
		{
			for (int k=0; k<numLines; k++)
			{
				acq.push_back(tempAcq[k]); // extend the block 'numRepts' times so that 'time' contains a serial list of acq values
			}
			j++;
		}
		counter+=(unsigned int)(numLines * numRepts);
	}

	// Checkpoint
	assert(counter == seqnHeader.totNumData);

	fHandle.close();
	printf("Finished!\n");

	return true;
} /* bool readSeqnData(std::string fName, Sequence &sequence, SeqnHeader seqnHeader) */

// ------------------------------------------------------------------------------
