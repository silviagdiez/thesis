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
		string s1 = args(0).string_value();
		string s2 = args(1).string_value();
		//octave_stdout << "S1\n" << s1 << "\n";
		//octave_stdout << "S2\n" << s2 << "\n";
		
		if (! error_state)
		{
			
			int n1,n2; 
			n1 = n2 = 0;
			for (int i = 0; i < s1.size(); i++){
				if ((s1[i] == '0') || (s1[i] == '1') || (s1[i] == '2') || (s1[i] == '3') || (s1[i] == '4')
				 || (s1[i] == '5') || (s1[i] == '6') || (s1[i] == '7') || (s1[i] == '8') || (s1[i] == '9'))
					n1++;
				else
					break;
			}
			
			for (int i = 0; i < s2.size(); i++){
				if ((s2[i] == '0') || (s2[i] == '1') || (s2[i] == '2') || (s2[i] == '3') || (s2[i] == '4')
				 || (s2[i] == '5') || (s2[i] == '6') || (s2[i] == '7') || (s2[i] == '8') || (s2[i] == '9'))
					n2++;
				else
					break;
			}
			//octave_stdout << "n1\n" << n1 << "\n";
			//octave_stdout << "n2\n" << n2 << "\n";
			
			// Initialize dynamic matrix Df with appropriate size:
			Matrix Df(n1+1,n2+1,0);
			
			double max;
			// This is dynamic programming algorithm:
			// Here the character comparison is performed *after* the transition
			for (int i = 0; i < n1; i++){
				for (int j = 0; j < n2; j++){
					if (s1[i] == s2[j]){
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
		
