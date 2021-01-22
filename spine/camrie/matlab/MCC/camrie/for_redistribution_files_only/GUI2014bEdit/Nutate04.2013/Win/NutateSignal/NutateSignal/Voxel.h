/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: Voxel.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 19:52:34 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef VOXEL_H
#define VOXEL_H

#include<complex>
#include<vector>
#include<cassert>
#include<map>

#include "Vect3D.h"
#include "TissType.h"
#include "Functions.h"

#define PI (float) 3.14159265358979323846264338327950288419716939937510
#define GAMMA (float) (42576000.0 * (float)2 * PI) // 267522209.9 /* rad/T/s */ // -> 42576000.0 /* Hz/T */
#define B1Pl (float)(PI/(float)2/GAMMA/0.001) /* T */ // -> 90 degree flip angle in 1ms.

// :TODO: this file is one of the most imortant for understanding the physics. Comments need to be detailed and descriptive. Need help adding comments.

// The parameters set in Voxel should be position dependent. (<--not by jmm) :TODO: explain this further
// class Voxel will hold all pertinent information about a single sample of tissue. Each voxel has an ID
// number referring to its particular tissue type, which is used to identify the properties of that tissue
// such as T1, T2, and so on. Each voxel also has a position, denoted by a Vect3D object which has x, y, and
// z coordinates.
class Voxel
{
private:
	// class TissInfo holds the tissue properties of the voxel.
	class TissInfo
	{
	public:
		float t1, t2, rho, sigmaChem, sigmaCon, rhoMass; // sigmaCon & rhoMass don't need unit conversion.
	};

	// class GeomInfo holds the x, y, and z position, and the tissue ID number
	class GeomInfo
	{
	public:	
		Vect3D<float> pos;
		unsigned int id;
	};

	// class BInfo holds the B1+ and B1- information for each coil in the simulation
	class BInfo
	{
	public:
		std::vector<std::complex<float> > b1Plus, b1Mins; // [Coil]

		float delB0;
		Vect3D<float> devDelB0;
		
		float delGradX, delGradY, delGradZ; 
		//float GCon; :TODO: future
	};

	class TempInfo
	{
	public:
		float delTemp;		
		float alpha;
	};

	Vect3D<float> magn;		// magnetization vector
	float magn0;			// magnetization (z-direction) at equilibrium
	Vect3D<float> beff;		// b-effective

	// derivative of magnetization in 3 directions and frequency direction
	Vect3D<float> dxMagn;
	Vect3D<float> dyMagn;
	Vect3D<float> dzMagn;
	Vect3D<float> dwMagn;
	
	// derivative of Phi in 3 directions and frequency direction
	float dxPhi;
	float dyPhi;
	float dzPhi;
	float dwPhi; 

public:
	Voxel();
	~Voxel();

	GeomInfo geomInfo;
	TissInfo tissInfo;
	BInfo bInfo;
	TempInfo tempInfo;

	void setMagn(const Vect3D<float> & magnToSet){ magn = magnToSet; };
	void setMagn(float x, float y) { magn.x = x; magn.y = y; };
	Vect3D<float> getMagn(){ return magn; };

	void setDxMagn(float x, float y, float z) { dxMagn.x = x; dxMagn.y = y; dxMagn.z = z; };
	void setDyMagn(float x, float y, float z) { dyMagn.x = x; dyMagn.y = y; dyMagn.z = z; };
	void setDzMagn(float x, float y, float z) { dzMagn.x = x; dzMagn.y = y; dzMagn.z = z; };
	void setDwMagn(float x, float y, float z) { dwMagn.x = x; dwMagn.y = y; dwMagn.z = z; }; 

	void setDxPhi(float value) { dxPhi = value; };
	void setDyPhi(float value) { dyPhi = value; };
	void setDzPhi(float value) { dzPhi = value; };
	void setDwPhi(float value) { dwPhi = value; };

	void updateDMagn(const Vect3D<float> & grad, float time);
	void updateDPhi();

	void setMagn0(float m0){ magn0 = m0; };
	float getMagn0(){ return magn0; };

	bool setTiss(const std::map<int, TissType> & tissMap);
	bool setB1Plus(const std::vector<std::complex<float> > & b1Plus);
	bool setB1Mins(const std::vector<std::complex<float> > & b1Mins);

	bool setDelB0(float delB0, const Vect3D<float> & devDelB0, float b0);
	bool setDelB0(float delB0, const Vect3D<float> & devDelB0, float b0, Vect3D<float> offset, Vect3D<float> wid);

	bool setDelTemp(float delTemp);
	bool setDelTemp(float delTemp, Vect3D<float> offset);

	bool setDelGradX(float gX);
	bool setDelGradY(float gY);
	bool setDelGradZ(float gZ);

	void initBeff() { beff = 0; };

	Vect3D<float> getBeff(){ return beff; };

	/*********************************************************************************************************** 
	* B_eff Calculation:
	*
	* B_eff_x = Re ( voltage * b1_plus ) ;
	* B_eff_y = Im ( voltage * b1_plus ) ;
	* B_eff_z = dB0 + ( widX * posX * Gx * DelGradX + widY * posY * Gy * DelGradY + widZ * posZ * Gz * DelGradZ ) ;
	* Units: wid is in m; G is in T/m.
	************************************************************************************************************/
	bool calBeff(const std::vector<std::complex<float> > & rf, const std::vector<float> & delFreq, const Vect3D<float> & grad, const std::vector<std::complex<float> > & aveB1Plus, const Vect3D<float> & wid, const Vect3D<float> & offSet);

	// :TODO: NEED more descriptive function names for these functions. If not changing the names, add comments about what they are doing.
	void calRot(float time); // Calculate Rotation
	void calRot(float time, float b0); // Calculate Rotation
	void calRlx(float time); // Calculate Relaxation
	bool appRot(const Vect3D<float> & grad, float time); // Apply Rotation

	std::complex<float> acqSignal(unsigned int coilIndex, const Vect3D<float> & wid, float b0, Vect3D<unsigned short int> numIso);

};  /* class Voxel*/

template<typename T>
std::complex<T> conjugate(const std::complex<T> & complexNum);

#endif /* VOXEL_H */

