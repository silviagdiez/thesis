function [result, K] = subseq_count(s,t,p)
%SUBSEQ_COUNT
%         Finds the non-contiguous subsequence match count between strings s and t
%         by implementing a dynamic matrix, where the length of the subsequence is p.
%
%         The following algorithm is used:
%         K[0](x,y) = 1 for all x,y
%         K[p](s,'empty string') = 0 for all p > 0, all s
%         K[p](sa,t) = K[p](s,t) + [Summation from 1 to i]K[p-1](s,t(1:i-1) [t(i) == a]
%
%         Simply prompting the function will return the value K(s,t), however
%         using the function as [result,K] = K(s,t) will also return the matrix K[p].
%
%         Example: subseq_count('abc','abbbbc', 3) returns a value of 4.
%            (Note that subseq_count('abc','abbbbc')=subseq_count('abbbbc','abc') since K(s,t,p) = K(t,s,p) ).
%         Example: subseq_count('a','a', 1) returns a value of 1.
%         Example: subseq_count('a','a', 0) returns a value of 1 (for the empty string).
%         Example: subseq_count('a','b', 1) returns a value of 0.
%         Example: subseq_count('a','b', 0) returns a value of 1.
%         Example: subseq_count('ab','ab', 2) returns a value of 1.
%         
%
%
%USAGE:   scalar = subseq_count('string1','string2', p);    (where p is the length of the subsequence)
%
%         [scalar, matrix] = subseq_count('string1,'string2', p);
%
%

%For more information, visit http://www.kernel-methods.net/
%
%Written and tested in Matlab 6.0, Release 12.
%Copyright 2003, Manju M. Pai 4/2003
%manju@kernel-methods.net
%------------------------------------------------------------------------------------------

%Obtain lengths of strings
n = length(s);
m = length(t);

%Allow one extra row & column for empty string
%Initially set every matrix index to -1 to show value has not yet been found
answer = repmat(-1, [n+1, m+1, p]);

%If p is equal to zero, just return 1 for the empty string and quit program
if p == 0
    result = 1;
    K = repmat(1, [n+1, m+1]);
    return;
end;

%Fill in the rest of the matrix using the function subseq_count(s,t)
for h=1:p
    for i=1:n+1
        for j=1:m+1      
            answer(i,j,h) = subseq_count_kernel(s(1:i-1), t(1:j-1), answer, h);
        end;
    end;
end;

result = answer(n+1,m+1,p);
K = answer(:,:,p);
