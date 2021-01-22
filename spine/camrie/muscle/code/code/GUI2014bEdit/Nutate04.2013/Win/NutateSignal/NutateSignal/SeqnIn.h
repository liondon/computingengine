/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: SeqnIn.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef SEQNIN_H
#define SEQNIN_H

#include<vector>
#include<complex>
#include<string>

#include "CmdInterp.h"

/* *******************************

1) A sequence file is written as:

Total # of Data
# Tx
# Rx

:TODO: confirm this file structure and make layout more clear

Time		Acq			RF(vector<complex>+ delFreq)	Gx			Gy			Gz
#lines		#lines		#lines							#lines		#lines		#lines
#repts		#repts		#repts							#repts		#repts		#repts
...

******************************* */

// class SeqnIn is designed to handle all aspects of file input regarding the
// sequence file. This includes header as well as data information.
class SeqnIn
{
private:
	class SeqnHeader
	{
	public:
		unsigned int totNumData;
		unsigned short int numRx, numTx;
	} seqnHeader;

	std::vector<float> time;
	std::vector<int> acq;
	std::vector<std::vector<std::complex<float> > > rf; // [coil][timeIndex]
	std::vector<std::vector<float> > delFreq; // [coil][timeIndex]
	std::vector<float> gX, gY, gZ;

	// these functions are called by the class's default constructor
	bool readSeqnHeader();
	bool readSeqnData();

public:

	bool seqnFlag;
	std::string fName;

	SeqnIn(CmdInterp & cmdInterp);
	~SeqnIn();
	
	// 'get' functions
	SeqnHeader & getSeqnHeader(){ return seqnHeader; }; // NOTE: Using '&' increases performance, but 'const' can't be used.
	const std::vector<float> & getTime() const { return time; };
	const std::vector<int> & getAcq() const { return acq; };
	const std::vector<std::vector<std::complex<float> > > & getRF() const { return rf; };
	const std::vector<std::vector<float> > & getDelFreq() const { return delFreq; };
	const std::vector<float> & getGx() const { return gX; }; 
	const std::vector<float> & getGy() const { return gY; };
	const std::vector<float> & getGz() const { return gZ; };
};

#endif /* SEQNFILEIN_H */
