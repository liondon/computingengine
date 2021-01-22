/*=========================================================================

  Program:   Nutate (This file is identical for all versions of PSUdo MRI)
  Module:    $RCSfile: TissIn.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 20:53:31 $
  Version:   $Revision: 1.4 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef TISSIN_H
#define TISSIN_H

#include<map>
#include<string>

#include "CmdInterp.h"
#include "TissType.h"

class TissIn
{
private:
	// tissMap maps tissue information to be keyed on the tissue ID number. The
	// map will use the ID to lookup an object of type TissType, holding all other
	// relevant information about each particular tissue type.
	std::map<int, TissType> tissMap;

	bool readTissData(); // to be called by the default constructor

public:
	bool tissFlag;
	std::string fName;

	TissIn(CmdInterp & cmdInterp);

	// 'get' function to return the tissue map for tissue property lookup
	const std::map<int, TissType> & getTissMap() const { return tissMap; };
};

#endif /* TISSIN_H */
