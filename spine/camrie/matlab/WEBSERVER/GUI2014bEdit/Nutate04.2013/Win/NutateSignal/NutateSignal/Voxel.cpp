/*=========================================================================

  Program:   NutateSignal
  Module:    $RCSfile: Voxel.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 19:52:34 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#include"Voxel.h"
#include<iostream>

// Determine how to handle intravodel dephasing and multi-isochromats.
#define SIMPLE_ACQ
//#define Z_ACQ
//#define COMPLEX_ACQ

// Determine how RF is calibrated.
#define SIMPLE_TX
//#define ADV_TX

// ------------------------------------------------------------------------------

Voxel::Voxel()
{
	magn  = 0;		// magnetization vector
	magn0 = 0;		// magnetization (z-direction) at equilibrium
	beff  = 0;		// b-effective

	// derivative of magnetization in 3 directions and frequency direction
	dxMagn = 0;
	dyMagn = 0;
	dzMagn = 0;
	dwMagn = 0;
	
	// derivative of Phi in 3 directions and frequency direction
	dxPhi = 0;
	dyPhi = 0;
	dzPhi = 0;
	dwPhi = 0;
}

// ------------------------------------------------------------------------------

Voxel::~Voxel()
{
	bInfo.b1Mins.clear();
	bInfo.b1Plus.clear();
}

bool Voxel::setTiss(const std::map<int, TissType> & tissMap) 
{
	TissType tissType;
	std::map<int, TissType>::const_iterator itr;
	itr = tissMap.find(geomInfo.id);
	if ( itr != tissMap.end() )
	{
		tissType = itr->second;

		assert(tissType.t1 >= 0.0 && tissType.t2 >= 0.0 && tissType.rho >= 0.0);

		tissInfo.t1 = tissType.t1;
		tissInfo.t2 = tissType.t2;
		tissInfo.rho = tissType.rho;
		tissInfo.sigmaChem = tissType.sigmaChem;

		return true;
	}
	else
	{
		std::cout<< "Fatal Error:Tissue Id=" << geomInfo.id << " cannot be found in Tissue Type File." << std::endl;
		return false;
	}
}

// ------------------------------------------------------------------------------

bool Voxel::setDelB0(float delB0, const Vect3D<float> & devDelB0, float b0)
{
	// all multiplications below by 1x10^(-6) are done to convert from parts-per-million(ppm)
	bInfo.devDelB0.x = (float) (0.000001 * devDelB0.x * b0);
	bInfo.devDelB0.y = (float) (0.000001 * devDelB0.y * b0);
	bInfo.devDelB0.z = (float) (0.000001 * devDelB0.z * b0);
	bInfo.delB0 = (float) (0.000001 * (delB0 - tissInfo.sigmaChem) * b0);
	return true;
}

// ------------------------------------------------------------------------------

bool Voxel::setDelB0(float delB0, const Vect3D<float> & devDelB0, float b0, Vect3D<float> offset, Vect3D<float> wid)
{
	// all multiplications below by 1x10^(-6) are done to convert from parts-per-million(ppm)
	bInfo.devDelB0.x = (float) (0.000001 * devDelB0.x * b0);
	bInfo.devDelB0.y = (float) (0.000001 * devDelB0.y * b0);
	bInfo.devDelB0.z = (float) (0.000001 * devDelB0.z * b0);
	bInfo.delB0 = (float) (0.000001 * (delB0 - tissInfo.sigmaChem) * b0 
		+ bInfo.devDelB0.x * offset.x * wid.x + bInfo.devDelB0.y * offset.y * wid.y + bInfo.devDelB0.z * offset.z * wid.z);
	return true;
}

// ------------------------------------------------------------------------------

bool Voxel::setDelTemp(float delTemp)
{
	tempInfo.delTemp = (float) delTemp;
	return true;
}

// ------------------------------------------------------------------------------

bool Voxel::setDelTemp(float delTemp, Vect3D<float> offset)
{
	tempInfo.delTemp = (float) delTemp;
	return true;
}

// ------------------------------------------------------------------------------

bool Voxel::setDelGradX(float delGradX)
{
	bInfo.delGradX = delGradX;
	return true;
}

bool Voxel::setDelGradY(float delGradY)
{
	bInfo.delGradY = delGradY;
	return true;
}

bool Voxel::setDelGradZ(float delGradZ)
{
	bInfo.delGradZ = delGradZ;
	return true;
}

// ------------------------------------------------------------------------------

bool Voxel::setB1Plus(const std::vector<std::complex<float> > & b1Plus)
{
	// the 'b1Plus' vector's index indicates the number of the coil causing the B1+ distribution
	for (unsigned int n=0; n<b1Plus.size(); n++)
	{
		bInfo.b1Plus.push_back(b1Plus[n]);
	}
	return true;
}

// ------------------------------------------------------------------------------

bool Voxel::setB1Mins(const std::vector<std::complex<float> > & b1Mins) // [Coil]
{
	// the 'b1Mins' vector's index indicates the number of the coil causing the B1- distribution
	for (unsigned int n=0; n<b1Mins.size(); n++)
	{
		bInfo.b1Mins.push_back(b1Mins[n]);
	}
	return true;
}

// ------------------------------------------------------------------------------

/*********************************************************************************************************** 
* B_eff Calculation:
*
* B_eff_x = Re ( voltage * b1_plus ) ;
* B_eff_y = Im ( voltage * b1_plus ) ;
* B_eff_z = dB0 + ( widX * posX * Gx * DelGradX + widY * posY * Gy * DelGradY + widZ * posZ * Gz * DelGradZ ) ;
* Units: wid is in m; G is in T/m.
************************************************************************************************************/
bool Voxel::calBeff(const std::vector<std::complex<float> > & rf, const std::vector<float> & delFreq, const Vect3D<float> & grad, const std::vector<std::complex<float> > & aveB1Plus, const Vect3D<float> & wid, const Vect3D<float> & offSet)
{
	assert(rf.size() == bInfo.b1Plus.size()); // :TODO: this is probably not the best place to do this check since it is called so many times FIND NEW PLACE

	std::complex<double> temp;
	temp = std::complex<double> (0,0);
	beff = 0;

	for (unsigned int n = 0; n < rf.size(); n++) // for each rf coil
	{
		if (rf[n] != std::complex<float> (0,0))
		{
#ifdef ADV_TX
			temp += (std::complex<double>) ((rf[n] * bInfo.b1Plus[n]) / (std::complex<float>((float)5.8718524e-007,0))); // Arbitrary Constant (Scaling Factor)
#endif
#ifdef SIMPLE_TX
			temp += (std::complex<double>) (rf[n] * bInfo.b1Plus[n] / aveB1Plus[n]); // this will cause problem for paralellism with inhomogeneous B1+.
#endif
		}

		// This is assuming all Tx channels are driving with same frequency offsets.
		beff.z -= delFreq[n] / ((float)rf.size())/(GAMMA /(float)2/PI);
	}

	beff.x = (float) real(temp);
	beff.y = (float) imag(temp);
	beff.z += (float)(bInfo.delB0 +
		wid.x * (geomInfo.pos.x + offSet.x) * ((float)1.0 + bInfo.delGradX) * grad.x + 
		wid.y * (geomInfo.pos.y + offSet.y) * ((float)1.0 + bInfo.delGradY) * grad.y + 
		wid.z * (geomInfo.pos.z + offSet.z) * ((float)1.0 + bInfo.delGradZ) * grad.z);
	return true;
}

