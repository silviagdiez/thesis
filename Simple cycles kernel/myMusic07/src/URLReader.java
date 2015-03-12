import java.net.*;
import java.util.UUID;
import java.io.*;
import java.util.Hashtable;

public class URLReader {
	
	private String myurl;
	private String fileout;
    private PersistentIntervals intervals;
	
	public URLReader(String a, String b, PersistentIntervals inter){
		myurl = a;
		fileout = b;
		intervals = inter;
	}
	
	public URLReader(String a, String b){
		myurl = a;
		fileout = b;
	}
	
	public void chord2intervals(){
	/* This class converts a chord sequence in a text file into an interval sequence */
	
	// We generate the Hash table that contains the chord identifiers
	HashChord hc = new HashChord();
	Hashtable ht = hc.GenerateList();

	File file = null;
	FileReader freader = null;
	LineNumberReader lnreader = null;
	try{
		file = new File(myurl);
		freader = new FileReader(file);
		lnreader = new LineNumberReader(freader);
		String line = "";
		
		// We open the file and read it line by line
		while ((line = lnreader.readLine()) != null){
			
			String melody = "";
			String newChord = "";
			String oldChord = "";
		        	    	
			// We split the current line by commas
			String auxChords[] = line.split(",");
			    
			for (int i=0; i < (auxChords.length-1); i++){
				// We extract the two chords
				oldChord = auxChords[i];
				newChord = auxChords[i+1];
				// We SIMPLIFY THE LEXICON
				oldChord = hc.simplifyLexicon(oldChord);
				newChord = hc.simplifyLexicon(newChord);
				//System.out.println(oldChord);
				//System.out.println(newChord);
				// We transform the SLASHED chords
				if (newChord.indexOf("/") >= 0){
					int pos = newChord.indexOf("/");
					newChord = newChord.substring(0,pos);
				}
				// We compute the interval with the previous chord (if there is a previous chord)
				if (oldChord.length() > 0){
					// We compute the interval
					String key = oldChord.concat(",").concat(newChord);
					//System.out.println(key);
					int value = intervals.getInterval(key);
					// We add the new interval to the melody
					melody = melody.concat(Integer.toString(value));
					melody = melody.concat(",");
				}			
			}
			// We write the result to a file
			System.out.println(melody);
			try{
				// We append the file 
				FileWriter fstream = new FileWriter(fileout,true);
				BufferedWriter fout = new BufferedWriter(fstream);
				// Generate ID
				UUID idOne = UUID.randomUUID();
				fout.write(idOne.toString());
				fout.write("\t");
				// Write singer name
				fout.write("queen");
				fout.write("\t");
				// Write song title
				fout.write("greatest_hits");
				fout.write("\t");
				// Write the melody
				fout.write(melody);
				fout.write("\n");
				//Close the output stream
				fout.close();
			}catch (Exception e){//Catch exception if any
				System.err.println("Error: " + e.getMessage());
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
		
	public void extractChords() throws Exception {
		// We open the HTML code
		URL yahoo = new URL(myurl);
		BufferedReader in = new BufferedReader(
				new InputStreamReader(
				yahoo.openStream()));

		// We extract the singer and the song title
		String auxURL = myurl.toString();
		String[] auxSplit = auxURL.split("/");
		int splitLength = auxSplit.length;
		String singer = auxSplit[splitLength-2];
		String song = auxSplit[splitLength-1];
		
		// We read the HTML code
		String inputLine;
		int flag = 0;
		int warning = 0;
		String melody = "";
		// We read line by line
		while ((inputLine = in.readLine()) != null){
			//System.out.println(inputLine);
			// This is the beginning of the song
			if (inputLine.indexOf("<div id=cont>") >= 0){
				flag = 1;
			}
			if (flag == 1){
				//This is the end of the song
				if ((inputLine.indexOf("</div>") >= 0) && (warning != 2)){
					flag = 0;
				}
				//This is the beginning of the warning
				if (inputLine.indexOf("<pre>") >= 0){
					warning++;
				}
				//This is the end of the warning
				if (inputLine.indexOf("</pre>") >= 0){
					warning++;
				}
				// We extract the chords in the line (not for the warning)
				if (inputLine.indexOf("<span>") >= 0){
					String auxLine[] = inputLine.split("<span>");
					String chord = "";
					for (int i=1; i<auxLine.length; i++){
						String aux[] = auxLine[i].split("</span>");
						chord = aux[0];
						String newchord = verify(chord);
						melody = melody.concat(newchord);
						melody = melody.concat(",");
					}
				}
			}
		}
			
		// We close the input buffer
		in.close();
		
		// We write the result to a file
		try{
			// We append the file 
			FileWriter fstream = new FileWriter(fileout,true);
			BufferedWriter fout = new BufferedWriter(fstream);
			// Generate ID
			UUID idOne = UUID.randomUUID();
			fout.write(idOne.toString());
			fout.write("\t");
			// Write singer name
			fout.write(singer);
			fout.write("\t");
			// Write song title
			fout.write(song);
			fout.write("\t");
			// Write the melody
			fout.write(melody);
			fout.write("\n");
			//Close the output stream
			fout.close();
		}catch (Exception e){//Catch exception if any
			System.err.println("Error: " + e.getMessage());
		}
    }

	public void extractIntervals() throws Exception{
		
		// We generate the Hash table that contains the chord identifiers
		HashChord hc = new HashChord();
		
		// We open the HTML code
		URL yahoo = new URL(myurl);
		BufferedReader in = new BufferedReader(
				new InputStreamReader(
				yahoo.openStream()));

		// We extract the singer and the song title
		String auxURL = myurl.toString();
		String[] auxSplit = auxURL.split("/");
		int splitLength = auxSplit.length;
		String singer = auxSplit[splitLength-2];
		String song = auxSplit[splitLength-1];
				
		// We read the HTML code
		String inputLine;
		int flag = 0;
		int warning = 0;
		String melody = "";
		String newChord = "";
		String oldChord = "";
		
		// We read line by line
		while ((inputLine = in.readLine()) != null){
			//System.out.println(inputLine);
			// This is the beginning of the song
			if (inputLine.indexOf("<div id=cont>") >= 0){
				flag = 1;
			}
			if (flag == 1){
				//This is the end of the song
				if ((inputLine.indexOf("</div>") >= 0) && (warning != 2)){
					flag = 0;
				}
				//This is the beginning of the warning
				if (inputLine.indexOf("<pre>") >= 0){
					warning++;
				}
				//This is the end of the warning
				if (inputLine.indexOf("</pre>") >= 0){
					warning++;
				}
				// We extract the chords in the line (not for the warning)
				if (inputLine.indexOf("<span>") >= 0){
					String auxLine[] = inputLine.split("<span>");
					for (int i=1; i<auxLine.length; i++){
						String aux[] = auxLine[i].split("</span>");
						// We extract the NEW chord
						newChord = aux[0];
						// We SIMPLIFY THE LEXICON
						newChord = hc.simplifyLexicon(newChord);
						// We transform the SLASHED chords
						if (newChord.indexOf("/") >= 0){
							int pos = newChord.indexOf("/");
							newChord = newChord.substring(0,pos);
						}
						// We compute the interval with the previous chord (if there is a previous chord)
						if (oldChord.length() > 0){
							// We compute the interval
							String key = oldChord.concat(",").concat(newChord);
							int value = intervals.getInterval(key);
							// We add the new interval to the melody
							melody = melody.concat(Integer.toString(value));
							melody = melody.concat(",");
						}	
						oldChord = newChord;
					}
				}
			}
		}
		
			
		// We close the input buffer
		in.close();
		System.out.println(melody);
		
		// We write the result to a file
		try{
			// We append the file 
			FileWriter fstream = new FileWriter(fileout,true);
			BufferedWriter fout = new BufferedWriter(fstream);
			// Generate ID
			UUID idOne = UUID.randomUUID();
			fout.write(idOne.toString());
			fout.write("\t");
			// Write singer name
			fout.write(singer);
			fout.write("\t");
			// Write song title
			fout.write(song);
			fout.write("\t");
			// Write the melody
			fout.write(melody);
			fout.write("\n");
			//Close the output stream
			fout.close();
		}catch (Exception e){//Catch exception if any
			System.err.println("Error: " + e.getMessage());
		}
	}

	public String verify(String chord){
		boolean strange = false;
		// We check if it's a SLASHED chord
		String newchord = "";
		if (chord.indexOf("/") >= 0){
			int pos = chord.indexOf("/");
			newchord = chord.substring(0,pos);
			strange = true;
		}
		/* We avoid strange notation for chords*/
		if (chord.matches("A2")){
			newchord = "Aadd9";
			strange = true;
		}
		if (chord.matches("C7-9")){
			newchord = "C7b9";
			strange = true;
		}
		if (chord.matches("C2")){
			newchord = "Cadd9";
			strange = true;
		}
		if (chord.matches("A7Sus4")){
			newchord = "A7sus4";
			strange = true;
		}
		if (chord.matches("F2")){
			newchord = "Fadd9";
			strange = true;
		}
		if (chord.matches("Aadd9(no3)")){
			newchord = "Aadd9";
			strange = true;
		}
		if (chord.matches("Badd9(no3)")){
			newchord = "Badd9";
			strange = true;
		}
		if (chord.matches("Cadd9(no3)")){
			newchord = "Cadd9";
			strange = true;
		}
		if (chord.matches("Dadd9(no3)")){
			newchord = "Dadd9";
			strange = true;
		}
		if (chord.matches("Eadd9(no3)")){
			newchord = "Eadd9";
			strange = true;
		}
		if (chord.matches("Fadd9(no3)")){
			newchord = "Fadd9";
			strange = true;
		}
		if (chord.matches("Gadd9(no3)")){
			newchord = "Gadd9";
			strange = true;
		}
		
		if (strange){
			return newchord;
		}else{
			return chord;
		}
	}
}
