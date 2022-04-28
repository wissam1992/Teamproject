package demo.model.beschaffungswesen;

import java.util.Map.Entry;

public class Eintrag {
	private String supplement;
	private int anzahl;
	
	public Eintrag() {
		
	}
	
	public Eintrag(String suppName, int count) {
		supplement = suppName;
		anzahl = count;
	}
	
	public Eintrag(Entry<String,Integer> entry) {
		this.supplement = entry.getKey(); 	//key = suppName
		this.anzahl = entry.getValue();		//value = anzahl der nachbestellung 
	}

	public String getSupplement() {
		return supplement;
	}

	public void setSupplement(String supplement) {
		this.supplement = supplement;
	}

	public int getAnzahl() {
		return anzahl;
	}

	public void setAnzahl(int anzahl) {
		this.anzahl = anzahl;
	}
	
	@Override
	public String toString() {
		return "(" + supplement + ", " + anzahl + ")";
	}
}