// ------------------------------------------------------------------------------
void Voxel::updateDMagn(const Vect3D<float> & grad, float time)
{
	float thetaRF, thetaZ;
	thetaRF = (float) -(GAMMA * time * beff.getTransNorm()); // Time in s.
	thetaZ = (float) (GAMMA * time * beff.z); // Time in s.
	Vect3D<float> tempBeffTrans;
	tempBeffTrans.x = beff.x; tempBeffTrans.y = beff.y; tempBeffTrans.z = 0;
	Vect3D<float> tempDxMagn, tempDyMagn, tempDzMagn, tempDwMagn;

	tempDxMagn.x = time*GAMMA*(grad.x*((float)1.0+bInfo.delGradX)+bInfo.devDelB0.x)*(-sin(thetaZ)*magn.x+cos(thetaZ)*magn.y) + cos(thetaZ)*dxMagn.x + sin(thetaZ)*dxMagn.y;
	tempDxMagn.y = time*GAMMA*(grad.x*((float)1.0+bInfo.delGradX)+bInfo.devDelB0.x)*(-cos(thetaZ)*magn.x-sin(thetaZ)*magn.y) - sin(thetaZ)*dxMagn.x + cos(thetaZ)*dxMagn.y;
	tempDxMagn.z = dxMagn.z;
	rotate(tempDxMagn, tempBeffTrans, thetaRF);
	tempDxMagn.x = tempDxMagn.x * exp(-time/tissInfo.t2);
	tempDxMagn.y = tempDxMagn.y * exp(-time/tissInfo.t2);
	tempDxMagn.z = tempDxMagn.z * exp(-time/tissInfo.t1);

	tempDyMagn.x = time*GAMMA*(grad.y*((float)1.0+bInfo.delGradY)+bInfo.devDelB0.y)*(-sin(thetaZ)*magn.x+cos(thetaZ)*magn.y) + cos(thetaZ)*dyMagn.x + sin(thetaZ)*dyMagn.y;
	tempDyMagn.y = time*GAMMA*(grad.y*((float)1.0+bInfo.delGradY)+bInfo.devDelB0.y)*(-cos(thetaZ)*magn.x-sin(thetaZ)*magn.y) - sin(thetaZ)*dyMagn.x + cos(thetaZ)*dyMagn.y;
	tempDyMagn.z = dyMagn.z;
	rotate(tempDyMagn, tempBeffTrans, thetaRF);
	tempDyMagn.x = tempDyMagn.x * exp(-time/tissInfo.t2);
	tempDyMagn.y = tempDyMagn.y * exp(-time/tissInfo.t2);
	tempDyMagn.z = tempDyMagn.z * exp(-time/tissInfo.t1);

	tempDzMagn.x = time*GAMMA*(grad.z*((float)1.0+bInfo.delGradZ)+bInfo.devDelB0.z)*(-sin(thetaZ)*magn.x+cos(thetaZ)*magn.y) + cos(thetaZ)*dzMagn.x + sin(thetaZ)*dzMagn.y;
	tempDzMagn.y = time*GAMMA*(grad.z*((float)1.0+bInfo.delGradZ)+bInfo.devDelB0.z)*(-cos(thetaZ)*magn.x-sin(thetaZ)*magn.y) - sin(thetaZ)*dzMagn.x + cos(thetaZ)*dzMagn.y;
	tempDzMagn.z = dzMagn.z;
	rotate(tempDzMagn, tempBeffTrans, thetaRF);
	tempDzMagn.x = tempDzMagn.x * exp(-time/tissInfo.t2);
	tempDzMagn.y = tempDzMagn.y * exp(-time/tissInfo.t2);
	tempDzMagn.z = tempDzMagn.z * exp(-time/tissInfo.t1);

	tempDwMagn.x = time*(-sin(thetaZ)*magn.x+cos(thetaZ)*magn.y) + cos(thetaZ)*dwMagn.x + sin(thetaZ)*dwMagn.y;;
	tempDwMagn.y = time*(-cos(thetaZ)*magn.x-sin(thetaZ)*magn.y) - sin(thetaZ)*dwMagn.x + cos(thetaZ)*dwMagn.y;
	tempDwMagn.z = dwMagn.z;
	rotate(tempDwMagn, tempBeffTrans, thetaRF);
	tempDwMagn.x = tempDwMagn.x * exp(-time/tissInfo.t2);
	tempDwMagn.y = tempDwMagn.y * exp(-time/tissInfo.t2);
	tempDwMagn.z = tempDwMagn.z * exp(-time/tissInfo.t1);

	dxMagn = tempDxMagn;
	dyMagn = tempDyMagn;
	dzMagn = tempDzMagn;
	dwMagn = tempDwMagn;
}

