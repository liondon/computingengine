/*=========================================================================

  Program:   NutateSAR
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

	B1PlusIn b1PlusIn(cmdInterp, geomIn.getGeomHeader().geomList);
	initFlag = initFlag && b1PlusIn.b1PlusFlag;
	
	B1MinsIn b1MinsIn(cmdInterp, geomIn.getGeomHeader().geomList);
	initFlag = initFlag && b1MinsIn.b1MinsFlag;

	E1PlusIn e1PlusIn(cmdInterp, geomIn.getGeomHeader().geomList);
	initFlag = initFlag && e1PlusIn.e1PlusFlag;

	initFlag = initFlag && initPhantomInfo(cmdInterp, seqnIn);
	initFlag = initFlag && initPhantomSeqn(seqnIn);
	initFlag = initFlag && initPhantomGeom(geomIn);
	initFlag = initFlag && initPhantomTiss(tissIn);

	initFlag = initFlag && initPhantomB1Mins(b1MinsIn);
	initFlag = initFlag && initPhantomB1Plus(b1PlusIn);
	initFlag = initFlag && initPhantomAveB1Mins();
	initFlag = initFlag && initPhantomAveB1Plus(info.aveB1Mins, info.sumB1Mins);

	initFlag = initFlag && initPhantomE1Plus(e1PlusIn);
	initFlag = initFlag && initPhantomSAR0();

	// :TODO: this may be a good place to report missing input data that has been set to default and ask user if default input is ok
	/************************************************************************************************
	//Example modification:

	if (!initPhantomDelB0(delB0In)
	{
		std::cout << "WARNING: Delta B0 File not provided. Defaulting to deltaB0 of 0 for all voxels.\n"
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
	info.aveB1Plus.clear();
	sequence.time.clear();
	for (unsigned int i = 0; i < sequence.rf.size(); i++)
	{
		sequence.rf[i].clear();
	}
	sequence.rf.clear();
	phantom.clear();
	sarMap.clear();
}

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().b0" accesses a public data value instead of 
// using a method to return the value.
bool Execution::initPhantomInfo(CmdInterp & cmdInterp, SeqnIn & seqnIn)
{
	// :TODO: this would be a good place to verify that different file headers match each other
	info.numTx = seqnIn.getSeqnHeader().numTx;
	info.numRx = seqnIn.getSeqnHeader().numRx;
	info.thread = cmdInterp.getCmdValues().thread;
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomSeqn(const SeqnIn & seqnIn)
{
	sequence.time = seqnIn.getTime();
	sequence.rf = seqnIn.getRF();

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

bool Execution::initPhantomSAR0()
{
	for (unsigned int i=0; i<phantom.size(); i++)
	{
		phantom[i].initSAR0(info.aveB1Plus);
	}
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomAveB1Mins()
{
	double temp=0;
	unsigned int k=0;
	double tempB1Mins;
	info.sumB1Mins.resize(phantom.size());
	
	for (unsigned int i=0; i<phantom.size(); i++)
	{
		tempB1Mins = 0;
		for (unsigned short int j=0; j<info.numRx; j++)
		{
			tempB1Mins += (double) abs(phantom[i].bInfo.b1Mins[j]);			
		}
		info.sumB1Mins[k] = (float) (tempB1Mins / (double)info.numRx);
		temp += tempB1Mins / (double)info.numRx;
		k++;
	}
	info.aveB1Mins = (float) (temp / ((double)k));
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomB1Mins(const B1MinsIn & b1MinsIn)
{
	std::vector<std::complex<float> > temp;
	const std::complex<float> defaultB1Mn(1,0);

	std::vector<std::vector<std::complex<float> > > tempB1MinsData;
	tempB1MinsData = b1MinsIn.getB1MinsData();

	for (unsigned int i=0; i<tempB1MinsData.size(); i++)
	{
		if (phantom.size() != tempB1MinsData[i].size())
		{
			std::cout << "Fatal Error: B1- data from " << b1MinsIn.fName[i] << " does not match the geometry data!\n";
			std::cout << "Check the header and data length in" << b1MinsIn.fName[i] << std::endl;
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
	}

	for (unsigned int j=0; j<phantom.size(); j++)
	{
		temp.clear();

		if ((unsigned short int)tempB1MinsData.size() > info.numRx)
		{
			printf("Fatal Error: More B1- files from commandline input than needed in sequence file!\n");
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
		else
		{
			for (unsigned int i=0; i<tempB1MinsData.size(); i++)
			{
				temp.push_back(tempB1MinsData[i][j]);
			}

			for (unsigned short int n=0; n<(info.numRx - tempB1MinsData.size()); n++)
			{
				temp.push_back(defaultB1Mn);
			}
		}
		phantom[j].setB1Mins(temp);
	}
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomB1Plus(const B1PlusIn & b1PlusIn)
{
	std::vector<std::complex<float> > temp;
	const std::complex<float> defaultB1Pl(B1Pl,0);
	
	std::vector<std::vector<std::complex<float> > > tempB1PlusData;
	tempB1PlusData = b1PlusIn.getB1PlusData();

	for (unsigned int i=0; i<tempB1PlusData.size(); i++)
	{
		if (phantom.size() != tempB1PlusData[i].size())
		{
			std::cout << "Fatal Error: B1+ data from " << b1PlusIn.fName[i] << " does not match the geometry data!";
			std::cout << "Check the header and data length in" << b1PlusIn.fName[i] << std::endl;
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
	}

	if ((unsigned short int)tempB1PlusData.size() > info.numTx)
	{
		printf("Fatal Error: More B1+ files from commandline input than needed in sequence file!\n");
		printf("Execution terminated, press enter to exit.\n");
		std::cin.get();
		return false;
	}

	for (unsigned int j=0; j<phantom.size(); j++)
	{
		temp.clear();

		for (unsigned int i=0; i<tempB1PlusData.size(); i++)
		{
			temp.push_back(tempB1PlusData[i][j]);
		}

		for (unsigned int n=0; n<(info.numTx - tempB1PlusData.size()); n++)// :TODO: verify this is correct. Use default value (1,0) when
																		// B1 is not specified. What if someone wants (1,0) for first 3 coils, then file?
		{
			temp.push_back(defaultB1Pl);
		}

		phantom[j].setB1Plus(temp);
	}

	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomAveB1Plus(const float & aveB1Mins, const std::vector<float> & sumB1Mins)
{
	std::complex<double> temp;
	unsigned int k;
	std::complex<float> tempB1Plus;
	info.aveB1Plus.resize(info.numTx);

	float tempDiv;

	for (unsigned short int j=0; j<info.numTx; j++)
	{
		temp = 0;
		k = 0;
		tempDiv = 0;
		for (unsigned int i=0; i<phantom.size(); i++)
		{
			tempB1Plus = phantom[i].bInfo.b1Plus[j];
			tempDiv = sumB1Mins[i]/aveB1Mins;
			temp += (std::complex<double>) (tempB1Plus * tempDiv);
			k++;
		}
		info.aveB1Plus[j] = (std::complex<float>) (temp / ((double)k));
	}
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomE1Plus(const E1PlusIn & e1PlusIn)
{
	std::vector<Vect3D<std::complex<float> > > temp;
	Vect3D<std::complex<float> > defaultE1Plus; // add const here.
	defaultE1Plus.x = std::complex<float>(1,0);
	defaultE1Plus.y = std::complex<float>(1,0);
	defaultE1Plus.z = std::complex<float>(1,0);

	std::vector<std::vector< Vect3D<std::complex<float> > > > tempE1PlusData;
	tempE1PlusData = e1PlusIn.getE1PlusData();

	for (unsigned int i=0; i<tempE1PlusData.size(); i++)
	{
		if (phantom.size() != tempE1PlusData[i].size())
		{
			std::cout << "Fatal Error: E1+ Field data from " << e1PlusIn.fName[i] << " does not match the geometry data!";
			std::cout << "Check the header and data length in" << e1PlusIn.fName[i] << std::endl;
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
	}

	for (unsigned int j=0; j<phantom.size(); j++)
	{
		temp.clear();

		if ((unsigned short int)tempE1PlusData.size() > info.numTx)
		{
			printf("Fatal Error: More E1+ files from commandline input than needed in sequence file!\n");
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
		else
		{
			for (unsigned int i=0; i<tempE1PlusData.size(); i++)
			{
				temp.push_back(tempE1PlusData[i][j]);
			}

			for (unsigned short int n=0; n<(info.numTx - tempE1PlusData.size()); n++)// :TODO: verify this is correct. Use default value (1,0) when
																			// e1-plus is not specified. What if someone wants (1,0) for first 3 coils, then file?
			{
				temp.push_back(defaultE1Plus);
			}
		}

		phantom[j].setE1Plus(temp);
	}
	return true;
}


// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().sarMap" accesses a public data value instead of 
// using a method to return the value.
bool Execution::expPhantomSARMap(CmdInterp & cmdInterp, double totTime)
{
	std::fstream fHandle;
	std::string expFName = cmdInterp.getCmdValues().sarMap;

	fHandle.open(expFName.c_str(), std::ios::out | std::ios::binary);
	if (fHandle.fail())
	{
		std::cout << "\n\"" << expFName << "\" failed to open!\n";
		printf("Execution terminated, press enter to exit.\n");
		std::cin.get();
		return false;
	}

	float tempFloat;
	// SARData______________________________________________________________
	assert(sarMap.size() == phantom.size());
	for (unsigned int i=0; i<phantom.size(); i++)
	{
		fHandle.write(reinterpret_cast<char*>(&phantom[i].geomInfo.pos), sizeof(phantom[i].geomInfo.pos));
		tempFloat = (float)phantom[i].geomInfo.id;
		fHandle.write(reinterpret_cast<char*>(&tempFloat), sizeof(tempFloat));

		//tempFloat = sarMap[i] / (float)totTime; // Wrong, because finalSarMapData already divided by totTime
		tempFloat = sarMap[i];
		fHandle.write(reinterpret_cast<char*>(&tempFloat), sizeof(tempFloat));
	}
	fHandle.close();
	return true;
}

// ------------------------------------------------------------------------------
