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
		string s1 = args(0).string_value();
		string s2 = args(1).string_value();
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
				
			      if (s1[i] == s2[j]){
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
		
