import java.io.ObjectOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
public class FlattenIntervals
{
	public static void main(String [] args)
	{
		String filename = "intervals.ser";
		if(args.length > 0)
		{
			filename = args[0];
		} 
		PersistentIntervals intervals = new PersistentIntervals();
		FileOutputStream fos = null;
		ObjectOutputStream out = null;
		try
		{
			fos = new FileOutputStream(filename);
			out = new ObjectOutputStream(fos);
			out.writeObject(intervals);
			out.close();
		}
		catch(IOException ex)
		{
			ex.printStackTrace();
		}
	}
}