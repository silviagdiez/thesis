#include <octave/oct.h>
#include <octave/parse.h>
#include <octave/oct-alloc.h>
#include <cmath>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>

using std::string;

using std::string;

DEFUN_DLD (GapAllSubsequence03, args, nargout,"")
{
	
// Determine the number of inputs. 

	std::string test("test");
	int	nargin = args.length(); 
	octave_value_list retval; 
	
	if (nargin != 4)
	{ 
		//print_usage (); 
	}
	else
	{	
		string s1 = args(0).string_value();
		string s2 = args(1).string_value();
		double p = args(2).double_value();
		double lambda = args(3).double_value();
		//octave_stdout << "S1\n" << s1 << "\n";
		//octave_stdout << "S2\n" << s2 << "\n";
		//octave_stdout << "P\n" << p << "\n";
		//octave_stdout << "LAMBDA\n" << lambda << "\n";
		
		
		std::ofstream log("log");
		//std::ofstream log(args(0).string_value().c_str());
		log << "S1\n" << s1 << std::endl;
		log << "S2\n" << s2 << std::endl;
		log << "P\n" << p << std::endl;
		log << "LAMBDA\n" << lambda << std::endl;
		
		if (! error_state)
		{
			if((lambda < 0) || (lambda > 1))
			{
				octave_stdout << "'The value of lambda is out of the admissible range (0,1)!\n";
				return retval;
			}
			
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
	
			
			// Initialize dynamic matrix k with appropriate size:
			//dim_vector dim(3);
			dim_vector dim(p,n1,n2);
			NDArray k(dim,0);
			
			double l2 = lambda*lambda;
			
			// Precompute the costs
			RowVector K(p,0);
			for (int i = 0; i < n1; i++){
				for (int j = 0; j < n2; j++){
					if (s1[i] == s2[j]){
						k(0,i,j) = l2;
						K(0) = K(0) + k(0,i,j);
						//octave_stdout << "k\n" << k << "\n";
						//octave_stdout << "K\n" << K << "\n";
					}
				}
			}
			//log << "AFTER PRECOMPUTING COSTS\n" << K << std::endl;
			
			// Nomalization
			K(0) = K(0)/l2;
			//octave_stdout << "K\n" << K << "\n";
			
			// This is dynamic programming algorithm	
			for (int q = 1; q < p; q++){
				K(q) = 0;
				Matrix S(n1+1,n2+1,0);
				for (int i = 0; i < n1; i++){
					for (int j = 0; j < n2; j++){
						S(i+1,j+1) = k(q-1,i,j) + lambda*S(i,j+1) + lambda*S(i+1,j) - l2*S(i,j);
						if (s1[i] == s2[j]){
							k(q,i,j) = l2 * S(i,j);
			 				K(q) = K(q) + k(q,i,j);
			 				//octave_stdout << "k\n" << k << "\n";
							//octave_stdout << "K\n" << K << "\n";
						}
					}
				}
				// Normalization
				double aux = 2*(q+1);
				double aux2 = pow(lambda,aux);
				K(q) = K(q)/aux2;
			}
			
			//octave_stdout << "k\n" << k << "\n";
			//octave_stdout << "K\n" << K << "\n";
			retval(0) = K(p-1);	
		
		}	
  	}
	return retval;
}
