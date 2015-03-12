import java.io.*;

import java.util.Hashtable;
import java.io.FileWriter;
import java.io.IOException;

public class GenerateBinarySequence {
	
	public GenerateBinarySequence(){
		
	}
	
	public void GenerateBinaryChords(String myfile, String fileout){
	/* This class generates the binary sequences of chords 
	 * for n-gram frequency extraction
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
		    
	    	// If there exists a sequence of chords
	    	if (auxLine.length == 4){
	    		// We take the last element (the chord sequence)
	    		String auxChords[] = auxLine[3].split(",");
	    		// We extract the chords and id
		    	String artist = auxLine[1];
		    	System.out.println(auxLine[3]);
		    	
		    	// We save them in the file
			    try {
			        BufferedWriter out = new BufferedWriter(new FileWriter(fileout,true));
			        for (int i=0; i < auxChords.length; i++){
				    	// We extract the chord
				    	String c = auxChords[i];
				    	
				    	// We obtain its number from the hash table
				    	int n = 0;
				    	try{
				    		n = (Integer)ht.get(c.toString());
				    	}catch(NullPointerException e){
				    		System.out.println("***********Error hash on " + artist + "***************");
				    		break;
				    	}
				    	
				    	// We convert it to binary
				    	String b = Integer.toBinaryString(n);
				    	String b2 = "";
				    	int lenb = b.length();
				    	// We format the binary number to 9 digits
				    	if (lenb < 9){
				    		for (int j=0; j < (9-lenb); j++)
				    			b2 = b2.concat("0");
				    		b2 = b2.concat(b);
				    	} else {
				    		b2 = b;
				    	}
				    	//System.out.println(b2);
				    	
				    	// We write it on the file
				    	out.write(b2);
				    	out.write(',');
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
	
	public void GenerateBinaryIntervals(String myfile, String fileout){
		/* This class generates the binary sequences of intervals 
		 * for n-gram frequency extraction
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
			    
		    	// If there exists a sequence of chords
		    	if (auxLine.length == 4){
		    		// We take the last element (the chord sequence)
		    		String auxIntervals[] = auxLine[3].split(",");
		    		// We extract the chords and id
			    	String artist = auxLine[1];
			    	System.out.println(auxLine[3]);
			    	
			    	// We save them in the file
				    try {
				        BufferedWriter out = new BufferedWriter(new FileWriter(fileout,true));
				        for (int i=0; i < auxIntervals.length; i++){
					    	// We extract the interval
					    	int c = Integer.parseInt(auxIntervals[i]);
					    	
					    	// We convert it to binary
					    	String b = Integer.toBinaryString(c);
					    	String b2 = "";
					    	int lenb = b.length();
					    	
					    	// We format the binary number to 12 digits
					    	if (lenb < 12){
					    		for (int j=0; j < (12-lenb); j++)
					    			b2 = b2.concat("0");
					    		b2 = b2.concat(b);
					    	} else {
					    		b2 = b;
					    	}
					    	
					    	// We write it on the file
					    	out.write(b2);
					    	out.write(',');
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
	
	public void GenerateBinaryIntervalsEachSong(String myfile){
		/* This class generates the binary sequences of intervals 
		 * for n-gram frequency extraction
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
			    
		    	// If there exists a sequence of chords
		    	if (auxLine.length == 4){
		    		// We take the identifier of the song
		    		String fileoutID = auxLine[0];
		    		String fileout = "Binary/Songs/".concat(fileoutID).concat(".txt");
		    		// We take the last element (the chord sequence)
		    		String auxIntervals[] = auxLine[3].split(",");
		    		// We extract the chords and id
			    	String artist = auxLine[1];
			    	System.out.println(auxLine[3]);
			    	
			    	// We save them in the file
				    try {
				        BufferedWriter out = new BufferedWriter(new FileWriter(fileout,true));
				        for (int i=0; i < auxIntervals.length; i++){
					    	// We extract the interval
					    	int c = Integer.parseInt(auxIntervals[i]);
					    	
					    	// We convert it to binary
					    	String b = Integer.toBinaryString(c);
					    	String b2 = "";
					    	int lenb = b.length();
					    	
					    	// We format the binary number to 12 digits
					    	if (lenb < 12){
					    		for (int j=0; j < (12-lenb); j++)
					    			b2 = b2.concat("0");
					    		b2 = b2.concat(b);
					    	} else {
					    		b2 = b;
					    	}
					    	
					    	// We write it on the file
					    	out.write(b2);
					    	out.write(',');
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
}
