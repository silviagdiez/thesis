#include <octave/oct.h> 
#include <cmath>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>
#include <time.h>

using std::string;
using namespace std;

DEFUN_DLD (SVM, args, nargout,"")
{
	
	std::string test("test");
	int	nargin = args.length(); 
	octave_value_list retval;
	//time_t t2;
	//ofstream fileo;
	
	if (nargin < 2)
	{ 
		print_usage (); 
	}
	else
	{	
			
		double opt = args(0).double_value();	
		string filename = args(1).string_value();
		string algo = args(2).string_value();
		string dataset = args(3).string_value();
		double c = args(4).double_value();
		//double t = args(5).double_value();
		//octave_stdout << c << "\n";
		
		if (! error_state)
		{
			// open folder
			string folder = "trKernels_";
			folder += algo;
			folder += "_";
			folder += dataset;
			
			std::string s;
			std::stringstream out;
			out << c;
			s = out.str();
			
			//fileo.open("salida.txt",ios::app);
			
			if (opt == 1){
			//svm_learn example1/train.dat example1/model
			//string learn = "./svm_multiclass_learn -v 2 -h 30 -# 10 -c ";
			string learn = "./liblinear-1.51/train -s 1 -q -c ";
			learn += s;
			learn += " ";
			learn += folder;
			learn += "/";
			learn += filename;
			learn += " ";
			learn += folder;
			learn += "/model";
			//learn += "/model >> train_out.txt";
			//octave_stdout << learn << "\n";
			system((char *)learn.c_str());
			//t = time(NULL);
			}
			
			
			if (opt == 2){
			//svm_classify example1/test.dat example1/model example1/predictions
			//string predict = "./svm_multiclass_classify ";
			string predict = "./liblinear-1.51/predict ";
			predict += folder;
			predict += "/";
			predict += filename;
			predict += " ";
			predict += folder;
			predict += "/model ";
			predict += folder;
			predict += "/predictions";
			//predict += "/predictions >> test_out.txt";
			system((char *)predict.c_str());
			// we print the time that took the learning
			//fileo << difftime(time(NULL),t) << "\n";
			//octave_stdout << predict << "\n";
			}
			
			//fileo.close();
			retval(0)= 1;		
		}	
  	}
  	return retval;
}