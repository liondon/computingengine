/*=========================================================================

  Program:   NutateSignal
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

	DelB0In delB0In(cmdInterp, geomIn.getGeomHeader().geomList);
	initFlag = initFlag && delB0In.delB0Flag;

	DelTempIn delTempIn(cmdInterp, geomIn.getGeomHeader().geomList);
	initFlag = initFlag && delTempIn.delTempFlag;

	initFlag = initFlag && initPhantomInfo(cmdInterp, seqnIn, geomIn);
	initFlag = initFlag && initPhantomSeqn(seqnIn);
	initFlag = initFlag && initPhantomGeom(geomIn);
	initFlag = initFlag && initPhantomIso();
	initFlag = initFlag && initPhantomTiss(tissIn);

	initFlag = initFlag && initPhantomDelTemp(delTempIn);
	initFlag = initFlag && initPhantomDelB0(delB0In);
	initFlag = initFlag && initPhantomMagn();
	initFlag = initFlag && initPhantomDMagn();
	initFlag = initFlag && initPhantomDPhi();
	initFlag = initFlag && initPhantomB1Mins(b1MinsIn);
	initFlag = initFlag && initPhantomB1Plus(b1PlusIn);
	initFlag = initFlag && initPhantomAveB1Mins();
	initFlag = initFlag && initPhantomAveB1Plus(info.aveB1Mins, info.sumB1Mins);
	
	DelGradIn delGradXIn(cmdInterp.getCmdFlags().delGx,cmdInterp.getCmdValues().delGx, info.min, info.max, info.wid);
	DelGradIn delGradYIn(cmdInterp.getCmdFlags().delGy,cmdInterp.getCmdValues().delGy, info.min, info.max, info.wid);
	DelGradIn delGradZIn(cmdInterp.getCmdFlags().delGz,cmdInterp.getCmdValues().delGz, info.min, info.max, info.wid);
	initFlag = initFlag && delGradXIn.delGradFlag && delGradYIn.delGradFlag && delGradZIn.delGradFlag;

	initFlag = initFlag && initPhantomDelGrad(delGradXIn, delGradYIn, delGradZIn);
	
	initFlag = initFlag && initPhantomBeff();

	// :TODO: this may be a good place to report missing input data that has been set to default and ask user if default input is ok
	/****************************************************  
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

#ifdef USE_DEBUG
	std::cout<<initFlag<<std::endl;
#endif
}

Execution::~Execution()
{
	info.aveB1Plus.clear();
	sequence.time.clear();
	sequence.acq.clear();
	for (unsigned int i = 0; i < sequence.rf.size(); i++)
	{
		sequence.rf[i].clear();
	}
	sequence.rf.clear();
	for (unsigned int i = 0; i < sequence.delFreq.size(); i++)
	{
		sequence.delFreq[i].clear();
	}
	sequence.delFreq.clear();
	sequence.gX.clear();
	sequence.gY.clear();
	sequence.gZ.clear();

	phantom.clear();

	for (unsigned int i = 0; i < kSpace.size(); i++)
	{
		kSpace[i].clear();
	}
	kSpace.clear();
	kMap.clear();
}

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().b0" accesses a public data value instead of 
// using a method to return the value.
bool Execution::initPhantomInfo(CmdInterp & cmdInterp, SeqnIn & seqnIn, GeomIn & geomIn)
{
	// :TODO: this would be a good place to verify that different file headers match each other
	info.numTx = seqnIn.getSeqnHeader().numTx;
	info.numRx = seqnIn.getSeqnHeader().numRx;
	
	info.b0 = cmdInterp.getCmdValues().b0;

	info.min = geomIn.getGeomHeader().min - geomIn.getGeomHeader().ctr;
	info.max = geomIn.getGeomHeader().max - geomIn.getGeomHeader().ctr;

	info.wid = geomIn.getGeomHeader().wid;

	info.thread = cmdInterp.getCmdValues().thread;

	// Important!!!
	info.numIso.x = cmdInterp.getCmdValues().numIsoX;
	info.numIso.y = cmdInterp.getCmdValues().numIsoY;
	info.numIso.z = cmdInterp.getCmdValues().numIsoZ;
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomSeqn(const SeqnIn & seqnIn)
{
	sequence.time = seqnIn.getTime();
	sequence.acq = seqnIn.getAcq();
	sequence.rf = seqnIn.getRF();
	sequence.delFreq = seqnIn.getDelFreq();
	sequence.gX = seqnIn.getGx();
	sequence.gY = seqnIn.getGy();
	sequence.gZ = seqnIn.getGz();

	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomGeom(const GeomIn & geomIn)
{
	std::vector<Voxel> tempVoxelVector = geomIn.getGeomData();
	Voxel tempVoxel;
	unsigned int temp = (info.numIso.x*info.numIso.y*info.numIso.z);
	phantom.resize(tempVoxelVector.size()*info.numIso.x*info.numIso.y*info.numIso.z);

	unsigned int m = 0;
	for (unsigned int i=0; i<tempVoxelVector.size(); i++)
	{
		unsigned int n = 0;
		while(n<temp)
		{
			phantom[m].geomInfo.id  = tempVoxelVector[i].geomInfo.id;
			phantom[m].geomInfo.pos = tempVoxelVector[i].geomInfo.pos;
			n = n+1; m = m+1;
		};
	};
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomIso()
{
	float nx = (float) info.numIso.x;
	float ny = (float) info.numIso.y;
	float nz = (float) info.numIso.z;

	Vect3D<float> temp1; // temp1 is the location of the smallest isochromat.
	Vect3D<float> temp2; // temp2 is the increment from the smallest isochromat.

	if (nx!=1)
	{
		temp1.x = -1 / (2*nx) * (nx-1);
		temp2.x = 1 / nx;
	}
	else
	{
		temp1.x = 0; temp2.x = 0;
	};

	if (ny!=1)
	{
		temp1.y = -1 / (2*ny) * (ny-1);
		temp2.y = 1 / ny;
	}
	else
	{
		temp1.y = 0; temp2.y = 0;
	};

	if (nz!=1)
	{
		temp1.z = -1 / (2*nz) * (nz-1);
		temp2.z = 1 / nz;
	}
	else
	{
		temp1.z = 0; temp2.z = 0;
	};


	unsigned short int temp3 = 0;
	info.offSet.clear();
	info.offSet.resize(info.numIso.x*info.numIso.y*info.numIso.z);
	for (unsigned short int k=0; k<info.numIso.z; k++)
	{
		for (unsigned short int j=0; j<info.numIso.y; j++)
		{
			for (unsigned short int i=0; i<info.numIso.x; i++)
			{
				temp3 = (unsigned short int) (ny*nx*k+nx*j+i); // How increments in each direction relate to the voxel index.
				info.offSet[temp3].x = temp1.x + temp2.x * i;
				info.offSet[temp3].y = temp1.y + temp2.y * j;
				info.offSet[temp3].z = temp1.z + temp2.z * k;
			};
		};
	};

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

bool Execution::initPhantomMagn()
{
	Vect3D<float> temp;
	for (unsigned int i=0; i<phantom.size(); i++)
	{
		phantom[i].setMagn0(phantom[i].tissInfo.rho * (float)(3.23587/1000.0) * (info.b0 + phantom[i].bInfo.delB0));
		
		// What is 3.23587/1000 ?
		// According to Haacke page 5, M0 = rho0 * 4.7818e-032 * B0, where 1 rho = 2 * 3.3428e25 * 1000.
		// 1 liter of water = 1000 grams of water
		//(1000 grams water)/(18.015 grams/mole) = 55.5093 moles
		// 55.5093 moles * (6.0221e23) = 3.3428e25 molecules of water per liter.

		temp.x = 0;
		temp.y = 0;
		temp.z = phantom[i].getMagn0();

		phantom[i].setMagn(temp);
	}
	return true;
}

// ------------------------------------------------------------------------------
bool Execution::initPhantomDMagn()
{
	for (unsigned int i=0; i<phantom.size(); i++)
	{
		phantom[i].setDxMagn(0,0,0);
		phantom[i].setDyMagn(0,0,0);
		phantom[i].setDzMagn(0,0,0);
		phantom[i].setDwMagn(0,0,0);
	}
	return true;
}

// ------------------------------------------------------------------------------
bool Execution::initPhantomDPhi()
{
	for (unsigned int i=0; i<phantom.size(); i++)
	{
		phantom[i].setDxPhi(0);
		phantom[i].setDyPhi(0);
		phantom[i].setDzPhi(0);
		phantom[i].setDwPhi(0);
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
		if (phantom.size() != (tempB1PlusData[i].size()*info.numIso.x*info.numIso.y*info.numIso.z))
		{
			std::cout << "Error: B1+ data from " << b1PlusIn.fName[i] << " does not match the geometry data!\n";
			std::cout << "Check the header and data length in" << b1PlusIn.fName[i] << std::endl;
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
	}

	for (unsigned int j=0; j<phantom.size(); j++)
	{
		temp.clear();

		if ((unsigned short int)tempB1PlusData.size() > info.numTx)
		{
			printf("Error: More B1+ files from commandline input than needed in sequence file!\n");
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
		else
		{
			for (unsigned int i=0; i<tempB1PlusData.size(); i++)
			{
				temp.push_back(tempB1PlusData[i][j/(info.numIso.x*info.numIso.y*info.numIso.z)]);
			}

			for (unsigned int n=0; n<(info.numTx - tempB1PlusData.size()); n++)
			{
				temp.push_back(defaultB1Pl);
			}
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
		if (phantom.size() != (tempB1MinsData[i].size()*info.numIso.x*info.numIso.y*info.numIso.z))
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
				temp.push_back(tempB1MinsData[i][j/(info.numIso.x*info.numIso.y*info.numIso.z)]);
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

bool Execution::initPhantomDelB0(const DelB0In & delB0In)
{
	std::vector<float> temp;

	assert(info.b0 > 0);

	if (delB0In.fName.compare(NULLSTR) == 0)
	{
		const float defaultDelB0 = 0;
		Vect3D<float> defaultDevDelB0;
		defaultDevDelB0 = 0;

		for (unsigned int j=0; j<phantom.size(); j++)
		{
			phantom[j].setDelB0(defaultDelB0, defaultDevDelB0, info.b0);
		}
	}
	else
	{
		std::vector<float> tempDelB0Data;
		tempDelB0Data = delB0In.getDelB0Data();

		// printf ("phantom.size()= %u; tempDelB0Data.size()=%u; info.numIso.x=%u; info.numIso.y=%u; info.numIso.z=%u;\n", phantom.size(),tempDelB0Data.size(),info.numIso.x,info.numIso.y,info.numIso.z);
		if(phantom.size() != (tempDelB0Data.size()*info.numIso.x*info.numIso.y*info.numIso.z))
		{
			std::cout << "Fatal Error: delB0 data from " << delB0In.fName << " does not match the geometry data!\n";
			std::cout << "Check the header and data length in" << delB0In.fName << std::endl;
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
		else
		{
			std::vector<Vect3D<float> > tempDevDelB0Data;
			tempDevDelB0Data = delB0In.getDevDelB0Data();

			for (unsigned int j=0; j<phantom.size(); j++)
			{
				phantom[j].setDelB0(tempDelB0Data[j/(info.numIso.x*info.numIso.y*info.numIso.z)],
					tempDevDelB0Data[j/(info.numIso.x*info.numIso.y*info.numIso.z)],
					info.b0,
					info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)],
					info.wid);
			}
		}
	}
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomDelTemp(const DelTempIn & delTempIn)
{
	std::vector<float> temp;

	if (delTempIn.fName.compare(NULLSTR) == 0)
	{
		const float defaultDelTemp = 0;

		for (unsigned int j=0; j<phantom.size(); j++)
		{
			phantom[j].setDelTemp(defaultDelTemp);
		}
	}
	else
	{
		std::vector<float> tempDelTempData;
		tempDelTempData = delTempIn.getDelTempData();

		// printf ("phantom.size()= %u; tempDelTempData.size()=%u; info.numIso.x=%u; info.numIso.y=%u; info.numIso.z=%u;\n", phantom.size(),tempDelTempData.size(),info.numIso.x,info.numIso.y,info.numIso.z);
		if(phantom.size() != (tempDelTempData.size()*info.numIso.x*info.numIso.y*info.numIso.z))
		{
			std::cout << "Fatal Error: delTemp data from " << delTempIn.fName << " does not match the geometry data!\n";
			std::cout << "Check the header and data length in" << delTempIn.fName << std::endl;
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
		else
		{
			std::vector<Vect3D<float> > tempDevDelTempData;
			tempDevDelTempData = delTempIn.getDevDelTempData();

			for (unsigned int j=0; j<phantom.size(); j++)
			{
				phantom[j].setDelTemp(tempDelTempData[j/(info.numIso.x*info.numIso.y*info.numIso.z)]);
					// info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)]);
			}
		}
	}
	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomDelGrad(DelGradIn delGradXIn, DelGradIn delGradYIn, DelGradIn delGradZIn) // Not rigorously tested, code can be combined and improved for efficiency.
{
	Vect3D<float> temp;
	const float defaultDelGrad = 0;

	if (delGradXIn.fName.compare(NULLSTR) == 0)
	{
		for (unsigned int j=0; j<phantom.size(); j++)
		{
			phantom[j].setDelGradX(defaultDelGrad);
		}
	}
	else
	{		
		if(
			( delGradXIn.getDelGradHeader().min.x * delGradXIn.getDelGradHeader().wid.x ) > ( info.min.x * info.wid.x ) ||
			( delGradXIn.getDelGradHeader().min.y * delGradXIn.getDelGradHeader().wid.y ) > ( info.min.y * info.wid.y ) ||
			( delGradXIn.getDelGradHeader().min.z * delGradXIn.getDelGradHeader().wid.z ) > ( info.min.z * info.wid.z ) ||
			( delGradXIn.getDelGradHeader().max.x * delGradXIn.getDelGradHeader().wid.x ) < ( info.max.x * info.wid.x ) ||
			( delGradXIn.getDelGradHeader().max.y * delGradXIn.getDelGradHeader().wid.y ) < ( info.max.y * info.wid.y ) ||
			( delGradXIn.getDelGradHeader().max.z * delGradXIn.getDelGradHeader().wid.z ) < ( info.max.z * info.wid.z )
			)
		{
			std::cout << "Fatal Error: delGradX data from " << delGradXIn.fName << " has smaller region than the geometry data!\n";
			std::cout << "Check the header and data length in" << delGradXIn.fName << std::endl;
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
		else
		{
			std::cout << "Initializing phantom delGradX data using trilinear interpolation... ";
			float tempX1 = info.wid.x / delGradXIn.getDelGradHeader().wid.x;
			float tempY1 = info.wid.y / delGradXIn.getDelGradHeader().wid.y;
			float tempZ1 = info.wid.z / delGradXIn.getDelGradHeader().wid.z;

			for (unsigned int j=0; j<phantom.size(); j++)
			{
				temp.x = ( phantom[j].geomInfo.pos.x + info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)].x ) * tempX1;
				temp.y = ( phantom[j].geomInfo.pos.y + info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)].y ) * tempY1;
				temp.z = ( phantom[j].geomInfo.pos.z + info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)].z ) * tempZ1;
				phantom[j].setDelGradX( delGradXIn.getDelGradData( temp ) );
			}
			std::cout << "Finished!" << std::endl;
		}
	}

	if (delGradYIn.fName.compare(NULLSTR) == 0)
	{
		for (unsigned int j=0; j<phantom.size(); j++)
		{
			phantom[j].setDelGradY(defaultDelGrad);
		}
	}
	else
	{		
		if(
			( delGradYIn.getDelGradHeader().min.x * delGradYIn.getDelGradHeader().wid.x ) > ( info.min.x * info.wid.x ) ||
			( delGradYIn.getDelGradHeader().min.y * delGradYIn.getDelGradHeader().wid.y ) > ( info.min.y * info.wid.y ) ||
			( delGradYIn.getDelGradHeader().min.z * delGradYIn.getDelGradHeader().wid.z ) > ( info.min.z * info.wid.z ) ||
			( delGradYIn.getDelGradHeader().max.x * delGradYIn.getDelGradHeader().wid.x ) < ( info.max.x * info.wid.x ) ||
			( delGradYIn.getDelGradHeader().max.y * delGradYIn.getDelGradHeader().wid.y ) < ( info.max.y * info.wid.y ) ||
			( delGradYIn.getDelGradHeader().max.z * delGradYIn.getDelGradHeader().wid.z ) < ( info.max.z * info.wid.z )
			)
		{
			std::cout << "Fatal Error: delGradY data from " << delGradYIn.fName << " has smaller region than the geometry data!\n";
			std::cout << "Check the header and data length in" << delGradYIn.fName << std::endl;
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
		else
		{
			std::cout << "Initializing phantom delGradY data using trilinear interpolation... ";
			float tempX1 = info.wid.x / delGradYIn.getDelGradHeader().wid.x;
			float tempY1 = info.wid.y / delGradYIn.getDelGradHeader().wid.y;
			float tempZ1 = info.wid.z / delGradYIn.getDelGradHeader().wid.z;

			for (unsigned int j=0; j<phantom.size(); j++)
			{
				temp.x = ( phantom[j].geomInfo.pos.x + info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)].x ) * tempX1;
				temp.y = ( phantom[j].geomInfo.pos.y + info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)].y ) * tempY1;
				temp.z = ( phantom[j].geomInfo.pos.z + info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)].z ) * tempZ1;
				phantom[j].setDelGradY( delGradYIn.getDelGradData( temp ) );
			}
			std::cout << "Finished!" << std::endl;
		}
	}
	
	if (delGradZIn.fName.compare(NULLSTR) == 0)
	{
		for (unsigned int j=0; j<phantom.size(); j++)
		{
			phantom[j].setDelGradZ(defaultDelGrad);
		}
	}
	else
	{		
		if(
			( delGradZIn.getDelGradHeader().min.x * delGradZIn.getDelGradHeader().wid.x ) > ( info.min.x * info.wid.x ) ||
			( delGradZIn.getDelGradHeader().min.y * delGradZIn.getDelGradHeader().wid.y ) > ( info.min.y * info.wid.y ) ||
			( delGradZIn.getDelGradHeader().min.z * delGradZIn.getDelGradHeader().wid.z ) > ( info.min.z * info.wid.z ) ||
			( delGradZIn.getDelGradHeader().max.x * delGradZIn.getDelGradHeader().wid.x ) < ( info.max.x * info.wid.x ) ||
			( delGradZIn.getDelGradHeader().max.y * delGradZIn.getDelGradHeader().wid.y ) < ( info.max.y * info.wid.y ) ||
			( delGradZIn.getDelGradHeader().max.z * delGradZIn.getDelGradHeader().wid.z ) < ( info.max.z * info.wid.z )
			)
		{
			std::cout << "Fatal Error: delGradZ data from " << delGradZIn.fName << " has smaller region than the geometry data!\n";
			std::cout << "Check the header and data length in" << delGradZIn.fName << std::endl;
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}
		else
		{
			std::cout << "Initializing phantom delGradZ data using trilinear interpolation... ";
			float tempX1 = info.wid.x / delGradZIn.getDelGradHeader().wid.x;
			float tempY1 = info.wid.y / delGradZIn.getDelGradHeader().wid.y;
			float tempZ1 = info.wid.z / delGradZIn.getDelGradHeader().wid.z;

			for (unsigned int j=0; j<phantom.size(); j++)
			{
				temp.x = ( phantom[j].geomInfo.pos.x + info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)].x ) * tempX1;
				temp.y = ( phantom[j].geomInfo.pos.y + info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)].y ) * tempY1;
				temp.z = ( phantom[j].geomInfo.pos.z + info.offSet[j%(info.numIso.x*info.numIso.y*info.numIso.z)].z ) * tempZ1;
				phantom[j].setDelGradZ( delGradZIn.getDelGradData( temp ) );
			}
			std::cout << "Finished!" << std::endl;
		}
	}

	return true;
}

// ------------------------------------------------------------------------------

bool Execution::initPhantomBeff()
{
	for (unsigned int i=0; i<phantom.size(); i++)
	{
		phantom[i].initBeff();
	}
	return true;
}

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().kMap" accesses a public data value instead of 
// using a method to return the value.
bool Execution::expPhantomKMap(CmdInterp & cmdInterp)
{
	assert(!kMap.empty());

	std::string expFName;
	std::fstream fHandle;

	expFName = cmdInterp.getCmdValues().kMap;

	fHandle.open(expFName.c_str(), std::ios::out | std::ios::binary);

	if (fHandle.fail())
	{
		std::cout << "\n\"" << expFName << "\" failed to open!\n";
		printf("Execution terminated, press enter to exit.\n");
		std::cin.get();
		return false;
	}

	// kMapData______________________________________________________________
	for (unsigned int n=0; n<kMap.size(); n++)
	{
		fHandle.write(reinterpret_cast<char*>(&kMap[n]), sizeof(kMap[n]));	
	}
	fHandle.close();

	return true;
}

// ------------------------------------------------------------------------------

// NOTE -- This method should have the 'const' qualifier, but it can't because 
// "cmdInterp.getCmdValues().kSpace" accesses a public data value instead of 
// using a method to return the value.
bool Execution::expPhantomKSpace(CmdInterp & cmdInterp)
{
	assert(!kSpace.empty());

	size_t ptr;
	std::vector<std::string> expFName;
	std::string tempFName;
	std::stringstream tempSS;
	for (unsigned int n=1; n<=info.numRx; n++)
	{
		tempFName.clear();
		tempFName = cmdInterp.getCmdValues().kSpace;
		tempSS << n;

		ptr = tempFName.rfind(".");
		if (ptr != std::string::npos)	// insert or append the coil number
		{
			tempFName.insert(ptr, tempSS.str());
		}
		else
		{
			tempSS << ".bin";
			tempFName.append(tempSS.str());
		}
		tempSS.str("");

		expFName.push_back(tempFName);
	}

	assert(expFName.size() == kSpace.size());

	std::fstream fHandle;
	
	for (unsigned int i=0; i<expFName.size(); i++)
	{
		fHandle.open(expFName[i].c_str(), std::ios::out | std::ios::binary);

		if (fHandle.fail())
		{
			std::cout << "\n\"" << expFName[i] << "\" failed to open!\n";
			printf("Execution terminated, press enter to exit.\n");
			std::cin.get();
			return false;
		}

		// kSpacData______________________________________________________________
		for (unsigned int m=0; m<kSpace[i].size(); m++)
		{
			fHandle.write(reinterpret_cast<char*>(&kSpace[i][m]), sizeof(kSpace[i][m]));
		}

		fHandle.close();
	}
	return true;
}
