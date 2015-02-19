#include <octave/oct.h>
#include <octave/parse.h>
#include <octave/oct-alloc.h>
#include <cmath>
#include <string>
#include <vector>
#include <iostream>

using std::string;

using std::string;

DEFUN_DLD (GapAllSubsequence05Log, args, nargout,"")
{
	
// Determine the number of inputs. 

	std::string test("test");
	int	nargin = args.length(); 
	octave_value_list retval; 
	double minValue = 2.2250738585072014e-308;
	
	if (nargin != 4)
	{ 
		//print_usage (); 
	}
	else
	{	
		string s1 = args(0).string_value();
		string s2 = args(1).string_value();
		int p = args(2).int_value();
		double lambda = args(3).double_value();
		//octave_stdout << "S1\n" << s1 << "\n";
		//octave_stdout << "S2\n" << s2 << "\n";
		//octave_stdout << "P\n" << p << "\n";
		//octave_stdout << "LAMBDA\n" << lambda << "\n";
		
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
			double l2 = log(lambda*lambda);
			double l1 = log(lambda);
			Matrix DPS(n1,n2,log(minValue));
			
			double K[p];
			for (int i = 0; i < p; i++){
				K[i] = log(minValue);
			}
			
			for (int i = 0; i < n1; i++){
				for (int j = 0; j < n2; j++){
					if (s1[i] == s2[j]){
						DPS(i,j) = l2;
						//K[0] = K[0] + DPS(i,j);
						RowVector m(2,0);
			        	m(0) = K[0];
			         	m(1) = DPS(i,j);
			         	double mx = m.max();
			         	double logDPS = log(exp(K[0] - mx) + exp(DPS(i,j) - mx)) + mx;
			         	K[0] = logDPS;
					}
				}
			}
			
			
			// Nomalization
			//K[0] = K[0]/l2;
			K[0] = K[0] - l2;
			
			// This is dynamic programming algorithm
			Matrix DP(n1+1,n2+1,log(minValue));
						
			for (int l = 1; l < p; l++){
				K[l] = log(minValue); //original
				for (int i = 0; i < n1; i++){
					for (int j = 0; j < n2; j++){
						//DP(i+1,j+1) = DPS(i,j) + lambda*DP(i,j+1) + lambda*DP(i+1,j) - l2*DP(i,j);
						RowVector m(3,0);
			            m(0) = DPS(i,j);
			            m(1) = l1 + DP(i,j+1);
			            m(2) = l1 + DP(i+1,j);
			            double mx = m.max();
			         	double logDP = log(exp(DPS(i,j) - mx) + exp(l1 + DP(i,j+1) - mx) + exp(l1 + DP(i+1,j) - mx)) + mx;
			         
			         	RowVector m2(2,0);
			         	m2(0) = logDP;
			            m2(1) = l2 + DP(i,j);
			            mx = m2.max();
			         	logDP = log(exp(logDP - mx) - exp(l2 + DP(i,j) - mx)) + mx;
			         	DP(i+1,j+1) = logDP;
												
						if (s1[i] == s2[j]){
							DPS(i,j) = l2 + DP(i,j);
							//K[l] = K[l] + DPS(i,j);
			 				double logK;
			 				RowVector m3(2,0);
			        		m3(0) = K[l];
			         		m3(1) = DPS(i,j);
			         		double mx = m3.max();
			         		logK = log(exp(K[l] - mx) + exp(DPS(i,j) - mx)) + mx;
			         		K[l] = logK;
			         		
			         	}
					}
				}
				// Normalization
				double aux = 2*(l+1);
				double aux2 = pow(lambda,aux);
				double logaux2 = log(aux2);
				K[l] = K[l] - logaux2;
				//octave_stdout << "l: " << l << "\t" << exp(K[l]) << "\n";
			}
			
			double res = log(minValue);
			for (int q = 0; q < p; q++){
				RowVector m(2,0);
			    m(0) = res;
			    m(1) = K[q];
			    double mx = m.max();
			    double logRes = log(exp(res - mx) + exp(K[q] - mx)) + mx;
			    res = logRes;
				//octave_stdout << "res\t" << res << "\n";
			}
			retval(0) = exp(res);
		}	
  	}
	return retval;
}
