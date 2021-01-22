/*=========================================================================

  Program:   NutateSAR
  Module:    $RCSfile: Execution.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef EXECUTION_H
#define EXECUTION_H

#include "Voxel.h"
#include "GeomIn.h"
#include "TissIn.h"
#include "B1PlusIn.h"
#include "B1MinsIn.h"
#include "E1PlusIn.h"
#include "SeqnIn.h"

// class Execution is the calling routine for all file read-in processes. The default constructor of Execution
// calls default constructors of all classes designed to handle file input. After the files have been read, the
// Execution class will hold all of the information necessary for all calculations to take place.
class Execution
{
public:
	// class Info will hold general information about the run
	class Info
	{
	public:
		unsigned short int thread;
		std::vector<std::complex<float> > aveB1Plus; // [Coil] Average B1Plus within the VOI.
		float							  aveB1Mins; // Average B1Mins within the VOI. Vector index indicates voxel number.
		std::vector<float>	              sumB1Mins; // Summation of B1Mins of each voxel within the VOI. Vector index indicates voxel number.
		unsigned short int numRx,numTx; // from the sequence file.
	};

	class Sequence
	{
	public:
		std::vector<float> time;
		std::vector<std::vector<std::complex<float> > > rf; // [coil][timeIndex]
	};

private:
	Info info;
	std::vector<Voxel> phantom; // 'phantom' is a vector of voxels that holds the sample geometry
	Sequence sequence;

	std::vector<float> sarMap; // [Voxel] - this holds the final SAR calculated values, one per voxel

	// these are functions to initialize the receiving data structures
	bool initPhantomInfo(CmdInterp & cmdInterp, SeqnIn & seqnIn);
	bool initPhantomSeqn(const SeqnIn & seqnIn);
	bool initPhantomGeom(const GeomIn & geomIn);
	bool initPhantomTiss(const TissIn & tissIn);
	bool initPhantomB1Mins(const B1MinsIn & b1MinsIn);
	bool initPhantomB1Plus(const B1PlusIn & b1PlusIn);
	bool initPhantomAveB1Mins();
	bool initPhantomAveB1Plus(const float & aveB1Mins, const std::vector<float> & sumB1Mins);
	bool initPhantomE1Plus(const E1PlusIn & e1PlusIn);
	bool initPhantomSAR0();

public:

	bool initFlag;

	// The Execution constructor will call each of the file input routines, putting all of the required data
	// for the simulation in the appropriate locations.
	Execution(CmdInterp & cmdInterp);
	~Execution();

	// expPhantomSARMap() writes the completed SAR file.
	bool expPhantomSARMap(CmdInterp & cmdInterp, double totTime);

	// 'get' functions
	Info & getInfo(){ return info; }; // NOTE: Using '&' increases performance, but 'const' can't be used.
	const std::vector<Voxel> & getPhantom() const { return phantom; };
	Sequence & getSequence(){ return sequence; };  // NOTE: Using '&' increases performance, but 'const' can't be used.

	// setSARMap() is used to put the data into 'sarMap' before using expPhantomSARMap() to write the data to a file.
	void setSARMap(const std::vector<float> & sarMapData) { sarMap = sarMapData; };
};

#endif /* EXECUTION_H */
