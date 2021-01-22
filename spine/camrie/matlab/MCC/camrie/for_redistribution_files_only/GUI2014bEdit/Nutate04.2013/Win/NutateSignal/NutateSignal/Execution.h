/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: Execution.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef EXECUTION_H
#define EXECUTION_H

#include "Voxel.h"
#include "Vect3D.h"
#include "GeomIn.h"
#include "TissIn.h"
#include "B1PlusIn.h"
#include "B1MinsIn.h"
#include "SeqnIn.h"
#include "DelB0In.h"
#include "DelTempIn.h"
#include "DelGradIn.h"

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
		Vect3D<unsigned short int> numIso;
		std::vector<Vect3D<float> > offSet;

		float b0;
		std::vector<std::complex<float> >	aveB1Plus; // Average B1Plus within the VOI. Vector index indicates coil number.
		float								aveB1Mins; // Average B1Mins within the VOI. Vector index indicates voxel number.
		std::vector<float>					sumB1Mins; // Summation of B1Mins of each voxel within the VOI. Vector index indicates voxel number.
		unsigned short int numRx, numTx; // Number of transmit and receive coils
		Vect3D<float> min;
		Vect3D<float> max;
		Vect3D<float> wid;
	};

	class Sequence
	{
	public:
		std::vector<float> time;
		std::vector<int> acq;
		std::vector<std::vector<std::complex<float> > > rf; // [coil][timeIndex] first index references coil number, second references the timestep
		std::vector<std::vector<float> > delFreq; // [coil][timeIndex]
		std::vector<float> gX, gY, gZ;
	};

private:
	Info info;

	std::vector<Voxel> phantom;
	Sequence sequence;

	std::vector<std::vector<std::complex<float> > > kSpace; // [Rx][# of data in k-space]
	std::vector<Vect3D<float> > kMap;

	// these are functions to initialize the receiving data structures
	bool initPhantomInfo(CmdInterp & cmdInterp, SeqnIn & seqnIn, GeomIn & geomIn);
	bool initPhantomSeqn(const SeqnIn & seqnIn);
	bool initPhantomGeom(const GeomIn & geomIn);
	bool initPhantomIso();
	bool initPhantomTiss(const TissIn & tissIn);
	bool initPhantomMagn();
	bool initPhantomDMagn();
	bool initPhantomDPhi();
	bool initPhantomB1Mins(const B1MinsIn & b1MinsIn);
	bool initPhantomB1Plus(const B1PlusIn & b1PlusIn);
	bool initPhantomAveB1Mins();
	bool initPhantomAveB1Plus(const float & aveB1Mins, const std::vector<float> & sumB1Mins);
	bool initPhantomDelB0(const DelB0In & delB0In);
	bool initPhantomDelTemp(const DelTempIn & delTempIn);
	bool initPhantomDelGrad(DelGradIn delGradXIn, DelGradIn delGradYIn, DelGradIn delGradZIn);
	bool initPhantomBeff();

public:

	bool initFlag;

	// The Execution constructor will call each of the file input routines, putting all of the required data
	// for the simulation in the appropriate locations.
	Execution(CmdInterp & cmdInterp);
	~Execution();

	// these functions will output the final k-map and k-space files
	bool expPhantomKMap(CmdInterp & cmdInterp);
	bool expPhantomKSpace(CmdInterp & cmdInterp);

	// 'get' functions
	Info & getInfo(){ return info; }; // NOTE: Using '&' increases performance, but 'const' can't be used.
	const std::vector<Voxel> & getPhantom() const { return phantom; };
	Sequence & getSequence(){ return sequence; };  // NOTE: Using '&' increases performance, but 'const' can't be used.

	void setKSpace(const std::vector<std::vector<std::complex<float> > > & kSpaceData) { kSpace = kSpaceData; };
	void setKMap(const std::vector<Vect3D<float> > & kMapData) { kMap = kMapData; };
};

#endif /* EXECUTION_H */
