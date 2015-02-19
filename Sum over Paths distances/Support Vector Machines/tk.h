#include <octave/oct.h> 
#include <cmath>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>

using std::string;
using namespace std;

DEFUN_DLD (tk, args, nargout,"")
{
	
// Determine the number of inputs. If 3 inputs, set default edit costs to 1.
// Otherwise, make sure there are exactly 6 inputs, and set edit costs accordingly.

	std::string test("test");
	int	nargin = args.length(); 
	octave_value_list retval; 
	Matrix k;
	RowVector y;
	string file;
	if (nargin < 6)
	{ 
		print_usage (); 
	}
	else
	{	
		
		y = args(0).row_vector_value();
		k = args(1).matrix_value();
		double r = args(2).double_value();
		double c = args(3).double_value();
		string filename = args(4).string_value();
		string algo = args(5).string_value();
		string dataset = args(6).string_value();
		//octave_stdout << "y\n" << y << "\n";
		//octave_stdout << "k\n" << k << "\n";
		//octave_stdout << "r\n" << c << "\n";
		//octave_stdout << "c\n" << r << "\n";
	
		ofstream fileo;
		string folder = "trKernels_";
		folder += algo;
		folder += "_";
		folder += dataset;
		folder += "/";
		folder += filename;
 		fileo.open((char *)folder.c_str());
		
		if (fileo.is_open()){
			
			for (int i = 0; i < r; i++){
				//string aux = "";
				//aux += y(i);
				fileo << y(i) << " ";
				for (int j = 0; j < c; j++){
					fileo << (j+1) << ":" << k(i,j) << " ";
				}
				fileo << "\n";
			}
			
		}
		retval(0)= 1;		
		fileo.close();		
  	}
	return retval;
}