// ------------------------------------------------------------------------------

void Voxel::calRot(float time)
{
	static float theta;
	theta = (float) -(GAMMA * time * beff.getNorm()); // Time in s.
	rotate(magn, beff, theta); 
}

// ------------------------------------------------------------------------------

void Voxel::calRot(float time, float b0)
{
	static float theta;
	theta = (float) -(GAMMA * time * beff.getNorm() + GAMMA * tempInfo.alpha * b0 * tempInfo.delTemp * time); // Time in s.
	rotate(magn, beff, theta); 
}

// ------------------------------------------------------------------------------

void Voxel::calRlx(float time)
{
	magn.x = magn.x * exp((-time)/tissInfo.t2);
	magn.y = magn.y * exp((-time)/tissInfo.t2);
	magn.z = magn0 - (magn0 - magn.z) * exp((-time)/tissInfo.t1);
}

// ------------------------------------------------------------------------------

bool Voxel::appRot(const Vect3D<float> & grad, float time)
{
#ifdef COMPLEX_MODE
	updateDMagn(grad, time);
#endif
#ifdef z_MODE
	updateDMagn(grad, time);
#endif

	if (!(beff == 0))
	{
		calRot(time);
	}
	calRlx(time);

	return true;
}

// ------------------------------------------------------------------------------

