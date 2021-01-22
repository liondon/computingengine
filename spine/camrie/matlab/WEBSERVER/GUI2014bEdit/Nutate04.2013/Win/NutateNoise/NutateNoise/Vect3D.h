/*=========================================================================

  Program:   Nutate (This file is identical for all versions of PSUdo MRI)
  Module:    $RCSfile: Vect3D.h,v $
  Language:  C++
  Date:      $Date: 2009/12/09 19:52:34 $
  Version:   $Revision: 1.3 $

  Copyright (c) The Pennsylvania State University. All rights reserved.

=========================================================================*/

#ifndef VECT3D_H
#define VECT3D_H

template<typename T>

// class Vect3D is defined in order to make mathematical vectors more easy to work with.
// The Vect3D class overloads several common operators in order to make vector math and
// vector comparison much easier. It also uses a template so that this class can be 
// instantiated for any numerical type (int, float, double, complex, etc.). There are also
// some functions that can be called to find different normal values of the vector.
class Vect3D
{
public:
	T x, y, z;

	bool operator< (const Vect3D<T> & vect);
	bool operator<= (const Vect3D<T> & vect);
	bool operator>= (const Vect3D<T> & vect);	
	bool operator> (const Vect3D<T> & vect);
	bool operator== (const Vect3D<T> & vect); bool operator== (T input);
	bool operator!= (const Vect3D<T> & vect); bool operator!= (T input);

	void operator= (const Vect3D<T> & vect); // -> why cannot use & ? Answer: use 'const'
	void operator= (T input);

	Vect3D<T> operator+ (const Vect3D<T> & vect);
	Vect3D<T> operator- (const Vect3D<T> & vect);
	T operator* (const Vect3D<T> & vect) const; // scalar dot product
	Vect3D<T> operator* (T param); // vector cross product
	Vect3D<T> operator/ (T param);
		
	void operator+= (const Vect3D<T> & vect);
	void operator-= (const Vect3D<T> & vect);
	void operator*= (T param);

	T getTransNorm();	// sqrt(x*x + y*y)
	T getTransNorm2();	// (x*x + y*y)
	T getNorm();		// sqrt(x*x + y*y + z*z)
	float getNorm2();	// (x*x + y*y + z*z)

};  /* class Vect3D */

// rotate will take one vector, 'vec', and rotate it about another, 'axis',
// by degree, 'theta'
template<typename T>
void rotate(Vect3D<T> & vec, Vect3D<T> & axis, T theta);

#include "Vect3D.cpp"

#endif /* VECT3D_H */

