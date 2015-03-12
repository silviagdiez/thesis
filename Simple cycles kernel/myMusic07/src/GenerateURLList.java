import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.LineNumberReader;
import java.util.Hashtable;


public class GenerateURLList {
	
	public GenerateURLList(String myfile){
		/* This class generates the file with the URLs for the whole
		 * random chord data base
		 */

			File file = null;
		    FileReader freader = null;
		    LineNumberReader lnreader = null;
		    try{
		      
		      file = new File(myfile);
		      freader = new FileReader(file);
		      lnreader = new LineNumberReader(freader);
		      
		      // Useful variables
		      String myURLS = "";
		      String line;
		      String oldArtist = "";
		      String oldSong = "";
		      int oldRating = 0;
		      String oldURL = "";
		      String artist = "";
		      String song = "";
		      int rating = 0;
		      String URL = "";
		      
		      // We open the file and read it line by line
		      while ((line = lnreader.readLine()) != null){
		    	
		    	// We split the current line by blanks
		    	String auxLine[] = line.split("\t");
		    	artist = auxLine[0];
		    	String auxSong[] = auxLine[1].split(" \\(");
		    	song = auxSong[0];
		    	rating = Integer.parseInt(auxLine[2]);
		    	URL = auxLine[3];
		    	
			    // We verify if the artist is the same as the previous one 
		    	if (artist.matches(oldArtist) == true){
		    		// We verify if the song is also the same
		    		if (song.startsWith(oldSong) == true){
		    			if (oldRating < rating){
		    				oldRating = rating;
		    				oldURL = URL;
		    			}
		    		// If the artist is the same but it's a new song
		    		} else {
		    			// We write the previous song
		    			myURLS = myURLS + oldURL + "\n";
		    			System.out.println("We keep: " + oldSong + " " + oldURL);
		    			System.out.println();
		    			// We update the other variables
		    			oldSong = song;
		    			oldRating = rating;
		    			oldURL = URL;
		    		}
		    	// If the artist does not match
		    	} else {
		    		if (oldArtist.length() > 0){ // This avoids printing by default the first song
		    			// We write the previous song
			    		myURLS = myURLS + oldURL + "\n";
			    		System.out.println("We keep: " + oldSong + " " + oldURL);
			    		System.out.println();
		    			
		    		}
	    			// We update the other variables
		    		oldArtist = artist;
		    		oldSong = song;
		    		oldRating = rating;
		    		oldURL = URL;
		    	}
			    
		      }
		      // We save them in the file
			    try {
			        BufferedWriter out = new BufferedWriter(new FileWriter("URLS/filteredURLS.txt",true));
			        out.write(myURLS);
			       	out.flush();
			       	out.close(); 
			    } catch (IOException e) {
			    	e.printStackTrace();
			    	System.out.println("ERROR");
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
