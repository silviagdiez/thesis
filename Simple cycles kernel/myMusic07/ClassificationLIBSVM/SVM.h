#include <octave/oct.h> 
#include <cmath>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>

using std::string;

DEFUN_DLD (SVM, args, nargout,"")
{
	
	std::string test("test");
	int	nargin = args.length(); 
	octave_value_list retval; 
	
	if (nargin < 2)
	{ 
		print_usage (); 
	}
	else
	{	
			
		double opt = args(0).double_value();	
		string filename = args(1).string_value();
		string algo = args(2).string_value();
		string family = args(3).string_value();
		string c = args(4).string_value();
		
		if (! error_state)
		{
			string folder = "trKernels_";
			folder += algo;
			folder += "_";
			folder += family;
			
			std::string s;
			std::stringstream out;
			s = out.str();
			
			if (opt == 1){
			//svm_learn example1/train.dat example1/model
			string learn = "./libsvm-2.89/svm-train ";
			learn += s;
			//learn += " -t 2 -c "; // RBF
			learn += " -c "; // normal
			learn += c;
			learn += " ";
			//learn += "-s 2 -n 0.9 "; //1-class SVM
			learn += folder;
			learn += "/";
			learn += filename;
			learn += " ";
			learn += folder;
			learn += "/model";
			//octave_stdout << learn << "\n";
			system((char *)learn.c_str());
			}
			
			
			if (opt == 2){
			//svm_classify example1/test.dat example1/model example1/predictions
			string predict = "./libsvm-2.89/svm-predict ";
			predict += folder;
			predict += "/";
			predict += filename;
			predict += " ";
			predict += folder;
			predict += "/model ";
			predict += folder;
			predict += "/predictions";
			//octave_stdout << predict << "\n";
			system((char *)predict.c_str());
			}
			
			
			retval(0)= 1;		
		}	
  	}
	return retval;
}