#include <octave/oct.h> 
#include <cmath>
#include <string>
#include <vector>
#include <iostream>

using std::string;


DEFUN_DLD (RspKernel01, args, nargout,"")
{ 
	std::string test("test");
	int	nargin = args.length(); 
	octave_value_list retval; 
	if (nargin != 3)
	{ 
		print_usage (); 
	}
	else
	{
		string s1 = args(0).string_value();
		string s2 = args(1).string_value();
		double theta = args(2).double_value();
		//octave_stdout << "S1\n" << s1 << "\n";
		//octave_stdout << "S2\n" << s2 << "\n";
		//octave_stdout << "THETA\n" << theta << "\n";
		
		if (! error_state)
		{
			if((theta < 0.001) || (theta>31.0))
			{
				octave_stdout << "'The value of theta is out of the admissible range [0.001,31.0] !\n";
				return retval;
			}
			
			double w = exp(theta);
			//octave_stdout << "W\n" << w << "\n";
			
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
			//octave_stdout << "n1\n" << n1 << "\n";
			//octave_stdout << "n2\n" << n2 << "\n";
			
			// Initialize dynamic matrix Df, Db with appropriate size:
			Matrix Df(n1+1,n2+1,0);
			Matrix Db(n1+1,n2+1,0);
			
			// This is forward dynamic programming algorithm:
			Df(0,0) = 1.0; 
			double sim = 0.0;
			
			// Only deletions and insertions; thus zero affinity
			for (int i = 0; i < n1; i++){
			   Df(i+1,0) = Df(i,0) * 1;
			}

			for (int j = 0; j < n2; j++){
				Df(0,j+1) = Df(0,j) * 1;
			}
	
			// Here the character comparison is performed *before* the transition
			for (int i = 0; i < n1; i++){
				for (int j = 0; j < n2; j++){
			      if (s1[i] == s2[j]){
			         sim = w; // here sim represents exp(theta*sij)
			      }else{
			         sim = 1; // a zero affinity
			      }
			      Df(i+1,j+1) = Df(i,j)*sim + Df(i+1,j)*1 + Df(i,j+1)*1;
			   }
			}
			//octave_stdout << "Df\n" << Df << "\n";
			
			// This is backward dynamic programming algorithm:
			Db(n1,n2) = 1;

			// Only deletions and insertions; thus zero affinity
			for (int i = (n1-1); i >= 0; i--)
				Db(i,n2) = Db(i+1,n2) * 1;

			for (int j = (n2-1); j >= 0; j--)
			   	Db(n1,j) = Db(n1,j+1) * 1;
			
			// Here the character comparison is performed *after* the transition
			for (int i = (n1-1); i >= 0; i--){
				for (int j = (n2-1); j >= 0; j--){
			      if (s1[i] == s2[j])
			         sim = w; // here sim represents exp(theta*sij)
			      else
			         sim = 1; // a zero affinity
			      Db(i,j) = Db(i+1,j+1)*sim + Db(i,j+1)*1 + Db(i+1,j)*1;
			   }
			}
			//octave_stdout << "Db\n" << Db << "\n";
			// Value of the partition function
			double z = Df(n1,n2);
			//octave_stdout << "Z\n" << z << "\n";
			// This is the computation of the cost along the treilli:
			double d = 0;

			for (int i = 1; i < n1; i++)
			   d = d + Df(i,0)*0*w*Db(i+1,0);

			for (int j = 1; j < n2; j++)
			   d = d + Df(0,j)*0*w*Db(0,j+1);
			
			// For each (i+1,j+1) in the treilli, we enumerate the links originating from (i,j), (i+1,j) and (i,j+1) and ending at (i+1,j+1)
			for (int i = 0; i < n1; i++){
				for (int j = 0; j < n2; j++){
			      if (s1[i] == s2[j])
			         sim = w; // here sim represents sij*exp(theta*sij) with sij = 0 or 1
			      else
			         sim = 0; // a zero affinity
			      // d is at (i+1,j+1)
				  // d = d + cost_eq + cost_insertion + cost_deletion
			      d = d + Df(i,j)*sim*Db(i+1,j+1) + Df(i+1,j)*0*Db(i+1,j+1) + Df(i,j+1)*0*Db(i+1,j+1);
		   		}
			}
			//octave_stdout << "Db\n" << Db << "\n";
			//octave_stdout << "Df\n" << Df << "\n";
			//octave_stdout << "d\n" << d << "\n";
			//octave_stdout << "z\n" << z << "\n";
			d = (d/z);
			//octave_stdout << "d\n" << d << "\n";
			retval(0)= d;
		}
	}
	return retval;
}
		