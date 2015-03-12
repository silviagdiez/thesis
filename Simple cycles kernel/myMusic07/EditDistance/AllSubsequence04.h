#include <octave/oct.h>
#include <octave/parse.h>
#include <octave/oct-alloc.h>
#include <cmath>
#include <string>
#include <vector>
#include <iostream>

using std::string;

/* This function is not valid except for the DIGITS dataset. BEWARE for other datasets!!! */

DEFUN_DLD (AllSubsequence04, args, nargout,"")
{
	std::string test("test");
	int	nargin = args.length(); 
	octave_value_list retval; 
	if (nargin != 2)
	{ 
	//	print_usage (); 
	}
	else
	{
		RowVector s1 = (RowVector) args(0).vector_value();
		RowVector s2 = (RowVector) args(1).vector_value();
		//octave_stdout << "S1\n" << s1 << "\n";
		//octave_stdout << "S2\n" << s2 << "\n";
				
		if (! error_state)
		{
				
			int n1,n2; 
			n1 = s1.length();
			n2 = s2.length();
			//octave_stdout << "n1\n" << n1 << "\n";
			//octave_stdout << "n2\n" << n2 << "\n";
			
			// Initialize dynamic matrix K with appropriate size:
			Matrix K(n1+1,n2+1,0);
			//K(0,0) = 1;
			
			//octave_stdout << "K\n" << K << "\n";
			
			// Initialize first column
			for (int i = 0; i < (n1+1); i++){
			   K(i,0) = 1;
			}
			
			//octave_stdout << "K\n" << K << "\n";

			// Initialize first row
			for (int j = 0; j < (n2+1); j++){
				 K(0,j) = 1;
			}
		
			//octave_stdout << "K\n" << K << "\n";
	
			// This is dynamic programming algorithm
			for (int i = 1; i < (n1+1); i++){
				double Ks = 0;
				int res = 0;
				for (int j = 1; j < (n2+1); j++){
						if (s1(i-1) == s2(j-1)){
							res = 1;
						}else{
							res = 0;
						}
					//octave_stdout << res << "\n";
					//octave_stdout << K(i-1,j-1) << "\n";
					 Ks = Ks + res*K(i-1,j-1);
					 K(i,j) = K(i-1,j) + Ks;
				 }
			}
			double k = K(n1,n2);
			//octave_stdout << "K\n" << K << "\n";
			//octave_stdout << "k\n" << k << "\n";
			retval(0)= k;
		}
	}
	return retval;
}
