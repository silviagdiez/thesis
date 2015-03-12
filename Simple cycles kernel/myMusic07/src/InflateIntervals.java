import java.io.ObjectInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Hashtable;

public class InflateIntervals
{
	private static String chordlist[] = {
			"C","C5","C6","C7","Cmaj7","C9","Cmaj9","C11","C13","Cmaj13","Cm","Cm6","Cm7","Cm9","Cm11","Cm13",
			"Cm(maj7)","Csus2","Csus4","Cdim","Caug","C6/9","C7sus4","C7b5","C7b9","C9sus4","Cadd9","Caug9",
			"C#","C#5","C#6","C#7","C#maj7","C#9","C#maj9","C#11","C#13","C#maj13","C#m","C#m6","C#m7","C#m9","C#m11","C#m13",
			"C#m(maj7)","C#sus2","C#sus4","C#dim","C#aug","C#6/9","C#7sus4","C#7b5","C#7b9","C#9sus4","C#add9","C#aug9",
			"Db","Db5","Db6","Db7","Dbmaj7","Db9","Dbmaj9","Db11","Db13","Dbmaj13","Dbm","Dbm6","Dbm7","Dbm9","Dbm11","Dbm13",
			"Dbm(maj7)","Dbsus2","Dbsus4","Dbdim","Dbaug","Db6/9","Db7sus4","Db7b5","Db7b9","Db9sus4","Dbadd9","Dbaug9",
			"D","D5","D6","D7","Dmaj7","D9","Dmaj9","D11","D13","Dmaj13","Dm","Dm6","Dm7","Dm9","Dm11","Dm13",
			"Dm(maj7)","Dsus2","Dsus4","Ddim","Daug","D6/9","D7sus4","D7b5","D7b9","D9sus4","Dadd9","Daug9",
			"D#","D#5","D#6","D#7","D#maj7","D#9","D#maj9","D#11","D#13","D#maj13","D#m","D#m6","D#m7","D#m9","D#m11","D#m13",
			"D#m(maj7)","D#sus2","D#sus4","D#dim","D#aug","D#6/9","D#7sus4","D#7b5","D#7b9","D#9sus4","D#add9","D#aug9",
			"Eb","Eb5","Eb6","Eb7","Ebmaj7","Eb9","Ebmaj9","Eb11","Eb13","Ebmaj13","Ebm","Ebm6","Ebm7","Ebm9","Ebm11","Ebm13",
			"Ebm(maj7)","Ebsus2","Ebsus4","Ebdim","Ebaug","Eb6/9","Eb7sus4","Eb7b5","Eb7b9","Eb9sus4","Ebadd9","Ebaug9",
			"E","E5","E6","E7","Emaj7","E9","Emaj9","E11","E13","Emaj13","Em","Em6","Em7","Em9","Em11","Em13",
			"Em(maj7)","Esus2","Esus4","Edim","Eaug","E6/9","E7sus4","E7b5","E7b9","E9sus4","Eadd9","Eaug9",
			"F","F5","F6","F7","Fmaj7","F9","Fmaj9","F11","F13","Fmaj13","Fm","Fm6","Fm7","Fm9","Fm11","Fm13",
			"Fm(maj7)","Fsus2","Fsus4","Fdim","Faug","F6/9","F7sus4","F7b5","F7b9","F9sus4","Fadd9","Faug9",
			"F#","F#5","F#6","F#7","F#maj7","F#9","F#maj9","F#11","F#13","F#maj13","F#m","F#m6","F#m7","F#m9","F#m11","F#m13",
			"F#m(maj7)","F#sus2","F#sus4","F#dim","F#aug","F#6/9","F#7sus4","F#7b5","F#7b9","F#9sus4","F#add9","F#aug9",
			"Gb","Gb5","Gb6","Gb7","Gbmaj7","Gb9","Gbmaj9","Gb11","Gb13","Gbmaj13","Gbm","Gbm6","Gbm7","Gbm9","Gbm11","Gbm13",
			"Gbm(maj7)","Gbsus2","Gbsus4","Gbdim","Gbaug","Gb6/9","Gb7sus4","Gb7b5","Gb7b9","Gb9sus4","Gbadd9","Gbaug9",
			"G","G5","G6","G7","Gmaj7","G9","Gmaj9","G11","G13","Gmaj13","Gm","Gm6","Gm7","Gm9","Gm11","Gm13",
			"Gm(maj7)","Gsus2","Gsus4","Gdim","Gaug","G6/9","G7sus4","G7b5","G7b9","G9sus4","Gadd9","Gaug9",
			"G#","G#5","G#6","G#7","G#maj7","G#9","G#maj9","G#11","G#13","G#maj13","G#m","G#m6","G#m7","G#m9","G#m11","G#m13",
			"G#m(maj7)","G#sus2","G#sus4","G#dim","G#aug","G#6/9","G#7sus4","G#7b5","G#7b9","G#9sus4","G#add9","G#aug9",
			"Ab","Ab5","Ab6","Ab7","Abmaj7","Ab9","Abmaj9","Ab11","Ab13","Abmaj13","Abm","Abm6","Abm7","Abm9","Abm11","Abm13",
			"Abm(maj7)","Absus2","Absus4","Abdim","Abaug","Ab6/9","Ab7sus4","Ab7b5","Ab7b9","Ab9sus4","Abadd9","Abaug9",
			"A","A5","A6","A7","Amaj7","A9","Amaj9","A11","A13","Amaj13","Am","Am6","Am7","Am9","Am11","Am13",
			"Am(maj7)","Asus2","Asus4","Adim","Aaug","A6/9","A7sus4","A7b5","A7b9","A9sus4","Aadd9","Aaug9",
			"A#","A#5","A#6","A#7","A#maj7","A#9","A#maj9","A#11","A#13","A#maj13","A#m","A#m6","A#m7","A#m9","A#m11","A#m13",
			"A#m(maj7)","A#sus2","A#sus4","A#dim","A#aug","A#6/9","A#7sus4","A#7b5","A#7b9","A#9sus4","A#add9","A#aug9",
			"Bb","Bb5","Bb6","Bb7","Bbmaj7","Bb9","Bbmaj9","Bb11","Bb13","Bbmaj13","Bbm","Bbm6","Bbm7","Bbm9","Bbm11","Bbm13",
			"Bbm(maj7)","Bbsus2","Bbsus4","Bbdim","Bbaug","Bb6/9","Bb7sus4","Bb7b5","Bb7b9","Bb9sus4","Bbadd9","Bbaug9",
			"B","B5","B6","B7","Bmaj7","B9","Bmaj9","B11","B13","Bmaj13","Bm","Bm6","Bm7","Bm9","Bm11","Bm13",
			"Bm(maj7)","Bsus2","Bsus4","Bdim","Baug","B6/9","B7sus4","B7b5","B7b9","B9sus4","Badd9","Baug9"
			};

