import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.io.ObjectInputStream;

public class HTMLMiner {
	
	public static void main(String args[])
	{
					
	String selectedURLS = "URLS/selected03.txt";
	String randomURLS = "URLS/randoms03.txt";
	String intermmediateRandomURLS = "URLS/randomURLS.txt";
	String selectedChords = "Chords/selectedChords03.txt";
	String randomChords = "Chords/randomChords03.txt";
	String selectedIntervals = "Intervals/selectedIntervals03.txt";
	String randomIntervals = "Intervals/randomIntervals03.txt";
	String selectedIntervalGraphs = "AdjacencyIntervalsSelected03/";
	String randomIntervalGraphs = "AdjacencyIntervalsRandom03/";
	String selectedBinaryChords = "Binary/selectedChords.txt";
	String randomBinaryChords = "Binary/randomChords.txt";
	String selectedBinaryIntervals= "Binary/selectedIntervals.txt";
	String randomBinaryIntervals = "Binary/randomIntervals.txt";
	String queenChords = "Queen Annotations/chordlab/Queen/Greatest Hits I/chords";
	String queenURLS = "URLS/queenURLS.txt";
	String queenIntervals = "Intervals/queenIntervals.txt";
	String queenIntervalGraphs = "AdjacencyIntervalsQueen/";
	String beatlesChords = "The Beatles Annotations/chordlab/The Beatles/ratedURL03.txt";
	String beatlesURLS = "URLS/ratedBeatlesURLS03.txt";
	String beatlesIntervals = "Intervals/beatlesIntervalsTotal03.txt";
	String beatlesIntervalGraphs = "AdjacencyIntervalsBeatles/";
	
	//generateRandomURLList(intermmediateRandomURLS);
	
	//extractChordsURL(selectedURLS,selectedChords);
	//extractChordsURL(randomURLS,randomChords);
	//extractChordsURL(randomURLS,randomChords);
	//extractChordsURL(selectedURLS,selectedChords);
	//extractChordsURL(beatlesURLS,beatlesChords);
	
	//extractIntervalsURL(selectedURLS,selectedIntervals);
	//extractIntervalsURL(randomURLS,randomIntervals);
	//extractIntervalsURL("URLS/testURLS.txt","Intervals/testIntervals.txt");
	//extractIntervalsURL(queenURLS,queenIntervals);
	//extractIntervalsURL(beatlesURLS,beatlesIntervals);
	
	//extractIntervalsFromChords(queenChords,queenIntervals);
	//extractIntervalsFromChords(beatlesChords,beatlesIntervals);
	
	//generateBinaryChords(selectedChords,selectedBinaryChords);
	//generateBinaryChords(randomChords,randomBinaryChords);
	
	//generateBinaryIntervals(selectedIntervals,selectedBinaryIntervals);
	//generateBinaryIntervals(randomIntervals,randomBinaryIntervals);
	//generateBinaryIntervalsEachSong(beatlesIntervals);
	
	//generateGraphChord(selectedChords);
	//generateGraphChord(randomChords);
	//generateGraphChord("Chords/test.txt");
	
	//generateGraphInterval("Intervals/testIntervals.txt");
	//generateGraphInterval(selectedIntervals,selectedIntervalGraphs);
	//generateGraphInterval(randomIntervals,randomIntervalGraphs);
	//generateGraphInterval(queenIntervals,queenIntervalGraphs);
	//generateGraphInterval(beatlesIntervals,beatlesIntervalGraphs);
	
	//printChords();
	
	}
	
	public static void generateRandomURLList(String fileout){
		
		/*** We randomly generate URLs ***/
		// We open the URL
		try {
			new HTMLRandomMiner(fileout);
		} catch (Exception e) {
			System.out.println("Not a valid URL.");  
		}
		
		/*** We filter the randomly generated URLs ***/
		new GenerateURLList("URLS/RandomURLS.txt");
		
	}
	
