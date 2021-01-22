#include<iostream>
#include<iomanip>
#include<fstream>
#include<complex>
#include<cmath>
#include<time.h>
using namespace std;
/*
void convert_Geom();	// converts head_geometry.txt to binary
void convert_dB0();		// converts head_geom_B0.txt to binary - must run convert_headGeom() before this
void convert_B1();      // converts head_B1_minus.txt to binary - must run convert_headGeom() before this
*/

void func2();// converts a file from .txt to .bin
void func3();// converts a file from .bin to .txt

int main()
{
	//convert_Geom();
	//convert_dB0();
	//convert_B1();
	func3();
	return 0;
}

void func3()
{
	fstream infile, outfile;
	float buff, buff2;

	infile.open("a.bin", ios::in | ios::binary);
	if (infile.fail())
	{
		cout << "Input file failure\n";
		exit(1);
	}

	outfile.open("a.txt", ios::out);
	if (outfile.fail())
	{
		cout << "output file failure\n";
		exit(1);
	}

	infile.read(reinterpret_cast<char *>(&buff), sizeof(buff));
	while(!infile.eof())
	{
		buff2 = buff;
		infile.read(reinterpret_cast<char *>(&buff), sizeof(buff));
		outfile << buff2 << endl;
	}

	infile.close();
	outfile.close();
}

