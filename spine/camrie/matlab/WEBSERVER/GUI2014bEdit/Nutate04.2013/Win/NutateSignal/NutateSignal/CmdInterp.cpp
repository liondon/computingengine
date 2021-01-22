/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: CmdInterp.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 18:54:15 $
  Version:   $Revision: 1.2 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"CmdInterp.h"
#include <exception>

// ------------------------------------------------------------------------------

static void initCmdMap()	// :TODO: make this a member function? YES
{
	cmdMap["Thread"] = cmd_thread;
	cmdMap["B0"] = cmd_b0;
	cmdMap["xMin"] = cmd_xMin;
	cmdMap["xMax"] = cmd_xMax;
	cmdMap["yMin"] = cmd_yMin;
	cmdMap["yMax"] = cmd_yMax;
	cmdMap["zMin"] = cmd_zMin;
	cmdMap["zMax"] = cmd_zMax;
	cmdMap["xCtr"] = cmd_xCtr;
	cmdMap["yCtr"] = cmd_yCtr;
	cmdMap["zCtr"] = cmd_zCtr;
	cmdMap["xWid"] = cmd_xWid;
	cmdMap["yWid"] = cmd_yWid;
	cmdMap["zWid"] = cmd_zWid;
	cmdMap["TissueTypeFile"] = cmd_tiss;
	cmdMap["GeometryFile"] = cmd_geom;
	cmdMap["DelB0File"] = cmd_delB0;
	cmdMap["B1PlusFile"] = cmd_b1Plus;
	cmdMap["B1MinsFile"] = cmd_b1Mins;
	cmdMap["DelTempFile"] = cmd_delTemp;
	cmdMap["DelGxFile"] = cmd_delGx;
	cmdMap["DelGyFile"] = cmd_delGy;
	cmdMap["DelGzFile"] = cmd_delGz;
	cmdMap["KSpaceFile"] = cmd_kSpace;
	cmdMap["KMapFile"] = cmd_kMap;
	cmdMap["SequenceFile"] = cmd_seqn;
	cmdMap["NumIsoX"] = cmd_numIsoX;
	cmdMap["NumIsoY"] = cmd_numIsoY;
	cmdMap["NumIsoZ"] = cmd_numIsoZ;
}

// ------------------------------------------------------------------------------

CmdInterp::CmdInterp()
{
	// Default constructor: Set all default values.
	cmdValues.b1Mins.clear();
	cmdValues.b1Plus.clear();

	cmdValues.delTemp.clear();
	
	cmdValues.delGx.clear();
	cmdValues.delGy.clear();
	cmdValues.delGz.clear();
	
	cmdValues.kMap = "kMap.bin";
	cmdValues.kSpace = "kSpace.bin";
	cmdValues.delB0.clear();
	cmdValues.tiss.clear();
	cmdValues.geom.clear();
	cmdValues.seqn.clear();

	cmdValues.thread = 1;
	cmdValues.b0 = 3;
	cmdValues.min = 0;	cmdValues.max = 0;
	cmdValues.wid= 0;
	cmdValues.ctr = 0;

	cmdValues.numIsoX = 1;
	cmdValues.numIsoY = 1;
	cmdValues.numIsoZ = 1;

	// Set default flags (false = no cmd input).

	cmdFlags.kMap = false;
	cmdFlags.kSpace = false;
	cmdFlags.delB0 = false;
	cmdFlags.b1Plus = false;
	cmdFlags.b1Mins = false;

	cmdFlags.delTemp = false;

	cmdFlags.delGx = false;
	cmdFlags.delGy = false;
	cmdFlags.delGz = false;

	cmdFlags.tiss = false;
	cmdFlags.geom = false;
	cmdFlags.seqn = false;

	cmdFlags.thread = false;
	cmdFlags.b0 = false;
	cmdFlags.min = false;	cmdFlags.max = false;
	cmdFlags.wid = false;
	cmdFlags.ctr = false;

	cmdFlags.numIsoX = false;
	cmdFlags.numIsoY = false;
	cmdFlags.numIsoZ = false;
}

CmdInterp::~CmdInterp()
{
	cmdValues.b1Plus.clear();
	cmdValues.b1Mins.clear();
}

