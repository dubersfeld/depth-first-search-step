package com.dub.site.depthFirstSearch;


/** container for AJAX response */
public class StepResult {
	
	private DFSGraph graph;
	private Status status;
	

	public DFSGraph getGraph() {
		return graph;
	}

	public void setGraph(DFSGraph graph) {
		this.graph = graph;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}
	

	enum Status {
		STEP, FINISHED
	}
}
