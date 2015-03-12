#include <octave/oct.h> 
#include <cmath>
#include <string>
#include <vector>
#include <iostream>
#include <algorithm>

using std::string;

DEFUN_DLD (EditDist, args, nargout,"")
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
			double DelCost  = 1;
			double InsCost  = 1;
			double ReplCost = 1;
		
			if (nargin == 5){ // set edition costs to user costs
				DelCost  = args(2).double_value();
				InsCost  = args(3).double_value();
				ReplCost = args(4).double_value();
			}
			 
			int n1,n2; 
			n1 = s1.length();
			n2 = s2.length();
			//octave_stdout << "n1\n" << n1 << "\n";
			//octave_stdout << "n2\n" << n2 << "\n";
			
			// Initialize dynamic matrix D with appropriate size:
			Matrix D(n1+1,n2+1,0);
			//octave_stdout << "D\n" << D << "\n";
			
			// This is a dynamic programming algorithm:
			double Repl = 0.0;
			
			for (int i = 0; i < n1; i++){
			   D(i+1,0) = D(i,0) + DelCost;
			}
			//octave_stdout << "D\n" << D << "\n";

			for (int j = 0; j < n2; j++){
				D(0,j+1) = D(0,j) + InsCost;
			}
			//octave_stdout << "D\n" << D << "\n";
	
			// Character comparison
			for (int i = 0; i < n1; i++){
				for (int j = 0; j < n2; j++){
				
			      if (s1(i) == s2(j)){
			         Repl = 0; 
			      }else{
			         Repl = ReplCost; 
			      }
			      
			      double min;
			      if ((D(i,j)+Repl) > (D(i+1,j)+InsCost))
			      	min = (D(i+1,j)+InsCost);
			      else
			        min = (D(i,j)+Repl);  
			      if (min > (D(i,j+1)+DelCost))
			      	min = (D(i,j+1)+DelCost);
			 
			      D(i+1,j+1) = min;
			   }
			}
			double d = D(n1,n2);
			//octave_stdout << "D\n" << D << "\n";
			//octave_stdout << "d\n" << d << "\n";
			retval(0)= d;
		}
	}
	return retval;
}
		