// ------------------------------------------------------------------------------

bool CmdInterp::interpCmd(int argc, char *argv[])
{

	std::string option;
	std::string parameter;
	size_t ptr;

	initCmdMap();

	for (int count = 1; count < argc; count++)
	{
		option = argv[count];								// fill the "option" string with the entire line, for example option will contain "b0=3.0"
		ptr = option.find("=");								// find the '=' sign in the option string
		parameter = option.substr(ptr + 1);					// place everything after the '=' sign in the "parameter" string. now, option = "b0=3.0" and parameter = "3.0"
		option.erase(option.begin() + ptr, option.end());	// remove everything after and including the '=' sign. now, option = "b0" and parameter = "3.0"

		static std::map<std::string, StringValue>::iterator it;
		try
		{
			it = cmdMap.find(option);
			if (it == cmdMap.end())
			{
				// if the command line input does not match a value in the map, throw error with the text from erroneous command line input
				throw option;
			}
			else
			{
				switch (it->second) // :TODO: (not by jmm) If the match is incomplete, error occurs here, need to fix, April 28, 2009.
				{
					// find the matching value and assign command line parameters where appropriate
					case cmd_thread:
						cmdValues.thread = (unsigned short int)strtod(parameter.c_str(), NULL);
						cmdFlags.thread = true;
						break;

					case cmd_b0:
						cmdValues.b0 = (float)strtod(parameter.c_str(), NULL);
						cmdFlags.b0 = true;
						break;

					case cmd_xMin:
						cmdValues.min.x = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.min.x = true;
						break;

					case cmd_xMax:
						cmdValues.max.x = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.max.x = true;
						break;

					case cmd_yMin:
						cmdValues.min.y = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.min.y = true;
						break;

					case cmd_yMax:
						cmdValues.max.y = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.max.y = true;
						break;

					case cmd_zMin:
						cmdValues.min.z = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.min.z = true;
						break;

					case cmd_zMax:
						cmdValues.max.z = (float)strtol(parameter.c_str(), NULL, 0);
						cmdFlags.max.z = true;
						break;

					case cmd_xWid:
						cmdValues.wid.x = (float)strtod(parameter.c_str(), NULL);
						cmdFlags.wid.x = true;
						break;

					case cmd_yWid:
						cmdValues.wid.y = (float)strtod(parameter.c_str(), NULL);
						cmdFlags.wid.y = true;
						break;

					case cmd_zWid:
						cmdValues.wid.z = (float)strtod(parameter.c_str(), NULL);
						cmdFlags.wid.z = true;
						break;

					case cmd_xCtr:
						cmdValues.ctr.x = (float)strtod(parameter.c_str(), NULL);
						cmdFlags.ctr.x = true;
						break;

					case cmd_yCtr:
						cmdValues.ctr.y = (float)strtod(parameter.c_str(), NULL);
						cmdFlags.ctr.y = true;
						break;

					case cmd_zCtr:
						cmdValues.ctr.z = (float)strtod(parameter.c_str(), NULL);
						cmdFlags.ctr.z = true;
						break;

					case cmd_tiss:
						cmdValues.tiss = parameter;
						cmdFlags.tiss = true;
						break;

					case cmd_geom:
						cmdValues.geom = parameter;
						cmdFlags.geom = true;
						break;

					case cmd_seqn:
						cmdValues.seqn = parameter;
						cmdFlags.seqn = true;
						break;

					case cmd_delB0:
						cmdValues.delB0 = parameter;
						cmdFlags.delB0 = true;
						break;

					case cmd_b1Plus:
						cmdValues.b1Plus.push_back(parameter);
						cmdFlags.b1Plus = cmdFlags.b1Plus || true;
						break;

					case cmd_b1Mins:
						cmdValues.b1Mins.push_back(parameter);
						cmdFlags.b1Mins = cmdFlags.b1Mins || true;
						break;

					case cmd_delTemp:
						cmdValues.delTemp = parameter;
						cmdFlags.delTemp = true;
						break;

					case cmd_delGx:
						cmdValues.delGx = parameter;
						cmdFlags.delGx = true;
						break;
					
					case cmd_delGy:
						cmdValues.delGy = parameter;
						cmdFlags.delGy = true;
						break;
					
					case cmd_delGz:
						cmdValues.delGz = parameter;
						cmdFlags.delGz = true;
						break;

					case cmd_kSpace:
						cmdValues.kSpace = parameter;
						cmdFlags.kSpace = true;
						break;

					case cmd_kMap:
						cmdValues.kMap = parameter;
						cmdFlags.kMap = true;
						break;

					case cmd_numIsoX: // Number of Isochromats in each direction.
						cmdValues.numIsoX = (unsigned short int)strtod(parameter.c_str(), NULL);
						cmdFlags.numIsoX = true;
						break;

					case cmd_numIsoY: // Number of Isochromats in each direction.
						cmdValues.numIsoY = (unsigned short int)strtod(parameter.c_str(), NULL);
						cmdFlags.numIsoY = true;
						break;

					case cmd_numIsoZ: // Number of Isochromats in each direction.
						cmdValues.numIsoZ = (unsigned short int)strtod(parameter.c_str(), NULL);
						cmdFlags.numIsoZ = true;
						break;

					default:
						std::cout << "\nFATAL ERROR: Map value found that does not exist in switch statement.\n";
						std::cout << "Debug file CmdInterp.cpp, function CmdInterp(int arc, char *argv[]).\n";
						std::cout << "Problem argv input: " << argv[count] << "\nPress enter to quit.\n";
						std::cin.get();
						return false;
						break;
				} /* switch (it->second) */
			} /* if (it == cmdMap.end()) */
		}
		catch (...)
		{
			std::cout << "\nError: command line option not recognized: \"" << argv[count] << "\"" << std::endl;
			std::cout << "Correct errors and re-run.\nPress enter to quit."<< std::endl;
			std::cin.get();
			return false;
		} /* try */
	} /* for (int count = 1; count < argc; count++) */

	return checkFileNames();
} /* bool CmdInterp(int argc, char *argv[]) */

