import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Phrase {

	
	public static void main(String [] args)
	{
		String filename = "/Users/silviagdiez/Desktop/dakota.csv"; 
		if(args.length > 0)
		{
			filename = args[0];
		}
		// We read the input file
		File file = new File(filename);

        try{
            // -read from filePooped with Scanner class
            Scanner inputStream = new Scanner(file);
            // hashNext() loops line-by-line
            while(inputStream.hasNext()){
                //read single line, put in string
                String data = inputStream.next();
                System.out.println(data + "***");

            }
            // after loop, close scanner
            inputStream.close();


        }catch (FileNotFoundException e){

            e.printStackTrace();
        }
	 
		
	}
}
