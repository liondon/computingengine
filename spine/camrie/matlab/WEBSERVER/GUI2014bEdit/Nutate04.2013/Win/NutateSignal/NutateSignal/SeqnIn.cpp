/*=========================================================================

  Program:   NutateSignal
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
	for (unsigned int i = 0; i < rf.size(); i++)
	{
		rf[i].clear();
	}
	rf.clear();
	for (unsigned int i = 0; i < delFreq.size(); i++)
	{
		delFreq[i].clear();
	}
	delFreq.clear();

	gX.clear();
	gY.clear();
	gZ.clear();
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

	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	seqnHeader.numTx = (unsigned short int) buff;

	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	seqnHeader.numRx = (unsigned short int) buff;

	fHandle.close();

	return true;
}

// ------------------------------------------------------------------------------

bool SeqnIn::readSeqnData()
{
	printf("Reading Sequence data... ");

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
	int numLines, numRepts, i;
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
		for (i = 1; i <= numLines; i++) // read one block of time information
		{
			fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
			tempTime.push_back((float)buff/(float)1000.0); // scale time from file (milliseconds) into seconds
		}

		for (i = 0; i < numRepts; i++)
		{
			for (int k=0; k<numLines; k++)
			{
				time.push_back(tempTime[k]); // extend the block 'numRepts' times so that 'time' contains a serial list of time values
			}
		}
		counter+=(unsigned int)(numLines * numRepts);
	} /* while (counter < seqnHeader.totNumData) */

	// Checkpoint
	assert(counter == seqnHeader.totNumData);
	//_____________________________________________________________(end) Time

	// Acq________________________________________________________
	std::vector<short int> tempAcq;
	counter = 0;
	while (counter < seqnHeader.totNumData)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numLines = (int)buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numRepts = (int)buff;
		
		tempAcq.clear();
		for (i = 1; i <= numLines; i++) // read one block of acq information
		{
			fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
			tempAcq.push_back((unsigned short int)buff);
		}

		for (i = 0; i < numRepts; i++)
		{
			for (int k=0; k<numLines; k++)
			{
				acq.push_back(tempAcq[k]); // extend the block 'numRepts' times so that 'acq' contains a serial list of acq values
			}
		}
		counter+=(unsigned int)(numLines * numRepts);
	}/* while (counter < seqnHeader.totNumData) */

	// Checkpoint
	assert(counter == seqnHeader.totNumData);
	//_____________________________________________________________(end) Acq

	// RF________________________________________________________
	std::complex<float> temp; float realBuff, imagBuff;
	std::vector<std::complex<float> > tempRF;
	std::vector<std::complex<float> > tempTempRF;

	std::vector<float> tempDelFreq;
	std::vector<float> tempTempDelFreq;

	for (int n=1; n<=seqnHeader.numTx; n++)
	{
		counter = 0;
		tempRF.clear();
		tempDelFreq.clear();
		while (counter < seqnHeader.totNumData)
		{
			fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
			numLines = (int)buff;
			fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
			numRepts = (int)buff;
			
			tempTempRF.clear();
			tempTempDelFreq.clear();
			for (i = 1; i <= numLines; i++) // read one block of RF information
			{
				fHandle.read(reinterpret_cast<char*>(&realBuff), sizeof(realBuff)); 
				fHandle.read(reinterpret_cast<char*>(&imagBuff), sizeof(imagBuff));
				temp = std::complex<float>(realBuff, imagBuff);
				tempTempRF.push_back(temp);
				
				fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));

				// In some cases that RF frequency offset may be accidentally turn on while having no transmission.
				if (realBuff == 0 && imagBuff == 0)
				{
					buff = 0;
				}

				tempTempDelFreq.push_back(buff);
			}
			
			for (i = 0; i < numRepts; i++)
			{
				for (int k=0; k<numLines; k++)
				{
					// extend the blocks 'numLines' times so that 'tempRF' and 'tempDelFreq' contain serial lists of RF and DelFreqencey values, respectively
					tempRF.push_back(tempTempRF[k]);
					tempDelFreq.push_back(tempTempDelFreq[k]);
				}
			}
			counter+=(unsigned int)(numLines * numRepts);
		} /* while (counter < seqnHeader.totNumData) */
		rf.push_back(tempRF);
		delFreq.push_back(tempDelFreq);
		
		// Checkpoint
		assert(counter == seqnHeader.totNumData);
	} /* for (int n=1; n<=seqnHeader.numTx; n++) */
	//___________________________________________________________(end) RF

	// Gx_________________________________________________________
	std::vector<float> tempGx;
	counter = 0;
	while (counter < seqnHeader.totNumData)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numLines = (int)buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numRepts = (int)buff;
		
		tempGx.clear();
		for (i = 1; i <= numLines; i++) // read one block of Gx information
		{
			fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
			tempGx.push_back((float)buff/(float)1000.0); // scale gradient info from file (mT) into Tesla
		}

		for (i = 0; i < numRepts; i++)
		{
			for (int k=0; k<numLines; k++)
			{
				gX.push_back(tempGx[k]); // extend the block 'numLines' times so that 'gX' contains a serial list of Gx values
			}
		}
		counter+=(unsigned int)(numLines * numRepts);
	} /* while (counter < seqnHeader.totNumData) */

	// Checkpoint
	assert(counter == seqnHeader.totNumData);
	//__________________________________________________________(end) Gx

	// Gy_________________________________________________________
	std::vector<float> tempGy;
	counter = 0;
	while (counter < seqnHeader.totNumData)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numLines = (int)buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numRepts = (int)buff;
		
		tempGy.clear();
		for (i = 1; i <= numLines; i++) // read one block of Gy information
		{
			fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
			tempGy.push_back((float)buff/(float)1000.0); // scale gradient info from file (mT) into Tesla
		}

		for (i = 0; i < numRepts; i++)
		{
			for (int k=0; k<numLines; k++)
			{
				gY.push_back(tempGy[k]); // extend the block 'numLines' times so that 'gY' contains a serial list of Gy values
			}
		}
		counter+=(unsigned int)(numLines * numRepts);
	} /* while (counter < seqnHeader.totNumData) */

	// Checkpoint
	assert(counter == seqnHeader.totNumData);
	//__________________________________________________________(end) Gy

	// Gz_________________________________________________________
	std::vector<float> tempGz;
	counter = 0;
	while (counter < seqnHeader.totNumData)
	{
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numLines = (int)buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		numRepts = (int)buff;
		
		tempGz.clear();
		for (i = 1; i <= numLines; i++) // read one block of Gz informtion
		{
			fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
			tempGz.push_back((float)buff/(float)1000.0); // scale gradient info from file (mT) into Tesla
		}

		for (i = 0; i < numRepts; i++)
		{
			for (int k=0; k<numLines; k++)
			{
				gZ.push_back(tempGz[k]); // extend the block 'numLines' times so that 'gZ' contains a serial list of Gz values
			}
		}
		counter+=(unsigned int)(numLines * numRepts);
	} /* while (counter < seqnHeader.totNumData) */

	// Checkpoint
	assert(counter == seqnHeader.totNumData);
	//__________________________________________________________(end) Gz

	fHandle.close();
	printf("Finished!\n");

	return true;
} /* bool readSeqnData(std::string fName, Sequence &sequence, SeqnHeader seqnHeader) */

// ------------------------------------------------------------------------------