std::complex<float> Voxel::acqSignal(unsigned int coilIndex, const Vect3D<float> & wid, float b0, Vect3D<unsigned short int> numIso)
{
	//assert(coilIndex<bInfo.b1Mins.size()); // :TODO: not the best place to do this since this will be called often FIND NEW PLACE
	
	// Classical method of calculation (left in for reference)
#ifdef SIMPLE_ACQ
	return ( std::complex<float> (magn.x,magn.y) * conj(bInfo.b1Mins[coilIndex]) * GAMMA * (b0+bInfo.delB0)
		* (wid.x/((float)numIso.x)) * (wid.y/((float)numIso.y)) * (wid.z/((float)numIso.z)) );
#endif

#ifdef Z_ACQ
	updateDPhi();
	return ( std::complex<float> (magn.x,magn.y) * conj(bInfo.b1Mins[coilIndex]) * GAMMA * (b0+bInfo.delB0) 
		* (wid.x/((float)numIso.x)) * (wid.y/((float)numIso.y)) * (wid.z/((float)numIso.z))
		* sinc(wid.x/((float)numIso.x)*dxPhi/(float)2)
		* sinc(wid.y/((float)numIso.y)*dyPhi/(float)2));
		//* sinc( GAMMA * ( wid.x/((float)numIso.x)*bInfo.devDelB0.x + wid.y/((float)numIso.y)*bInfo.devDelB0.y + wid.z/((float)numIso.z)*bInfo.devDelB0.z ) * dwPhi/(float)2 ) );
#endif

#ifdef COMPLEX_ACQ
	updateDPhi();
	return ( std::complex<float> (magn.x,magn.y) * conj(bInfo.b1Mins[coilIndex]) * GAMMA * (b0+bInfo.delB0) 
		* (wid.x/((float)numIso.x)) * (wid.y/((float)numIso.y)) * (wid.z/((float)numIso.z))
		* sinc(wid.x/((float)numIso.x)*dxPhi/(float)2)
		* sinc(wid.y/((float)numIso.y)*dyPhi/(float)2)
		* sinc(wid.z/((float)numIso.z)*dzPhi/(float)2)
		* sinc( GAMMA * ( wid.x/((float)numIso.x)*bInfo.devDelB0.x + wid.y/((float)numIso.y)*bInfo.devDelB0.y + wid.z/((float)numIso.z)*bInfo.devDelB0.z ) * dwPhi/(float)2 ) ); // This line is used as standard.
#endif

}

// ------------------------------------------------------------------------------

void Voxel::updateDPhi()
{
	if (magn.x == 0 && magn.y == 0)
	{
		dxPhi = 0;
		dyPhi = 0;
		dzPhi = 0;
		dwPhi = 0;
	}
	else
	{
		dxPhi = ( magn.x*dxMagn.y - magn.y*dxMagn.x ) / magn.getTransNorm2();
		dyPhi = ( magn.x*dyMagn.y - magn.y*dyMagn.x ) / magn.getTransNorm2();
		dzPhi = ( magn.x*dzMagn.y - magn.y*dzMagn.x ) / magn.getTransNorm2();
		dwPhi = ( magn.x*dwMagn.y - magn.y*dwMagn.x ) / magn.getTransNorm2();
	}
}
