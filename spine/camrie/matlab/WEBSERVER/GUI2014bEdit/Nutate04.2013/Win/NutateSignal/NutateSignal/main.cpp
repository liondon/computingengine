/*=========================================================================

  Program:   NutateSignal
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

#define USE_DEBUG

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

	// The variables below are used as buffers. Their purpose is to reduce the amount of function calls that take place in the loops below.
	Execution::Info info = run.getInfo();
	std::vector<Voxel> phantom = run.getPhantom();
	std::vector<float> timeSteps = run.getSequence().time;
	std::vector<int> acq = run.getSequence().acq;
	std::vector<std::vector<std::complex<float> > > rf = run.getSequence().rf;
	std::vector<std::vector<float> > delFreq = run.getSequence().delFreq;
	std::vector<float> gX = run.getSequence().gX;
	std::vector<float> gY = run.getSequence().gY;
	std::vector<float> gZ = run.getSequence().gZ;

/*******************************************************************************/
	int threadP=1, threadID=0;
#ifdef USE_OpenMP
	threadP=(int)info.thread;
	std::vector<std::vector<std::complex<float> > > * array_addresses = new std::vector<std::vector<std::complex<float> > > [threadP];
	omp_set_num_threads(threadP);
	std::vector<std::vector<std::complex<float> > > finalKSpaceData;
#endif //USE_OpenMP
/*******************************************************************************/

	// for % completion reporting
	clock_t startTime,endTime;
	startTime = clock();
	float processIndicator;

	std::vector<std::vector<std::complex<float> > > kSpaceData; // [Coil][Voxel]

	Vect3D<float> tempKMapData;	tempKMapData = 0;
	std::vector<Vect3D<float> > kMapData;

	std::vector<std::complex<float> > tempRF;
	std::vector<float> tempDelFreq;
	Vect3D<float> tempGrad; tempGrad = 0;
	unsigned int timeStep_size = (unsigned int) timeSteps.size();
	std::complex<double> temp;
	std::complex<double> tempSum;

	unsigned int timeIndex;
	int n; unsigned int i;
	unsigned int threadStartRange, threadEndRange;