// ------------------------------------------------------------------------------

bool CmdInterp::checkFileNames()
{
	std::fstream fHandle;
	std::string str;

	// ****************************************************************
	// Test only whether the required files are input with file names. // :TODO: don't need to do '== 0' below - strcmp returns boolean
	if ( !strcmp(cmdValues.tiss.c_str(), NULLSTR.c_str()) || !strcmp(cmdValues.geom.c_str(), NULLSTR.c_str()) || !strcmp(cmdValues.seqn.c_str(), NULLSTR.c_str()) )
	{
		std::cout << "Error: Tissue type file, geometry file, and sequence file names must ALL be supplied\n";
		std::cout << "Press enter to quit.";
		std::cin.get();
		return false;
	}

	// ****************************************************************
	// make sure geometry file exist
	str = cmdValues.geom;
	fHandle.open(str.c_str(), std::ios::in | std::ios::binary);
	if (fHandle.fail()) 
	{
		fHandle.close();
		std::cout << "\nError opening geometry file!\n";
		std::cout << "Verify file: " << str << " exists\n";
		std::cout << "Press enter to quit.";
		std::cin.get();
		return false;
	}
	fHandle.close();

	// ****************************************************************
	// make sure tissue file exist
	str = cmdValues.tiss;
	fHandle.open(str.c_str(), std::ios::in | std::ios::binary);
	if (fHandle.fail()) 
	{
		fHandle.close();
		std::cout << "\nError opening tissue file!\n";
		std::cout << "Verify file: " << str << " exists\n";
		std::cout << "Press enter to quit.";
		std::cin.get();
		return false;
	}
	fHandle.close();

	// ****************************************************************
	// make sure sequence file exist
	str = cmdValues.seqn;
	fHandle.open(str.c_str(), std::ios::in | std::ios::binary);
	if (fHandle.fail()) 
	{
		fHandle.close();
		std::cout << "\nError opening sequence file!\n";
		std::cout << "Verify file: " << str << " exists\n";
		std::cout << "Press enter to quit.";
		std::cin.get();
		return false;
	}
	fHandle.close();

	return true;
}

// ------------------------------------------------------------------------------
