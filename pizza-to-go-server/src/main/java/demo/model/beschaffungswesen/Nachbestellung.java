package demo.model.beschaffungswesen;

import java.util.Map.Entry;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import demo.model.ref.DatabaseEntity;
import demo.model.ref.Logable;
import demo.model.shop.entities.Orders;

public class Nachbestellung implements DatabaseEntity, Logable{
	private static int count = 0;
	private int id;
	private String date;
	private List<Eintrag> eintragList;

	public Nachbestellung() {
		
	}
	
	public Nachbestellung(Set<Entry<String, Integer>> set) {
		id = ++count;
		Date currentDate = new Date(System.currentTimeMillis());
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd 'at' HH:mm:ss z");
		date = formatter.format(currentDate);
		
		this.eintragList = convertSuppListToEintragList(set);
	}

	//erzeugt eine nachbestellung aus einer order o
	public static Nachbestellung createNachbestellung(Orders o) {
		HashMap<String, Integer> suppCounts = new HashMap<String, Integer>();

		// gehe jedes supp durch
		o.getPizzas().forEach(pizza -> pizza.getSupplements().forEach(supp -> {
			// schaue, welcher wert an stelle von suppNahme steht
			int count = (suppCounts.get(supp.getName()) == null) ? 0 : suppCounts.get(supp.getName());
			//erhoehe alter wert
			suppCounts.put(supp.getName(), ++count);
		}));
		
		Set<Entry<String,Integer>> set = suppCounts.entrySet();
		return new Nachbestellung(set);
	}
	
	//wandelt eine Menge aus Entry<String,Integer> in eine List<Eintrag> um
	private static List<Eintrag> convertSuppListToEintragList(Set<Entry<String,Integer>> set){
		Iterator<Entry<String,Integer>> it = set.iterator();
		List<Eintrag> list = new ArrayList<Eintrag>();
		
		while(it.hasNext()) {
			Eintrag e = new Eintrag(it.next());
			list.add(e);
		}
		
		return list;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public List<Eintrag> getEintragList() {
		return eintragList;
	}

	public void setEintragList(List<Eintrag> eintragList) {
		this.eintragList = eintragList;
	}
	

	@Override
	public String toString() {
		return "{" +
			" id='" + getId() + "'" +
			", date='" + getDate() + "'" +
			", eintragList='" + getEintragList() + "'" +
			"}";
	}

	
}
