import java.io.Serializable;
import java.util.Date;
import java.util.Hashtable;
public class PersistentIntervals implements Serializable
{
	private Hashtable intervals;
 
	public PersistentIntervals()
	{
		HashChord hc = new HashChord();
		intervals = hc.GenerateIntervals();
	}
	
	public Integer getInterval(String key)
    {
		int id = 0;
		try{
    		id = (Integer)intervals.get(key);
    	}catch(NullPointerException e){
    		System.out.println("***********Error hash " + key + " ***************");
    		String newkey = "";
    		if (key.contains("A2")){
    			int begin = key.indexOf("A2");
    			int end = begin + 2;
    			newkey = key.substring(0, begin).concat("Aadd9").concat(key.substring(end));
    		}
    		if (key.contains("C7-9")){
    			int begin = key.indexOf("C7-9");
    			int end = begin + 4;
    			newkey = key.substring(0, begin).concat("C7b9").concat(key.substring(end));
    		}
    		if (key.contains("C2")){
    			int begin = key.indexOf("C2");
    			int end = begin + 2;
    			newkey = key.substring(0, begin).concat("Cadd9").concat(key.substring(end));
    		}
    		if (key.contains("A7Sus4")){
    			int begin = key.indexOf("A7Sus4");
    			int end = begin + 6;
    			newkey = key.substring(0, begin).concat("A7sus4").concat(key.substring(end));
    		}
    		if (key.contains("F2")){
    			int begin = key.indexOf("F2");
    			int end = begin + 2;
    			newkey = key.substring(0, begin).concat("Fadd9").concat(key.substring(end));
    		}
    		if (key.contains("Aadd9(no3)")){
    			int begin = key.indexOf("Aadd9(no3)");
    			int end = begin + 10;
    			newkey = key.substring(0, begin).concat("Aadd9").concat(key.substring(end));
    		}
    		if (key.contains("Badd9(no3)")){
    			int begin = key.indexOf("Badd9(no3)");
    			int end = begin + 10;
    			newkey = key.substring(0, begin).concat("Badd9").concat(key.substring(end));
    		}
    		if (key.contains("Cadd9(no3)")){
    			int begin = key.indexOf("Cadd9(no3)");
    			int end = begin + 10;
    			newkey = key.substring(0, begin).concat("Cadd9").concat(key.substring(end));
    		}
    		if (key.contains("Dadd9(no3)")){
    			int begin = key.indexOf("Dadd9(no3)");
    			int end = begin + 10;
    			newkey = key.substring(0, begin).concat("Dadd9").concat(key.substring(end));
    		}
    		if (key.contains("Eadd9(no3)")){
    			int begin = key.indexOf("Eadd9(no3)");
    			int end = begin + 10;
    			newkey = key.substring(0, begin).concat("Eadd9").concat(key.substring(end));
    		}
    		if (key.contains("Fadd9(no3)")){
    			int begin = key.indexOf("Fadd9(no3)");
    			int end = begin + 10;
    			newkey = key.substring(0, begin).concat("Fadd9").concat(key.substring(end));
    		}
    		if (key.contains("Gadd9(no3)")){
    			int begin = key.indexOf("Gadd9(no3)");
    			int end = begin + 10;
    			newkey = key.substring(0, begin).concat("Gadd9").concat(key.substring(end));
    		}
    		if (key.contains("Cb")){
    			int begin = key.indexOf("Cb");
    			int end = begin + 2; // BEWARE OF THE LENGTH
    			newkey = key.substring(0, begin).concat("B").concat(key.substring(end));
    		}
    		if (key.contains("Eb+5")){
    			int begin = key.indexOf("Eb+5");
    			int end = begin + 4; // BEWARE OF THE LENGTH
    			newkey = key.substring(0, begin).concat("Eb5").concat(key.substring(end));
    		}
    		if (key.contains("G7-9")){
    			int begin = key.indexOf("G7-9");
    			int end = begin + 4; // BEWARE OF THE LENGTH
    			newkey = key.substring(0, begin).concat("G7b9").concat(key.substring(end));
    		}
    		System.out.println(newkey);
    		id = (Integer)intervals.get(newkey);
    	}
		return id;
    }

}