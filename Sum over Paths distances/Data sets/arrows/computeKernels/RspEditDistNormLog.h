#include <octave/oct.h> 
#include <cmath>
#include <string>
#include <vector>
#include <iostream>

using std::string;

DEFUN_DLD (RspEditDistNormLog, args, nargout,"")
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
		int DelCost  = log(1.0);
		int InsCost  = log(1.0);
		int ReplCost = log(1.0);
		
		if (nargin == 6){ // set edition costs to user costs
			DelCost  = args(3).double_value();
			DelCost = log(DelCost);
			InsCost  = args(4).double_value();
			InsCost = log(InsCost);
			ReplCost = args(5).double_value();
			ReplCost = log(ReplCost);
		}
		
		if (! error_state)
		{
			/*if((theta < 0.001) || (theta>31.0))
			{
				octave_stdout << "'The value of theta is out of the admissible range [0.001,31.0] !\n";
				return retval;
			}*/
			
			long double ExpDelCost = -theta*exp(DelCost);
			long double ExpInsCost = -theta*exp(InsCost);
			long double ExpReplCost = -theta*exp(ReplCost);
			
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
			
			// This is forward dynamic programming algorithm:
			Df(0,0) = log(1.0);

			for (int i = 0; i < n1; i++){
			   //Df(i+1,0) = Df(i,0)*ExpDelCost;
			   Df(i+1,0) = Df(i,0) + ExpDelCost;
			}
			
			for (int j = 0; j < n2; j++){
			   //Df(0,j+1) = Df(0,j)*ExpInsCost;
			   Df(0,j+1) = Df(0,j) + ExpInsCost;
			}
			
			double ExpRepl;
			double Repl;
			for (int i = 0; i < n1; i++){
			   for (int j = 0; j < n2; j++){
			      if (s1[i] == s2[j]){
			      	 // ExpRepl = 1; // a zero cost
			      	 RowVector m(3,0);
			         m(0) = Df(i,j);
			         m(1) = Df(i+1,j) + ExpInsCost;
			         m(2) = Df(i,j+1) + ExpDelCost;
			         double mx = m.max();
			         // computation of log(Df(i+1,j+1))
			         double logDf = log(exp(Df(i,j) - mx) + exp(Df(i+1,j) + ExpInsCost - mx) + exp(Df(i,j+1) + ExpDelCost - mx)) + mx;
			         Df(i+1,j+1) = logDf;
			      }else{
			         RowVector m(3,0);
			         ExpRepl = ExpReplCost;
			         m(0) = Df(i,j)   + ExpRepl;
			         m(1) = Df(i+1,j) + ExpInsCost;
			         m(2) = Df(i,j+1) + ExpDelCost;
			         double mx = m.max();
			         // computation of log(Df(i+1,j+1))
			         double logDf = log(exp(Df(i,j) + ExpRepl - mx) + exp(Df(i+1,j) + ExpInsCost - mx) + exp(Df(i,j+1) + ExpDelCost - mx)) + mx;
			         Df(i+1,j+1) = logDf;
			      }
			      //Df(i+1,j+1) = Df(i,j)*ExpRepl + Df(i+1,j)*ExpInsCost + Df(i,j+1)*ExpDelCost;
			   }
			}
			
			//octave_stdout << "Df\n" << exp(Df(n1,n2)) << "\n";
			// This is backward dynamic programming algorithm:
			Db(n1,n2) = log(1.0);

			for (int i = (n1-1); i >= 0; i--){
			   Db(i,n2) = Db(i+1,n2) + ExpDelCost;
			}

			for (int j = (n2-1); j >= 0; j--){
			   Db(n1,j) = Db(n1,j+1) + ExpInsCost;
			}

			for (int i = (n1-1); i >= 0; i--){
				for (int j = (n2-1); j >= 0; j--){
			      if (s1[i] == s2[j]){
			         // ExpRepl = 1; // a zero cost
			         RowVector m(3,0);
			         m(0) = Db(i+1,j+1);
			         m(1) = Db(i,j+1) + ExpInsCost;
			         m(2) = Db(i+1,j) + ExpDelCost;
			         double mx = m.max();
			         // computation of log(Df(i+1,j+1))
			         double logDb = log(exp(Db(i+1,j+1) - mx) + exp(Db(i,j+1) + ExpInsCost - mx) + exp(Db(i+1,j) + ExpDelCost - mx)) + mx;
			         Db(i,j) = logDb;
			      }else{
			         ExpRepl = ExpReplCost;
			         RowVector m(3,0);
			         m(0) = Db(i+1,j+1) + ExpRepl;
			         m(1) = Db(i,j+1) + ExpInsCost;
			         m(2) = Db(i+1,j) + ExpDelCost;
			         double mx = m.max();
			         // computation of log(Df(i+1,j+1))
			         double logDb = log(exp(Db(i+1,j+1) + ExpRepl - mx) + exp(Db(i,j+1) + ExpInsCost - mx) + exp(Db(i+1,j) + ExpDelCost - mx)) + mx;
			         Db(i,j) = logDb;
			      }
			   }
			}
			
			//octave_stdout << "Db\n" << exp(Db(0,0)) << "\n";
			double norm = Df(n1,n2);
			//octave_stdout << "norm: " << exp(norm) << "\n";
			
			// This is the computation of the cost along the treilli:
			double d = log(0);
			double l = log(0);

			for (int i = 0; i < n1; i++){
			   //d = d + Df(i,0)*DelCost*ExpDelCost*Db(i+1,0);
			   RowVector m(2,0);
			   m(0) = d;
			   m(1) = Df(i,0) + DelCost + ExpDelCost + Db(i+1,0);
			   double mx = m.max();
			   RowVector n(2,0);
			   n(0) = l;
			   n(1) = Df(i,0) + ExpDelCost + Db(i+1,0);
			   double nx = n.max();
			   double logd = log(exp(d - mx) + exp(Df(i,0) + DelCost + ExpDelCost + Db(i+1,0) - mx)) + mx;
			   d = logd;
			   double logl = log(exp(l - nx) + exp(Df(i,0) + ExpDelCost + Db(i+1,0) - nx)) + nx;
			   l = logl;
			}
			//octave_stdout << "d: " << exp(d) << "\t l: " << exp(l) << "\n";
			
			for (int j = 0; j < n2; j++){
			   //d = d + Df(0,j)*InsCost*ExpInsCost*Db(0,j+1);
			   RowVector m(2,0);
			   m(0) = d;
			   m(1) = Df(0,j) + InsCost + ExpInsCost + Db(0,j+1);
			   double mx = m.max();
			   RowVector n(2,0);
			   n(0) = l;
			   n(1) = Df(0,j) + ExpInsCost + Db(0,j+1);
			   double nx = n.max();
			   double logd = log(exp(d - mx) + exp(Df(0,j) + InsCost + ExpInsCost + Db(0,j+1) - mx)) + mx;
			   d = logd;
			   double logl = log(exp(l - nx) + exp(Df(0,j) + ExpInsCost + Db(0,j+1) - nx)) + nx;
			   l = logl;
			}
			//octave_stdout << "d: " << exp(d) << "\t l: " << exp(l) << "\n";
			
			// For each (i+1,j+1) in the treilli, we enumerate the links originating from (i,j), (i+1,j) and (i,j+1) and ending at (i+1,j+1)
			for (int i = 0; i < n1; i++){
			   for (int j = 0; j < n2; j++){
			      if (s1[i] == s2[j]){
			         //Repl = 1;
			         //d = d + Df(i,j)*ReplCost*ExpReplCost*Db(i+1,j+1) + Df(i+1,j)*InsCost*ExpInsCost*Db(i+1,j+1) + Df(i,j+1)*DelCost*ExpDelCost*Db(i+1,j+1);
			         RowVector m(3,0);
			         // ExpRepl = 1; // a zero cost, thus exp = 1
         			 // Repl    = 0; // a zero cost for replacing s1(i) by s2(j)
			   		 m(0) = d;
			   		 m(1) = Df(i+1,j) + InsCost + ExpInsCost + Db(i+1,j+1);
			   		 m(2) = Df(i,j+1) + DelCost + ExpDelCost + Db(i+1,j+1);
			   		 double mx = m.max();
			   		 RowVector n(4,0);
			   		 n(0) = l;
			   		 n(1) = Df(i,j) + Db(i+1,j+1);
			   		 n(2) = Df(i+1,j) + InsCost + ExpInsCost + Db(i+1,j+1);
			   		 n(3) = Df(i,j+1) + DelCost + ExpDelCost + Db(i+1,j+1);
			   		 double nx = n.max();
			   		 double logd = log(exp(d - mx) + exp(Df(i+1,j) + InsCost + ExpInsCost + Db(i+1,j+1) - mx) + exp(Df(i,j+1) + DelCost + ExpDelCost + Db(i+1,j+1) - mx)) + mx;
			   		 d = logd;
			   		 double logl = log(exp(l - nx) + exp(Df(i,j) + Db(i+1,j+1) - nx) + exp(Df(i+1,j) + InsCost + ExpInsCost + Db(i+1,j+1) - nx) + exp(Df(i,j+1) + DelCost + ExpDelCost + Db(i+1,j+1) - nx)) + nx;
			   		 l = logl;
			      }else{
			         //Repl = ExpReplCost;
			         //d = d + Df(i,j)*ReplCost*ExpReplCost*Db(i+1,j+1) + Df(i+1,j)*InsCost*ExpInsCost*Db(i+1,j+1) + Df(i,j+1)*DelCost*ExpDelCost*Db(i+1,j+1);
			    	 RowVector m(4,0);
                     // ExpRepl = ExpReplCost;
         			 // Repl = ReplCost;
			   		 m(0) = d;
			   		 m(1) = Df(i,j) + ReplCost + ExpReplCost + Db(i+1,j+1);
			   		 m(2) = Df(i+1,j) + InsCost + ExpInsCost + Db(i+1,j+1);
			   		 m(3) = Df(i,j+1) + DelCost + ExpDelCost + Db(i+1,j+1);
			   		 double mx = m.max();
			   		 RowVector n(4,0);
			   		 n(0) = l;
			   		 n(1) = Df(i,j) + ExpReplCost + Db(i+1,j+1);
			   		 n(2) = Df(i+1,j) + InsCost + ExpInsCost + Db(i+1,j+1);
			   		 n(3) = Df(i,j+1) + DelCost + ExpDelCost + Db(i+1,j+1);
			   		 double nx = n.max();
			   		 double logd = log(exp(d - mx) + exp(Df(i,j) + ReplCost + ExpReplCost + Db(i+1,j+1) - mx) + 
			   		 				exp(Df(i+1,j) + InsCost + ExpInsCost + Db(i+1,j+1) - mx) + exp(Df(i,j+1) + DelCost + ExpDelCost + Db(i+1,j+1) - mx)) + mx;
			   		 d = logd;
			   		 double logl = log(exp(l - nx) + exp(Df(i,j) + ExpReplCost + Db(i+1,j+1) - nx) + exp(Df(i+1,j) + InsCost + ExpInsCost + Db(i+1,j+1) - nx) + exp(Df(i,j+1) + DelCost + ExpDelCost + Db(i+1,j+1) - nx)) + nx;
			   		 l = logl;
			      }
			   }
			}
			  // octave_stdout << "d: " << exp(d) << "\t l: " << exp(l) << "\n";	
				
			d = d-norm;
			l = l-norm;
			//octave_stdout << "d\n" << d << "\n";
			retval(0)= exp(d-l);		
		}	
  	}
	return retval;
}