#include <octave/oct.h> 
#include <cmath>
#include <string>
#include <vector>
#include <iostream>

using std::string;

DEFUN_DLD (RspEditDistNorm, args, nargout,"")
{
	
// Determine the number of inputs. If 3 inputs, set default edit costs to 1.
// Otherwise, make sure there are exactly 6 inputs, and set edit costs accordingly.

	std::string test("test");
	int	nargin = args.length(); 
	octave_value_list retval; 
	Matrix d;
	if (nargin != 3 && nargin != 6)
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
		int DelCost  = 1;
		int InsCost  = 1;
		int ReplCost = 1;
		
		if (nargin == 6){ // set edition costs to user costs
			DelCost  = args(3).double_value();
			InsCost  = args(4).double_value();
			ReplCost = args(5).double_value();
		}
		
		if (! error_state)
		{
			/*if((theta < 0.001) || (theta>31.0))
			{
				octave_stdout << "'The value of theta is out of the admissible range [0.001,31.0] !\n";
				return retval;
			}*/
			
			long double ExpDelCost = exp(-theta*DelCost);
			long double ExpInsCost = exp(-theta*InsCost);
			long double ExpReplCost = exp(-theta*ReplCost);
			
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
			
			// Initialize dynamic matrix Df, Db with appropriate size:
			Matrix Df(n1+1,n2+1,0);
			Matrix Db(n1+1,n2+1,0);
			
			double ExpRepl;
			double Repl;
			// This is forward dynamic programming algorithm:
			Df(0,0) = 1;

			for (int i = 0; i < n1; i++)
			   Df(i+1,0) = Df(i,0)*ExpDelCost;

			for (int j = 0; j < n2; j++)
			   Df(0,j+1) = Df(0,j)*ExpInsCost;
			
			for (int i = 0; i < n1; i++){
			   for (int j = 0; j < n2; j++){
			      if (s1[i] == s2[j]){
			         Repl = 1; // a zero cost
			      }else{
			         Repl = ExpReplCost;
			      }
			      Df(i+1,j+1) = Df(i,j)*Repl + Df(i+1,j)*ExpInsCost + Df(i,j+1)*ExpDelCost;
			      
			   }
			}
			
			//octave_stdout << "Df\n" << Df << "\n";
			// This is backward dynamic programming algorithm:
			Db(n1,n2) = 1;

			for (int i = (n1-1); i >= 0; i--)
			   Db(i,n2) = Db(i+1,n2)*ExpDelCost;

			for (int j = (n2-1); j >= 0; j--)
			   Db(n1,j) = Db(n1,j+1)*ExpInsCost;

			for (int i = (n1-1); i >= 0; i--){
				for (int j = (n2-1); j >= 0; j--){
			      if (s1[i] == s2[j])
			         Repl = 1; // a zero cost
			      else
			         Repl = ExpReplCost;
			      Db(i,j) = Db(i+1,j+1)*Repl + Db(i,j+1)*ExpInsCost + Db(i+1,j)*ExpDelCost;
			   }
			}
			
			//octave_stdout << "Db\n" << Db << "\n";
			double norm = Df(n1,n2);
			//octave_stdout << "Norm: " << norm << "\n";
			
			// This is the computation of the cost along the treilli:
			double d = 0;
			double l = 0;

			for (int i = 0; i < n1; i++){
			   d = d + Df(i,0)*DelCost*ExpDelCost*Db(i+1,0);
			   l = l + Df(i,0)*1*ExpDelCost*Db(i+1,0);
			}
			//octave_stdout << "d: " << d << "\t l: " << l << "\n";
			for (int j = 0; j < n2; j++){
			   d = d + Df(0,j)*InsCost*ExpInsCost*Db(0,j+1);
			   l = l + Df(0,j)*1*ExpInsCost*Db(0,j+1);
			}
			//octave_stdout << "d: " << d << "\t l: " << l << "\n";
			
			// For each (i+1,j+1) in the treilli, we enumerate the links originating from (i,j), (i+1,j) and (i,j+1) and ending at (i+1,j+1)
			for (int i = 0; i < n1; i++){
			   for (int j = 0; j < n2; j++){
			      if (s1[i] == s2[j]){
			         ExpRepl = 1; // a zero cost, thus exp = 1
         			 Repl    = 0; // a zero cost for replacing s1(i) by s2(j)
			      }else{
			         ExpRepl = ExpReplCost;
         			 Repl = ReplCost;
         		  }
			      // distance
			      d = d + Df(i,j)*Repl*ExpRepl*Db(i+1,j+1) + Df(i+1,j)*InsCost*ExpInsCost*Db(i+1,j+1) + Df(i,j+1)*DelCost*ExpDelCost*Db(i+1,j+1);
			      // length of the path (we substitute the cost of each operation for 1)
			      l = l + Df(i,j)*1*ExpRepl*Db(i+1,j+1) + Df(i+1,j)*1*ExpInsCost*Db(i+1,j+1) + Df(i,j+1)*1*ExpDelCost*Db(i+1,j+1);
			   }
			}	
			//octave_stdout << "d: " << d << "\t l: " << l << "\n";		
		
			d = d/norm;	
			l = l/norm;
			if (l < d)
				octave_stdout << "d: " << d << "\t l: " << l << "\n";
			retval(0)= d/l;		
		}	
  	}
	return retval;
}