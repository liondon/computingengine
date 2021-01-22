/*=========================================================================

  Program:   Nutate (This file is identical for all versions of PSUdo MRI)
  Module:    $RCSfile: Vect3D.cpp,v $
  Language:  C++
  Date:      $Date: 2009/12/09 19:52:34 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/
#ifndef _VECT3D_CPP
#define _VECT3D_CPP

#include "Vect3D.h"
#include<cmath>
#include<complex>

// ------------------------------------------------------------------------------

template<typename T>
bool Vect3D< T >::operator< (const Vect3D<T> & vect)
{
	return ((x < vect.x) && (y < vect.y) && (z < vect.z));
}
template bool Vect3D<float>::operator< (const Vect3D<float> & vect);

// ------------------------------------------------------------------------------

template<typename T>
bool Vect3D< T >::operator<= (const Vect3D<T> & vect)
{
	return ((x <= vect.x) && (y <= vect.y) && (z <= vect.z));
}
template bool Vect3D<float>::operator<= (const Vect3D<float> & vect);

// ------------------------------------------------------------------------------

template<typename T>
bool Vect3D< T >::operator> (const Vect3D<T> & vect)
{
	return ((x > vect.x) && (y > vect.y) && (z > vect.z));
}
template bool Vect3D<float>::operator> (const Vect3D<float> & vect);

// ------------------------------------------------------------------------------

template<typename T>
bool Vect3D< T >::operator>= (const Vect3D<T> & vect)
{
	return ((x >= vect.x) && (y >= vect.y) && (z >= vect.z));
}
template bool Vect3D<float>::operator>= (const Vect3D<float> & vect);

// ------------------------------------------------------------------------------

template<typename T>
bool Vect3D< T >::operator== (const Vect3D<T> & vect)
{
	return ((x == vect.x) && (y == vect.y) && (z == vect.z));
}
template bool Vect3D<float>::operator== (const Vect3D<float> & vect);

// ------------------------------------------------------------------------------

template<typename T>
bool Vect3D< T >::operator== (T input)
{
	return ((x == input) && (y == input) && (z == input));
}
template bool Vect3D<float>::operator== (float input);

// ------------------------------------------------------------------------------

template<typename T>
bool Vect3D< T >::operator!= (const Vect3D<T> & vect)
{
	return ((x != vect.x) && (y != vect.y) && (z != vect.z));
}
template bool Vect3D<float>::operator!= (const Vect3D<float> & vect);

// ------------------------------------------------------------------------------

template<typename T>
bool Vect3D< T >::operator!= (T input)
{
	return ((x != input) && (y != input) && (z != input));
}
template bool Vect3D<float>::operator!= (float input);
// ------------------------------------------------------------------------------

template<typename T>
void Vect3D<T>::operator= (const Vect3D<T> & vect)
{
	x = vect.x;
	y = vect.y;
	z = vect.z;
}
template void Vect3D<int>::operator= (const Vect3D<int> & vect);
template void Vect3D<float>::operator= (const Vect3D<float> & vect);
template void Vect3D<bool>::operator= (const Vect3D<bool> & vect);

// ------------------------------------------------------------------------------

template<typename T>
void Vect3D<T>::operator= (T input)
{
	x = input; y = input; z = input;
}
template void Vect3D<int>::operator= (int input);
template void Vect3D<float>::operator= (float input);
template void Vect3D<bool>::operator= (bool input);

// ------------------------------------------------------------------------------

template<typename T>
Vect3D< T > Vect3D< T >::operator+ (const Vect3D<T> & vect)
{
	Vect3D temp;
	temp.x = x + vect.x;
	temp.y = y + vect.y;
	temp.z = z + vect.z;
	return temp;
}
template Vect3D<float> Vect3D<float>::operator+ (const Vect3D<float> & vect);

// ------------------------------------------------------------------------------

template<typename T>
void Vect3D<T>::operator+= (const Vect3D<T> & vect)
{
	x += vect.x;
	y += vect.y;
	z += vect.z;
}

// ------------------------------------------------------------------------------

template<typename T>
Vect3D<T> Vect3D<T>::operator- (const Vect3D<T> & vect)
{
	Vect3D temp;
	temp.x = x - vect.x;
	temp.y = y - vect.y;
	temp.z = z - vect.z;
	return temp;
}
template Vect3D<float> Vect3D<float>::operator- (const Vect3D<float> & vect);

// ------------------------------------------------------------------------------

template<typename T>
void Vect3D<T>::operator-= (const Vect3D<T> & vect)
{
	x -= vect.x;
	y -= vect.y;
	z -= vect.z;
}
template void Vect3D<float>::operator-= (const Vect3D<float> & vect);

// ------------------------------------------------------------------------------

template<typename T>
Vect3D<T> Vect3D<T>::operator* (T param)
{
	Vect3D<T> temp;
	temp.x = x * param;
	temp.y = y * param;
	temp.z = z * param;
	return temp;
}
template Vect3D<float> Vect3D<float>::operator* (float param);


// ------------------------------------------------------------------------------

template<typename T>
T Vect3D<T>::operator* (const Vect3D<T> & vect) const
{
	return (x*vect.x+y*vect.y+z*vect.z);
}
template float Vect3D<float>::operator* (const Vect3D<float> & param) const;


// ------------------------------------------------------------------------------

template<typename T>
Vect3D<T> Vect3D<T>::operator/ (T param)
{
	Vect3D<T> temp;
	temp.x = x / param;
	temp.y = y / param;
	temp.z = z / param;
	return temp;
}
template Vect3D<float> Vect3D<float>::operator/ (float param);
template Vect3D<std::complex<float> > Vect3D<std::complex<float> >::operator/ (std::complex<float> param);
// ------------------------------------------------------------------------------

template< typename T>
void Vect3D< T >::operator*= (T param)
{
	x *= param;
	y *= param;
	z *= param;
}

// ------------------------------------------------------------------------------

template< typename T >
T Vect3D< T >::getTransNorm()
{
	T temp;
	temp = (T) sqrt(x*x + y*y);
	return temp;
}
template float Vect3D<float>::getTransNorm();

// ------------------------------------------------------------------------------

template< typename T >
T Vect3D< T >::getTransNorm2()
{
	T temp;
	temp = (T)(x*x + y*y);
	return temp;
}
template float Vect3D<float>::getTransNorm2();

// ------------------------------------------------------------------------------

template< typename T >
T Vect3D< T >::getNorm()
{
	T temp;
	temp = (T) sqrt(x*x + y*y + z*z);
	return temp;
}
template float Vect3D<float>::getNorm();

// ------------------------------------------------------------------------------

template< typename T >
float Vect3D< T >::getNorm2()
{
	// Changed by DCB -- without using std::abs, the float value is cast to an int!
	float temp = (float) (pow(std::abs(x),2) + pow(std::abs(y),2) + pow(std::abs(z),2));
	return temp;
}
template float Vect3D<std::complex<float> >::getNorm2();
template float Vect3D<float>::getNorm2();

// ------------------------------------------------------------------------------

template<typename T>
void rotate(Vect3D<T> & vect, Vect3D<T> & axis, T theta)
{
	if (!(axis == 0))
	{
		float a;
		a = sin(theta);
		float b;
		b = cos(theta);

		float x;
		x = vect.x;
		float y;
		y = vect.y;
		float z;
		z = vect.z;

		// :TODO: remove this old code?
		//if ( (axis.x == 0) && (axis.y == 0) )
		//{
		//	temp.x =  x*b - y*a;
		//	temp.y =  x*a + y*b;
		//	temp.z =  z;
		//}
		//else if ( (axis.y == 0) && (axis.z == 0) )
		//{
		//	// By convention, RF pulses with 0 phase are all in x direction.
		//	temp.x =  x;
		//	temp.y =  y*b - z*a;
		//	temp.z =  y*a + z*b;
		//}
		//else
		//{
			// Equation obtained from "Rotations about the origin":
			// http://inside.mines.edu/~gmurray/ArbitraryAxisRotation/ArbitraryAxisRotation.html

		// :TODO: site a source for these equations?
			float u;
			u = axis.x;
			float v;
			v = axis.y;
			float w;
			w = axis.z;

			float temp1;
			temp1 = sqrt(u*u+v*v+w*w);
			float temp2;
			temp2 = 1/(u*u+v*v+w*w);
			float temp3;
			temp3 = u*x+v*y+w*z;

			vect.x = ( u*temp3 + (x*(v*v+w*w)-u*(v*y+w*z))*b + temp1*(-w*y+v*z)*a ) * temp2;
			vect.y = ( v*temp3 + (y*(u*u+w*w)-v*(u*x+w*z))*b + temp1*( w*x-u*z)*a ) * temp2;
			vect.z = ( w*temp3 + (z*(u*u+v*v)-w*(u*x+v*y))*b + temp1*(-v*x+u*y)*a ) * temp2;
		//};
	}

}
template void rotate(Vect3D<float> & vect, Vect3D<float> & axis, float theta);

// ------------------------------------------------------------------------------

#endif /* _VECT3D_CPP */
