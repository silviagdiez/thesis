#include <octave/oct.h> 
#include <cmath>
#include <string>
#include <vector>
#include <iostream>
#include <algorithm>

using std::string;


DEFUN_DLD (RspKernelNormLog, args, nargout,"")
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
			
			double w = theta;
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
			Df(0,0) = log(1.0); 
			double sim = 0.0;
            double sim2 = 0.0;
						
			// Only deletions and insertions; thus zero affinity
			for (int i = 0; i < n1; i++){
			   Df(i+1,0) = Df(i,0);
			}

			for (int j = 0; j < n2; j++){
				Df(0,j+1) = Df(0,j);
			}
	
			//octave_stdout << "Df\n" << Df << "\n";
			// Here the character comparison is performed *before* the transition
			for (int i = 0; i < n1; i++){
				for (int j = 0; j < n2; j++){
			      if (s1[i] == s2[j]){
			         //sim = w; // here sim represents exp(theta*sij)
			         //Df(i+1,j+1) = Df(i,j)*w + Df(i+1,j) + Df(i,j+1);
			         // search maximum value
			         RowVector m(3,0);
			         m(0) = Df(i,j)+w;
			         m(1) = Df(i+1,j);
			         m(2) = Df(i,j+1);
			         double mx = m.max();
			         // computation of log(Df(i+1,j+1))
			         double logDf = log(exp(Df(i,j) + w - mx) + exp(Df(i+1,j) - mx) + exp(Df(i,j+1) - mx)) + mx;
			         // we calculate the exponential
			         Df(i+1,j+1) = logDf;
			      }else{
			         //sim = 1; // a zero affinity
			         //Df(i+1,j+1) = Df(i,j)*sim + Df(i+1,j)*1 + Df(i,j+1)*1;
			         // search maximum value
			         RowVector m(3,0);
			         m(0) = Df(i,j);
			         m(1) = Df(i+1,j);
			         m(2) = Df(i,j+1);
			         double mx = m.max();
			         // computation of log(Df(i+1,j+1))
			         double logDf = log(exp(Df(i,j) - mx) + exp(Df(i+1,j) - mx) + exp(Df(i,j+1) - mx)) + mx;
			         // we calculate the exponential
			         Df(i+1,j+1) = logDf;
			         //octave_stdout << "Df\n" << Df << "\n";
			      }
			   }
			}
			//octave_stdout << "Df\n" << Df << "\n";
			//octave_stdout << exp(Df(n1,n2)) << "\n";
			
			// This is backward dynamic programming algorithm:
			Db(n1,n2) = log(1.0);

			// Only deletions and insertions; thus zero affinity
			for (int i = (n1-1); i >= 0; i--)
				Db(i,n2) = Db(i+1,n2);

			for (int j = (n2-1); j >= 0; j--)
			   	Db(n1,j) = Db(n1,j+1);
			
			// Here the character comparison is performed *after* the transition
			for (int i = (n1-1); i >= 0; i--){
				for (int j = (n2-1); j >= 0; j--){
			      if (s1[i] == s2[j]){
			         //sim = w; // here sim represents exp(theta*sij)
			         //Db(i,j) = Db(i+1,j+1)*w + Db(i,j+1) + Db(i+1,j);
			         // search maximum value
			         RowVector m(3,0);
			         m(0) = Db(i+1,j+1)+w;
			         m(1) = Db(i,j+1);
			         m(2) = Db(i+1,j);
			         double mx = m.max();
			         // computation of log(Df(i+1,j+1))
			         double logDb = log(exp(Db(i+1,j+1) + w - mx) + exp(Db(i,j+1) - mx) + exp(Db(i+1,j) - mx)) + mx;
			         // we calculate the exponential
			         Db(i,j) = logDb;
			         
			      }else{
			         //sim = 1; // a zero affinity
			         // Db(i,j) = Db(i+1,j+1)*sim + Db(i,j+1) + Db(i+1,j);
			         // search maximum value
			         RowVector m(3,0);
			         m(0) = Db(i+1,j+1);
			         m(1) = Db(i,j+1);
			         m(2) = Db(i+1,j);
			         double mx = m.max();
			         // computation of log(Df(i+1,j+1))
			         double logDb = log(exp(Db(i+1,j+1) - mx) + exp(Db(i,j+1) - mx) + exp(Db(i+1,j) - mx)) + mx;
			         // we calculate the exponential
			         Db(i,j) = logDb;
			      }
			   }
			}
			//octave_stdout << "Db\n" << Db << "\n";
			//octave_stdout << "Db " << exp(Db(0,0)) << "\n";
			
			// Value of the partition function
			double z = Df(n1,n2);
			//octave_stdout << "Z: " << exp(z) << "\n";
			// This is the computation of the cost along the treilli:
			double d = log(0);
			double l = log(0);
			
			for (int i = 1; i < n1; i++){
         	    //l = l + Df(i,0)*1*w*Db(i+1,0);
         	     RowVector n(2,0);
			     n(0) = l;
			     n(1) = Df(i,0) + w + Db(i+1,0);
			     double nx = n.max();
			     l = log(exp(l - nx) + exp(Df(i,0) + w + Db(i+1,0) - nx)) + nx;
            }

            for (int j = 1; j < n2; j++){
            	//l = l + Df(0,j)*1*w*Db(0,j+1);
            	RowVector n(2,0);
			    n(0) = l;
			    n(1) = Df(0,j) + w + Db(0,j+1);
			    double nx = n.max();
			    l = log(exp(l - nx) + exp(Df(0,j) + w + Db(0,j+1) - nx)) + nx;          	
            }

			
			// For each (i+1,j+1) in the treilli, we enumerate the links originating from (i,j), (i+1,j) and (i,j+1) and ending at (i+1,j+1)
			for (int i = 0; i < n1; i++){
				for (int j = 0; j < n2; j++){
			      if (s1[i] == s2[j]){
			         //sim = w; // here sim represents sij*exp(theta*sij) with sij = 0 or 1
			         //d = d + Df(i,j)*w*Db(i+1,j+1);
			         RowVector m(2,0);
			         m(0) = d;
			         m(1) = Df(i,j)+w+Db(i+1,j+1);
			         double mx = m.max();
			         double logd = log(exp(d - mx) + exp(Df(i,j) + w + Db(i+1,j+1) - mx)) + mx;
			         d = logd;
			         RowVector n(4,0);
			         n(0) = Df(i,j) + w + Db(i+1,j+1);
			         n(1) = Df(i+1,j) + w + Db(i+1,j+1);
			         n(2) = Df(i,j+1) + w + Db(i+1,j+1);
			         n(3) = l;
			         double nx = n.max();
			         l = log(exp(l - nx) + exp(Df(i,j) + w + Db(i+1,j+1) - nx) + exp(Df(i+1,j) + w + Db(i+1,j+1) - nx) + exp(Df(i,j+1) + w + Db(i+1,j+1) - nx)) + nx;
			         //octave_stdout << "d\n" << exp(d) << "\n";
			      }else{
			         //sim = 0; // a zero affinity
			         RowVector n(4,0);
			         n(0) = Df(i,j) + Db(i+1,j+1);
			         n(1) = Df(i+1,j) + w + Db(i+1,j+1);
			         n(2) = Df(i,j+1) + w + Db(i+1,j+1);
			         n(3) = l;
			         double nx = n.max();
			         l = log(exp(l - nx) + exp(Df(i,j) + Db(i+1,j+1) - nx) + exp(Df(i+1,j) + w + Db(i+1,j+1) - nx) + exp(Df(i,j+1) + w + Db(i+1,j+1) - nx)) + nx;
			      }
			      // d is at (i+1,j+1)
				  // d = d + cost_eq + cost_insertion + cost_deletion
		   		}
			}
			//octave_stdout << "d: " << exp(d) << "l: " << exp(l) << "\n";
			//octave_stdout << "Db\n" << Db << "\n";
			//octave_stdout << "Df\n" << Df << "\n";
			//octave_stdout << "d\n" << exp(d) << "\n";
			//octave_stdout << "z\n" << exp(z) << "\n";
			d = d-z;
			l = l-z;
			//octave_stdout << "d\n" << d << "\n";
			retval(0)= exp(d-l);
			}
	}
	return retval;
}
		
/*
			         double a = exp(Df(i,j) + w - mx);
			         double b = exp(Df(i+1,j) - mx);
			         double c = exp(Df(i,j+1) - mx);
			         if (a == 0){
			         	a = 4.941e-324;
			         } 
			         if (b == 0){
			         	b = 4.941e-324;
			         }
			         if (c == 0){
			         	c = 4.941e-324;
			         }
			         double logDf = log(exp(log(Df(i,j)) + log(w) - log(mx)) + exp(log(Df(i+1,j)) - log(mx)) + exp(log(Df(i,j+1)) - log(mx))) + log(mx);

*/		