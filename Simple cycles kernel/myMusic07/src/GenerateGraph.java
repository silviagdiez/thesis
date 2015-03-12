import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Hashtable;
import java.io.FileWriter;
import java.io.IOException;

public class GenerateGraph {
	
	private String myfile;
	private String outdir;
	
	public GenerateGraph(String mf,String od){
		myfile = mf;
		outdir = od;
	}
	
	public void extractGraphChord(){
	/* This class generates all the adjacency matrices for each line
	 * of the SongsBase text file based on the chord sequences.
	 */
		// We generate the Hash table that contains the chord identifiers
		HashChord hc = new HashChord();
		Hashtable ht = hc.GenerateList();

		File file = null;
	    FileReader freader = null;
	    LineNumberReader lnreader = null;
	    try{
	      file = new File(myfile);
	      freader = new FileReader(file);
	      lnreader = new LineNumberReader(freader);
	      String line = "";
	      // We open the file and read it line by line
	      while ((line = lnreader.readLine()) != null){
	        	    	
	    	// We split the current line by blanks
	    	String auxLine[] = line.split("\t");
		    
	    	// We take the last element (the chord sequence) ONLY IF THERE ARE 4 ELEMENTS!
	    	if (auxLine.length == 4){
	    		
	    		String auxChords[] = auxLine[3].split(",");
		    	
		    	// We create the matrix A and initialize it
		    	int dim = 476;
		    	char[][] A = new char[dim][dim]; 
		    	for (int i=0; i < dim; i++){
	            	for (int j=0; j < dim; j++){
	            		A[i][j] = '0';
	            	}
	            }
		    	
		    	// We extract the chords and id
		    	String id = auxLine[0];
		    	String artist = auxLine[1];
		    	System.out.println(id);
		    	System.out.println(artist);
		    	System.out.println(auxLine[3]);
		    	
		    	for (int i=0; i < (auxChords.length-1); i++){
			    	// We extract the two chords
			    	String c1 = auxChords[i];
			    	String c2 = auxChords[i+1];
			    	System.out.println(c1);
			    	System.out.println(c2);
			        // We compute the number of the chords
			    	try{
			    		int n1 = (Integer)ht.get(c1.toString());
			    		System.out.println(n1);
			    		try{
				    		int n2 = (Integer)ht.get(c2.toString());
				    		System.out.println(n2);
				    		A[n1][n2] = '1';
				    	}catch(NullPointerException e){
				    		System.out.println("***********Error hash on " + artist + "***************");
				    		break;
				    	}
			    	}catch(NullPointerException e){
			    		System.out.println("***********Error hash on " + artist + "***************");
			    		break;
			    	}
			    }
		    	
		    	// We write the matrix in a file named after the id of the song
		    	try {
		    	    BufferedWriter out = new BufferedWriter(new FileWriter("Adjacency/" + id));
		    	    for (int i=0; i < dim; i++){
		    	    	String auxA = "";
		    	    	for (int j=0; j < dim; j++){
		    	    		auxA = auxA + A[i][j] + ' ';
		    	    	}
		    	    	// We write each line in the file
		    	    	out.write(auxA);
		    	    	out.write('\n');
		    	    	out.flush();
					}
		    	    out.close();
		    	} catch (IOException e) {
		    		e.printStackTrace();
		    		System.out.println("ERROR");
		    	}	
	    	}
	      }
	      // We close the buffers
	      freader.close();
		  lnreader.close();
	    } catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}   
	}
	
	public void extractGraphInterval(){
		/* This class generates all the adjacency matrices for each line
		 * of the SongsBase text file based on the chord sequences.
		 */
			
			File file = null;
		    FileReader freader = null;
		    LineNumberReader lnreader = null;
		    try{
		      file = new File(myfile);
		      freader = new FileReader(file);
		      lnreader = new LineNumberReader(freader);
		      String line = "";
		      // We open the file and read it line by line
		      while ((line = lnreader.readLine()) != null){
		        	    	
		    	// We split the current line by blanks
		    	String auxLine[] = line.split("\t");
			    
		    	// We take the last element (the interval sequence) ONLY IF THERE ARE 4 ELEMENTS!
		    	if (auxLine.length == 4){
		    		
		    		String auxIntervals[] = auxLine[3].split(",");
			    				    				    	
			    	// We extract the intervals and id
			    	String id = auxLine[0];
			    	String artist = auxLine[1];
			    	System.out.println(id);
			    	System.out.println(artist);
			    	System.out.println(auxLine[3]);
			    	String Adj = "";
			    	
			    	for (int i=0; i < (auxIntervals.length-1); i++){
			    		//System.out.println(i);
				    	// We extract the two chords
				    	Integer i1 = Integer.parseInt(auxIntervals[i]);
				    	Integer i2 = Integer.parseInt(auxIntervals[i+1]);
				    					    	
				        // We assign an arc between both intervals
				    	Adj = Adj + i1.toString() + " " + i2.toString() + " 1\n";
			    	}
			    	//System.out.println(Adj);
			    	
			    	// We write the matrix in a file named after the id of the song
			    	try {
			    	    BufferedWriter out = new BufferedWriter(new FileWriter(outdir + id));
			    	    
		    	    	// We write each line in the file
		    	    	out.write(Adj);
		    	    	out.flush();
		    	    	out.close();
			    	} catch (IOException e) {
			    		e.printStackTrace();
			    		System.out.println("ERROR");
			    	}	
		    	}
		      }
		      // We close the buffers
		      freader.close();
			  lnreader.close();
		    } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}   
		}
}