void func2()
{
	fstream infile, outfile;
	float buff, buff2;

	infile.open("a.txt", ios::in);
	if (outfile.fail())
	{
		cout << "Input file failure\n";
		exit(1);
	}

	outfile.open("a.bin", ios::out | ios::binary);
	if (infile.fail())
	{
		cout << "Output file failure\n";
		exit(1);
	}

	infile >> buff;
	while(!infile.eof())
	{
		buff2 = buff;
		infile >> buff;
		outfile.write(reinterpret_cast<char *>(&buff2), sizeof(buff2));
	}

	infile.close();
	outfile.close();
}
//
//void convert_headGeom()
//{
//	fstream inFile;
//	fstream outFile;
//	float num;
//	int linecount = 0;
//	char check;
//
//	inFile.open("voxels1pxlres.txt", ios::in);
//	if (inFile.fail())
//	{
//		cout << "Problem opening head_geometry.txt\n";
//		cout << "Make sure the file is in the program directory and\nit is not in use.\n";
//		cout << "Press enter to continue.";
//		cin.get();
//		exit(1);
//	}
//
//	cout << "Verifying \"head_geometry.txt\" file correctness...";
///*
//	check = inFile.get();
//	while (check == 0x09 || check == 0x20 || check == 0x0a || check == 0x0d)
//			check = inFile.get();	// ignore extra whitespace characters at the beginning of the line
//
//	linecount++;
//	while (check != 0x09 && check != 0x20 && check != 0x0a && check != 0x0d) // loop til hitting tab, space, or newline
//	{
//		if (!(check > 0x2f && check < 0x3a))	// check that it is a numeral
//		{
//			cout << "\n\nFile error: line " << linecount << " of \"head_geom.txt\", header information: number of lines\nmust be an integer\n";
//			cout << "Correct errors and re-run.\n";
//			cout << "Problem character = " << check << "\nPress enter to continue.";
//			cin.get();
//			exit(1);
//		}
//		check = inFile.get();
//	}
//// here check rest of header information************************
//	while (!inFile.eof())
//	{
//		linecount++;
//		while (check == 0x09 || check == 0x20 || check == 0x0a || check == 0x0d)
//			check = inFile.get();	// ignore extra whitespace characters at the beginning of the line
//		while (check != 0x09 && check != 0x20) // loop til hitting tab or space
//		{
//			if (!(check > 0x2f && check < 0x3a))	// check that it is a numeral
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_geom.txt\", X value must be an integer\n";
//				cout << "Correct errors and re-run.\n";
//				cout << "Problem character = " << check << "\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			check = inFile.get();
//		}
//
//		check = inFile.get();
//		while (check == 0x09 || check == 0x20)
//			check = inFile.get();	// ignore extra whitespace characters between tissue X and Y
//		while (check != 0x09 && check != 0x20)	// loop until hitting whitespace (tab or space)
//		{
//			if (!(check > 0x2f && check < 0x3a))	// make sure its a numeral
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_geom.txt\", Y value must be an integer\n";
//				cout << "Correct errors and re-run.\n";
//				cout << "Problem character = " << check << "\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			check = inFile.get();
//		}
//
//		while (check == 0x09 || check == 0x20)
//			check = inFile.get();	// ignore extra whitespace characters between tissue Y and Z
//		while (check != 0x09 && check != 0x20)	// loop til tab or space
//		{
//			if (!(check > 0x2f && check < 0x3a))		// check to make sure it is a numeral
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_geom.txt\", Z value must be an integer\n";
//				cout << "Correct errors and re-run.\n";
//				cout << "Problem character = " << check << "\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			check = inFile.get();
//		}
//
//		while (check == 0x09 || check == 0x20)
//			check = inFile.get();	// ignore extra whitespace characters between tissue ID and t1
//		while (check != 0x09 && check != 0x20 && check != '\n')	// loop til tab, space, or newline
//		{
//			if (!(check > 0x2f && check < 0x3a))	// checking for numeral
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_geom.txt\", Tissue ID must be an integer\n";
//				cout << "Correct errors and re-run.\n";
//				cout << "Problem character = " << check << "\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			check = inFile.get();
//		}
//		check = inFile.get();
//	}
//*/
//	cout << "Done!\n";
//
//	// crosscheck_length = linecount;	// set global variable, crosscheck_length, for file comparison
//
//	outFile.open("voxels1pxlres.bin", ios::out | ios::binary);
//	if (outFile.fail())
//	{
//		cout << "Problem opening head_geometry.bin\n";
//		cout << "Make sure the file is not in use.\nPress enter to continue.";
//		cin.get();
//		exit(1);
//	}
//
//	cout << "Beginning conversion of \"head_geometry.txt\"...";
//
//	inFile.clear();
//	inFile.seekg(0);
//	while (!inFile.eof())
//	{
//		inFile >> num;//float
//		outFile.write(reinterpret_cast<char *>(&num), sizeof(num));
//	}
//	inFile.close();
//	outFile.close();
//} /* convert_headGeom() */
//
//void convert_dB0()
//{
//	fstream dB0_fileIn, outFile;
//	long int linecount = 0;
//	char check;
//	bool fraction = false, negative = false, exponent = false;
//	float number;
//
//	cout << "Verifying \"head_geom_B0.txt\" file correctness...";
//
//	dB0_fileIn.open("head_geom_B0.txt", ios::in);
//	if (dB0_fileIn.fail())
//		cout << "Problem opening head_geom_B0.txt\n";
//
//	while (!dB0_fileIn.eof())	// SEE ABOVE FUNCTIONS FOR COMMENTS ON THE FUNCTIONALITY OF THIS LOOP (SIMILAR LOOPS ABOVE)
//	{
//		linecount++;
//		check = '0'; // initialize before testing
//		while (check != '\n' && check != 0x20)	// loop until newline or space
//		{
//			if (check == '-' && !negative)
//			{
//				negative = true;
//				check = dB0_fileIn.get();
//				continue;
//			}
//			else if (check == '-')
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_geom_B0.txt\", two '-' symbols found\n";
//				cout << "Correct errors and re-run.\n\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			if (check == '.' && !fraction)
//			{
//				fraction = true;
//				check = dB0_fileIn.get();
//				continue;
//			}
//			else if (check == '.')
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_geom_B0.txt\", two '.' symbols found\n";
//				cout << "Correct errors and re-run.\n\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			if (check == 'e' && !exponent)
//			{
//				fraction = true;
//				exponent = true;
//				negative = false;
//				check = dB0_fileIn.get();
//				continue;
//			}
//			else if (check == 'e')
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_geom_B0.txt\", extra 'e' character found.\n";
//				cout << "Correct errors and re-run.\n\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			if (!(check > 0x2f && check < 0x3a))
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_geom_B0.txt\"\n";
//				cout << "Correct errors and re-run.\n";
//				cout << "Problem character = " << check << "\n\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			check = dB0_fileIn.get();
//		}
//		fraction = false;
//		negative = false;
//		exponent = false;
//		check = dB0_fileIn.get();
//	}
//
//	if (linecount != crosscheck_length)
//	{
//		cout << "File length mismatch: \"head_geometry.txt\" has " << crosscheck_length << " lines,\n";
//		cout << "\"head_B0.txt\" has " << linecount << " lines.\n";
//		cout << "Ensure corresponding files have same length and re-run.\n";
//		cout << "\nPress enter to continue.";
//		cin.get();
//		exit(1);
//	}
//
//	cout << "Done!\n";
//
//	outFile.open("head_geom_B0.bin", ios::out | ios::binary);
//	if (outFile.fail())
//		cout << "Problem opening head_geometry.bin\n";
//
//	cout << "Beginning conversion of \"head_geom_B0.txt\"...";
//
//	dB0_fileIn.clear();
//	dB0_fileIn.seekg(0);
//	while (!dB0_fileIn.eof())
//	{
//		dB0_fileIn >> number;
//
//		outFile.write(reinterpret_cast<char *>(&number), sizeof(number));
//	}
//	dB0_fileIn.close();
//	outFile.close();
//	cout << "Done!\n";
//} /* convert_headB0() */
//
//void convert_B1()	// should be updated for imaginary numbers******
//{
//	fstream fileIn, fileOut;
//	long int linecount = 0;
//	char check;
//	bool fraction = false, negative = false, exponent = false;
//	float number;
//
//	cout << "Verifying \"head_B1_minus.txt\" file correctness...";
//
//	fileIn.open("head_B1_minus.txt", ios::in);
//	if (fileIn.fail())
//	{
//		cout << "Problem opening \"head_B1_minus.txt\"\n";
//		cout << "Place the file in the program directory and ensure that\nit is not in use.\n";
//		cout << "Re-run conversion program.\nPress enter to continue.";
//		cin.get();
//		exit(1);
//	}
//
//	while (!fileIn.eof())
//	{
//		linecount++;
//		check = '0'; // initialize before testing
//		while (check != '\n' && check != 0x20)
//		{
//			if (check == 'e' && !exponent)
//			{
//				exponent = true;
//				negative = false;
//				fraction = true;
//				check = fileIn.get();
//				continue;
//			}
//			else if (check == 'e')
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_B1_minus.txt\", two 'e' symbols found\n";
//				cout << "Correct errors and re-run.\n\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			if (check == '-' && !negative)
//			{
//				negative = true;
//				check = fileIn.get();
//				continue;
//			}
//			else if (check == '-')
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_B1_minus.txt\", two '-' symbols found\n";
//				cout << "Correct errors and re-run.\n\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			if (check == '.' && !fraction)
//			{
//				fraction = true;
//				check = fileIn.get();
//				continue;
//			}
//			else if (check == '.')
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_B1_minus.txt\", two '.' symbols found\n";
//				cout << "Correct errors and re-run.\n\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			if (!(check > 0x2f && check < 0x3a))
//			{
//				cout << "\n\nFile error: line " << linecount << " of \"head_B1_minus.txt\"\n";
//				cout << "Correct errors and re-run.\n";
//				cout << "Problem character = " << check << "\n\nPress enter to continue.";
//				cin.get();
//				exit(1);
//			}
//			check = fileIn.get();
//		}
//		fraction = false;
//		negative = false;
//		exponent = false;
//		check = fileIn.get();
//	}
//
//	if (linecount != crosscheck_length)
//	{
//		cout << "File length mismatch: \"head_geometry.txt\" has " << crosscheck_length << " lines,\n";
//		cout << "\"head_B1_minus.txt\" has " << linecount << " lines.\n";
//		cout << "Ensure corresponding files have same length and re-run.\n";
//		cout << "\nPress enter to continue.";
//		cin.get();
//		exit(1);
//	}
//
//	cout << "Done!\n";
//
//	fileOut.open("head_B1_minus.bin", ios::out | ios::binary);
//	if (fileOut.fail())
//	{
//		cout << "Problem opening \"head_B1_minus.bin\"\n";
//		cout << "Ensure that a file with that name is not in use and re-run conversion.\n";
//		cout << "Press enter to continue.";
//		cin.get();
//		exit(1);
//	}
//
//	cout << "Beginning conversion of \"head_B1_minus.txt\"...";
//
//	fileIn.clear();
//	fileIn.seekg(0);
//	while (!fileIn.eof())
//	{
//		fileIn >> number;
//
//		fileOut.write(reinterpret_cast<char *>(&number), sizeof(number));
//	}
//	fileIn.close();
//	fileOut.close();
//	cout << "Done!\n";
//} /* convert_headB1_minus() */
//
//void convert_headB1_plus()
//{
//	fstream fileIn, fileOut;
//	long int linecount = 0;
//	char check;
//	bool fraction = false, sign = false, exponent = false;
//	float buff1, buff2;
//
//	cout << "Verifying \"head_B1_plus.txt\" file correctness...";
//
//	fileIn.open("head_B1_plus.txt", ios::in);
//	if (fileIn.fail())
//	{
//		cout << "Problem opening \"head_B1_plus.txt\"\n";
//		cout << "Place the file in the program directory and ensure that\nit is not in use.\n";
//		cout << "Re-run conversion program.\nPress enter to continue.";
//		cin.get();
//		exit(1);
//	}
//
//	while (!fileIn.eof())
//	{
//		linecount++;
//		check = '0'; // initialize before testing
//		for (int count = 0; count < 2; count++)
//		{
//			while (check != '\n' && check != 0x20 && check != '\t')	//go until finding newline, space, or tab
//			{
//				if (check == 'e' && !exponent)
//				{					// when we find the first e (for exponent)
//					exponent = true;	// set exponent flag
//					sign = false;	// remove negative flag
//					fraction = true;	// set fraction flag
//					check = fileIn.get();	// get a new character
//					continue;				// proceed to next loop iteration
//				}
//				else if (check == 'e')	// if we find a second e, error
//				{
//					cout << "\n\nFile error: line " << linecount << " of \"head_B1_plus.txt\", two 'e' symbols found\n";
//					cout << "Correct errors and re-run.\n\nPress enter to continue.";
//					cin.get();
//					exit(1);
//				}
//				if ((check == '-' || check == '+') && !sign)
//				{					// when we find the first - or + symbol
//					sign = true;	// set sign flag
//					check = fileIn.get();	// get new character
//					continue;				// proceed to next iteration
//				}
//				else if (check == '-')	// if we find a second - symbol, error
//				{
//					cout << "\n\nFile error: line " << linecount << " of \"head_B1_plus.txt\", extra '-' symbol found\n";
//					cout << "Correct errors and re-run.\n\nPress enter to continue.";
//					cin.get();
//					exit(1);
//				}
//				if (check == '.' && !fraction)
//				{					// when we find the first decimal point
//					fraction = true;	// set fraction flag
//					check = fileIn.get();	// get a new character
//					continue;				// proceed to next iteration
//				}
//				else if (check == '.')	// if we find a second decimal, error
//				{
//					cout << "\n\nFile error: line " << linecount << " of \"head_B1_plus.txt\", extra '.' symbol found\n";
//					cout << "Correct errors and re-run.\n\nPress enter to continue.";
//					cin.get();
//					exit(1);
//				}
//				if (!(check > 0x2f && check < 0x3a)) //make sure character is a numeral
//				{
//					cout << "\n\nFile error: line " << linecount << " of \"head_B1_plus.txt\"\n";
//					cout << "Correct errors and re-run.\n";
//					cout << "Problem character = " << check << "\n\nPress enter to continue.";
//					cin.get();
//					exit(1);
//				}
//				check = fileIn.get();
//			}	/* while (check != '\n' && check != 0x20 && check != '\t') */
//			fraction = false;
//			sign = false;	// reset all flags
//			exponent = false;
//			check = fileIn.get();	// get next character
//		} /* for (int count = 0; count < 2; count++) */
//	} /* while (!fileIn.eof()) */
//
//	if (linecount != crosscheck_length)
//	{
//		cout << "File length mismatch: \"head_geometry.txt\" has " << crosscheck_length << " lines,\n";
//		cout << "\"head_B1_plus.txt\" has " << linecount << " lines.\n";
//		cout << "Ensure corresponding files have same length and re-run.\n";
//		cout << "\nPress enter to continue.";
//		cin.get();
//		exit(1);
//	}
//
//	cout << "Done!\n";
//
//	fileOut.open("head_B1_plus.bin", ios::out | ios::binary);
//	if (fileOut.fail())
//	{
//		cout << "Problem opening \"head_B1_plus.bin\"\n";
//		cout << "Ensure that a file with that name is not in use and re-run conversion.\n";
//		cout << "Press enter to continue.";
//		cin.get();
//		exit(1);
//	}
//
//	cout << "Beginning conversion of \"head_B1_plus.txt\"...";
//
//	fileIn.clear();
//	fileIn.seekg(0);
//	while (!fileIn.eof())
//	{
//		fileIn >> buff1 >> buff2;
//		complex<float> number(buff1, buff2);
//
//		fileOut.write(reinterpret_cast<char *>(&number), sizeof(number));
//	}
//	fileIn.close();
//	fileOut.close();
//	cout << "Done!\n";
//} /* convert_headB1_plus() */
