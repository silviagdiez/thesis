#include <octave/oct.h> 
#include <cmath>
#include <string>
#include <vector>
#include <iostream>

using std::string;

DEFUN_DLD (LongestCommonSubsequence04, args, nargout,"")
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
			
			// Initialize dynamic matrix Df with appropriate size:
			Matrix Df(n1+1,n2+1,0);
			
			double max;
			// This is dynamic programming algorithm:
			// Here the character comparison is performed *after* the transition
			for (int i = 0; i < n1; i++){
				for (int j = 0; j < n2; j++){
					if (s1(i) == s2(j)){
			        	Df(i+1,j+1) = Df(i,j) + 1;
			      	}else{
			      		if (Df(i,j+1) > Df(i+1,j))
			      			max = Df(i,j+1);
			      		else
			      			max = Df(i+1,j);
			      		Df(i+1,j+1) = max;
			      	}
			    }
			}
	 
			double k = Df(n1,n2);
			// octave_stdout << k << "\n";
			retval(0)= k;
		}
	}
	return retval;
}
		
