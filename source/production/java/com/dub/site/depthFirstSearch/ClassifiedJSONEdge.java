package com.dub.site.depthFirstSearch;

/** POJO represents an edge with DFS classification */
public class ClassifiedJSONEdge extends JSONEdge {
	
	private Type type;// edge classifier

	public ClassifiedJSONEdge(JSONEdge edge) {
		super(edge.getFrom(), edge.getTo());
		this.type = null;
	}
	
	public String toString() {// for debug only
		return super.toString() + " " + this.type; 
	}
	

	public Type getType() {
		return type;
	}

	public void setType(Type type) {
		this.type = type;
	}


	public static enum Type {
		TREE, FORWARD, BACKWARD, CROSS
	}

}
