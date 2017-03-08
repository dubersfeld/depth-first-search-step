package com.dub.site.depthFirstSearch;


import java.util.ArrayList;

public class DFSVertex extends Vertex {

	/**
	 * DFSVertex subclasses Vertex for DFSSearch.
	 * It contains all additional fields specific to Depth First Search
	 */
	    
	private Integer parent = null;
	private Color color = Color.BLACK;
	private int d = 0;
	private int f = 0;
	
	public Integer getParent() {
		return parent;
	}

	public void setParent(Integer parent) {
		this.parent = parent;
	}

	public Color getColor() {
		return color;
	}

	public void setColor(Color color) {
		this.color = color;
	}

	public int getD() {
		return d;
	}

	public void setD(int d) {
		this.d = d;
	}
	
	public int getF() {
		return f;
	}

	public void setF(int f) {
		this.f = f;
	}


	public DFSVertex clone() {
		DFSVertex v = new DFSVertex();
		v.name = name;
		v.parent = parent;
		v.color = color;
		v.d = d;
		v.f = f;
		v.adjacency = new ArrayList<>();
		v.adjacency.addAll(adjacency);
		return v;
	}
	
	public String toString() {
		return this.name + " " + this.parent 
				+ " " + this.color + " " + this.d + "/" + this.f;
	}

	public static enum Color {
		BLACK, GREEN, BLUE
	}

}
