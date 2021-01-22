/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: DelGradIn.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"DelGradIn.h"
#include<cassert>
#include<fstream>
#include<iostream>
#include<math.h>

// ------------------------------------------------------------------------------

DelGradIn::DelGradIn(bool flag, std::string addr, Vect3D<float> min, Vect3D<float> max, Vect3D<float> wid)
{
	fName.clear();
	delGradHeader.totNumVox = 0;
	delGradHeader.min = 0;
	delGradHeader.max = 0;
	delGradHeader.ctr = 0;
	delGradHeader.wid = 0;
	delGradData.clear();

	if (flag == true)
	{
		fName = addr;
		delGradFlag = readDelGradHeader( min, max, wid ) && readDelGradData();
		axisShift();
	}
	else
	{
		fName = NULLSTR;
		delGradFlag = true;
	}
}

DelGradIn::~DelGradIn()
{
	delGradData.clear();
}

// ------------------------------------------------------------------------------

bool DelGradIn::readDelGradHeader( Vect3D<float> min, Vect3D<float> max, Vect3D<float> wid )
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

	// totNumVox__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.totNumVox = (unsigned int) buff;

	// xMin__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.min.x =  (int) buff;
	
	// xMax__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.max.x =  (int) buff;

	// yMin__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.min.y =  (int) buff;
	
	// yMax__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.max.y =  (int) buff;
	
	// zMin__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.min.z =  (int) buff;
	
	// zMax__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.max.z =  (int) buff;

	// xCtr__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.ctr.x =  (int) buff;
	
	// yCtr__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.ctr.y =  (int) buff;

	// zCtr__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.ctr.z =  (int) buff;

	// xWid__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.wid.x =  buff/1000;
	
	// yWid__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.wid.y =  buff/1000;

	// zWid__________________________________________________
	fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
	delGradHeader.wid.z =  buff/1000;
	
	fHandle.close();

	if ( ( delGradHeader.ctr.x - delGradHeader.min.x ) * delGradHeader.wid.x >= -min.x * wid.x )
	{
		delGradHeader.min.x = delGradHeader.ctr.x + (int) floor( min.x * wid.x / delGradHeader.wid.x );
	}
	else
	{
		printf("Error");
		return false;
	}

	if ( ( delGradHeader.ctr.y - delGradHeader.min.y ) * delGradHeader.wid.y >= -min.y * wid.y )
	{
		delGradHeader.min.y = delGradHeader.ctr.y + (int) floor( min.y * wid.y / delGradHeader.wid.y );
	}
	else
	{
		printf("Error");
		return false;
	}

	if ( ( delGradHeader.ctr.z - delGradHeader.min.z ) * delGradHeader.wid.z >= -min.z * wid.z )
	{
		delGradHeader.min.z = delGradHeader.ctr.z + (int) floor( min.z * wid.z / delGradHeader.wid.z );
	}
	else
	{
		printf("Error");
		return false;
	}

	if ( ( delGradHeader.max.x - delGradHeader.ctr.x ) * delGradHeader.wid.x >= max.x * wid.x )
	{
		delGradHeader.max.x = delGradHeader.ctr.x + (int) ceil( max.x * wid.x / delGradHeader.wid.x);
	}
	else
	{
		printf("Error");
		return false;
	}

	if ( ( delGradHeader.max.y - delGradHeader.ctr.y ) * delGradHeader.wid.y >= max.y * wid.y )
	{
		delGradHeader.max.y = delGradHeader.ctr.y + (int) ceil( max.y * wid.y / delGradHeader.wid.y);
	}
	else
	{
		printf("Error");
		return false;
	}

	if ( ( delGradHeader.max.z - delGradHeader.ctr.z ) * delGradHeader.wid.z >= max.z * wid.z )
	{
		delGradHeader.max.z = delGradHeader.ctr.z + (int) ceil( max.z * wid.z / delGradHeader.wid.z);
	}
	else
	{
		printf("Error");
		return false;
	}

	return true;
}

// ------------------------------------------------------------------------------

