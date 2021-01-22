/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: Execution.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"Execution.h"

#include<cassert>
#include<fstream>
#include<iostream>
#include<sstream>

#include<direct.h>
#include<stdlib.h>
#include<stdio.h>

#include<complex>

// ------------------------------------------------------------------------------

Execution::Execution(CmdInterp & cmdInterp)
{
	// :TODO: IMPORTANT: verify all failure cases are caught and reported well. Consider stopping as soon as initFlag goes bad.
	initFlag = 1;

	GeomIn geomIn(cmdInterp);
	initFlag = initFlag && geomIn.geomFlag;

	TissIn tissIn(cmdInterp);
	initFlag = initFlag && tissIn.tissFlag;

	SeqnIn seqnIn(cmdInterp);
	initFlag = initFlag && seqnIn.seqnFlag;

	E1MinsIn e1MinsIn(cmdInterp, geomIn.getGeomHeader().geomList);
	initFlag = initFlag && e1MinsIn.e1MinsFlag;

	initFlag = initFlag && initPhantomInfo(cmdInterp, seqnIn, geomIn);
	initFlag = initFlag && initPhantomSeqn(seqnIn);
	initFlag = initFlag && initPhantomGeom(geomIn);
	initFlag = initFlag && initPhantomTiss(tissIn);

	noiseInfo.resistanceRatio = 0;

	initFlag = initFlag && initPhantomE1Mins(e1MinsIn);
	initFlag = initFlag && initPhantomKNoise();

	// :TODO: this may be a good place to report missing input data that has been set to default and ask user if default input is ok INVESTIGATE IF THIS IS GOOD FOR NOISE
	/************************************************************************************************
	//Example modification:

	if (!initPhantomE1Mins(e1MinsIn)
	{
		std::cout << "WARNING: E1- File not provided. Defaulting to deltaB0 of 0 for all voxels.\n"
		initFlag = false;
	}
	// repeat above for each init function

	if (!initFlag)
	{
		char choice;
		do
		{
			std::cout << "\nPlease review the warnings above. Would you like to continue with simulation? (Y/N)\n";
			std::cin >> choice;
			switch (choice)
			{
			case 'y': case: 'Y':
				initFlag = true; break;
			case 'n': case 'N': break;
			default:
				std::cout << "Invalid choice\n";
				break;
			}
		} while (!(choice == 'y' || choice == 'n' || choice == 'Y' || choice == 'N'))
	}
	************************************************************************************************/

#ifdef DEBUG
	cout<<initFlag<<endl;
#endif
}

