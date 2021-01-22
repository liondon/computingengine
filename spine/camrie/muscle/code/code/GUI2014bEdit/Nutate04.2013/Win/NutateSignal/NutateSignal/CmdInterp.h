/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: CmdInterp.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef CMDINTERP_H
#define CMDINTERP_H

#include<map>
#include<string>
#include<vector>
#include<iostream>
#include<fstream>

#include "Vect3D.h"
	
const std::string NULLSTR = "NULL";

// Value-Defintions of the different command line string values
enum StringValue
{
	cmd_thread,
	cmd_b0,
	cmd_xMin,
	cmd_xMax,
	cmd_yMin,
	cmd_yMax,
	cmd_zMin,
	cmd_zMax,
	cmd_xCtr,
	cmd_yCtr,
	cmd_zCtr,
	cmd_xWid,
	cmd_yWid,
	cmd_zWid,
	cmd_tiss,
	cmd_geom,
	cmd_delB0,
	cmd_b1Plus,
	cmd_b1Mins,
	cmd_delTemp,
	cmd_delGx,
	cmd_delGy,
	cmd_delGz,
	cmd_kSpace,
	cmd_kMap,
	cmd_seqn,
	cmd_numIsoX,
	cmd_numIsoY,
	cmd_numIsoZ
};

// Map from command line strings to StringValue enumeration values
static std::map<std::string, StringValue> cmdMap;

// function to link values in the cmdMap map
static void initCmdMap();	// :TODO: why is this function not a member function?

// class CmdInterp is for parsing and interpreting the command line input passed in
// via argc and argv
class CmdInterp
{
private:
	// class CmdValues holds all information passed in via the command line. This includes
	// file names, Volume Of Interest (VOI) limits, and other data from the command line.
	class CmdValues
	{
	public:
		std::string kMap;
		std::string kSpace;

		unsigned short int thread;
		float b0;
		std::string delB0;
		std::vector<std::string> b1Plus;
		std::vector<std::string> b1Mins;

		std::string delTemp;

		std::string delGx;
		std::string delGy;
		std::string delGz;

		Vect3D<float> min, max;
		Vect3D<float> ctr;
		Vect3D<float> wid;

		std::string tiss;
		std::string geom;
		std::string seqn;

		unsigned short int numIsoX;
		unsigned short int numIsoY;
		unsigned short int numIsoZ;
	} cmdValues;

	// class CmdFlags is full of boolean values that are initialized to false. These
	// flags become true only when their corresponding value has been read from the
	// command line.
	class CmdFlags
	{
	public:
		bool kMap;
		bool kSpace;

		bool thread;
		bool b0;
		bool delB0;
		bool b1Plus;
		bool b1Mins;

		bool delTemp;

		Vect3D<bool> min, max;
		Vect3D<bool> wid;
		Vect3D<bool> ctr;

		bool delGx;
		bool delGy;
		bool delGz;

		bool tiss;
		bool geom;
		bool seqn;

		bool numIsoX;
		bool numIsoY;
		bool numIsoZ;

	} cmdFlags;

	// checkCmd() verifies that all filenames taken from the command line actually exist
	// before attempting to read any file information
	bool checkFileNames();

public:
	CmdInterp();
	~CmdInterp();

	// interpCmd() parses the command line and assigns parameters to the appropriate
	// buffer location in the cmdValues object
	bool interpCmd(int argc, char *argv[]);

	// 'get' functions
	const CmdValues & getCmdValues() { return cmdValues; };
	const CmdFlags & getCmdFlags() { return cmdFlags; };
};

#endif /* CMDINTERP_H */