	public static void extractChordsURL(String myfile, String fileout){
		/*** We extract the sequence of chords from each each URL***/
		File file = null;
		FileReader freader = null;
	    LineNumberReader lnreader = null;
	    String line = "";
	    try{
	    	file = new File(myfile);
		    freader = new FileReader(file);
		    lnreader = new LineNumberReader(freader);
	    	// We read the file with the URL of the songs
	    	while ((line = lnreader.readLine()) != null){
	    		// We open the URL
	    		System.out.println(line);
	    		String myURL = line;
	    		URLReader ur = new URLReader(myURL,fileout);
				try {
					ur.extractChords();
				} catch (Exception e) {
					System.out.println("Not a valid URL.");  
				}
	    	}
	    	freader.close();
		    lnreader.close();
	    } catch (IOException e) {
			e.printStackTrace();
		}   	
	}
	
	public static void extractIntervalsURL(String myfile, String fileout){
		/*** We extract the sequence of chords from each each URL***/
		// We recover the hash table containing all intervals
		PersistentIntervals intervals = recoverIntervals();
		System.out.println("Inflated object: intervals");
		
		File file = null;
		FileReader freader = null;
	    LineNumberReader lnreader = null;
	    String line = "";
	    try{
	    	file = new File(myfile);
		    freader = new FileReader(file);
		    lnreader = new LineNumberReader(freader);
	    	// We read the file with the URL of the songs
	    	while ((line = lnreader.readLine()) != null){
	    		// We open the URL
	    		System.out.println(line);
	    		String myURL = line;
	    		URLReader ur = new URLReader(myURL,fileout,intervals);
				try {
					ur.extractIntervals();
				} catch (Exception e) {
					System.out.println("Not a valid URL.");  
				}
	    	}
	    	freader.close();
		    lnreader.close();
	    } catch (IOException e) {
			e.printStackTrace();
		}   	
	}
	
	public static void extractIntervalsFromChords(String myfile, String fileout){
		/*** We convert a chord sequence into an interval one***/
		// We recover the hash table containing all intervals
		PersistentIntervals intervals = recoverIntervals();
		System.out.println("Inflated object: intervals");
		
		URLReader ur = new URLReader(myfile,fileout,intervals);
		ur.chord2intervals();   	
	}

	public static void generateBinaryChords(String myfile, String fileout){
		/*** We generate the binary sequences for n-gram frequency extraction ***/
		GenerateBinarySequence bs = new GenerateBinarySequence();
		bs.GenerateBinaryChords(myfile, fileout);
	}
	
	public static void generateBinaryIntervals(String myfile, String fileout){
		/*** We generate the binary sequences for n-gram frequency extraction ***/
		GenerateBinarySequence bs = new GenerateBinarySequence();
		bs.GenerateBinaryIntervals(myfile, fileout);
	}
	
	public static void generateBinaryIntervalsEachSong(String myfile){
		/*** We generate the binary sequences for n-gram frequency extraction ***/
		GenerateBinarySequence bs = new GenerateBinarySequence();
		bs.GenerateBinaryIntervalsEachSong(myfile);
	}

	public static void printChords(){
		HashChord hc = new HashChord();
		//hc.PrintHashChord();
		hc.verifySimpleLexicon();
	}
	
	public static PersistentIntervals recoverIntervals(){
		String filename = "intervals.ser"; 
		PersistentIntervals intervals = null;
		FileInputStream fis = null;
		ObjectInputStream in = null;
		try
		{
			fis = new FileInputStream(filename);
			in = new ObjectInputStream(fis);
			intervals = (PersistentIntervals)in.readObject();
			in.close();
			return intervals;
		}
		catch(IOException ex)
		{
			ex.printStackTrace();
		}
		catch(ClassNotFoundException ex)
		{
			ex.printStackTrace();
		}
		return intervals;
	}

	public static void generateGraphChord(String myfile){
		GenerateGraph gg = new GenerateGraph(myfile,null);
		gg.extractGraphChord();
	}
	
	public static void generateGraphInterval(String myfile, String outdir){
		GenerateGraph gg = new GenerateGraph(myfile,outdir);
		gg.extractGraphInterval();
	}
	
}