bool DelGradIn::readDelGradData()
{
	printf("Reading DelGrad data... "); // TODO: add a switch statement here to denote x,y,z gradient files.

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

	// Skip Header
	fHandle.seekg (4*13, std::ios::cur);

	DelGradData tempDelGradData;

	unsigned int j=0, k=0;
	while(j < delGradHeader.totNumVox)
	{
		tempDelGradData.x = 0;
		tempDelGradData.z = 0;
		tempDelGradData.y = 0;
		tempDelGradData.delGrad = 0;

		// DelGradData_________________________________________________
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		tempDelGradData.x = (int) buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		tempDelGradData.y = (int) buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		tempDelGradData.z = (int) buff;
		fHandle.read(reinterpret_cast<char*>(&buff), sizeof(buff));
		tempDelGradData.delGrad = (float) buff;
		
		if ( delGradHeader.min.x <= tempDelGradData.x && tempDelGradData.x <= delGradHeader.max.x &&
			delGradHeader.min.y <= tempDelGradData.y && tempDelGradData.y <= delGradHeader.max.y &&
			delGradHeader.min.z <= tempDelGradData.z && tempDelGradData.z <= delGradHeader.max.z
			) // if the voxel falls within the volume of interest
		{
			delGradData.push_back(tempDelGradData);
			k++;
		}

		j++;
	}

	fHandle.close();

	delGradHeader.totNumVox = k;

	printf("Finished!\n");
	
	return true;
}

// ------------------------------------------------------------------------------

unsigned int DelGradIn::FindGrad(int x, int y, int z)
{
	unsigned int j = 0;
	while(j<delGradHeader.totNumVox)
	{
		if(delGradData[j].x == x && delGradData[j].y == y && delGradData[j].z == z)
		{
			return j;
		}
		else
		{
			j++;
		};		
	};
	// try & catch
	return 0;
}

// ------------------------------------------------------------------------------

float DelGradIn::getDelGradData(Vect3D<float> pos)
{
	float xd=0, yd=0, zd=0,
		i1=0, i2=0, j1=0, j2=0,
		w1=0, w2=0,
		IV=0;

	unsigned int i1_idx1=0, i1_idx2=0, i2_idx1=0, i2_idx2=0,
		j1_idx1=0, j1_idx2=0, j2_idx1=0, j2_idx2=0;

	xd = pos.x - floor(pos.x);
	yd = pos.y - floor(pos.y);
	zd = pos.z - floor(pos.z);

	//try{
		i1_idx1 = FindGrad( (int)floor(pos.x), (int)floor(pos.y), (int)floor(pos.z) );
		i1_idx2 = FindGrad( (int)floor(pos.x), (int)floor(pos.y), (int)ceil(pos.z) );
		i2_idx1 = FindGrad( (int)floor(pos.x), (int)ceil(pos.y), (int)floor(pos.z) );
		i2_idx2 = FindGrad( (int)floor(pos.x), (int)ceil(pos.y), (int)ceil(pos.z) );
		j1_idx1 = FindGrad( (int)ceil(pos.x), (int)floor(pos.y), (int)floor(pos.z) );
		j1_idx2 = FindGrad( (int)ceil(pos.x), (int)floor(pos.y), (int)ceil(pos.z) );
		j2_idx1 = FindGrad( (int)ceil(pos.x), (int)ceil(pos.y), (int)floor(pos.z) );
		j2_idx2 = FindGrad( (int)ceil(pos.x), (int)ceil(pos.y), (int)ceil(pos.z) );
	//}
	//catch
	//{
	//	runtime_error( "attempted to divide by zero" );
	//};

	i1 = delGradData[i1_idx1].delGrad * (1-zd) + delGradData[i1_idx2].delGrad * zd;
	i2 = delGradData[i2_idx1].delGrad * (1-zd) + delGradData[i2_idx2].delGrad * zd;
	j1 = delGradData[j1_idx1].delGrad * (1-zd) + delGradData[j1_idx2].delGrad * zd;
	j2 = delGradData[j2_idx1].delGrad * (1-zd) + delGradData[j2_idx2].delGrad * zd;

	w1 = i1*(1-yd) + i2*yd;
	w2 = j1*(1-yd) + j2*yd;

	IV = w1*(1-xd) + w2*xd;

	return IV;
}

// ------------------------------------------------------------------------------

void DelGradIn::axisShift()
{
	for (unsigned int i=0; i<delGradData.size(); i++)
	{
		delGradData[i].x -= delGradHeader.ctr.x;
		delGradData[i].y -= delGradHeader.ctr.y;
		delGradData[i].z -= delGradHeader.ctr.z;
	}

	delGradHeader.min = delGradHeader.min - delGradHeader.ctr;
	delGradHeader.max = delGradHeader.max - delGradHeader.ctr;

	delGradHeader.ctr = 0;
}

// ------------------------------------------------------------------------------