Execution::~Execution()
{
	for (unsigned int i = 0; i < noiseInfo.aMat.size(); i++)
	{
		noiseInfo.aMat[i].clear();
	}
	noiseInfo.aMat.clear();
	for (unsigned int i = 0; i < noiseInfo.rMat.size(); i++)
	{
		noiseInfo.rMat[i].clear();
	}
	noiseInfo.rMat.clear();

	sequence.time.clear();
	sequence.acq.clear();
	phantom.clear();

	for (unsigned int i = 0; i < kNoise.size(); i++)
	{
		kNoise[i].clear();
	}
	kNoise.clear();
}

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().b0" accesses a public data value instead of 
// using a method to return the value.
bool Execution::initPhantomInfo(CmdInterp & cmdInterp, SeqnIn & seqnIn, GeomIn & geomIn)
{
	info.numRx = seqnIn.getSeqnHeader().numRx;

	info.totNumVox = geomIn.getGeomHeader().totNumVox;

	info.wid = geomIn.getGeomHeader().wid;

	info.nex = cmdInterp.getCmdValues().NEX;

	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomSeqn(const SeqnIn & seqnIn)
{
	sequence.time = seqnIn.getTime();
	sequence.acq = seqnIn.getAcq();
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomGeom(const GeomIn & geomIn)
{
	phantom = geomIn.getGeomData();
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomTiss(const TissIn & tissIn)
{
	for (unsigned int i=0; i<phantom.size(); i++)
	{
		phantom[i].setTiss(tissIn.getTissMap());
	}
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomE1Mins(const E1MinsIn & e1MinsIn)
{
	std::vector<Vect3D<std::complex<float> > > temp;
	Vect3D<std::complex<float> > defaultE1Mins; // :TODO: (not by jmm) add const here.
	defaultE1Mins.x = std::complex<float>(1,0);
	defaultE1Mins.y = std::complex<float>(1,0);
	defaultE1Mins.z = std::complex<float>(1,0);

	std::vector<std::vector< Vect3D<std::complex<float> > > > tempE1MinsData;
	tempE1MinsData = e1MinsIn.getE1MinsData();

	for (unsigned int i=0; i<tempE1MinsData.size(); i++)
	{
		if (phantom.size() != tempE1MinsData[i].size())
		{
			std::cout << "Fatal Error: E1- Field data from " << e1MinsIn.fName[i] << " does not match the geometry data!";
			std::cout << "Check the header and data length in" << e1MinsIn.fName[i] << std::endl;
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
	}

	if ((unsigned short int)tempE1MinsData.size() > info.numRx)
	{
		printf("Fatal Error: More E1- files from commandline input than needed in sequence file!\n");
		printf("Execution terminated, press enter to exit.\n");
		std::cin.get();
		return false;
	}

	for (unsigned int j=0; j<phantom.size(); j++)
	{
		temp.clear();
		for (unsigned int i=0; i<tempE1MinsData.size(); i++)
		{
			temp.push_back(tempE1MinsData[i][j]);
		}

		for (unsigned int n=0; n<(info.numRx - tempE1MinsData.size()); n++) // :TODO: verify this is correct. Use default value (1,0) when
						// e1-minus is not specified. What if someone wants (1,0) for first 3 coils, then file? LEAVE AS IS - NOTE IN DOCUMENT
		{
			temp.push_back(defaultE1Mins);
		}

		phantom[j].setE1Mins(temp);
	}
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomKNoise()
{
	// :TODO: this function seems very complex, suggest code review w/ all present (See also function above) - DISCUSSED
	// :TODO: add detailed comments.

	noiseInfo.rMat.resize(info.numRx);
	noiseInfo.aMat.resize(info.numRx);
	for(int i = 0; i < info.numRx; i++)
	{
		noiseInfo.rMat[i].resize(info.numRx);
		noiseInfo.aMat[i].resize(info.numRx);
	}

	for (int i = 0; i < info.numRx; i++)
	{
		for (int j = 0; j < info.numRx; j++)
		{
			noiseInfo.rMat[i][j] = 0;
			for (unsigned int k=0; k<phantom.size(); k++)
			{
				Vect3D<std::complex<float> > temp;
				temp.x = std::conj(phantom[k].eInfo.e1Mins[j].x);
				temp.y = std::conj(phantom[k].eInfo.e1Mins[j].y);
				temp.z = std::conj(phantom[k].eInfo.e1Mins[j].z);
				
				// Here, we use the classic definition of noise resistane matrix: sigma * Ei * conj(Ej).
				// This definition corresponds to the 4 in : noiseConstant = sqrt( (double)4.0 * K_BOLZ * (double)298.0 * (double)(info.wid.x * info.wid.y * info.wid.z));
				noiseInfo.rMat[i][j] += (std::complex<double>) (phantom[k].tissInfo.sigmaCon * (phantom[k].eInfo.e1Mins[i] * temp));
			}
		}
	}

	// The coil resistance is calculated by ratio of the diagnal terms of the rMat.
	// Because the diagnal terms are always real, the real() function here is for programming conveience.
	noiseInfo.coilResist.resize(info.numRx);
	for (int i = 0; i < info.numRx; i++)
	{
		noiseInfo.coilResist[i] = noiseInfo.resistanceRatio * real(noiseInfo.rMat[i][i]);
	}

	// The aMat is generated by decomposing rMat using Cholesky Decomposition.
	std::complex<double> temp;
	for (int j = 0; j < info.numRx; j++)
	{
		for (int i = 0; i < info.numRx; i++)
		{
			temp = std::complex<double> (0,0);

			if (i == j)
			{
				if (j != 0)
				{
					for (int k = 0; k <= j-1; k++)
					{
						temp += noiseInfo.aMat[j][k] * conj( noiseInfo.aMat[j][k] );
					}
				}
				noiseInfo.aMat[j][j] = sqrt( noiseInfo.rMat[j][j] - temp ) ;
				//noiseInfo.aMat[j][j] = sqrt( (double)(info.wid.x * info.wid.y * info.wid.z) * std::complex<double> ((4 * K_BOLZ * 310), 0) )
				//	* sqrt( noiseInfo.rMat[j][j] - temp ) ;
			}
			else if (i > j)
			{
				if (j != 0)
				{
					for (int k = 0; k <= j-1; k++)
					{
						temp += noiseInfo.aMat[i][k] * conj( noiseInfo.aMat[j][k] );
					}
				}
				noiseInfo.aMat[i][j] = ( ( noiseInfo.rMat[i][j] - temp ) / noiseInfo.aMat[j][j] );
				//noiseInfo.aMat[i][j] = sqrt( (double)(info.wid.x * info.wid.y * info.wid.z) * std::complex<double> ((4 * K_BOLZ * 310), 0) )
				//	* ( ( noiseInfo.rMat[i][j] - temp ) / noiseInfo.aMat[j][j] ) ;
			}
		}
	}
	return true;
}

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().kSpace" accesses a public data value instead of 
// using a method to return the value.
bool Execution::expPhantomKNoise(CmdInterp & cmdInterp)
{
	assert(!kNoise.empty());

	size_t ptr;
	std::vector<std::vector<std::string> > expFName;
	std::string tempFName;
	std::stringstream tempSS;

	expFName.resize(info.nex);
	for (unsigned int k=0; k<info.nex; k++)
	{
		expFName[k].clear();
		for (unsigned int n=1; n<=info.numRx; n++)
		{
			tempFName.clear();
			tempFName = cmdInterp.getCmdValues().kNoise;
			tempSS << n; // place coil number in stringstream

			ptr = tempFName.rfind(".");
			if (ptr != std::string::npos)	// insert or append the coil number
			{
				tempFName.insert(ptr, tempSS.str());
			}
			else
			{
				tempSS << ".bin";	// if no extension exists, add .bin
				tempFName.append(tempSS.str());
			}
			tempSS.str(""); // clear stringstream

			std::string str1 ("\\noiseSet"); // "\\" stands for "\"
			tempSS << (k+1); // place nex number in stringstream
			ptr = tempFName.rfind("\\");
			str1 = str1.append(tempSS.str()); str1 = str1.append("\\");
			if (ptr != std::string::npos)	// insert the nex number and folder name
			{
				tempFName.replace(ptr,1,str1);
			}
			tempSS.str(""); // clear stringstream

			expFName[k].push_back(tempFName);
		}

		assert(expFName[k].size() == kNoise[k].size());

		std::fstream fHandle;
		
		// Create new folder
		std::string folderFName;
		folderFName = tempFName;
		size_t ptr1 = folderFName.rfind("\\");
		size_t ptr2 = folderFName.size();
		folderFName.erase (ptr1,ptr2);
		_mkdir(folderFName.c_str());

		for (unsigned int i=0; i<expFName[k].size(); i++)
		{

			fHandle.open(expFName[k][i].c_str(), std::ios::out | std::ios::binary);

			if (fHandle.fail())
			{
				std::cout << "\n\"" << expFName[k][i] << "\" failed to open!\n";
				printf("Execution terminated, press enter to exit.\n");
				std::cin.get();
				return false;
			}

			// kNoiseData______________________________________________________________
			for (unsigned int m=0; m<kNoise[k][i].size(); m++)
			{
				fHandle.write(reinterpret_cast<char*>(&kNoise[k][i][m]), sizeof(kNoise[k][i][m]));	
			}

			fHandle.close();
		}
	}
	return true;
}

// ------------------------------------------------------------------------------
