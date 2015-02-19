#include <octave/oct.h>
#include <octave/parse.h>
#include <octave/oct-alloc.h>
#include <cmath>
#include <string>
#include <vector>
#include <iostream>

using std::string;

/* This function is not valid except for the DIGITS dataset. BEWARE for other datasets!!! */

DEFUN_DLD (minLength, args, nargout,"")
{
	std::string test("test");
	int	nargin = args.length(); 
	octave_value_list retval; 
	if (nargin != 2)
	{ 
		print_usage (); 
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
				if ((s1[i] == 'A') || (s1[i] == 'B') || (s1[i] == 'C') || (s1[i] == 'D') || (s1[i] == 'E')
				 || (s1[i] == 'F') || (s1[i] == 'G') || (s1[i] == 'H') || (s1[i] == 'I') || (s1[i] == 'J')
				 || (s1[i] == 'K') || (s1[i] == 'L') || (s1[i] == 'M') || (s1[i] == 'N') || (s1[i] == 'O')
				 || (s1[i] == 'P') || (s1[i] == 'Q') || (s1[i] == 'R') || (s1[i] == 'S') || (s1[i] == 'T')
				 || (s1[i] == 'U') || (s1[i] == 'V') || (s1[i] == 'W') || (s1[i] == 'X') || (s1[i] == 'Y')
				 || (s1[i] == 'Z'))
					n1++;
				else
					break;
			}
			
			for (int i = 0; i < s2.size(); i++){
				if ((s2[i] == 'A') || (s2[i] == 'B') || (s2[i] == 'C') || (s2[i] == 'D') || (s2[i] == 'E')
				 || (s2[i] == 'F') || (s2[i] == 'G') || (s2[i] == 'H') || (s2[i] == 'I') || (s2[i] == 'J')
				 || (s2[i] == 'K') || (s2[i] == 'L') || (s2[i] == 'M') || (s2[i] == 'N') || (s2[i] == 'O')
				 || (s2[i] == 'P') || (s2[i] == 'Q') || (s2[i] == 'R') || (s2[i] == 'S') || (s2[i] == 'T')
				 || (s2[i] == 'U') || (s2[i] == 'V') || (s2[i] == 'W') || (s2[i] == 'X') || (s2[i] == 'Y')
				 || (s2[i] == 'Z'))
					n2++;
				else
					break;
			}
			
			if (n1 < n2)
				retval(0) = n1;
			else 
				retval(0) = n2;
		}
	}
	return retval;
}