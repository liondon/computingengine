/*=========================================================================

  Program:   NutateNoise
  Module:    $RCSfile: main.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 21:18:18 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/

#include "Execution.h"

#include<ctime>
#include<stdio.h>

int main(int argc, char *argv[])
{
	printf("\n--------- Simulation Started. ---------\n");

	CmdInterp cmdInterp;
	if (!(cmdInterp.interpCmd(argc, argv)))
	{
		// Sufficient error message given for error causing failure
		return (EXIT_FAILURE);
	}
	
	/* :TODO: discuss change - moved function into interpCmd and changed name to checkFileNames
	Delete this commented block after review is accepted
	if (!(cmdInterp.checkCmd()))
	{
		std::cout << "\nOne or more files not found. Verify file names and restart simulation.\nPress enter to quit.\n";
		std::cin.get();
		return (EXIT_FAILURE);
	}
	*/

	Execution run(cmdInterp);

	if (!(run.initFlag))
	{
		// Sufficient error message given for error causing failure
		return (EXIT_FAILURE);
	}

	// The variables below are used as buffers. Their purpose is to reduce the amount of function calls that take place in the loops below.
	Execution::Info info = run.getInfo(); // buffer to hold run information
	std::vector<float> timeSteps = run.getSequence().time; // buffer to hold time info
	std::vector<int> acq = run.getSequence().acq; // acq window buffer

	// for % completion reporting
	clock_t startTime,endTime;
	startTime = clock();
	float processIndicator;

	srand((unsigned)time(NULL)); // seed random number generator with system clock value

	std::vector<std::vector<std::vector<std::complex<float> > > > kNoiseData; // [NEX][Coil][Acq]
	std::vector<std::vector<std::complex<float> > > tempKNoiseData; // [Coil][Acq]
	tempKNoiseData.resize(info.numRx);
	kNoiseData.resize(info.nex);
			
	//std::vector<std::vector<float> > zMat;
	std::vector<float> zMat1, zMat2, zMat3, zMat4;
	std::vector<std::vector<std::complex<double> > > aMat;
	aMat = run.getNoiseInfo().aMat;

	unsigned int tempSize = (unsigned int) acq.size();
	std::complex<double> temp;

	double noiseConstant = sqrt( 
		(double)4.0 * K_BOLZ * (double)298.0
		* (double)(info.wid.x * info.wid.y * info.wid.z)
		);

	unsigned int tempNex = info.nex;
	// The following for loop will generate one (complex) noise value per coil per acq window
	for (unsigned int nex = 0; nex < info.nex; nex++)
	{
		bool indFlag = 0;

		// indicate % completion
		if ((int)tempNex/100 == 0)
		{
			indFlag = 1;
		}
		else if ( nex%((int)tempNex/100) == 0 )
		{
			indFlag = 1;
		};

		if (indFlag == 1)
		{
			processIndicator = ( float (nex) / float(tempNex) ) * 100.0f;
			std::cout<<"Calculating: "<<processIndicator<<"% done,"<<std::endl;
		};

		tempKNoiseData.clear(); tempKNoiseData.resize(info.numRx);
		for (unsigned int timeIndex = 0; timeIndex < tempSize; timeIndex++)
		{
			if(acq[timeIndex] == 1)
			{
				// Generate KNoiseData.
				zMat1 = rdmMat(info.numRx); // rdmMat defined in "functions.h"
				zMat2 = rdmMat(info.numRx); 
				for (unsigned short int i=0; i<info.numRx; i++)
				{
					temp = (double)(0,0);
					for (unsigned short int j=0; j<info.numRx; j++)
					{
						// Because the Cholesky Decomposition method used will be real-biased, so I here used two random numbers to generate
						// a random complex number.
						temp += (std::complex<double>) ( aMat[i][j] * (std::complex<double>)(zMat1[j]/sqrt(2.0), zMat2[j]/sqrt(2.0)) );
					}

					// zMat3 = rdmMat(1);
					// zMat4 = rdmMat(1);

					//// The noise from each channel is the addition of correlated sample noise and uncorrelated coil noise.
					//tempKNoiseData[i].push_back( ( std::complex<float> )
					//	( (temp + run.getNoiseInfo().coilResist[i] * (std::complex<double>)(zMat3[1]/sqrt(2.0), zMat4[1]/sqrt(2.0)))
					//	* noiseConstant / sqrt((double)timeSteps[timeIndex]) ));

					// The noise from each channel is the addition of correlated sample noise and uncorrelated coil noise.
					tempKNoiseData[i].push_back( ( std::complex<float> ) (temp * noiseConstant / sqrt((double)timeSteps[timeIndex])) );
				} /* for (unsigned short int i=0; i<info.numRx; i++) */

			} /* if(acq[timeIndex] == 1) */

		} /* for (unsigned int timeIndex = 0; timeIndex < tempSize; timeIndex++) */
		kNoiseData[nex] = tempKNoiseData;
	} /* for (unsigned int nex = 0; nex < info.nex; nex++) */

	/***********************************************************************/
			
	endTime = clock();
	double TheTime = double(endTime - startTime) / double( CLOCKS_PER_SEC );
	printf ("Simulation took %f seconds.\n", TheTime);

	//noiseData
	run.setKNoise(kNoiseData);
	run.expPhantomKNoise(cmdInterp);

	printf("Execution completed successfully, press enter to exit.\n");
	std::cin.get();
	
	return (EXIT_SUCCESS);
} /* int main(int argc, char *argv[]) */