#ifdef USE_OpenMP
#pragma omp parallel private(threadStartRange,threadEndRange,threadID,i,n,tempRF,tempGrad,tempDelFreq,temp,timeIndex,kSpaceData)
	{
		threadID = omp_get_thread_num();
#endif //USE_OpenMP
		kSpaceData.resize(info.numRx);
		float binSize = float( phantom.size() ) / float( threadP );
		threadStartRange = (unsigned int)( binSize * float( threadID ) ); 
		threadEndRange   = (unsigned int)( binSize * float( threadID + 1 ) );

		for (timeIndex = 0; timeIndex < timeStep_size; timeIndex++)
		{
			if (threadID == 0)
			{
				// indicate % completion
				// if (timeIndex%10 == 0)
				if ( timeIndex%((int)timeStep_size/100) == 0 )
				{
					processIndicator = ( float (timeIndex) / float(timeStep_size) ) * 100.0f;
					std::cout<<"Calculating "<<processIndicator<<"% done,"<<std::endl;
				}
			}

			tempRF.clear();
			tempDelFreq.clear();
			for (n=0; n<info.numTx; n++)
			{
				// place the values for this timeIndex of all RF coils in one location, 'tempRF'
				tempRF.push_back(rf[n][timeIndex]); // [coil][time] -> [coil]

				// place the delta_Frequency values for this timeIndex of all RF coils in one location, 'tempDelFreq'
				tempDelFreq.push_back(delFreq[n][timeIndex]); // [coil][time] -> [coil]
			}

			// place gradient values in a buffer: 'tempGrad'
			tempGrad.x = gX[timeIndex];
			tempGrad.y = gY[timeIndex];
			tempGrad.z = gZ[timeIndex];

			if(acq[timeIndex] == 1) // if this timestep is flagged as signal acquisition
			{

				// In the event
				//-----------------------------------------------------------------------------------------------------------------//

				// First part of rotation.
				for (i = threadStartRange; i < threadEndRange; i++) // thread specific
				{
					phantom[i].calBeff(tempRF, tempDelFreq, tempGrad, info.aveB1Plus, info.wid, info.offSet[i%(info.numIso.x*info.numIso.y*info.numIso.z)]);
					phantom[i].appRot(tempGrad, timeSteps[timeIndex]/2); // perform rotation for 1st half of this time step's length
				};

				// Acquire signal.
				for (n=0; n < info.numRx; n++)
				{
					temp = (std::complex<double>) (0,0);
					for (i = threadStartRange; i < (int) threadEndRange; i++) // thread specific
					{
						temp += (std::complex<double>) phantom[i].acqSignal(n, info.wid, info.b0, info.numIso);
					}
					kSpaceData[n].push_back((std::complex<float>)temp);
				}

				// complete second half of rotation
				for (i = threadStartRange; i < (int) threadEndRange; i++) // thread specific
				{
					phantom[i].appRot(tempGrad, timeSteps[timeIndex]/2);  // perform rotation for 2nd half of this time step's length
				}

				//-----------------------------------------------------------------------------------------------------------------//
						
				if (threadID == 0) // do only in thread 0
				{
					// Equation used: dK = gammaBar * Gradient * dTime
					if (tempGrad.x != 0)
					{
						tempKMapData.x += GAMMA/(float)2/PI * tempGrad.x * timeSteps[timeIndex]/(float)2;
					}
					if (tempGrad.y != 0)
					{
						tempKMapData.y += GAMMA/(float)2/PI * tempGrad.y * timeSteps[timeIndex]/(float)2;
					}
					if (tempGrad.z != 0)
					{
						tempKMapData.z += GAMMA/(float)2/PI * tempGrad.z * timeSteps[timeIndex]/(float)2;
					}

					kMapData.push_back(tempKMapData);

					if (tempGrad.x != 0)
					{
						tempKMapData.x += GAMMA/(float)2/PI * tempGrad.x * timeSteps[timeIndex]/(float)2;
					}
					if (tempGrad.y != 0)
					{
						tempKMapData.y += GAMMA/(float)2/PI * tempGrad.y * timeSteps[timeIndex]/(float)2;
					}
					if (tempGrad.z != 0)
					{
						tempKMapData.z += GAMMA/(float)2/PI * tempGrad.z * timeSteps[timeIndex]/(float)2;
					}
				}

				//-----------------------------------------------------------------------------------------------------------------//

			} /* if(acq[timeIndex] == 1) */
			else
			{
				for (i = threadStartRange; i < (int) threadEndRange; i++) // thread specific
				{
					phantom[i].calBeff(tempRF, tempDelFreq, tempGrad, info.aveB1Plus, info.wid, info.offSet[i%(info.numIso.x*info.numIso.y*info.numIso.z)]);
					phantom[i].appRot(tempGrad, timeSteps[timeIndex]);
				}

				switch (acq[timeIndex])
				{
				case 0: // Not acquiring signal, no data collected
					if (threadID == 0) // do only in thread 0
					{
						// Equation used: dK = gammaBar * Gradient * dTime
						if (tempGrad.x!=0)
						{
							tempKMapData.x += GAMMA/(float)2/PI * tempGrad.x * timeSteps[timeIndex];
						}
						if (tempGrad.y!=0)
						{
							tempKMapData.y += GAMMA/(float)2/PI * tempGrad.y * timeSteps[timeIndex];
						}
						if (tempGrad.z!=0)
						{
							tempKMapData.z += GAMMA/(float)2/PI * tempGrad.z * timeSteps[timeIndex];
						}
					}
					break ;
						
				case -2: // return to center of K-space and use ideal crushing
					for (i = threadStartRange; i < (int) threadEndRange; i++)
					{
						phantom[i].setMagn(0,0);
						phantom[i].setDxMagn(0,0,0);
						phantom[i].setDyMagn(0,0,0);
						phantom[i].setDzMagn(0,0,0);
						phantom[i].setDwMagn(0,0,0);
						phantom[i].updateDPhi();
					}
					// break command is omitted here since '-2' indicates a return to the center of K-space as well
				case -1: // return to center of K-space
					if (threadID == 0) // do only in thread 0
					{
						tempKMapData = 0;
					}
					break;
				default:
					std::cout << "WARNING: Error in sequence file: see time index #" << timeIndex << std::endl;
					std::cout << "Value causing error is " << acq[timeIndex] << std::endl;
					std::cout << "Sequence file only accepts values 1, 0, -1, and -2.\n";
					std::cout << "Press enter to continue simulation.\n";
					std::cin.get();
					break;

				} /* switch (acq[timeIndex]) */

			} /* else if(acq[timeIndex] == 1) */

		} /* for (unsigned int timeIndex = 0; timeIndex < timeStep_size; timeIndex++) */

#ifdef USE_OpenMP
		array_addresses[threadID] = kSpaceData;

		finalKSpaceData.resize(kSpaceData.size());
		for (n=0; n<(int)kSpaceData.size(); n++)
		{
			finalKSpaceData[n].resize(kSpaceData[n].size());
		}
	} /* #pragma omp parallel private(threadStartRange,threadEndRange,threadID,i,n,tempRF,tempGrad,tempDelFreq,temp,timeIndex,kSpaceData) */

	unsigned int l;		int m;
//#pragma omp for private(m,n,l,tempSumKSpace) // How to deal with stacked FORs ???
#pragma omp single
	for(n=0; n<(int)finalKSpaceData.size(); n++)
	{
		for(l=0; l<(unsigned int)array_addresses[0][n].size(); l++) // Voxel
		{
			tempSum = (double)(0,0);
			for(m=0; m<(int)threadP; m++) // thread
			{
				tempSum += (std::complex<double>) array_addresses[m][n][l];
			}
			finalKSpaceData[n][l] = (std::complex<float>) (tempSum);
		}
	}
#endif //USE_OpenMP
		
	endTime = clock();
	double TheTime = double(endTime - startTime) / double( CLOCKS_PER_SEC );
	printf ("ID %u used %f seconds.\n", threadID, TheTime);

	if(threadID == 0) // do only in thread 0
	{
#ifndef USE_OpenMP
		run.setKSpace(kSpaceData);
#endif //USE_OpenMP
#ifdef USE_OpenMP
		run.setKSpace(finalKSpaceData);
#endif //USE_OpenMP
		run.expPhantomKSpace(cmdInterp);

		run.setKMap(kMapData);
		run.expPhantomKMap(cmdInterp);

		printf("Execution completed, press enter to exit.\n");
		std::cin.get();
	}

	return (EXIT_SUCCESS);
} /* int main(int argc, char *argv[]) */
