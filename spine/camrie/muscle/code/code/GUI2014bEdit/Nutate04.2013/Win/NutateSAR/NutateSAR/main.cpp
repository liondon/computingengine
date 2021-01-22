/*=========================================================================

  Program:   NutateSAR
  Module:    $RCSfile: main.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 21:18:18 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#define USE_OpenMP // :TODO: uncomment - jmm testing purposes only

#ifdef USE_OpenMP
#include "omp.h"
#endif //USE_OpenMP

#include "Execution.h"

#include<ctime>
#include<stdio.h>

int main(int argc, char *argv[])
{
	printf("\n--------- Simulation Started. ---------\n");

	CmdInterp cmdInterp;
	if (!(cmdInterp.interpCmd(argc, argv)))
	{
		// Sufficient error message given by error causing failure
		return (EXIT_FAILURE);
	}

	Execution run(cmdInterp);

	if (!(run.initFlag))
	{
		// Sufficient error message given by error causing failure
		return (EXIT_FAILURE);
	}

	// The variables below are used as buffers. Their purpose is to reduce the amount of function calls that take place in the nested loops below.
	Execution::Info info = run.getInfo();
	std::vector<Voxel> phantom = run.getPhantom();
	std::vector<float> timeSteps = run.getSequence().time;
	std::vector<std::vector<std::complex<float> > > rf = run.getSequence().rf;

/*******************************************************************************/
	int threadP=1, threadID=0;
#ifdef USE_OpenMP
	threadP=(int)info.thread;
	std::vector<double> * array_addresses = new std::vector<double> [threadP];
	omp_set_num_threads(threadP);
#endif //USE_OpenMP
/*******************************************************************************/
	std::vector<float> finalSarMapData;

	// for % completion reporting
	clock_t startTime,endTime;
	startTime = clock();
	float processIndicator;

	// sarMapData holds the output for this version of the engine. The comment below indicates that there is one entry in sarMapData per voxel
	std::vector<double> sarMapData; // [Voxel]

	std::vector<std::complex<float> > tempRF;
	unsigned int timeStep_size = (unsigned int) timeSteps.size();
	double temp;

	unsigned int timeIndex;
	int n;  unsigned int i;
	unsigned int startRange, endRange;

	double tempTime; double finalTempTime=0;

#ifdef USE_OpenMP			
#pragma omp parallel private(startRange,endRange,threadID,i,n,tempRF,tempTime,timeIndex,sarMapData)
	{
		threadID = omp_get_thread_num();
#endif //USE_OpenMP

		sarMapData.resize(phantom.size());
		float binSize = float( phantom.size() ) / float( threadP );
		startRange = (unsigned int)( binSize * float( threadID ) ); 
		endRange   = (unsigned int)( binSize * float( threadID + 1 ) );

		tempTime=0;

		// this loop will walk through each time index in the sequence
		for (timeIndex = 0; timeIndex < timeStep_size; timeIndex++)
		{
			tempTime += timeSteps[timeIndex];
			if (threadID == 0)
			{
				// indicate % completion
				if (timeIndex%10 == 0)
				{
					processIndicator = ( float (timeIndex) / float(timeStep_size) ) * 100.0f;
					std::cout<<"Calculating: "<<processIndicator<<"% done,"<<std::endl;
				}
			}

			tempRF.clear(); // remove all previous values from the vector
			for (n=0; n<info.numTx; n++)
			{
				// load 'tempRF' with an array of values for each transmit coil during this particular time
				tempRF.push_back(rf[n][timeIndex]); // [coil][time] -> [coil]
			}

			for (i = startRange; i < endRange; i++) // this limits the amount of calculation any one OpenMP thread will perform
			{
				sarMapData[i] += (double) phantom[i].calSAR(tempRF, timeSteps[timeIndex]);
			}
		} /* for (unsigned int timeIndex = 0; timeIndex < timeStep_size; timeIndex++) */

#ifdef USE_OpenMP
		array_addresses[threadID] = sarMapData;
		finalSarMapData.resize(sarMapData.size());
		finalTempTime = tempTime;
	} /* #pragma omp parallel private(startRange,endRange,threadID,i,n,tempRF,tempGrad,tempDelFreq,temp,timeIndex,kSpaceData) */

#pragma omp single
	for(i=0; i<(unsigned int)array_addresses[0].size(); i++) // voxel
	{
		temp = (double)0;
		for(int m=0; m<(int)threadP; m++) // thread
		{
			temp += (double)array_addresses[m][i];
		}
		finalSarMapData[i] = (float)(temp / finalTempTime);
	}
#endif //USE_OpenMP

	endTime = clock();
	double TheTime = double(endTime - startTime) / double( CLOCKS_PER_SEC );
	printf ("Time used: %f seconds.\n", TheTime);

	if(threadID == 0)
	{
#ifndef USE_OpenMP
		finalSarMapData.clear();
		for(i=0; i<sarMapData.size(); i++)
		{
			finalSarMapData[i] = (float)sarMapData[i];
		};
		run.setSARMap(finalSarMapData);
#endif //USE_OpenMP
#ifdef USE_OpenMP
		run.setSARMap(finalSarMapData);
#endif //USE_OpenMP
		run.expPhantomSARMap(cmdInterp, finalTempTime);

		printf("Execution completed, press enter to exit.\n");
		std::cin.get();
	}
	
	return (EXIT_SUCCESS);
} /* int main(int argc, char *argv[]) */