	public static void main(String [] args)
	{
		String filename = "intervals.ser"; 
		if(args.length > 0)
		{
			filename = args[0];
		}
		PersistentIntervals intervals = null;
		FileInputStream fis = null;
		ObjectInputStream in = null;
		try
		{
			fis = new FileInputStream(filename);
			in = new ObjectInputStream(fis);
			intervals = (PersistentIntervals)in.readObject();
			in.close();
		}
		catch(IOException ex)
		{
			ex.printStackTrace();
		}
		catch(ClassNotFoundException ex)
		{
			ex.printStackTrace();
		}
		// check integrity
		System.out.println("C->G: " + intervals.getInterval("C,G"));
		System.out.println("G->Am: " + intervals.getInterval("G,Am"));
		System.out.println("Am->F: " + intervals.getInterval("Am,F"));
		System.out.println("F->C: " + intervals.getInterval("F,C"));
		System.out.println("Baug9->C: " + intervals.getInterval("Baug9,C"));
		System.out.println("Baug9->Baug9: " + intervals.getInterval("Baug9,Baug9"));
		System.out.println("Baug9->Badd9: " + intervals.getInterval("Baug9,Badd9"));
		System.out.println("C->C: " + intervals.getInterval("C,C"));
		//checkIntegrity(intervals);
		
	}
	
	public static void checkIntegrity(PersistentIntervals intervals){
		
		HashChord hc = new HashChord();
		
		// FIRST CHORD
		for (int i=0; i < chordlist.length; i++){
			String chord1 = chordlist[i];
			System.out.println("chord1 " + i + "*****************");
			
			// SECOND CHORD
			for (int j=0; j < chordlist.length; j++){
				String chord2 = chordlist[j];
				
				// We generate the sequence of possible transpositions for the two given chords
				String aux1[] = hc.filterChord(chord1);
				String aux2[] = hc.filterChord(chord2);
				
				// We identify both chord in the circle of fifths
				int id1 = hc.identifyChord(aux1[0].concat(aux1[1]));
				int id2 = hc.identifyChord(aux2[0].concat(aux2[1]));
				
				// We generate all possible transpositions for this pair of chords
				String[][] transpositions = hc.generateTranspositions(id1,id2,aux1[2].concat(aux1[3]),aux2[2].concat(aux2[3]));
				
				// We check if the value is the same for all transpositions
				boolean same = true;
				int value = 0;
				for (int k=0; k < 30; k++){
					String c1 = transpositions[0][k];
					String c2 = transpositions[1][k];
					if (c1 != null){
						String key = c1.concat(",").concat(c2);
						if (k == 0){ // First value
							value = intervals.getInterval(key);
						} else {
							int auxValue = intervals.getInterval(key);
							if (auxValue != value){
								same = false;
							}
						}
					} else {
						break;
					}
				}
				if (same == false){
					System.out.println("ERROR CON LAS TRANSPOSICIONES!!!");
				}
			}
		}
	}
}

