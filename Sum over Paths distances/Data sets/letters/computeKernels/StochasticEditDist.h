#include <octave/oct.h>
#include <octave/parse.h>
#include <octave/oct-alloc.h>
#include <cmath>
#include <string>
#include <vector>
#include <iostream>

using std::string;

/* This function is not valid except for the DIGITS dataset. BEWARE for other datasets!!! */

DEFUN_DLD (StochasticEditDist, args, nargout,"")
{
	std::string test("test");
	int	nargin = args.length(); 
	octave_value_list retval; 
	if (nargin != 3)
	{ 
	//	print_usage (); 
	}
	else
	{
		string s1 = args(0).string_value();
		string s2 = args(1).string_value();
		double pe = args(2).double_value();
		double ps = 1-(3*pe);
		//octave_stdout << "S1\n" << s1 << "\n";
		//octave_stdout << "S2\n" << s2 << "\n";
				
		if (! error_state)
		{
			
			if((pe < 0) || (pe > 0.25))
			{
				octave_stdout << "The error probability is out of the admissible range [0,0.25] !\n";
				return retval;
			}
			
			// Contamos la longitud de la cadena
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
			
			// Initialize transition costs
			long double ExpDelCost = pe; // exp(-(-log(pe)));
			long double ExpInsCost = pe; // exp(-(-log(pe)));
			long double ExpNonMatchCost = pe; // exp(-(-log(pe)));
			long double ExpMatchCost = ps; // exp(-(-log(ps)));
			
			// Initialize dynamic matrix Df, Db with appropriate size:
			Matrix Df(n1+1,n2+1,0);
			
			// This is forward dynamic programming algorithm:
			Df(0,0) = 1;

			for (int i = 0; i < n1; i++)
			   Df(i+1,0) = Df(i,0)*ExpDelCost;

			for (int j = 0; j < n2; j++)
			   Df(0,j+1) = Df(0,j)*ExpInsCost;
			
			//octave_stdout << "Df\n" << Df << "\n";
					
			for (int i = 0; i < n1; i++){
			   for (int j = 0; j < n2; j++){
			      Df(i+1,j+1) = Df(i,j)*ExpNonMatchCost + Df(i,j)*ExpMatchCost + Df(i+1,j)*ExpInsCost + Df(i,j+1)*ExpDelCost;
			   }
			}
			
			//octave_stdout << "Df\n" << Df << "\n";
			
			double norm = Df(n1,n2);
			//octave_stdout << "norm " << norm << "\n";
			norm = -log(norm);
			//octave_stdout << "distance " << norm << "\n";
			retval(0)= norm;		
		}	
  	}
	return retval;
}