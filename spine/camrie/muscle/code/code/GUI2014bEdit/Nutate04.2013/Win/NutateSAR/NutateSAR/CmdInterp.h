/*=========================================================================

  Program:   NutateSAR
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

// Value-Defintions of the different String values
enum StringValue
{	
	cmd_thread,
	cmd_xMin,
	cmd_xMax,
	cmd_yMin,
	cmd_yMax,
	cmd_zMin,
	cmd_zMax,
	cmd_tiss,
	cmd_geom,
	cmd_b1Plus,
	cmd_b1Mins,
	cmd_e1Plus,
	cmd_seqn,
	cmd_sarMap
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
	// class CmdValues holds file names for kNoise, tissue, geometry, and sequence files
	// as well as all E1 Plus file names as given in the command line input . It also
	// holds the min and max values passed in via the command line.
	class CmdValues
	{
	public:
		std::string sarMap;

		unsigned short int thread; // :TODO: why does the command line select number of threads? shouldn't this be determined by OpenMP?

		std::vector<std::string> b1Plus;
		std::vector<std::string> b1Mins;
		std::vector<std::string> e1Plus;

		Vect3D<float> min, max;

		// file names
		std::string tiss;
		std::string geom;
		std::string seqn;
	} cmdValues;

	// class CmdFlags is full of boolean values that are initialized to false. These
	// flags become true only when their corresponding value has been read from the
	// command line.
	class CmdFlags
	{
	public:
		bool sarMap;

		bool thread;

		bool b1Plus;
		bool b1Mins;
		bool e1Plus;

		Vect3D<bool> min, max;

		bool tiss;
		bool geom;
		bool seqn;
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
