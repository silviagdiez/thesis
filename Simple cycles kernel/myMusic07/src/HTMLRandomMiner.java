import java.net.*;
import java.io.*;

public class HTMLRandomMiner {
	
	public HTMLRandomMiner(String fileout){
		/* This class navigates randomly ultimateGuitar.com and
		 * creates a chord base from the extracted songs
		 */
		
		// This is the initial URL of an advanced search for CHORDS, WHOLE SONG, 5*, STANDARD
		String[] initialURL = {
				"http://www.ultimate-guitar.com/search.php?view_state=advanced&band_name=&song_name=&type%5B%5D=300&type2%5B%5D=40000&rating%5B%5D=5&tuning%5B%5D=Standard&version_la=",
				"http://www.ultimate-guitar.com/search.php?type%5B2%5D=300&type2%5B0%5D=40000&rating%5B4%5D=5&tuning%5BStandard%5D=Standard&page=2&view_state=advanced&order=myweight",
				"http://www.ultimate-guitar.com/search.php?type%5B2%5D=300&type2%5B0%5D=40000&rating%5B4%5D=5&tuning%5BStandard%5D=Standard&page=3&view_state=advanced&order=myweight",
				"http://www.ultimate-guitar.com/search.php?type%5B2%5D=300&type2%5B0%5D=40000&rating%5B4%5D=5&tuning%5BStandard%5D=Standard&page=4&view_state=advanced&order=myweight",
				"http://www.ultimate-guitar.com/search.php?type%5B2%5D=300&type2%5B0%5D=40000&rating%5B4%5D=5&tuning%5BStandard%5D=Standard&page=5&view_state=advanced&order=myweight",
				"http://www.ultimate-guitar.com/search.php?type%5B2%5D=300&type2%5B0%5D=40000&rating%5B4%5D=5&tuning%5BStandard%5D=Standard&page=6&view_state=advanced&order=myweight",
				"http://www.ultimate-guitar.com/search.php?type%5B2%5D=300&type2%5B0%5D=40000&rating%5B4%5D=5&tuning%5BStandard%5D=Standard&page=7&view_state=advanced&order=myweight",
				"http://www.ultimate-guitar.com/search.php?type%5B2%5D=300&type2%5B0%5D=40000&rating%5B4%5D=5&tuning%5BStandard%5D=Standard&page=8&view_state=advanced&order=myweight",
				"http://www.ultimate-guitar.com/search.php?type%5B2%5D=300&type2%5B0%5D=40000&rating%5B4%5D=5&tuning%5BStandard%5D=Standard&page=9&view_state=advanced&order=myweight",
				"http://www.ultimate-guitar.com/search.php?type%5B2%5D=300&type2%5B0%5D=40000&rating%5B4%5D=5&tuning%5BStandard%5D=Standard&page=10&view_state=advanced&order=myweight"
		};
		
		// For each URL we extract the songs
		for (int i=0; i < initialURL.length; i++){
			try {
				String myURLS = getHTML(initialURL[i]);
				System.out.println(myURLS);
				// Now we save the extracted songs in a file
				saveURLFile(myURLS,fileout);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				System.out.println("ERROR in GetHTML");
			}	
		}
	}
	
	public String getHTML(String myurl) throws Exception{
		
		// We open the HTML code
		URL yahoo = new URL(myurl);
		BufferedReader in = new BufferedReader(
				new InputStreamReader(
				yahoo.openStream()));
		
		// We read the HTML code
		String inputLine;
		int flag = 0;
		int row = 0;
		int col = 0;
		
		// Useful variables
		String myURLS = "";
		String artist = "";
		String song = "";
		String html = "";
		int rating = 0;
		
		while ((inputLine = in.readLine()) != null){
			// We set delimiters for the HTML about songs
			if (inputLine.indexOf("tresults") >= 0){
				flag = 1;
			}
			if (inputLine.indexOf("</table>") >= 0){
				flag = 0;
			}
			// We read the songs
			if (flag == 1){
				//System.out.println("flag "+flag);
				//System.out.println(inputLine);
								
				// We set delimiters for rows
				if (inputLine.indexOf("</tr>") >= 0){
					row = 0;
					//System.out.println(artist + "\t" + song + "\t" + rating);
					// We store the URL
					if (rating > 4){
						myURLS = myURLS + artist + "\t" + song + "\t" + rating + '\t' + html + '\n';
					}
				}
				if (inputLine.indexOf("<tr") >= 0){
					row = 1;
					col = 0;
				}
				// We read the song
				if (row == 1){
					//System.out.println("row "+row);
					// We set delimiters for columns
					if (inputLine.indexOf("<td") >= 0){
						col = col + 1;
					}
					//System.out.println("col "+col);
					String auxLine[];
					switch (col) {
					case 1:
						// We read the artist
						if (inputLine.indexOf("class=\"song\">") >= 0){
							auxLine = inputLine.split("class=\"song\">");
							auxLine = auxLine[1].split("<");
							artist = auxLine[0];
							//System.out.print(artist + "\t");
						}
						break;
					case 2:
						// We read the song
						if (inputLine.indexOf("class=\"song\">") >= 0){
							auxLine = inputLine.split("class=\"song\">");
							auxLine = auxLine[1].split("<");
							song = auxLine[0];
							//System.out.print(song + "\t");
							
							// We extract the HTML link
							if (inputLine.indexOf("<a href=\"") >= 0){
								auxLine = inputLine.split("<a href=\"");
								auxLine = auxLine[1].split("\"");
								html = auxLine[0];
								//System.out.println(html);
							} else {
								html = "";
							}
						}
						break;
					case 3:
						if (inputLine.indexOf("ratdig\">") >= 0){
							// We read the rating
							auxLine = inputLine.split("ratdig\">");
							auxLine = auxLine[1].split("<");
							rating = Integer.parseInt(auxLine[0]);
							//System.out.print(rating + "\n");
						}
						break;
					case 4:
						// We read the type
						col = 0;
						break;
					}
				}
			}
		}
		return myURLS;
	}
	
	public void saveURLFile(String myURLS, String fileout){
		
		try{
			// We append the file 
			FileWriter fstream = new FileWriter(fileout);
			BufferedWriter fout = new BufferedWriter(fstream);
			// Write the sequence
			fout.write(myURLS);
			//Close the output stream
			fout.close();
		}catch (Exception e){//Catch exception if any
			System.err.println("Error: " + e.getMessage());
		}
		
	}
}
