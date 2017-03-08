package com.dub.site.depthFirstSearch;

//import java.io.Serializable;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

/** Vertex has an adjacency list of vertices represented as indices */
public class Vertex implements Cloneable {

	/**
	 * 
	 */
	protected String name = "";    
	
	@JsonIgnore
	protected List<Integer> adjacency;// all adjacent vertices indexes, unused in AJAX response
	
	public Vertex() {
		adjacency = new ArrayList<Integer>();
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<Integer> getAdjacency() {
		return adjacency;
	}

	public void setAdjacency(List<Integer> adjacency) {
		this.adjacency = adjacency;
	}
	
	public Vertex clone() {
		Vertex v = new Vertex();
		v.name = this.name;
		v.adjacency = new ArrayList<>();
		v.adjacency.addAll(adjacency);
		return v;
	}


}
