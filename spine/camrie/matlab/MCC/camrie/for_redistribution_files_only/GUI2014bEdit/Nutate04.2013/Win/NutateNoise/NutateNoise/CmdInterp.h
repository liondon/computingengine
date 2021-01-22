/*=========================================================================

  Program:   NutateNoise
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
	cmd_xMin,
	cmd_xMax,
	cmd_yMin,
	cmd_yMax,
	cmd_zMin,
	cmd_zMax,
	cmd_xWid,
	cmd_yWid,
	cmd_zWid,
	cmd_tiss,
	cmd_geom,
	cmd_e1Mins,
	cmd_kNoise,
	cmd_seqn,
	cmd_NEX,
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
	// as well as all E1 Minus file names as given in the command line input . It also
	// holds the min, max, and width values passed in via the command line.
	class CmdValues
	{
	public:
		std::string kNoise;

		std::vector<std::string> e1Mins;

		Vect3D<float> min, max;
		Vect3D<float> wid;

		std::string tiss;
		std::string geom;
		std::string seqn;

		unsigned short int NEX;
	} cmdValues;

	// class CmdFlags is full of boolean values that are initialized to false. These
	// flags become true only when their corresponding value has been read from the
	// command line.
	class CmdFlags
	{
	public:
		bool kNoise;

		bool e1Mins;

		Vect3D<bool> min, max;
		Vect3D<bool> wid;

		bool tiss;
		bool geom;
		bool seqn;

		bool NEX;
	} cmdFlags;

	// checkFileNames() verifies that all filenames taken from the command line actually exist
	// before attempting to read any file information
	bool checkFileNames();	

public:
	CmdInterp();

	// interpCmd() parses the command line and assigns parameters to the appropriate
	// buffer location in the cmdValues object
	bool interpCmd(int argc, char *argv[]);

	// 'Get' functions
	const CmdValues & getCmdValues() { return cmdValues; };
	const CmdFlags & getCmdFlags() { return cmdFlags; };
};

#endif /* CMDINTERP_H */
